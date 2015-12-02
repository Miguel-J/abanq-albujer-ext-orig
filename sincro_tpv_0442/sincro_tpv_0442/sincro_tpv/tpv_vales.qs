
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincro extends oficial
{
  var chkCentral_;

  function sincro(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.sincro_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.sincro_bufferChanged(fN);
  }
  function chkCentralToggled(on)
  {
    this.ctx.sincro_chkCentralToggled(on);
  }
  function incluirDatosLinea(curLinea, curLineaPadre)
  {
    return this.ctx.sincro_incluirDatosLinea(curLinea, curLineaPadre);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincro_init()
{
  var _i = this.iface;

  _i.__init();

  _i.chkCentral_ = this.child("chkConsultaCentral");

  connect(_i.chkCentral_, "toggled(bool)", _i, "chkCentralToggled()");
}

function sincro_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "codigo": {
      if (this.child("fdbCodigo").value().length == 12) {
        var curFdbCodigo = this.child("fdbCodigo").cursor();
        var idComanda = AQUtil.sqlSelect("tpv_comandas", "idtpv_comanda",
                                         "codigo='" + cursor.valueBuffer("codigo") + "'",
                                         "", curFdbCodigo.connectionName());
        if (idComanda) {
          this.child("tdbLineasComanda").cursor().setMainFilter("idtpv_comanda = " + idComanda);
          this.child("tdbLineasComanda").refresh();
        }
      }
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function sincro_chkCentralToggled(on)
{
  var _i = this.iface;

  var curFdbCodigo = this.child("fdbCodigo").cursor();
  var curFdbLineas = this.child("tdbLineasComanda").cursor();

  if (on) {
    var cxCentral = flfact_tpv.iface.dameCxCentral();
    var dbCentral = AQSql.database(cxCentral);

    if (dbCentral.connectionName() != cxCentral ||
        !dbCentral.isOpen()) {
      if (!flfact_tpv.iface.pub_conectaCentral()) {
        MessageBox.warning(sys.translate("Error al conectar a la base de datos central"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return;
      }
      cxCentral = flfact_tpv.iface.dameCxCentral();
    }
    curFdbCodigo.changeConnection(cxCentral);
    curFdbLineas.changeConnection(cxCentral);
  } else {
    curFdbCodigo.changeConnection("default");
    curFdbLineas.changeConnection("default");
  }
}

function sincro_incluirDatosLinea(curLinea, curLineaPadre)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__incluirDatosLinea(curLinea, curLineaPadre))
    return false;

  var idTpvComanda = cursor.valueBuffer("idtpv_comanda");
  var codComanda = AQUtil.sqlSelect("tpv_comandas", "codigo", "idtpv_comanda = " + idTpvComanda);
  if (codComanda && codComanda != "")
    curLinea.setValueBuffer("codcomanda", codComanda);
  curLinea.setValueBuffer("idsincro", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("idsincro", curLinea));

  return true;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
