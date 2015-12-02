/***************************************************************************
                 bultosdespacho.qs  -  description
                             -------------------
    begin                : lun jun 29 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
  function validarArticuloSuelto(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_validarArticuloSuelto(cursor);
  }
  function habilitarPorArticuloSuelto()
  {
    return this.ctx.oficial_habilitarPorArticuloSuelto();
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
  function pub_validarArticuloSuelto(cursor: FLSqlCursor): Boolean {
    return this.validarArticuloSuelto(cursor);
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
\end */
function interna_init()
{
  debug("init");
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.child("tdbLineasBulto").setReadOnly(true);

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tdbLineasBulto").cursor(), "bufferCommited()", this, "iface.calcularTotales");
  connect(this.child("tdbEmbalajesBulto").cursor(), "bufferCommited()", this, "iface.calcularTotales");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbNumero").setValue(this.iface.calculateField("numero"));
      break;
    }
  }
  this.iface.habilitarPorArticuloSuelto();
}

function interna_calculateField(fN: String): String {
  debug("cf " + fN);
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  switch (fN)
  {
    default: {
      valor = this.iface.commonCalculateField(fN, cursor);
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
function oficial_calcularTotales()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.child("fdbPesoBruto").setValue(this.iface.calculateField("pesobruto"));
  this.child("fdbPesoNeto").setValue(this.iface.calculateField("pesoneto"));
  if (!this.iface.validarArticuloSuelto(cursor)) {
    this.child("fdbArticuloSuelto").setValue(false);
  }
  if (cursor.valueBuffer("articulosuelto")) {
    this.child("fdbAlto").setValue(this.iface.calculateField("alto"));
    this.child("fdbLargo").setValue(this.iface.calculateField("largo"));
    this.child("fdbAncho").setValue(this.iface.calculateField("ancho"));
  }
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "alto":
    case "largo":
    case "ancho": {
      this.child("fdbVolumen").setValue(this.iface.calculateField("volumen"));
      break;
    }
    case "volumen": {
      this.child("fdbPesoVol").setValue(this.iface.calculateField("pesovol"));
      break;
    }
    case "articulosuelto": {
      if (!this.iface.validarArticuloSuelto(cursor)) {
        this.child("fdbArticuloSuelto").setValue(false);
        break;
      }
      if (cursor.valueBuffer("articulosuelto")) {
        this.child("fdbAlto").setValue(this.iface.calculateField("alto"));
        this.child("fdbLargo").setValue(this.iface.calculateField("largo"));
        this.child("fdbAncho").setValue(this.iface.calculateField("ancho"));
      }
      this.iface.habilitarPorArticuloSuelto();
      break;
    }
  }
}

function oficial_validarArticuloSuelto(cursor: FLSqlCursor): Boolean {
  if (!cursor.valueBuffer("articulosuelto"))
  {
    return true;
  }
  var util: FLUtil = new FLUtil();
  var canArticulos: Number = parseInt(util.sqlSelect("lineasbulto", "SUM(cantidad)", "idbulto = " + cursor.valueBuffer("idbulto")));
  if (isNaN(canArticulos))
  {
    canArticulos = 0;
  }
  if (canArticulos > 1)
  {
    MessageBox.warning(util.translate("scripts", "Si el bulto contiene varios artículos no puede marcarse como artículo suelto"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (util.sqlSelect("embalajesbulto", "COUNT(idembalaje)", "idbulto = " + cursor.valueBuffer("idbulto")))
  {
    MessageBox.warning(util.translate("scripts", "Si el bulto contiene embalajes no puede marcarse como artículo suelto"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_habilitarPorArticuloSuelto()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("articulosuelto")) {
    this.child("fdbAncho").setDisabled(true);
    this.child("fdbAlto").setDisabled(true);
    this.child("fdbLargo").setDisabled(true);
  } else {
    this.child("fdbAncho").setDisabled(false);
    this.child("fdbAlto").setDisabled(false);
    this.child("fdbLargo").setDisabled(false);
  }
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("oficial_commonCalculateField " + fN);
  var util: FLUtil = new FLUtil();
  var valor: String;
  switch (fN)
  {
    case "numero": {
      valor = util.sqlSelect("bultosdespacho", "numero", "iddespacho = " + cursor.valueBuffer("iddespacho") + " ORDER BY numero DESC");
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor++;
      break;
    }
    case "pesobruto": {
      var pesoMaterial: Number = parseFloat(util.sqlSelect("lineasbulto", "SUM(peso)", "idbulto = " + cursor.valueBuffer("idbulto")));
      if (isNaN(pesoMaterial)) {
        pesoMaterial = 0;
      }
      var pesoEmbalajes: Number = parseFloat(util.sqlSelect("embalajesbulto", "SUM(peso)", "idbulto = " + cursor.valueBuffer("idbulto")));
      if (isNaN(pesoEmbalajes)) {
        pesoEmbalajes = 0;
      }
      valor = parseFloat(pesoMaterial) + parseFloat(pesoEmbalajes);
      break;
    }
    case "pesoneto": {
      var pesoMaterial: Number = parseFloat(util.sqlSelect("lineasbulto", "SUM(peso)", "idbulto = " + cursor.valueBuffer("idbulto")));
      if (isNaN(pesoMaterial)) {
        pesoMaterial = 0;
      }
      valor = parseFloat(pesoMaterial);
      break;
    }
    case "volumen": {
      valor = parseFloat(cursor.valueBuffer("largo")) * parseFloat(cursor.valueBuffer("ancho")) * parseFloat(cursor.valueBuffer("alto"));
      valor = valor / 1000000000;   // Unidades en mm, volumen en m3
      break;
    }
    case "pesovol": {
      var curDespacho: FLSqlCursor = cursor.cursorRelation();
      var factorPV: Number = parseFloat(util.sqlSelect("mediostransporte", "factorpv", "codmediotransporte = '" + curDespacho.valueBuffer("codmediotransporte") + "'"));
      if (isNaN(factorPV)) {
        factorPV = 0;
      }
      if (factorPV == 0) {
        valor = 0;
      } else {
        valor = parseFloat(cursor.valueBuffer("volumen")) / factorPV;
      }
      valor = Math.ceil(valor);
      break;
    }
    case "alto": {
      if (cursor.valueBuffer("articulosuelto")) {
        var codUnidad: String = util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.codunidadalto", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos");
        valor = parseFloat(util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.alto", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos"));
        if (isNaN(valor)) {
          valor = 0;
        }
        valor = flfactalma.iface.pub_convertirValorUnidades(valor, codUnidad, "mm");
      } else {
        valor = cursor.valueBuffer("alto");
      }
      break;
    }
    case "largo": {
      if (cursor.valueBuffer("articulosuelto")) {
        var codUnidad: String = util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.codunidadlargo", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos");
        valor = parseFloat(util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.largo", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos"));
        if (isNaN(valor)) {
          valor = 0;
        }
        valor = flfactalma.iface.pub_convertirValorUnidades(valor, codUnidad, "mm");
      } else {
        valor = cursor.valueBuffer("largo");
      }
      break;
    }
    case "ancho": {
      if (cursor.valueBuffer("articulosuelto")) {
        var codUnidad: String = util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.codunidadancho", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos");
        valor = parseFloat(util.sqlSelect("lineasbulto lb INNER JOIN articulos a ON lb.referencia = a.referencia", "a.ancho", "idbulto = " + cursor.valueBuffer("idbulto"), "lineasbulto,articulos"));
        if (isNaN(valor)) {
          valor = 0;
        }
        valor = flfactalma.iface.pub_convertirValorUnidades(valor, codUnidad, "mm");
      } else {
        valor = cursor.valueBuffer("ancho");
      }
      break;
    }
  }
  debug("valor " + valor);
  return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
