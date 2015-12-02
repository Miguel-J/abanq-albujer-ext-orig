/***************************************************************************
                 dtoscompletosprov.qs  -  description
                             -------------------
    begin                : mar dic 16 2008
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
  var bloqueoArticulo_: Boolean;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function comprobarVacio(campoCodigo: String, controlValor: String)
  {
    return this.ctx.oficial_comprobarVacio(campoCodigo, controlValor);
  }
  function dameWhere(criterios: Array): String {
    return this.ctx.oficial_dameWhere(criterios);
  }
  function comprobarUnicidad(): String {
    return this.ctx.oficial_comprobarUnicidad();
  }
  function dameIntervalo(criterios: Array, fecha: String, masWhere: String): Array {
    return this.ctx.oficial_dameIntervalo(criterios, fecha, masWhere);
  }
  /// Propuesto por José Antonio
  function dameIntervaloDto(criterios: Array, fecha: String): Array {
    return this.ctx.oficial_dameIntervaloDto(criterios, fecha);
  }
  function dameWhereDto(criterios: Array): String {
    return this.ctx.oficial_dameWhereDto(criterios);
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
  function pub_dameIntervalo(criterios: Array, fecha: String, masWhere: String): Array {
    return this.dameIntervalo(criterios, fecha, masWhere);
  }
  /// Propuesto por José Antonio
  function pub_dameIntervaloDto(criterios: Array, fecha: String): Array {
    return this.dameIntervaloDto(criterios, fecha);
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

  this.iface.bloqueoArticulo_ = false;

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.iface.bloqueoArticulo_ = true;
      this.iface.comprobarVacio("codproveedor", "fdbNombre");
      this.iface.comprobarVacio("codfamilia", "fdbFamilia");
      this.iface.comprobarVacio("codsubfamilia", "fdbSubfamilia");
      this.iface.comprobarVacio("referencia", "fdbArticulo");
      this.iface.bloqueoArticulo_ = false;
      break;
    }
    case cursor.Edit: {
      this.iface.bloqueoArticulo_ = true;
      if (!cursor.isNull("referencia")) {
        this.iface.comprobarVacio("referencia", "fdbArticulo");
      }
      if (!cursor.isNull("codfamilia")) {
        this.iface.comprobarVacio("codfamilia", "fdbFamilia");
      }
      if (!cursor.isNull("codsubfamilia")) {
        this.iface.comprobarVacio("codsubfamilia", "fdbSubfamilia");
      }
      this.iface.bloqueoArticulo_ = false;
      break;
    }
  }
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isNull("desde") && !cursor.isNull("hasta"))
  {
    var fechaDesde: String = cursor.valueBuffer("desde");
    var fechaHasta: String = cursor.valueBuffer("hasta");
    if (util.daysTo(fechaHasta, fechaDesde) > 0) {
      MessageBox.warning(util.translate("scripts", "La fecha desde debe ser menor que la fecha hasta"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  var hayReferencia: Boolean = (!cursor.isNull("referencia"));
  var haySubfamilia: Boolean = (!cursor.isNull("codsubfamilia"));
  var hayFamilia: Boolean = (!cursor.isNull("codfamilia"));

  if ((hayReferencia && haySubfamilia) || (hayReferencia && hayFamilia) || (haySubfamilia && hayFamilia))
  {
    MessageBox.warning(util.translate("scripts", "Sólo puede indicar un valor de entre artículo, familia y subfamilia"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codIntervalo: String = this.iface.comprobarUnicidad();
  if (codIntervalo != "OK")
  {
    MessageBox.warning(util.translate("scripts", "La combinación e intervalo introducidos se superponen a otro intervalo ya existente (%1)").arg(codIntervalo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
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
    case "codproveedor": {
      this.iface.comprobarVacio("codproveedor", "fdbNombre");
      break;
    }
    case "codfamilia": {
      if (!this.iface.bloqueoArticulo_) {
        this.iface.bloqueoArticulo_ = true;
        this.iface.comprobarVacio("codfamilia", "fdbFamilia");
        this.iface.bloqueoArticulo_ = false;
      }
      break;
    }
    case "codsubfamilia": {
      if (!this.iface.bloqueoArticulo_) {
        this.iface.bloqueoArticulo_ = true;
        this.iface.comprobarVacio("codsubfamilia", "fdbSubfamilia");
        this.iface.bloqueoArticulo_ = false;
      }
      break;
    }
    case "referencia": {
      if (!this.iface.bloqueoArticulo_) {
        this.iface.bloqueoArticulo_ = true;
        this.iface.comprobarVacio("referencia", "fdbArticulo");
        this.iface.bloqueoArticulo_ = false;
      }
      break;
    }
  }
}

function oficial_comprobarVacio(campoCodigo: String, controlValor: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var valor: String = cursor.valueBuffer(campoCodigo);
  var vacio: Boolean = (!valor || valor.isEmpty());
  var todos: String = util.translate("scripts", "(TODOS)");
  if (vacio) {
    this.child(controlValor).setValue(todos);
    switch (campoCodigo) {
      case "referencia":
      case "codfamilia":
      case "codsubfamilia": {
        this.child("fdbReferencia").setDisabled(false);
        this.child("fdbCodFamilia").setDisabled(false);
        this.child("fdbCodSubfamilia").setDisabled(false);
        break;
      }
    }
  } else {
    switch (campoCodigo) {
      case "referencia": {
        this.child("fdbCodFamilia").setDisabled(true);
        this.child("fdbCodSubfamilia").setDisabled(true);
        this.child("fdbCodFamilia").setValue("");
        this.child("fdbCodSubfamilia").setValue("");
        this.child("fdbFamilia").setValue(todos);
        this.child("fdbSubfamilia").setValue(todos);
        break;
      }
      case "codfamilia": {
        this.child("fdbReferencia").setDisabled(true);
        this.child("fdbCodSubfamilia").setDisabled(true);
        this.child("fdbReferencia").setValue("");
        this.child("fdbCodSubfamilia").setValue("");
        this.child("fdbArticulo").setValue(todos);
        this.child("fdbSubfamilia").setValue(todos);
        break;
      }
      case "codsubfamilia": {
        this.child("fdbReferencia").setDisabled(true);
        this.child("fdbCodFamilia").setDisabled(true);
        this.child("fdbReferencia").setValue("");
        this.child("fdbCodFamilia").setValue("");
        this.child("fdbFamilia").setValue(todos);
        this.child("fdbArticulo").setValue(todos);
        break;
      }
    }
  }
}

function oficial_comprobarUnicidad(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.valueBuffer("activo"))
  {
    return "OK";
  }
  var criterios: Array = [];
  criterios["codproveedor"] = cursor.valueBuffer("codproveedor");
  criterios["codfamilia"] = cursor.valueBuffer("codfamilia");
  criterios["codsubfamilia"] = cursor.valueBuffer("codsubfamilia");
  criterios["referencia"] = cursor.valueBuffer("referencia");

  var where: String = this.iface.dameWhere(criterios);
  var masWhere: String = " AND coddescuento <> '" + cursor.valueBuffer("coddescuento") + "'";

  var fechaDesde: String = cursor.valueBuffer("desde");
  if (!fechaDesde)
  {
    fechaDesde = "";
  }
  fechaDesde = fechaDesde.toString();

  var fechaHasta: String = cursor.valueBuffer("hasta");
  if (!fechaHasta)
  {
    fechaHasta = "";
  }
  fechaHasta = fechaHasta.toString();

  var datosIntervalo: Array;
  var codDescuento: String;
  if (fechaDesde.isEmpty())
  {
    codDescuento = util.sqlSelect("dtoscompletosprov", "coddescuento", "desde IS NULL AND " + where + masWhere);
    if (codDescuento) {
      return codDescuento;
    }
  } else {
    datosIntervalo = this.iface.dameIntervalo(criterios, fechaDesde, masWhere);
    if (datosIntervalo)
    {
      return datosIntervalo["coddescuento"];
    }
  }

  if (fechaHasta.isEmpty())
  {
    codDescuento = util.sqlSelect("dtoscompletosprov", "coddescuento", "hasta IS NULL AND " + where + masWhere);
    if (codDescuento) {
      return codDescuento;
    }
  } else {
    datosIntervalo = this.iface.dameIntervalo(criterios, fechaHasta, masWhere);
    if (datosIntervalo)
    {
      return datosIntervalo["coddescuento"];
    }
  }

  if (fechaDesde.isEmpty() && fechaHasta.isEmpty())
  {
    codDescuento = util.sqlSelect("dtoscompletosprov", "coddescuento", where + masWhere);
    if (codDescuento) {
      return codDescuento;
    }
  }

  return "OK";
}


function oficial_dameWhere(criterios: Array): String {
  var where: String = "";
  if (criterios["codproveedor"] != "")
  {
    where += "codproveedor = '" + criterios["codproveedor"] + "'";
  } else {
    where += "codproveedor IS NULL";
  }

  if (criterios["codfamilia"] != "")
  {
    where += " AND codfamilia = '" + criterios["codfamilia"] + "'";
  } else {
    where += " AND codfamilia IS NULL";
  }

  if (criterios["codsubfamilia"] != "")
  {
    where += " AND codsubfamilia = '" + criterios["codsubfamilia"] + "'";
  } else {
    where += " AND codsubfamilia IS NULL";
  }

  if (criterios["referencia"] != "")
  {
    where += " AND referencia = '" + criterios["referencia"] + "'";
  } else {
    where += " AND referencia IS NULL";
  }
  where += " AND activo = true";

  return where;
}

function oficial_dameIntervalo(criterios: Array, fecha: String, masWhere: String): Array {
  var util: FLUtil = new FLUtil;
  var datos: Array = [];

  var where: String = this.iface.dameWhere(criterios);
  if (!masWhere)
  {
    masWhere = "";
  }

  var whereFecha: String = " AND (desde IS NULL OR desde <= '" + fecha + "') AND (hasta IS NULL OR hasta >= '" + fecha + "')" ;

  var query: FLSqlQuery = new FLSqlQuery();
  query.setTablesList("dtoscompletosprov");
  query.setSelect("coddescuento, dtopor, dtolineal, sumar");
  query.setFrom("dtoscompletosprov");
  query.setWhere(where + whereFecha + masWhere);
  query.setForwardOnly(true);

  if (!query.exec())
  {
    return false;
  }
  debug(query.sql());
  if (!query.first())
  {
    return false;
  }
  datos["coddescuento"] = query.value("coddescuento");
  datos["dtopor"] = query.value("dtopor");
  datos["dtolineal"] = query.value("dtolineal");
  datos["sumar"] = query.value("sumar");
  return datos;
}

/// Propuesto por José Antonio
function oficial_dameIntervaloDto(criterios: Array, fecha: String): Array {
  var util: FLUtil = new FLUtil;
  var datos: Array = [];

  var where: String = this.iface.dameWhereDto(criterios);

  var whereFecha: String = " AND (desde IS NULL OR desde <= '" + fecha + "') AND (hasta IS NULL OR hasta >= '" + fecha + "')" ;

  var query: FLSqlQuery = new FLSqlQuery();
  query.setTablesList("dtoscompletosprov");
  query.setSelect("coddescuento, dtopor, dtolineal, sumar, codproveedor, referencia, codsubfamilia, codfamilia");
  query.setFrom("dtoscompletosprov");
  query.setWhere(where + whereFecha + " ORDER BY codproveedor, referencia, codsubfamilia, codfamilia");
  query.setForwardOnly(true);

  if (!query.exec())
  {
    return false;
  }
  debug(query.sql());
  if (!query.first())
  {
    return false;
  }
  datos["coddescuento"] = query.value("coddescuento");
  datos["dtopor"] = query.value("dtopor");
  datos["dtolineal"] = query.value("dtolineal");
  datos["sumar"] = query.value("sumar");
  return datos;
}

/// Propuesto por José Antonio
function oficial_dameWhereDto(criterios: Array): String {
  var where: String = "";
  if (criterios["codproveedor"] != "")
  {
    where += "(codproveedor = '" + criterios["codproveedor"] + "' OR codproveedor IS NULL)";
  } else {
    where += "codproveedor IS NULL";
  }

  if (criterios["codfamilia"] != "")
  {
    where += " AND (codfamilia = '" + criterios["codfamilia"] + "' OR codfamilia IS NULL)";
  } else {
    where += " AND codfamilia IS NULL";
  }

  if (criterios["codsubfamilia"] != "")
  {
    where += " AND (codsubfamilia = '" + criterios["codsubfamilia"] + "' OR codsubfamilia IS NULL)";
  } else {
    where += " AND codsubfamilia IS NULL";
  }

  if (criterios["referencia"] != "")
  {
    where += " AND (referencia = '" + criterios["referencia"] + "' OR referencia IS NULL)";
  } else {
    where += " AND referencia IS NULL";
  }
  where += " AND activo = true";

  return where;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
