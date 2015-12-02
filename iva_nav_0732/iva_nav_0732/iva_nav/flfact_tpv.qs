
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function datosFactura(curComanda)
  {
    return this.ctx.ivaNav_datosFactura(curComanda);
  }
}

//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////

function ivaNav_datosFactura(curComanda)
{
  var _i = this.iface;

  var codAlmacen = AQUtil.sqlSelect("tpv_puntosventa", "codalmacen", "codtpv_puntoventa = '" + curComanda.valueBuffer("codtpv_puntoventa") + "'");
  if (!codAlmacen || codAlmacen == "")
    codAlmacen = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");

  var codCliente = curComanda.valueBuffer("codcliente");
  var nomCliente = curComanda.valueBuffer("nombrecliente");
  var cifCliente = curComanda.valueBuffer("cifnif");
  var direccion = curComanda.valueBuffer("direccion");

  if (!nomCliente || nomCliente == "") {
    nomCliente = "-";
  }
  if (!cifCliente || cifCliente == "") {
    cifCliente = "-";
  }
  if (!direccion || direccion == "") {
    direccion = "-";
  }

  var serieCliente = _i.obtenerSerieFactura(curComanda);

  with(this.iface.curFactura) {
    if (codCliente && codCliente != "") {
      setValueBuffer("codcliente", codCliente);
    }
    setValueBuffer("nombrecliente", nomCliente);
    setValueBuffer("cifnif", cifCliente);
    setValueBuffer("direccion", direccion);
    if (curComanda.valueBuffer("coddir") != 0) {
      setValueBuffer("coddir", curComanda.valueBuffer("coddir"));
    }
    setValueBuffer("codpostal", curComanda.valueBuffer("codpostal"));
    setValueBuffer("ciudad", curComanda.valueBuffer("ciudad"));
    setValueBuffer("provincia", curComanda.valueBuffer("provincia"));
    setValueBuffer("codpais", curComanda.valueBuffer("codpais"));
    setValueBuffer("fecha", curComanda.valueBuffer("fecha"));
    setValueBuffer("hora", curComanda.valueBuffer("hora"));
    setValueBuffer("codgrupoivaneg", curComanda.valueBuffer("codgrupoivaneg"));
    setValueBuffer("codejercicio", _i.dameEjercicioFactura(curComanda));
    setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
    setValueBuffer("codpago", curComanda.valueBuffer("codpago"));
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("codserie", serieCliente);
    setValueBuffer("tasaconv", AQUtil.sqlSelect("divisas", "tasaconv", "coddivisa = '" + flfactppal.iface.pub_valorDefectoEmpresa("coddivisa") + "'"));
    setValueBuffer("automatica", true);
    setValueBuffer("tpv", true);
  }
  return true;
}

//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

