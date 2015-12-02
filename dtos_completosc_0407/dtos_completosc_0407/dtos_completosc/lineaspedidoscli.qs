
/** @class_declaration dtosCompletosCli */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
class dtosCompletosCli extends oficial
{
  function dtosCompletosCli(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.dtosCompletosCli_init();
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.dtosCompletosCli_commonBufferChanged(fN, miForm);
  }
  function dameValorDescuento(fN: String, cursor: FLSqlCursor, datosTP: Array): Number {
    return this.ctx.dtosCompletosCli_dameValorDescuento(fN, cursor, datosTP);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.dtosCompletosCli_commonCalculateField(fN, cursor);
  }
}
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtosCompletosCli */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
function dtosCompletosCli_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
      this.child("fdbDtoLineal").setValue(this.iface.calculateField("dtolineal"));
      break;
    }
  }
}

function dtosCompletosCli_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var datosTP: Array = this.iface.datosTablaPadre(cursor);
  if (!datosTP)
  {
    return false;
  }
  var wherePadre: String = datosTP.where;
  var tablaPadre: String = datosTP.tabla;

  var valor: String;
  switch (fN)
  {
    case "dtopor": {
      valor = this.iface.dameValorDescuento(fN, cursor, datosTP);
      break;
    }
    case "dtolineal": {
      valor = this.iface.dameValorDescuento(fN, cursor, datosTP);
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function dtosCompletosCli_commonBufferChanged(fN: String, miForm: Object)
{
  var cursor: FLSqlCursor = miForm.cursor();
  switch (fN) {
    case "referencia": {
      this.iface.__commonBufferChanged(fN, miForm);
      miForm.child("fdbDtoPor").setValue(this.iface.commonCalculateField("dtopor", cursor));
      miForm.child("fdbDtoLineal").setValue(this.iface.commonCalculateField("dtolineal", cursor));
      break;
    }
    default: {
      this.iface.__commonBufferChanged(fN, miForm);
    }
  }
  return true;
}

function dtosCompletosCli_dameValorDescuento2(fN: String, cursor: FLSqlCursor, datosTP: Array): Number {
  var util: FLUtil = new FLUtil();
  var valor: Number = 0;

  var referencia: String = cursor.valueBuffer("referencia");
  var codCliente: String;
  var hayCursorRelation: Boolean = false;
  if (cursor.cursorRelation() && cursor.cursorRelation().table() == datosTP.tabla)
  {
    codCliente = cursor.cursorRelation().valueBuffer("codcliente");
    hayCursorRelation = true;
  } else {
    hayCursorRelation = false;
    codCliente = util.sqlSelect(datosTP.tabla, "codcliente", datosTP.where);
  }
  debug("codCliente " + codCliente);

  var codFamilia: String = "";
  var codSubfamilia: String = "";
  if (referencia != "")
  {
    var datosArticulo: Array;
    datosArticulo = flfactppal.iface.pub_ejecutarQry("articulos", "codfamilia,codsubfamilia", "referencia = '" + referencia + "'");
    if (datosArticulo["result"] != 1) {
      return 0;
    }
    codFamilia = datosArticulo["codfamilia"];
    codSubfamilia = datosArticulo["codsubfamilia"];
  }
  var fecha: String;
  if (hayCursorRelation)
  {
    fecha = cursor.cursorRelation().valueBuffer("fecha");
  } else {
    fecha = util.sqlSelect(datosTP.tabla, "fecha", datosTP.where);
  }

  var criterios: Array;
  var datosIntervalo: Array;

  if (codCliente && codCliente != "")
  {
    criterios["codcliente"] = codCliente;
    criterios["codfamilia"] = "";
    criterios["codsubfamilia"] = "";
    criterios["referencia"] = referencia;
    datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);

    if (!datosIntervalo && codSubfamilia && codSubfamilia != "") {
      criterios["codfamilia"] = "";
      criterios["codsubfamilia"] = codSubfamilia;
      criterios["referencia"] = "";
      datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
    }
    if (!datosIntervalo && codFamilia && codFamilia != "") {
      criterios["codfamilia"] = codFamilia;
      criterios["codsubfamilia"] = "";
      criterios["referencia"] = "";
      datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
    }
    if (!datosIntervalo) {
      criterios["codfamilia"] = "";
      criterios["codsubfamilia"] = "";
      criterios["referencia"] = "";
      datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
    }
  }
  if (!datosIntervalo)
  {
    criterios["codcliente"] = "";
    criterios["codfamilia"] = "";
    criterios["codsubfamilia"] = "";
    criterios["referencia"] = referencia;
    datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
  }
  if (!datosIntervalo && codSubfamilia && codSubfamilia != "")
  {
    criterios["codfamilia"] = "";
    criterios["codsubfamilia"] = codSubfamilia;
    criterios["referencia"] = "";
    datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
  }
  if (!datosIntervalo && codFamilia && codFamilia != "")
  {
    criterios["codfamilia"] = codFamilia;
    criterios["codsubfamilia"] = "";
    criterios["referencia"] = "";
    datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
  }
  if (!datosIntervalo && codFamilia && codFamilia != "")
  {
    criterios["codfamilia"] = "";
    criterios["codsubfamilia"] = "";
    criterios["referencia"] = "";
    datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervalo(criterios, fecha);
  }
  if (datosIntervalo)
  {
    valor = datosIntervalo[fN];
    if (datosIntervalo["sumar"]) {
      var otroDto: Number = this.iface.__commonCalculateField(fN, cursor);
      if (otroDto && !isNaN(otroDto)) {
        valor += parseFloat(otroDto);
      }
    }
  } else {
    var otroDto: Number = this.iface.__commonCalculateField(fN, cursor);
    if (!isNaN(otroDto))
    {
      valor += parseFloat(otroDto);
    }
  }

  return valor;
}

/// Propuesto por José Antonio
function dtosCompletosCli_dameValorDescuento(fN: String, cursor: FLSqlCursor, datosTP: Array): Number {
  var util: FLUtil = new FLUtil();
  var valor: Number = 0;

  var referencia: String = cursor.valueBuffer("referencia");
  var codCliente: String;
  var hayCursorRelation: Boolean = false;
  if (cursor.cursorRelation() && cursor.cursorRelation().table() == datosTP.tabla)
  {
    codCliente = cursor.cursorRelation().valueBuffer("codcliente");
    hayCursorRelation = true;
  } else {
    hayCursorRelation = false;
    codCliente = util.sqlSelect(datosTP.tabla, "codcliente", datosTP.where);
  }
  debug("codCliente " + codCliente);

  var codFamilia: String = "";
  var codSubfamilia: String = "";
  if (referencia && referencia != "")
  {
    var datosArticulo: Array;
    datosArticulo = flfactppal.iface.pub_ejecutarQry("articulos", "codfamilia,codsubfamilia", "referencia = '" + referencia + "'");
    if (datosArticulo["result"] != 1) {
      return 0;
    }
    codFamilia = datosArticulo["codfamilia"];
    codSubfamilia = datosArticulo["codsubfamilia"];
  }
  var fecha: String;
  if (hayCursorRelation)
  {
    fecha = cursor.cursorRelation().valueBuffer("fecha");
  } else {
    fecha = util.sqlSelect(datosTP.tabla, "fecha", datosTP.where);
  }

  var criterios: Array;
  var datosIntervalo: Array;

  criterios["codcliente"] = codCliente;
  criterios["codfamilia"] = codFamilia;
  criterios["codsubfamilia"] = codSubfamilia;
  criterios["referencia"] = referencia;
  datosIntervalo = formRecorddtoscompletoscli.iface.pub_dameIntervaloDto(criterios, fecha);

  if (datosIntervalo)
  {
    valor = datosIntervalo[fN];
    if (datosIntervalo["sumar"]) {
      var otroDto: Number = this.iface.__commonCalculateField(fN, cursor);
      if (otroDto && !isNaN(otroDto)) {
        valor += parseFloat(otroDto);
      }
    }
  } else {
    var otroDto: Number = this.iface.__commonCalculateField(fN, cursor);
    if (!isNaN(otroDto))
    {
      valor += parseFloat(otroDto);
    }
  }

  if (!valor)
    valor = 0;

  return valor;
}

//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
/////////////////////////////////////////////////////////////////
