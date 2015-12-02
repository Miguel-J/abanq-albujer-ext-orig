/***************************************************************************
                 cobrosterceros.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String)
  {
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
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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

  var cursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
      this.child("fdbCodCuenta").setValue(AQUtil.sqlSelect("factteso_general", "codcuentacobros", "1=1"));
      this.child("fdbFechaPago").setDisabled(true);
      break;
    }
  }
}

function interna_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codEjercicio = cursor.valueBuffer("codejercicio");
  if (!codEjercicio || codEjercicio == "")
    return true;

  var fechaC = cursor.valueBuffer("fechacobro");
  if (!fechaC || fechaC == "")
    return true;

  if (!AQUtil.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND '" + fechaC + "' BETWEEN fechainicio AND fechafin")) {
    MessageBox.warning(sys.translate("La fecha de cobro establecida no está dentro del periódo del ejercicio."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var fechaP = cursor.valueBuffer("fechapago");
  if (!fechaP || fechaP == "") {
    if (cursor.valueBuffer("pagado")) {
      MessageBox.warning(sys.translate("Debe establecer la fecha de pago."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    } else {
      return true;
    }
  }

  if (!AQUtil.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND '" + fechaP + "' BETWEEN fechainicio AND fechafin")) {
    MessageBox.warning(sys.translate("La fecha de pago establecida no está dentro del periódo del ejercicio."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function interna_calculateField(fN: String)
{
  var cursor = this.cursor();
  var valor = "";

  switch (fN) {
    case "concepto": {
      var concepto = cursor.valueBuffer("concepto");
      if (concepto && concepto != "") {
        valor = concepto;
      } else {
        var nombreCliente = cursor.valueBuffer("nombrecliente");
        valor = "Cobro por cuenta de " + nombreCliente;
      }
      break;
    }
    case "fechapago": {
      var fecha = cursor.valueBuffer("fechapago");
      if (!fecha || fecha == "") {
        var hoy = new Date();
        valor = hoy.toString();
      } else {
        valor = fecha;
      }
      break;
    }
    case "dc": {
      var entidad = cursor.valueBuffer("ctaentidad");
      var agencia = cursor.valueBuffer("ctaagencia");
      var cuenta = cursor.valueBuffer("cuenta");

      if (!entidad) entidad = "";
      if (!agencia) agencia = "";
      if (!cuenta) cuenta = "";

      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var dc1 = AQUtil.calcularDC(entidad + agencia);
        var dc2 = AQUtil.calcularDC(cuenta);
        valor = dc1 + dc2;
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
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "nombrecliente": {
      this.child("fdbConcepto").setValue(_i.calculateField("concepto"));
      break;
    }
    case "pagado" : {
      if (cursor.valueBuffer("pagado")) {
        this.child("fdbFechaPago").setDisabled(false);
        this.child("fdbFechaPago").setValue(_i.calculateField("fechapago"));
      } else {
        this.child("fdbFechaPago").setValue("");
        this.child("fdbFechaPago").setDisabled(true);
      }
      break;
    }
    case "codcuenta":
    case "ctaentidad":
    case "ctaagencia":
    case "cuenta": {
      this.child("fdbDc").setValue(_i.calculateField("dc"));
      break;
    }
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
