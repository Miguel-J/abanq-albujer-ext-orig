
/** @class_declaration tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
class tpvtactIvainc extends oficial
{
  function tpvtactIvainc(context)
  {
    oficial(context);
  }
  function datosLineaVenta(cantidad): Boolean {
    return this.ctx.tpvtactIvainc_datosLineaVenta(cantidad);
  }
  function actualizarTotalesComanda()
  {
    return this.ctx.tpvtactIvainc_actualizarTotalesComanda();
  }
  function sumarUno(idLinea: Number)
  {
    return this.ctx.tpvtactIvainc_sumarUno(idLinea);
  }
  function restarUno(idLinea: Number)
  {
    return this.ctx.tpvtactIvainc_restarUno(idLinea);
  }
  function aplicarDtoLinea(porDto: Number)
  {
    return this.ctx.tpvtactIvainc_aplicarDtoLinea(porDto);
  }
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
function tpvtactIvainc_datosLineaVenta(cantidad)
{
  if (!this.iface.__datosLineaVenta(cantidad)) {
    return false;
  }
  var ivaIncluido;
  if (this.iface.precioLibre) {
    ivaIncluido = true;
    this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);
    this.iface.curLineas.setValueBuffer("pvpunitarioiva", this.iface.precioLibre);
    this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));
  } else {
    ivaIncluido = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas);
    this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);
    if (ivaIncluido) {
      this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));

      this.iface.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", this.iface.curLineas));
    } else {
      this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineas));

      this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
      this.iface.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", this.iface.curLineas));
    }
  }
  //  this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
  //  this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));

  return true;
}

function tpvtactIvainc_actualizarTotalesComanda()
{
  this.iface.__actualizarTotalesComanda();
  return;
  var cursor = this.cursor();

  var dtoEspecial = parseFloat(cursor.valueBuffer("dtoesp"));
  if (!isNaN(dtoEspecial) && dtoEspecial != 0) return;

  var util = new FLUtil();

  var tabla = "tpv_lineascomanda";

  var id = cursor.valueBuffer("idtpv_comanda");
  var neto = util.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad)", "idtpv_comanda = " + id);
  var iva = util.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad*iva/100)", "idtpv_comanda = " + id);

  var totalExacto = Math.round(100 * (parseFloat(neto) + parseFloat(iva))) / 100;
  var totalActual = parseFloat(cursor.valueBuffer("neto")) + parseFloat(cursor.valueBuffer("totaliva"));
  debug(totalExacto + "|" + totalActual)
  var dif = parseFloat(totalActual) - parseFloat(totalExacto);
  if (dif != 0) {
    cursor.setValueBuffer("totaliva", parseFloat(cursor.valueBuffer("totaliva")) - dif);
  }
}


function tpvtactIvainc_sumarUno(idLinea: Number)
{
  if (!idLinea)
    return false;

  var curLinea = new FLSqlCursor("tpv_lineascomanda");
  curLinea.select("idtpv_linea = " + idLinea);
  curLinea.first();
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  curLinea.setValueBuffer("cantidad", parseFloat(curLinea.valueBuffer("cantidad")) + 1);
  if (curLinea.valueBuffer("ivaincluido")) {
    curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", curLinea));
    curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", curLinea));
  } else {
    curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", curLinea));
    curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", curLinea));
  }

  //  curLinea.setValueBuffer("pvpsindto",formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto",curLinea));
  //  curLinea.setValueBuffer("pvptotal",formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal",curLinea));
  if (!curLinea.commitBuffer())
    return false;

  //  this.iface.calcularTotales();
  return true;
}

function tpvtactIvainc_aplicarDtoLinea(idLinea: Number, porDto: Number)
{
  if (!idLinea) {
    return false;
  }
  var curLinea = new FLSqlCursor("tpv_lineascomanda");
  curLinea.select("idtpv_linea = " + idLinea);
  curLinea.first();
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  curLinea.setValueBuffer("dtopor", porDto);
  if (curLinea.valueBuffer("ivaincluido")) {
    curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", curLinea));
    curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", curLinea));
  } else {
    curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", curLinea));
    curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", curLinea));
  }

  //  curLinea.setValueBuffer("pvpsindto", formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto", curLinea));
  //  curLinea.setValueBuffer("pvptotal", formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal", curLinea));
  if (!curLinea.commitBuffer()) {
    return false;
  }
  return true;
}

function tpvtactIvainc_restarUno(idLinea: Number)
{
  if (!idLinea)
    return false;

  var util = new FLUtil();
  var curLinea = new FLSqlCursor("tpv_lineascomanda");
  curLinea.select("idtpv_linea = " + idLinea);
  curLinea.first();
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad")) - 1;
  if (cantidad == 0) {
    var res = MessageBox.warning(util.translate("scripts", "La cantidad de la linea ") + idLinea + util.translate("scripts", " es 0 ¿Seguro que desea eliminarla?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
    curLinea.setModeAccess(curLinea.Del);
  } else {
    curLinea.setModeAccess(curLinea.Edit);
    curLinea.refreshBuffer();
    curLinea.setValueBuffer("cantidad", cantidad);
    if (curLinea.valueBuffer("ivaincluido")) {
      curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", curLinea));
      curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", curLinea));
      curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", curLinea));
      curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", curLinea));
    } else {
      curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", curLinea));
      curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", curLinea));
      curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
      curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", curLinea));
    }
    //    curLinea.setValueBuffer("pvpsindto",formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto",curLinea));
    //    curLinea.setValueBuffer("pvptotal",formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal",curLinea));
  }
  if (!curLinea.commitBuffer())
    return false;
  //  this.iface.calcularTotales();
  return true;
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////
