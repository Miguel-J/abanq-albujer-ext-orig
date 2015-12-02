/***************************************************************************
                 co_modelo201.qs  -  description
                             -------------------
    begin                : vie mar 14 2008
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
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm(): Boolean {
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
  function establecerFechasPeriodo()
  {
    return this.ctx.oficial_establecerFechasPeriodo();
  }
  function comprobarFechas(): String {
    return this.ctx.oficial_comprobarFechas();
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
    this.child("fdbNombre").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("nombre"));
    this.child("fdbNif").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif"));
    this.iface.establecerFechasPeriodo();
  }

}


function interna_calculateField(fN)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor;
  switch (fN) {
    case "dcdev":
      var entidad: String = cursor.valueBuffer("ctaentidaddev");
      var agencia: String = cursor.valueBuffer("ctaagenciadev");
      var cuenta: String = cursor.valueBuffer("cuentadev");
      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var dc1: String = util.calcularDC(entidad + agencia);
        var dc2: String = util.calcularDC(cuenta);
        valor = dc1 + dc2;
      }
      break;

    case "dcingreso":
      var entidad: String = cursor.valueBuffer("ctaentidadingreso");
      var agencia: String = cursor.valueBuffer("ctaagenciaingreso");
      var cuenta: String = cursor.valueBuffer("cuentaingreso");
      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var dc1: String = util.calcularDC(entidad + agencia);
        var dc2: String = util.calcularDC(cuenta);
        valor = dc1 + dc2;
      }
      break;
  }
  return valor;
}

function interna_validateForm(): Boolean {
  /** \C Las fechas que definen el período deben ser coherentes (fin > inicio) y pertenecer al ejercicio seleccionado
  \end */
  if (!this.iface.comprobarFechas())
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
  switch (fN) {
    case "periodo":
      this.iface.establecerFechasPeriodo();
      break;

    case "codejercicio":
      this.iface.establecerFechasPeriodo();
      break;

    case "codcuentadev":
    case "ctaentidaddev":
    case "ctaagenciadev":
    case "cuentadev":
      this.child("fdbDcDevol").setValue(this.iface.calculateField("dcdev"));
      break;

    case "codcuentaingreso":
    case "ctaentidadingreso":
    case "ctaagenciaingreso":
    case "cuentaingreso":
      this.child("fdbDcIng").setValue(this.iface.calculateField("dcingreso"));
      break;

  }
}

/** \D Establece las fechas de inicio y fin de trimestre en función del trimestre seleccionado
\end */
function oficial_establecerFechasPeriodo()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var fechaInicio: Date;
  var fechaFin: Date;

  var codEjercicio: String = cursor.valueBuffer("codejercicio");
  if (!codEjercicio || codEjercicio == "")
    return false;

  var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  if (!inicioEjercicio)
    return false;

  fechaInicio.setYear(inicioEjercicio.getYear());
  fechaFin.setYear(inicioEjercicio.getYear());
  fechaInicio.setDate(1);

  switch (this.child("fdbPeriodo").value()) {
    case 0:
      fechaInicio.setMonth(1);
      fechaFin.setMonth(3);
      fechaFin.setDate(31);
      break;
    case 1:
      fechaInicio.setMonth(4);
      fechaFin.setMonth(6);
      fechaFin.setDate(30);
      break;
    case 2:
      fechaInicio.setMonth(7);
      fechaFin.setMonth(9);
      fechaFin.setDate(30);
      break;
    case 3:
      fechaInicio.setMonth(10);
      fechaFin.setMonth(12);
      fechaFin.setDate(31);
      break;
  }

  this.child("fdbFechaInicio").setValue(fechaInicio);
  this.child("fdbFechaFin").setValue(fechaFin);
}

/** \D Comprueba que fechainicio < fechafin y que ambas pertenecen al ejercicio seleccionado

@return True si la comprobación es buena, false en caso contrario
\end */
function oficial_comprobarFechas(): Boolean {
  var util: FLUtil = new FLUtil();

  var codEjercicio: String = this.child("fdbCodEjercicio").value();
  var fechaInicio: String = this.child("fdbFechaInicio").value();
  var fechaFin: String = this.child("fdbFechaFin").value();

  if (util.daysTo(fechaInicio, fechaFin) < 0)
  {
    MessageBox.critical(util.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var inicioEjercicio: String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  var finEjercicio: String = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");

  if ((util.daysTo(inicioEjercicio, fechaInicio) < 0) || (util.daysTo(fechaFin, finEjercicio) < 0))
  {
    MessageBox.critical(util.translate("scripts", "Las fechas seleccionadas no corresponden al ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
