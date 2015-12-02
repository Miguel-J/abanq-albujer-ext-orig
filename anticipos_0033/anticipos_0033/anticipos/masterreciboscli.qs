
/** @class_declaration anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
class anticipos extends oficial
{
  var lblTotalTexto_;
  function anticipos(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.anticipos_init();
  }
  function tbnAnticipo_clicked()
  {
    return this.ctx.anticipos_tbnAnticipo_clicked();
  }
}
//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
function anticipos_init()
{
  var _i = this.iface;
  _i.__init();
  connect(this.child("tbnAnticipo"), "clicked()", _i, "tbnAnticipo_clicked");
}

function anticipos_tbnAnticipo_clicked()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var idAnticipo = cursor.valueBuffer("idanticipo");
  var idRecibo = cursor.valueBuffer("idrecibo");
  if (idAnticipo) {
    if (util.sqlSelect("anticipos", "idanticipo", "idanticipo = " + idAnticipo + " AND (idpedido IS NOT NULL OR idalbaran IS NOT NULL)")) {
      MessageBox.warning(util.translate("scripts", "El anticipo de este recibo está ligado a sus documentos de facturación. No puede desvincularse"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    var res = MessageBox.warning(util.translate("scripts", "Va a desvincular el recibo selecionado de su anticipo. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
    var curT = new FLSqlCursor("empresa");
    curT.transaction(false);
    try {
      if (flfactteso.iface.pub_desvincularReciboAnticipo(idRecibo, idAnticipo, true)) {
        curT.commit();
      } else {
        curT.rollback();
        MessageBox.critical(util.translate("scripts", "Error al desvincular el anticipo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    } catch (e) {
      curT.rollback();
      MessageBox.critical(util.translate("scripts", "Error al desvincular el anticipo: ") + e, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    var f = new FLFormSearchDB("anticiposcli");
    var curA = f.cursor();
    var idRecibo = cursor.valueBuffer("idrecibo");
    var codCliente = cursor.valueBuffer("codcliente");
    var importeR = cursor.valueBuffer("importe");
    var filtro = "codcliente = '" + codCliente + "' AND pendiente >= 0 AND idpedido IS NULL AND idalbaran IS NULL";
    curA.setMainFilter(filtro);
    f.setMainWidget();
    var idAnticipo: String = f.exec("idanticipo");
    if (!idAnticipo) {
      return;
    }
    curA.select("idanticipo = " + idAnticipo);
    if (!curA.first()) {
      return false;
    }
    curA.setModeAccess(curA.Browse);
    curA.refreshBuffer();
    var curT = new FLSqlCursor("empresa");
    curT.transaction(false);
    try {
      if (flfactteso.iface.pub_aplicarAnticipo(cursor, curA, true)) {
        curT.commit();
      } else {
        curT.rollback();
        MessageBox.critical(util.translate("scripts", "Error al vincular el anticipo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    } catch (e) {
      curT.rollback();
      MessageBox.critical(util.translate("scripts", "Error al vincular el anticipo: ") + e, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  this.child("tableDBRecords").refresh();
}

//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
