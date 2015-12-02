
/** @class_declaration anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
class anticipos extends oficial
{
  function anticipos(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.anticipos_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.anticipos_bufferChanged(fN);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.anticipos_commonCalculateField(fN, cursor);
  }
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
function anticipos_init()
{
  var idAnticipo: Number = this.cursor().valueBuffer("idanticipo");
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
    this.child("coddir").editor().setDisabled(true);;
    this.child("fdbDescripcion").editor().setDisabled(true);
    this.child("fdbCtaEntidad").editor().setDisabled(true);
    this.child("fdbCtaAgencia").editor().setDisabled(true);
    this.child("fdbCuenta").editor().setDisabled(true);
    this.child("gbxPagDev").close();

    var tdbAnt: Object = this.child("tdbAnticipo");
    tdbAnt.setReadOnly(true);
    tdbAnt.cursor().setMainFilter("idanticipo = " + idAnticipo);
    tdbAnt.refresh();

  } else {
    this.child("groupBoxAnt").close();
    this.iface.__init();
  }
}

function anticipos_bufferChanged(fN: String)
{
  var _i = this.iface;
  switch (fN) {
    case "importe": {
      _i.__bufferChanged(fN);
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function anticipos_commonCalculateField(fN, cursor)
{
  debug("anticipos_commonCalculateField " + fN);
  var util = new FLUtil();
  var valor;
  var idAnticipo = cursor.valueBuffer("idanticipo");
  switch (fN) {
    case "fechapago": {
      if (idAnticipo) {
        valor = util.sqlSelect("anticiposcli", "fecha", "idanticipo = " + idAnticipo);
        if (!valor) valor = "NULL";
        debug("valor " + valor);
      } else {
        valor = this.iface.__commonCalculateField(fN, cursor);
      }
      break;
    }
    case "codcuentapagocli": {
      if (idAnticipo) {
        valor = util.sqlSelect("anticiposcli", "codcuenta", "idanticipo = " + idAnticipo);
        if (!valor) valor = "";
      } else {
        valor = this.iface.__commonCalculateField(fN, cursor);
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }

  return valor;
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////