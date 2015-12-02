/***************************************************************************
                 servicioscli.qs  -  description
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
    this.ctx.interna_init();
  }
  function calculateField(fN: String): String { return this.ctx.interna_calculateField(fN); }
  function calculateCounter(): String { return this.ctx.interna_calculateCounter(); }
  function validateForm(): Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var refHora: String;
  var refDesp: String;
  var curLineaServicio_: FLSqlCursor;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function calcularTotales()
  {
    return this.ctx.oficial_calcularTotales();
  }
  function generarCostes()
  {
    return this.ctx.oficial_generarCostes();
  }
  function mostrarTraza()
  {
    return this.ctx.oficial_mostrarTraza();
  }
  function datosLineaServicio(datosArt: Array): Boolean {
    return this.ctx.oficial_datosLineaServicio(datosArt);
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
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
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
/** \C
Este formulario realiza la gestión de los albaranes a clientes.

Los albaranes pueden ser generados de forma manual o a partir de uno o más pedidos.
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tdbLineasServiciosCli").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  connect(this.child("pbnGenerarCostes"), "clicked()", this, "iface.generarCostes");
  connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
  }

  this.iface.refHora = "HMN";
  this.iface.refDesp = "DSP";
}

/** \D Calcula un nuevo número de servicio
\end */
function interna_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  return util.nextCounter("numservicio", this.cursor());
}

function interna_calculateField(fN: String): String {
  return this.iface.commonCalculateField(fN, this.cursor());
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;

  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var datosEjercicio = flfactppal.iface.pub_ejecutarQry("ejercicios", "fechainicio,fechafin", "codejercicio = '" + codEjercicio + "'");
  if (datosEjercicio.result > 0)
    if (this.cursor().valueBuffer("fecha") < datosEjercicio.fechainicio || this.cursor().valueBuffer("fecha") > datosEjercicio.fechafin)
    {
      MessageBox.warning(util.translate("scripts", "La fecha del servicio no corresponde al ejercicio actual ") + codEjercicio, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }

  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
      /** \C
      El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
      \end */
    case "total":
      var neto: Number = parseFloat(cursor.valueBuffer("neto"));
      var totalIva: Number = parseFloat(cursor.valueBuffer("totaliva"));
      var totalRecargo: Number = parseFloat(cursor.valueBuffer("totalrecargo"));
      var totalIrpf: Number = parseFloat(cursor.valueBuffer("totalirpf"));
      valor = neto - totalIrpf + totalIva + totalRecargo;
      break;
      /** \C
      El --neto-- es la suma del pvp total de las líneas de servicio
      \end */
    case "neto":
      valor = util.sqlSelect("lineasservicioscli", "SUM(pvptotal)", "idservicio = " + cursor.valueBuffer("idservicio"));
      break;
      /** \C
      El --totaliva-- es la suma del iva correspondiente a las líneas de servicio
      \end */
    case "totaliva":
      valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * iva) / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totaliva"));
      break;
      /** \C
      El --totarecargo-- es la suma del recargo correspondiente a las líneas de servicio
      \end */
    case "totalrecargo":
      valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * recargo) / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totalrecargo"));
      break;

    case "irpf":
      valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
      break;
      /** \C
      El --totalirpf-- es el producto del --irpf-- por el --neto--
      \end */
    case "totalirpf":
      valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * irpf) / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
      //      valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totalirpf"));
      break;

  }
  return valor;
}

function oficial_calcularTotales()
{
  var util: FLUtil = new FLUtil;

  this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
  this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
  this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  switch (fN) {
      /** \C
      El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
      \end */
    case "neto":
      this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
    case "totalrecargo":
    case "totaliva":
    case "totalirpf": {
      this.child("fdbTotal").setValue(this.iface.calculateField("total"));
      break;
    }
    /** \C
    El --irpf-- es el asociado a la --codserie-- del albaran
    \end */
    case "codserie": {
      this.cursor().setValueBuffer("irpf", this.iface.calculateField("irpf"));
      break;
    }
    /** \C
    El --totalirpf-- es el producto del --irpf-- por el --neto--
    \end */
    case "irpf": {
      this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
      break;
    }
  }
}

function oficial_generarCostes()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    var curDir: FLSqlCursor = this.child("tdbLineasServiciosCli").cursor();
    curDir.setModeAccess(curDir.Insert);
    if (!curDir.commitBufferCursorRelation())
      debug("NO COMMIT");
  }


  // Línea de horas de mano de obra ////////////////////////////////////////////

  var datosArt = flfactppal.iface.pub_ejecutarQry("articulos", "descripcion,pvp,codimpuesto", "referencia = '" + this.iface.refHora + "'");
  if (datosArt["result"] == -1) {
    MessageBox.warning(util.translate("scripts", "No se encuentra el artículo de hora técnica.\nDebe crearlo con la referencia ") + this.iface.refHora, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var codTarifa: String = util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + cursor.valueBuffer("codcliente") + "'", "clientes,gruposclientes");
  if (codTarifa)
    var valor: Number = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + this.iface.refHora + "' AND codtarifa = '" + codTarifa + "'");
  if (valor)
    datosArt["pvp"] = valor;

  // datos de IVA
  var iva: Number = 0;
  var recargo: Number = 0;
  var datosIVA = flfacturac.iface.pub_datosImpuesto(datosArt["codimpuesto"], cursor.valueBuffer("fecha"));
  if (datosIVA)
    iva = datosIVA["iva"];

  delete this.iface.curLineaServicio_
  this.iface.curLineaServicio_ = new FLSqlCursor("lineasservicioscli");

  this.iface.curLineaServicio_.select("idservicio = " + cursor.valueBuffer("idservicio") + " AND referencia = '" + this.iface.refHora + "'");
  if (this.iface.curLineaServicio_.first()) {
    MessageBox.warning(util.translate("scripts", "Este servicio ya tiene una línea de mano de obra"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  } else {
    var horas: Number = parseInt(cursor.valueBuffer("horas")) + (parseInt(cursor.valueBuffer("minutos")) / 60);

    if (horas == 0) {
      MessageBox.warning(util.translate("scripts", "Para generar la línea de mano de obra el tiempo empleado debe ser mayor de cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    } else {
      this.iface.curLineaServicio_.setModeAccess(this.iface.curLineaServicio_.Insert);
      this.iface.curLineaServicio_.refreshBuffer();
      this.iface.curLineaServicio_.setValueBuffer("idservicio", cursor.valueBuffer("idservicio"));
      this.iface.curLineaServicio_.setValueBuffer("referencia", this.iface.refHora);
      this.iface.curLineaServicio_.setValueBuffer("descripcion", datosArt["descripcion"]);
      this.iface.curLineaServicio_.setValueBuffer("cantidad", horas);
      this.iface.curLineaServicio_.setValueBuffer("iva", iva);
      this.iface.curLineaServicio_.setValueBuffer("recargo", recargo);
      this.iface.curLineaServicio_.setValueBuffer("codimpuesto", datosArt["codimpuesto"]);
      this.iface.curLineaServicio_.setValueBuffer("pvpunitario", datosArt["pvp"]);
      this.iface.curLineaServicio_.setValueBuffer("pvpsindto", datosArt["pvp"] * horas);
      this.iface.curLineaServicio_.setValueBuffer("pvptotal", datosArt["pvp"] * horas);
      if (!this.iface.datosLineaServicio(datosArt))
        return false;
      if (!this.iface.curLineaServicio_.commitBuffer())
        return false;
    }
  }


  // Línea de desplazamiento  ////////////////////////////////////////////

  datosArt = flfactppal.iface.pub_ejecutarQry("articulos", "descripcion,pvp,codimpuesto", "referencia = '" + this.iface.refDesp + "'");
  if (datosArt["result"] == -1) {
    MessageBox.warning(util.translate("scripts", "No se encuentra el artículo de desplazamiento.\nDebe crearlo con la referencia ") + this.iface.refDesp, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  codTarifa = util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + cursor.valueBuffer("codcliente") + "'", "clientes,gruposclientes");
  if (codTarifa)
    valor = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + this.iface.refDesp + "' AND codtarifa = '" + codTarifa + "'");
  if (valor)
    datosArt["pvp"] = valor;

  // datos de IVA
  iva = 0;
  recargo = 0;
  datosIVA = flfacturac.iface.pub_datosImpuesto(datosArt["codimpuesto"], cursor.valueBuffer("fecha"));

  if (datosIVA)
    iva = datosIVA["iva"];

  this.iface.curLineaServicio_.select("idservicio = " + cursor.valueBuffer("idservicio") + " AND referencia = '" + this.iface.refDesp + "'");
  if (this.iface.curLineaServicio_.first()) {
    MessageBox.warning(util.translate("scripts", "Este servicio ya tiene una línea de desplazamiento"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  } else {
    this.iface.curLineaServicio_.setModeAccess(this.iface.curLineaServicio_.Insert);
    this.iface.curLineaServicio_.refreshBuffer();
    this.iface.curLineaServicio_.setValueBuffer("idservicio", cursor.valueBuffer("idservicio"));
    this.iface.curLineaServicio_.setValueBuffer("referencia", this.iface.refDesp);
    this.iface.curLineaServicio_.setValueBuffer("descripcion", datosArt["descripcion"]);
    this.iface.curLineaServicio_.setValueBuffer("cantidad", 1);
    this.iface.curLineaServicio_.setValueBuffer("iva", iva);
    this.iface.curLineaServicio_.setValueBuffer("recargo", recargo);
    this.iface.curLineaServicio_.setValueBuffer("codimpuesto", datosArt["codimpuesto"]);
    this.iface.curLineaServicio_.setValueBuffer("pvpunitario", datosArt["pvp"]);
    this.iface.curLineaServicio_.setValueBuffer("pvpsindto", datosArt["pvp"]);
    this.iface.curLineaServicio_.setValueBuffer("pvptotal", datosArt["pvp"]);
    if (!this.iface.datosLineaServicio(datosArt))
      return false;
    if (!this.iface.curLineaServicio_.commitBuffer())
      return false;
  }

  this.child("tdbLineasServiciosCli").refresh();
  this.iface.calcularTotales();
}

function oficial_mostrarTraza()
{
  flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("numservicio"), "servicioscli");
}

function oficial_datosLineaServicio(datosArt: Array): Boolean {
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
