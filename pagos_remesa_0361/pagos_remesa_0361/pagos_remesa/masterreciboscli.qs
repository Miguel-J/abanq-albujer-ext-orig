
/** @class_declaration pagoRemesas */
/////////////////////////////////////////////////////////////////
//// PAGO_REMESAS ///////////////////////////////////////////////
class pagoRemesas extends oficial
{
  var tbnPagoRecibos: Object;
  function pagoRemesas(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.pagoRemesas_init();
  }
  function pagoRecibosRemesados()
  {
    return this.ctx.pagoRemesas_pagoRecibosRemesados()
  }
  function crearPagoRecibo(idRecibo: String): Boolean {
    return this.ctx.pagoRemesas_crearPagoRecibo(idRecibo);
  }
  function generarRecibos(recibos: String): Boolean {
    return this.ctx.pagoRemesas_generarRecibos(recibos);
  }
}
//// PAGO_REMESAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagoRemesas */
/////////////////////////////////////////////////////////////////
//// PAGO_REMESAS ///////////////////////////////////////////////
function pagoRemesas_init()
{
  this.iface.__init();

  var util: FLUtil;

  this.iface.tbnPagoRecibos = this.child("tbnPagoRecibos");
  if (!util.sqlSelect("factteso_general", "pagoindirecto", "1 = 1"))
    this.iface.tbnPagoRecibos.setDisabled(true);
  else
    connect(this.iface.tbnPagoRecibos, "clicked()", this, "iface.pagoRecibosRemesados()");
}

function pagoRemesas_pagoRecibosRemesados()
{
  var util: FLUtil;

  if (!util.sqlSelect("factteso_general", "pagoindirecto", "1 = 1"))
    return;

  var f: Object = new FLFormSearchDB("pagorecibosremesados");
  var cursor: FLSqlCursor = f.cursor();
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();

  var acp: Number = f.exec("id");

  if (!f.accepted())
    return false;

  if (!acp)
    return false;

  var recibos: String = cursor.valueBuffer("recibos");

  var cur: FLSqlCursor = this.cursor();
  cur.transaction(false);
  try {
    if (!this.iface.generarRecibos(recibos))
      cur.rollback();
    else
      cur.commit();
  } catch (e) {
    MessageBox.warning(util.translate("scripts", "Error al los pagos:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    cur.rollback();
  }
}

function pagoRemesas_generarRecibos(recibos: String): Boolean {
  var util: FLUtil;
  if (recibos && recibos != "")
  {
    var arrayRecibos: Array = recibos.split(",");
    util.createProgressDialog(util.translate("scripts", "Generando pagos..."), arrayRecibos.length);
    util.setProgress(0);
    for (var i = 0; i < arrayRecibos.length; i++) {
      util.setProgress(i)
      if (!this.iface.crearPagoRecibo(arrayRecibos[i])) {
        //        MessageBox.warning(util.translate("scripts", "Ha habido un error en la generación del pago del recibo %1.").arg(arrayRecibos[i]), MessageBox.Ok, MessageBox.NoButton);
        util.destroyProgressDialog();
        return false;
      }
    }
    util.setProgress(arrayRecibos.length);
    util.destroyProgressDialog();
  }

  return true;
}

function pagoRemesas_crearPagoRecibo(idRecibo: String): Boolean {
  var util: FLUtil;

  var hoy: Date = new Date();
  var curPago = new FLSqlCursor("pagosdevolcli");
  var tasaConv: Number = util.sqlSelect("facturascli", "tasaconv", "idfactura IN (select idfactura FROM reciboscli WHERE idrecibo = " + idRecibo + ")");
  if (!tasaConv)
    tasaConv = 0;

  var codPago: String = util.sqlSelect("facturascli", "codpago", "idfactura IN (select idfactura FROM reciboscli WHERE idrecibo = " + idRecibo + ")");
  if (!codPago || codPago == "")
    return false;

  var codCliente: String = util.sqlSelect("reciboscli", "codcliente", "idrecibo = " + idRecibo);
  if (!codCliente || codCliente == "")
    return false;

  var datosCuentaEmp: Array = flfactteso.iface.obtenerDatosCuentaEmp(codCliente, codPago);
  if (datosCuentaEmp.error == 2)
    return false;

  var datosSubcuentaEmp: Array = false;
  if (sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1"))
  {
    datosSubcuentaEmp = flfactteso.iface.obtenerDatosSubcuentaEmp(datosCuentaEmp);
    if (datosSubcuentaEmp.error == 2)
      return false;
  }

  with(curPago)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idrecibo", idRecibo);
    setValueBuffer("tipo", "Pago");
    setValueBuffer("fecha", hoy);
    setValueBuffer("tasaconv", tasaConv);
    if (datosCuentaEmp.error == 0) {
      setValueBuffer("codcuenta", datosCuentaEmp.codcuenta);
      setValueBuffer("descripcion", datosCuentaEmp.descripcion);
      setValueBuffer("ctaentidad", datosCuentaEmp.ctaentidad);
      setValueBuffer("ctaagencia", datosCuentaEmp.ctaagencia);
      setValueBuffer("dc", datosCuentaEmp.dc);
      setValueBuffer("cuenta", datosCuentaEmp.cuenta);
    }
    if (datosSubcuentaEmp && datosSubcuentaEmp.error == 0) {
      setValueBuffer("codsubcuenta", datosSubcuentaEmp.codsubcuenta);
      setValueBuffer("idsubcuenta", datosSubcuentaEmp.idsubcuenta);
    }
  }
  if (!curPago.commitBuffer())
    return false;

  return true;
}
//// PAGO_REMESAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
