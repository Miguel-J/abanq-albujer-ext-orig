/***************************************************************************
                 altatcrapida.qs  -  description
                             -------------------
    begin                : vie oct 21 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function cargaSeleccion()
  {
    return this.ctx.oficial_cargaSeleccion();
  }
  function filtraTallas()
  {
    return this.ctx.oficial_filtraTallas();
  }
  function pushButtonAccept_clicked()
  {
    return this.ctx.oficial_pushButtonAccept_clicked();
  }
  function crearBarcodes()
  {
    return this.ctx.oficial_crearBarcodes();
  }
  function iniciaFiltroTallas()
  {
    return this.ctx.oficial_iniciaFiltroTallas();
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
  var util = new FLUtil();
  var cursor = this.cursor();
  var _i = this.iface;

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(this.child("tdbGruposTalla"), "currentChanged()", _i, "filtraTallas");
  connect(this.child("chkFiltroGrupo"), "clicked()", _i, "filtraTallas");
  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "pushButtonAccept_clicked");
  _i.cargaSeleccion();
  _i.iniciaFiltroTallas();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_iniciaFiltroTallas()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var _i = this.iface;

  var referencia = cursor.valueBuffer("referencia");
  var codGrupo = util.sqlSelect("atributosarticulos aa INNER JOIN tallas t ON aa.talla = t.codtalla", "t.codgrupotalla", "aa.referencia = '" + referencia + "' AND t.codgrupotalla IS NOT NULL", "atributosarticulos,tallas");
  if (codGrupo) {
    var pos = util.sqlSelect("grupostalla", "COUNT(*)", "codgrupotalla < '" + codGrupo + "'");
    pos = isNaN(pos) ? 0 : pos;
    this.child("tdbGruposTalla").setCurrentRow(pos);
  } else {
    this.child("chkFiltroGrupo").checked = false;
  }
  _i.filtraTallas();
}

function oficial_pushButtonAccept_clicked()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var _i = this.iface;

  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);

  try {
    if (_i.crearBarcodes()) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.warning(util.translate("scripts", "Error al crear los registros de barcode"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.critical(util.translate("scripts", "Error al crear los registros de barcode") + ": " + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  this.accept();
}

function oficial_crearBarcodes()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var referencia = cursor.valueBuffer("referencia");

  var tT = this.child("tdbTallas"), tC = this.child("tdbColores");
  var aT = tT.primarysKeysChecked();
  var aC = tC.primarysKeysChecked();
  var curBC = new FLSqlCursor("atributosarticulos");
  var curC = new FLSqlCursor("coloresarticulo");
  var avisar = true, barcode;
  for (var c = 0; c < aC.length; c++) {
    curC.select("referencia = '" + referencia + "' AND codcolor = '" + aC[c] + "'");
    if (!curC.first()) {
      curC.setModeAccess(curC.Insert);
      curC.refreshBuffer();
      curC.setValueBuffer("referencia", referencia);
      curC.setValueBuffer("codcolor", aC[c]);
      curC.setValueBuffer("descolor", util.sqlSelect("colores", "descripcion", "codcolor = '" + aC[c] + "'"));
      curC.setValueBuffer("activo", true);
      if (!curC.commitBuffer()) {
        return false;
      }
    }
    for (var t = 0; t < aT.length; t++) {
      curBC.select("referencia = '" + referencia + "' AND talla = '" + aT[t] + "' AND color = '" + aC[c] + "'");
      if (curBC.first()) {
        if (avisar) {
          var res = MessageBox.warning(util.translate("scripts", "La combinación ref. %1, talla %2, color %3 tiene ya un barcode asociado.\nPulse Cancelar para cancelar, Aceptar para continuar o Ignorar para continuar y no mostar más avisos de este tipo").arg(referencia).arg(aT[t]).arg(aC[c]), MessageBox.Cancel, MessageBox.Ok, MessageBox.Ignore, "AbanQ");
          if (res == MessageBox.Cancel) {
            return false;
          }
          if (res == MessageBox.Ignore) {
            avisar = false;
          }
        }
      } else {
        barcode = formRecordarticulos.iface.pub_obtenerBarcode(referencia, aT[t], aC[c]);
        curBC.setModeAccess(curBC.Insert);
        curBC.refreshBuffer();
        curBC.setValueBuffer("referencia", referencia);
        curBC.setValueBuffer("barcode", barcode);
        curBC.setValueBuffer("talla", aT[t]);
        curBC.setValueBuffer("color", aC[c]);
        if (!curBC.commitBuffer()) {
          return false;
        }
      }
    }
  }
  return true;
}

function oficial_filtraTallas()
{
  var filtro = "";
  var tT = this.child("tdbTallas");
  if (this.child("chkFiltroGrupo").checked) {
    var codGrupo = this.child("tdbGruposTalla").cursor().valueBuffer("codgrupotalla")
                   filtro = codGrupo ? "codgrupotalla = '" + codGrupo + "'" : "";
  }
  if (filtro != "") {
    var aCamposT = ["orden", "codtalla", "descripcion"];
    tT.setOrderCols(aCamposT);
    tT.setColumnWidth("orden", 1);
  } else {
    var aCamposT = ["codgrupotalla", "codtalla", "descripcion"];
    tT.setOrderCols(aCamposT);
  }
  tT.setFilter(filtro);
  tT.refresh();
}

function oficial_bufferChanged(fN)
{
  var cursor = this.cursor();

  switch (fN) {
    case "X": {
      break;
    }
  }
}

function oficial_cargaSeleccion()
{
  var aTallas = formRecordarticulos.iface.dameArrayTallas();
  var aColores = formRecordarticulos.iface.dameArrayColores();
  var i;
  var tT = this.child("tdbTallas"), tC = this.child("tdbColores");
  for (i = 0; i < aTallas.length; i++) {
    tT.setPrimaryKeyChecked(aTallas[i], true);
  }
  for (i = 0; i < aColores.length; i++) {
    tC.setPrimaryKeyChecked(aColores[i], true);
  }
  tT.refresh();
  tC.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
