
/** @class_declaration anticiposprov */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS A PROVEEDOR ///////////////////////////////////////
class anticiposprov extends proveed
{
  function anticiposprov(context)
  {
    proveed(context);
  }
  function init()
  {
    return this.ctx.anticiposprov_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.anticiposprov_bufferChanged(fN);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.anticiposprov_commonCalculateField(fN, cursor);
  }
}
//// ANTICIPOS A PROVEEDOR ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition anticiposprov */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS A PROVEEDOR ///////////////////////////////////////
function anticiposprov_init()
{
  var idAnticipo = this.cursor().valueBuffer("idanticipo");
  if (idAnticipo != 0) {
    this.child("lblRemesado").text = "ANTICIPO";
    this.child("pushButtonNext").close();
    this.child("pushButtonPrevious").close();
    this.child("pushButtonFirst").close();
    this.child("pushButtonLast").close();
    this.child("pushButtonAcceptContinue").close();
    this.child("pushButtonAccept").close();

    this.child("fdbFechav").setDisabled(true);
    this.child("fdbImporte").setDisabled(true);
    this.child("fdbCodCuenta").editor().setDisabled(true);;
    this.child("fdbCodDir").editor().setDisabled(true);;
    this.child("fdbDescripcion").editor().setDisabled(true);
    this.child("fdbCtaEntidad").editor().setDisabled(true);
    this.child("fdbCtaAgencia").editor().setDisabled(true);
    this.child("fdbCuenta").editor().setDisabled(true);
    this.child("gbxPagDev").close();

    var tdbAnt = this.child("tdbAnticipo");
    tdbAnt.setReadOnly(true);
    tdbAnt.cursor().setMainFilter("idanticipo = " + idAnticipo);
    tdbAnt.refresh();

  } else {
    this.child("groupBoxAnt").close();
    this.iface.__init();
  }
}

function anticiposprov_bufferChanged(fN: String)
{
  var _i = this.iface;
  switch (fN) {
    case "importe": {
      this.child("fdbTexto").setValue(_i.calculateField("texto"));
      this.child("gbxPagDev").setDisabled(true);
      _i.__bufferChanged(fN);
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function anticiposprov_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var util = new FLUtil();
  var valor;
  var idAnticipo = cursor.valueBuffer("idanticipo");
  switch (fN) {
    case "fechapago": {
      if (idAnticipo) {
        valor = util.sqlSelect("anticiposprov", "fecha", "idanticipo = " + idAnticipo);
        if (!valor) valor = "NULL";
      } else {
        valor = _i.__commonCalculateField(fN, cursor);
      }
      break;
    }
    case "codcuentapagoprov": {
      if (idAnticipo) {
        valor = util.sqlSelect("anticiposprov", "codcuenta", "idanticipo = " + idAnticipo);
        if (!valor) valor = "";
      } else {
        valor = _i.__commonCalculateField(fN, cursor);
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }

  return valor;
}
//// ANTICIPOS A PROVEEDOR ///////////////////////////////////////
//////////////////////////////////////////////////////////////////
