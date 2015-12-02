
/** @class_declaration dtosCompletosProv */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
class dtosCompletosProv extends oficial
{
  function dtosCompletosProv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.dtosCompletosProv_init();
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.dtosCompletosProv_commonBufferChanged(fN, miForm);
  }
  function dameValorDescuento(fN: String, cursor: FLSqlCursor, datosTP: Array): Number {
    return this.ctx.dtosCompletosProv_dameValorDescuento(fN, cursor, datosTP);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.dtosCompletosProv_commonCalculateField(fN, cursor);
  }
}
//// DESCUENTOS COMPLETOS A PROVEEDORES ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtosCompletosProv */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
function dtosCompletosProv_init()
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

function dtosCompletosProv_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
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

function dtosCompletosProv_commonBufferChanged(fN: String, miForm: Object)
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

/// Propuesto por José Antonio
function dtosCompletosProv_dameValorDescuento(fN: String, cursor: FLSqlCursor, datosTP: Array): Number {
  var util: FLUtil = new FLUtil();
  var valor: Number = 0;

  var referencia: String = cursor.valueBuffer("referencia");
  var codProveedor: String;
  var hayCursorRelation: Boolean = false;
  if (cursor.cursorRelation() && cursor.cursorRelation().table() == datosTP.tabla)
  {
    codProveedor = cursor.cursorRelation().valueBuffer("codproveedor");
    hayCursorRelation = true;
  } else {
    hayCursorRelation = false;
    codProveedor = util.sqlSelect(datosTP.tabla, "codproveedor", datosTP.where);
  }
  debug("codProveedor " + codProveedor);

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

  criterios["codproveedor"] = codProveedor;
  criterios["codfamilia"] = codFamilia;
  criterios["codsubfamilia"] = codSubfamilia;
  criterios["referencia"] = referencia;
  datosIntervalo = formRecorddtoscompletosprov.iface.pub_dameIntervaloDto(criterios, fecha);

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

//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
/////////////////////////////////////////////////////////////////
