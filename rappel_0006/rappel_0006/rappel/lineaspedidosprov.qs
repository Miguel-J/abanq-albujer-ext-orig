
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial
{
  function rappel(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.rappel_init();
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.rappel_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.rappel_commonCalculateField(fN, cursor);
  }
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_init()
{
  this.iface.__init();
  this.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", this.cursor()));
}

function rappel_commonBufferChanged(fN: String, miForm: Object)
{
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "referencia":
      miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
      var serie: String = miForm.cursor().cursorRelation().valueBuffer("codserie");
      var sinIva: Boolean = util.sqlSelect("series", "siniva", "codserie = '" + serie + "'");
      if (sinIva == false)
        miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
      miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
      break;
    case "dtorappel":
      miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
      miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
      break;
    case "cantidad":
      miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
      miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
      break;
    case "pvpsindto":
      miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
      miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
      miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
      break;
    default:
      this.iface.__commonBufferChanged(fN, miForm);
      break;
  }
}

function rappel_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var datosTP: Array = this.iface.datosTablaPadre(cursor);
  if (!datosTP)
    return false;
  var wherePadre: String = datosTP.where;
  var tablaPadre: String = datosTP.tabla;

  var valor: String;
  switch (fN)
  {
    case "dtorappel":
      var cantidad: String = cursor.valueBuffer("cantidad");
      cantidad = parseFloat(cantidad);
      if (!cantidad || cantidad < 0) {
        valor = 0;
        break;
      }
      var codProveedor: String = util.sqlSelect(tablaPadre, "codproveedor", wherePadre);
      var referencia: String = cursor.valueBuffer("referencia");
      valor = flfactppal.iface.pub_valorQuery("articulosprov,rappelprovart", "descuento", "articulosprov inner join rappelprovart on articulosprov.id = rappelprovart.id", "articulosprov.referencia = '" + referencia + "' AND articulosprov.codproveedor = '" + codProveedor + "' AND limiteinferior <= " + cantidad + " AND limitesuperior >= " + cantidad);
      if (!valor)
        valor = 0;
      break;
    case "lbldtorappel":
      valor = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
      break;
    case "pvptotal":
      var dtoPor: Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtopor"))) / 100;
      dtoPor = util.roundFieldValue(dtoPor, "lineaspedidosprov", "pvpsindto");
      var dtoRappel: Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
      dtoRappel = util.roundFieldValue(dtoRappel, "lineaspedidosprov", "pvpsindto");
      valor = parseFloat(cursor.valueBuffer("pvpsindto")) - dtoPor - parseFloat(cursor.valueBuffer("dtolineal")) - dtoRappel;
      break;
    default:
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
  }
  return valor;
}

//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
