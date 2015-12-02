
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
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "referencia":
      _i.__commonBufferChanged(fN, miForm);
      miForm.child("fdbDtoRappel").setValue(_i.commonCalculateField("dtorappel", miForm.cursor()));
      break;
    case "dtorappel":
      miForm.child("lblDtoRappel").setText(_i.commonCalculateField("lbldtorappel", miForm.cursor()));
      miForm.child("fdbPvpTotal").setValue(_i.commonCalculateField("pvptotal", miForm.cursor()));
      break;
    case "cantidad":
      miForm.child("fdbDtoRappel").setValue(_i.commonCalculateField("dtorappel", miForm.cursor()));
      _i.__commonBufferChanged(fN, miForm);
      break;
    case "pvpsindto":
      _i.__commonBufferChanged(fN, miForm);
      break;
    default:
      _i.__commonBufferChanged(fN, miForm);
      break;
  }
}

function rappel_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
    case "dtorappel":
      var cantidad: String = parseFloat(cursor.valueBuffer("cantidad"));
      if (!cantidad || cantidad < 0)
        return 0;
      var referencia: String = cursor.valueBuffer("referencia");
      valor = util.sqlSelect("rappelarticulos", "descuento", "referencia = '" + referencia + "' AND limiteinferior <= " + cantidad + " AND limitesuperior >= " + cantidad);
      if (!valor)
        valor = 0;
      break;
    case "lbldtorappel":
      valor = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
      valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
      break;
    case "pvptotal":
      var dtoPor: Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtopor"))) / 100;
      dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
      var dtoRappel: Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
      dtoRappel = util.roundFieldValue(dtoRappel, "lineaspedidoscli", "pvpsindto");
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
