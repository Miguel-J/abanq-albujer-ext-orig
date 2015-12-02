/***************************************************************************
                 pr_tareacorte.qs  -  description
                             -------------------
    begin                : lun jul 18 2004
    copyright            : (C) 2005 by InfoSiAL S.L.
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
/** \C
Para iniciar una tarea de corte es necesario introducir mediante el lector de códigos de barra los códigos correspondientes a los rollos que hay que utilizar en el corte. Cuando todos los códigos han sido introducidos correctamente, la tarea de corte pasa a estado 'EN CURSO'.
\end */
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
  var ledTarea: Object;
  var ledCorte: Object;
  var pbnAceptar: Object;
  var pbnCancelar: Object;
  var tblPartes: QObject;
  var PARTE: Number = 0;
  var TELA: Number = 1;
  var ROLLO: Number = 2;
  var METROS: Number = 3;
  var NOMBRE: Number = 4;
  function oficial(context)
  {
    interna(context);
  }
  function aceptar()
  {
    return this.ctx.oficial_aceptar();
  }
  function cancelar()
  {
    return this.ctx.oficial_cancelar();
  }
  function partesCorte(idCorte: String): String {
    return this.ctx.oficial_partesCorte(idCorte);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
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
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  this.iface.ledTarea = this.child("ledTarea");
  this.iface.ledCorte = this.child("ledCorte");
  this.iface.tblPartes = this.child("tblPartes");
  this.iface.pbnAceptar = this.child("pbnAceptar");
  this.iface.pbnCancelar = this.child("pbnCancelar");

  connect(this.iface.pbnAceptar, "clicked()", this, "iface.aceptar");
  connect(this.iface.pbnCancelar, "clicked()", this, "iface.cancelar");

  this.iface.ledTarea.text = cursor.valueBuffer("idtarea") + " - " + cursor.valueBuffer("descripcion");
  var idCorte: Number = util.sqlSelect("pr_tareas t INNER JOIN pr_procesos p ON t.idproceso = p.idproceso", "p.idobjeto", "t.idtarea = '" + cursor.valueBuffer("idtarea") + "'", "pr_tareas,pr_procesos");

  if (!idCorte)
    return false;

  var desCorte: String = util.sqlSelect("lotesstock ls INNER JOIN articulos a ON ls.referencia = a.referencia", "a.descripcion", "ls.codlote = '" + idCorte + "'", "lotesstock,articulos");
  this.iface.partesCorte(idCorte);

  this.iface.ledCorte.text = idCorte  + " - " + desCorte;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_partesCorte(idCorte: String): String {
  var util: FLUtil = new FLUtil;

  this.iface.tblPartes.setNumCols(5);
  this.iface.tblPartes.setColumnWidth(this.iface.PARTE, 100);
  this.iface.tblPartes.setColumnWidth(this.iface.TELA, 100);
  this.iface.tblPartes.setColumnWidth(this.iface.ROLLO, 100);
  this.iface.tblPartes.setColumnWidth(this.iface.METROS, 50);
  this.iface.tblPartes.setColumnWidth(this.iface.NOMBRE, 200);
  this.iface.tblPartes.setColumnLabels("/", "Parte/Tela/Rollo/Metros/Nombre tela");

  var qryPartes: FLSqlQuery = new FLSqlQuery;
  with(qryPartes)
  {
    setTablesList("lotesstock,pr_procesos,pr_tareas,pr_tiposproceso,movistock,articulos,articuloscomp,tiposopcionartcomp");
    setSelect("ac.desccomponente, ms.referencia, ms.codlote, ms.cantidad");
    setFrom("lotesstock ls INNER JOIN articulos a ON ls.referencia = a.referencia INNER JOIN movistock ms ON ls.codlote = ms.codloteprod INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN tiposopcionartcomp toa ON ac.idtipoopcionart = toa.idtipoopcionart INNER JOIN opcionesarticulocomp oac ON ac.idopcionarticulo = oac.idopcionarticulo");
    setWhere("ls.codlote = '" + idCorte + "'");
    setForwardOnly(true);
  }
  if (!qryPartes.exec())
    return "Error";

  //var lista:String = util.translate("scripts", "Parte\tTela\tRollo\tMetros\tNombre tela\n");
  var cantidad: Number;
  var fila: Number = 0;
  while (qryPartes.next())
  {
    this.iface.tblPartes.insertRows(fila);
    this.iface.tblPartes.setText(fila, this.iface.PARTE, qryPartes.value("ac.desccomponente"));
    this.iface.tblPartes.setText(fila, this.iface.TELA, qryPartes.value("ms.referencia"));
    this.iface.tblPartes.setText(fila, this.iface.ROLLO, qryPartes.value("ms.codlote"));
    cantidad = -1 * qryPartes.value("ms.cantidad");
    this.iface.tblPartes.setText(fila, this.iface.METROS, util.roundFieldValue(cantidad, "movistock", "cantidad"));
    this.iface.tblPartes.setText(fila, this.iface.NOMBRE, util.sqlSelect("articulos", "descripcion", "referencia = '" + qryPartes.value("ms.referencia") + "'"));
    fila++;
  }

  return true;
}

function oficial_aceptar()
{
  this.child("pushButtonAccept").animateClick();
}

function oficial_cancelar()
{
  this.child("pushButtonCancel").animateClick();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
