/***************************************************************************
                 masterdespachos.qs  -  description
                             -------------------
    begin                : jue mar 18 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
    return this.ctx.interna_init();
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
  function imprimir(codDespacho)
  {
    return this.ctx.oficial_imprimir(codDespacho);
  }
  function dameParamInforme(idDespacho)
  {
    return this.ctx.oficial_dameParamInforme(idDespacho);
  }
  function tbnEtiquetas_clicked()
  {
    return this.ctx.oficial_tbnEtiquetas_clicked();
  }
  function dameParamInformeBultos()
  {
    return this.ctx.oficial_dameParamInformeBultos();
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
  var _i = this.iface;
  connect(this.child("toolButtonPrint"), "clicked()", _i, "imprimir");
  connect(this.child("tbnEtiquetas"), "clicked()", _i, "tbnEtiquetas_clicked");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_imprimir(codDespacho)
{
  if (sys.isLoadedModule("flfactinfo")) {
    var idDespacho, codigo;
    if (codDespacho) {
      codigo = codDespacho;
      idDespacho = util.sqlSelect("despachos", "iddespacho", "coddespacho = '" + codigo + "'");
    } else {
      var cursor = this.cursor();
      if (!cursor.isValid()) {
        return;
      }
      codigo = this.cursor().valueBuffer("coddespacho");
      idDespacho = this.cursor().valueBuffer("iddespacho");
    }
    if (!idDespacho) {
      return;
    }

    var oParam = this.iface.dameParamInforme(idDespacho);
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_despachos");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("i_despachos_coddespacho", codigo);
    flfactinfo.iface.pub_lanzaInforme(curImprimir, oParam);
  } else {
    flfactppal.iface.pub_msgNoDisponible("Informes");
  }
}

function oficial_dameParamInforme(idDespacho)
{
  var oParam = flfactinfo.iface.pub_dameParamInforme();
  oParam.nombreInforme = "i_despachos";
  return oParam;
}

function oficial_tbnEtiquetas_clicked()
{
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return;
  }
  codigo = cursor.valueBuffer("coddespacho");

  var oParam = this.iface.dameParamInformeBultos();
  var curImprimir = new FLSqlCursor("i_despachos");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("i_despachos_coddespacho", codigo);
  flfactinfo.iface.pub_lanzaInforme(curImprimir, oParam);
}

function oficial_dameParamInformeBultos()
{
  var oParam = flfactinfo.iface.pub_dameParamInforme();
  oParam.nombreInforme = "i_bultos_despacho";
  return oParam;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
