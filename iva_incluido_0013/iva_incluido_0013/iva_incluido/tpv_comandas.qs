
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////
class ivaIncluido extends oficial
{
  function ivaIncluido(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.ivaIncluido_init();
  }
  function datosLineaVentaPrecio()
  {
    return this.ctx.ivaIncluido_datosLineaVentaPrecio();
  }
  function datosLineaVentaIva()
  {
    return this.ctx.ivaIncluido_datosLineaVentaIva();
  }
  function datosLineaVentaPvpUnitario()
  {
    return this.ctx.ivaIncluido_datosLineaVentaPvpUnitario();
  }
  function calculateField(fN)
  {
    return this.ctx.ivaIncluido_calculateField(fN);
  }
  function calcularTotales()
  {
    return this.ctx.ivaIncluido_calcularTotales();
  }
  function aplicarTarifaLinea(codTarifa)
  {
    return this.ctx.ivaIncluido_aplicarTarifaLinea(codTarifa);
  }
  function sumarUno(idLinea)
  {
    return this.ctx.ivaIncluido_sumarUno(idLinea);
  }
  function restarUno(idLinea)
  {
    return this.ctx.ivaIncluido_restarUno(idLinea);
  }
  function descontar(idLinea, descuentoLineal, porDescuento)
  {
    return this.ctx.ivaIncluido_descontar(idLinea, descuentoLineal, porDescuento);
  }
}
//// IVAINCLUIDO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
function ivaIncluido_init()
{
  var _i = this.iface;

  _i.__init();

  var ivaIncluidoDefecto = flfact_tpv.iface.pub_valorDefectoTPV("ivaincluido");

  if (!ivaIncluidoDefecto)
    this.child("lblPvp").setText("PVP (sin iva)");
}

function ivaIncluido_calculateField(fN)
{
  var _i = this.iface;
  var valor;
  var cursor = this.cursor();

  switch (fN) {
    case "ivaarticulo": {
      if (cursor.valueBuffer("referencia") && cursor.valueBuffer("referencia") != "")
        valor = _i.__calculateField(fN);
      else
        valor = AQUtil.sqlSelect("factalma_general", "codimpuesto", "1=1");
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
      break;
    }
  }
  return valor;
}

/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function ivaIncluido_datosLineaVentaIva()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__datosLineaVentaIva()) {
    return false;
  }
  _i.curLineas.setValueBuffer("ivaincluido", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", _i.curLineas));
  return true;
}

function ivaIncluido_datosLineaVentaPvpUnitario()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var ivaIncluidoDefecto = flfact_tpv.iface.pub_valorDefectoTPV("ivaincluido");

  if (_i.curLineas.valueBuffer("ivaincluido")) {
    if (ivaIncluidoDefecto) {
      _i.curLineas.setValueBuffer("pvpunitarioiva", AQUtil.roundFieldValue(_i.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitario"));
      _i.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", _i.curLineas));
    } else {
      _i.curLineas.setValueBuffer("pvpunitario", AQUtil.roundFieldValue(_i.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitario"));
      _i.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", _i.curLineas));
    }
  } else {
    if (ivaIncluidoDefecto) {
      _i.curLineas.setValueBuffer("pvpunitarioiva", AQUtil.roundFieldValue(_i.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitario"));
      _i.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", _i.curLineas));
    } else {
      _i.curLineas.setValueBuffer("pvpunitario", AQUtil.roundFieldValue(_i.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitario"));
      _i.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", _i.curLineas));
    }
  }
  return true;
}

function ivaIncluido_datosLineaVentaPrecio()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var ivaIncluidoDefecto = flfact_tpv.iface.pub_valorDefectoTPV("ivaincluido");

  if (_i.curLineas.valueBuffer("ivaincluido")) {
    if (ivaIncluidoDefecto) {
      _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", _i.curLineas));
    } else {
      _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", _i.curLineas));
      _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", _i.curLineas));
    }
  } else {
    if (ivaIncluidoDefecto) {
      _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", _i.curLineas));
    } else {
      _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", _i.curLineas));
      _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", _i.curLineas));
      _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", _i.curLineas));
    }
  }
  _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", _i.curLineas));
  _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", _i.curLineas));
  _i.curLineas.setValueBuffer("costeunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("costeunitario", _i.curLineas));

  return true;
}


function ivaIncluido_calcularTotales()
{
  var _i = this.iface;

  _i.__calcularTotales();
  return;
  var cursor = this.cursor();

  var dtoEspecial = parseFloat(cursor.valueBuffer("dtoesp"));
  if (!isNaN(dtoEspecial) && dtoEspecial != 0) return;

  var tabla = "tpv_lineascomanda";

  var id = cursor.valueBuffer("idtpv_comanda");
  var neto = AQUtil.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad)", "idtpv_comanda = " + id);
  var iva = AQUtil.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad*iva/100)", "idtpv_comanda = " + id);

  var totalExacto = Math.round(100 * (parseFloat(neto) + parseFloat(iva))) / 100;
  var totalActual = parseFloat(cursor.valueBuffer("neto")) + parseFloat(cursor.valueBuffer("totaliva"));
  debug(totalExacto + "|" + totalActual)
  var dif = parseFloat(totalActual) - parseFloat(totalExacto);
  if (dif != 0) {
    cursor.setValueBuffer("totaliva", parseFloat(cursor.valueBuffer("totaliva")) - dif);
  }
}

function ivaIncluido_aplicarTarifaLinea(codTarifa)
{
  var _i = this.iface;

  if (_i.curLineas.valueBuffer("ivaincluido")) {
    _i.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", _i.curLineas));
    _i.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", _i.curLineas));

    _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", _i.curLineas));
    _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto2", _i.curLineas));
    _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", _i.curLineas));
    _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", _i.curLineas));
  } else {
    _i.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", _i.curLineas));
    _i.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", _i.curLineas));

    _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", _i.curLineas));
    _i.curLineas.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva", _i.curLineas));
    _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", _i.curLineas));
    _i.curLineas.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", _i.curLineas));
  }
  //  _i.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", _i.curLineas));
  //  _i.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", _i.curLineas));

  return true;
}

/** \D
Suma uno a la cantidad de una linea
@param idLinea identificador de la linea
@return devuelve true si se ha sumado correctamente y false si ha habido algún error
*/
function ivaIncluido_sumarUno(idLinea)
{
  var _i = this.iface;

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

  if (!curLinea.commitBuffer())
    return false;

  _i.calcularTotales();
  return true;
}

function ivaIncluido_restarUno(idLinea)
{
  var _i = this.iface;

  if (!idLinea)
    return false;

  var curLinea = new FLSqlCursor("tpv_lineascomanda");
  curLinea.select("idtpv_linea = " + idLinea);
  curLinea.first();
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad")) - 1;
  if (cantidad == 0) {
    var res = MessageBox.warning(util.translate("scripts", "La cantidad de la linea ") + idLinea + AQUtil.translate("scripts", " es 0 ¿Seguro que desea eliminarla?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
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
  }

  if (!curLinea.commitBuffer())
    return false;
  _i.calcularTotales();
  return true;
}

/** \D
Aplica un descuento a la linea
@param idLinea identificador de la linea
@param descuentoLineal descuento lineal
@param porDescuento descuento en porcentaje
@return devuelve true si se ha aplicado correctamente y false si ha habido algún error
*/
function ivaIncluido_descontar(idLinea, descuentoLineal, porDescuento)
{
  var _i = this.iface;

  if (!idLinea)
    return false;

  var curLinea = new FLSqlCursor("tpv_lineascomanda");
  curLinea.select("idtpv_linea = " + idLinea);
  curLinea.first();
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  curLinea.setValueBuffer("dtolineal", descuentoLineal);
  curLinea.setValueBuffer("dtopor", porDescuento);
  if (curLinea.valueBuffer("ivaincluido")) {
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva2", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal2", curLinea));
  } else {
    curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", curLinea));
  }
  //   curLinea.setValueBuffer("pvptotal", _i.calcularTotalesLinea("pvptotal", curLinea));
  if (!curLinea.commitBuffer())
    return false;
  _i.calcularTotales();
  return true;
}
//// IVA INCLUIDO ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////