/***************************************************************************
                 trabexternolibro.qs  -  description
                             -------------------
    begin                : mar abr 02 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var bloqueoPortes: Boolean = false;
  var bloqueoTotal: Boolean = false;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function establecerTrabajoDefecto()
  {
    return this.ctx.oficial_establecerTrabajoDefecto();
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
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbPeso").setValue(this.iface.calculateField("peso"));
      this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
      this.iface.establecerTrabajoDefecto();
      break;
    }
  }
  this.child("fdbIdTipoTareaPro").setFilter("idtipoproceso = 'ENCUADERNACION'");
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  return true;
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "portes": {
      var codProveedor: String = cursor.valueBuffer("codproveedor");
      if (!codProveedor || codProveedor == "") {
        valor = 0;
        break;
      }
      var dirProveedor: Array = flfactppal.iface.ejecutarQry("dirproveedores", "idpoblacion,idprovincia,codpais", "codproveedor = '" + codProveedor + "' AND direccionppal = true");
      if (dirProveedor["result"] != 1) {
        break;
      }
      var peso: Number = cursor.valueBuffer("peso");
      var codAgencia: String = cursor.valueBuffer("codagencia");
      if (codAgencia && codAgencia != "") {
        valor = flfactppal.iface.pub_obtenerPortesAgencia(codAgencia, peso, dirProveedor["idpoblacion"], dirProveedor["idprovincia"], dirProveedor["codpais"]);
      } else {
        var datosPortes: Array = flfactppal.iface.pub_obtenerPortesMinimos(peso, dirProveedor["idpoblacion"], dirProveedor["idprovincia"], dirProveedor["codpais"]);
        if (!datosPortes) {
          valor = 0;
          break;
        }
        valor = datosPortes["portes"];
        /// Acceder al this en el calculateField es irregular
        this.child("fdbCodAgencia").setValue(datosPortes["codagencia"]);
      }
      break;
    }
    case "pvptotal": {
      valor = parseFloat(cursor.valueBuffer("pvptrabajo")) + parseFloat(cursor.valueBuffer("portes"));
      break;
    }
    case "pvpunitario": {
      var cantidad: Number = parseFloat(cursor.valueBuffer("cantidad"));
      if (cantidad == 0) {
        valor = 0;
      } else {
        valor = parseFloat(cursor.valueBuffer("pvptrabajo")) / cantidad;
      }
      break;
    }
    case "pvptrabajo": {
      var cantidad: Number = parseFloat(cursor.valueBuffer("cantidad"));
      valor = parseFloat(cursor.valueBuffer("pvpunitario")) * cantidad;
      break;
    }
    case "peso": {
      var idParamLibro: String = cursor.valueBuffer("idparamlibro");
      if (idParamLibro && idParamLibro != "") {
        var curLibro: FLSqlCursor = cursor.cursorRelation();
        valor = parseFloat(curLibro.valueBuffer("pesopliegos"));
      }
      break;
    }
    case "cantidad": {
      var idParamLibro: String = cursor.valueBuffer("idparamlibro");
      if (idParamLibro && idParamLibro != "") {
        var curLibro: FLSqlCursor = cursor.cursorRelation();
        valor = curLibro.valueBuffer("numcopias");
      }
      break;
    }
  }

  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codagencia": {
      var codAgencia: String = cursor.valueBuffer("codagencia");
      if (!codAgencia || codAgencia == "") {
        break;
      }
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "peso":
    case "codproveedor": {
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "pvptrabajo":
    case "portes": {
      this.child("fdbPvpTotal").setValue(this.iface.calculateField("pvptotal"));
      if (!this.iface.bloqueoTotal) {
        this.iface.bloqueoTotal = true;
        this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
        this.iface.bloqueoTotal = false;
      }
      break;
    }
    case "pvpunitario":
    case "cantidad": {
      if (!this.iface.bloqueoTotal) {
        this.iface.bloqueoTotal = true;
        this.child("fdbPvpTrabajo").setValue(this.iface.calculateField("pvptrabajo"));
        this.iface.bloqueoTotal = false;
      }
      break;
    }
    case "idtipotareapro": {
      var idTipoTareaPro: String = cursor.valueBuffer("idtipotareapro");
      if (idTipoTareaPro && idTipoTareaPro != "") {
        this.child("fdbCodTipoCentro").setFilter("codtipocentro IN (SELECT codtipocentro FROM pr_costestarea WHERE idtipotareapro = " + idTipoTareaPro + ")");
      } else {
        this.child("fdbCodTipoCentro").setFilter("");
      }
      break;
    }
  }
}

function oficial_establecerTrabajoDefecto()
{
  var util: FLUtil = new FLUtil;
  var idTipoTareaPro: String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = 'ENCUADERNACION' AND idtipotarea = 'ENCUADERNADO'");
  debug("idTipoTareaPro = " + idTipoTareaPro);
  this.child("fdbIdTipoTareaPro").setValue(idTipoTareaPro);
  var codTipoCentro: String = util.sqlSelect("pr_tiposcentrocoste", "codtipocentro", "codtipocentro IN (SELECT codtipocentro FROM pr_costestarea WHERE idtipotareapro = " + idTipoTareaPro + ")");
  debug("codTipoCentro = " + codTipoCentro);
  this.child("fdbCodTipoCentro").setValue(codTipoCentro);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////