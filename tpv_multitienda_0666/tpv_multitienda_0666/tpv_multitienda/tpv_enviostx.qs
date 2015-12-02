/***************************************************************************
                 tpv_enviostx.qs  -  description
                             -------------------
    begin                : vie sep 14 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
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
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function validarAgente()
  {
    return this.ctx.oficial_validarAgente();
  }
  function validaAgenteCerrado()
  {
    return this.ctx.oficial_validaAgenteCerrado();
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
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
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
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

  if (cursor.modeAccess() == cursor.Edit) {
    this.child("gbxReferencia").setDisabled(true);
  }
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  return _i.commonCalculateField(fN, cursor);
}

function interna_validateForm()
{
  var _i = this.iface;

  if (!_i.validarAgente())
    return false;

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "cantenviada": {
      cursor.setValueBuffer("excentral", _i.calculateField("excentral"));
      cursor.setValueBuffer("extienda", _i.calculateField("extienda"));
      cursor.setValueBuffer("cantpterecibir", _i.calculateField("cantpterecibir"));
      cursor.setValueBuffer("estado", _i.calculateField("estado"));
      break;
    }
    case "cerradoex": {
      cursor.setValueBuffer("excentral", _i.calculateField("excentral"));
      cursor.setValueBuffer("extienda", _i.calculateField("extienda"));
      cursor.setValueBuffer("cantpterecibir", _i.calculateField("cantpterecibir"));
      cursor.setValueBuffer("rxcentral", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxcentral", cursor));
      cursor.setValueBuffer("rxtienda", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxtienda", cursor));
      cursor.setValueBuffer("estado", _i.calculateField("estado"));
      break;
    }
  }
}

function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor = "";

  switch (fN) {
    case "codagentetx": {
      var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
      var codAgente = flfact_tpv.iface.agenteActivo_;
      if (!codAgente || codAgente == "") {
        codAgente = AQUtil.sqlSelect("tpv_puntosventa", "codtpv_agente", "codtpv_puntoventa ='" + codTerminal + "'");
        var noAutentificar = !flfact_tpv.iface.pub_valorDefectoTPV("autageenvrecep");

        if (!flfact_tpv.iface.pub_cambiarAgenteActivo(codAgente, noAutentificar)) {
          MessageBox.warning(sys.translate("No ha establecido ningún agente de venta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
          valor = false;
          break;
        }

        if (!codAgente || codAgente == "")
          codAgente = flfact_tpv.iface.agenteActivo_;

        flfact_tpv.iface.pub_ponAgenteActivo(codAgente);
      }

      if (!codAgente) {
        MessageBox.warning(sys.translate("No ha establecido ningún agente de venta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        valor = false;
        break;
      }
      if (!codAgente || codAgente == "")
        valor = false;
      else
        valor = codAgente;
      break;
    }
    case "excentral": {
      if (flfact_tpv.iface.pub_esBDLocal()) {
        valor = cursor.valueBuffer("excentral");
      } else {
        if (cursor.valueBuffer("cantenviada") >= cursor.valueBuffer("cantpteenvio") || cursor.valueBuffer("cerradoex")) {
          valor = "OK";
        } else {
          valor = "PTE";
        }
      }
      break;
    }
    case "extienda": {
      if (flfact_tpv.iface.pub_esBDLocal()) {
        if (cursor.valueBuffer("cantenviada") >= cursor.valueBuffer("cantpteenvio") || cursor.valueBuffer("cerradoex")) {
          valor = "OK";
        } else {
          valor = "PTE";
        }
      } else {
        valor = cursor.valueBuffer("excentral");
      }
      break;
    }
    case "cantpterecibir": {
      //      if(cursor.valueBuffer("cerradoex"))
      //        valor = 0;
      //      else
      valor = cursor.valueBuffer("cantenviada");
      break;
    }
    case "estado": {
      valor = formRecordtpv_lineasmultitransstock.iface.pub_commonCalculateField("estado", cursor);
      break;
    }
  }
  return valor;
}

function oficial_validarAgente()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codAgente;
  if (cursor.valueBuffer("cerradoex")) {
    codAgente = _i.validaAgenteCerrado();
  } else {
    codAgente = _i.commonCalculateField("codagentetx", cursor);
  }
  if (AQUtil.sqlSelect("tpv_datosgenerales", "autageenvrecep", "1=1") && (!codAgente || codAgente == "")) {
    MessageBox.warning(sys.translate("No se ha encontrado el agente"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (codAgente && codAgente != "")
    cursor.setValueBuffer("codagentetx", codAgente);

  return true;
}

function oficial_validaAgenteCerrado()
{
  var _i = this.iface;

  return _i.commonCalculateField("codagentetx");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
