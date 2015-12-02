/***************************************************************************
                 masterlotesstock.qs  -  description
                             -------------------
    begin                : mar oct 9 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
  function imprimir()
  {
    return this.ctx.oficial_imprimir();
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class sofa extends oficial
{
  var pbnComprobarLotes: Object
  function sofa(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function comprobarLotes_clicked()
  {
    return this.ctx.sofa_comprobarLotes_clicked();
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends sofa
{
  function head(context)
  {
    sofa(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init()
{
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Lanza el informe de pegatinas correspondiente a la mercancía recibida
*/
function oficial_imprimir()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var masWhere: String = "";
  if (!sys.isLoadedModule("flfactinfo")) {
    flfactppal.iface.pub_msgNoDisponible("Informes");
    return;
  }

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  if (codFamilia != "TELA") {
    MessageBox.information(util.translate("scripts", "No se pueden imprimir las etiquetas para lotes que no sean rollos de tela"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curImprimir: FLSqlCursor = new FLSqlCursor("i_pegaslotesstock");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("i_lotesstock_codlote", "");

  masWhere = "codlote = '" + cursor.valueBuffer("codlote") + "'";

  flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pegaslotesstock", "", "", false, false, masWhere);

}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
function sofa_init()
{
  this.iface.pbnComprobarLotes = this.child("pbnComprobarLotes");

  connect(this.iface.pbnComprobarLotes, "clicked()", this, "iface.comprobarLotes_clicked()");

  this.iface.pbnComprobarLotes.close();
}

function sofa_comprobarLotes_clicked()
{
  var util: FLUtil;

  var qryLotes: FLSqlQuery = new FLSqlQuery();
  qryLotes.setTablesList("lotesstock");
  qryLotes.setSelect("codlote");
  qryLotes.setFrom("lotesstock");
  qryLotes.setWhere("codlote LIKE 'M%' order by codlote");

  if (!qryLotes.exec())
    return false;

  util.createProgressDialog(util.translate("scripts", "Comprobando Lotes..."), qryLotes.size());
  util.setProgress(0);

  var i: Number = 1;
  var columna: Number = 1;
  var lotesEncontrados: String = "";
  var lotes: String = "";
  while (qryLotes.next()) {
    util.setProgress(i);
    i++;
    var codLote: String = qryLotes.value("codlote");
    if (util.sqlSelect("movistock ms LEFT OUTER JOIN lineaspedidoscli lp ON ms.idlineapc = lp.idlinea", "ms.idmovimiento", "ms.codlote = '" + codLote + "' AND (lp.idlinea IS NULL OR lp.idlinea = 0) AND (ms.idproceso IS NULL OR ms.idproceso = 0)", "movistock,lineaspedidoscli")) {
      var referencia: String = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");



      if (columna == 1) {
        var num: Number = 18 - referencia.length;
        for (var i = 0; i < num; i++)
          referencia += "  ";

        lotesEncontrados += "\n     " + codLote + " - " + referencia;
        columna = 2;
      } else {
        lotesEncontrados += "\t" + codLote + " - " + referencia;
        columna = 1;
      }
      if (lotes != "")
        lotes += ",";
      lotes += codLote;
    }
  }

  util.setProgress(qryLotes.size());
  util.destroyProgressDialog();

  if (lotes == "" || !lotes) {
    MessageBox.information(util.translate("scripts", "No se encontró ningún lote sin asociar a una línea de pedido."), MessageBox.Ok, MessageBox.No);
    return;
  }

  var res: Number = MessageBox.information(util.translate("scripts", "Los siguientes lotes no están asociados a una línea de pedido:\n%1\n\n¿Desea eliminarlos así como sus cortes, tareas y procesos de producción asociados?").arg(lotesEncontrados), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return;


  //  var arrayLotes:Array = lotes.split(",");
  //
  //  util.createProgressDialog(util.translate("scripts", "Borrando Lotes..."), qryLotes.size());
  //  util.setProgress(0);
  //
  //  for (var i=0;i<arrayLotes.length;i++) {
  //    util.setProgress(i);
  //    this.cursor().transaction(false);
  //    try {
  //      if(!flfacturac.iface.pub_eliminarLote(arrayLotes[i])) {
  //        this.cursor().rollback();
  //        util.destroyProgressDialog();
  //        return;
  //      }
  //      else
  //        this.cursor().commit();
  //    }
  //    catch (e) {
  //      this.cursor().rollback();
  //      util.destroyProgressDialog();
  //      MessageBox.warning(util.translate("scripts", "Hubo un error al borrar lotes de stock:\n" + e), MessageBox.Ok, MessageBox.NoButton);
  //      return;
  //    }
  //  }
  //
  //  util.setProgress(qryLotes.size());
  //  util.destroyProgressDialog();
  //
  //  MessageBox.information(util.translate("scripts", "Los lotes se borraron correctamente"),MessageBox.Ok, MessageBox.No);

  debug(lotes);

}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////