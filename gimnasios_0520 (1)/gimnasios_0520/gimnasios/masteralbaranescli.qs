
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function crearFacturaBono(curBono: FLSqlCursor): Number {
    return this.ctx.gym_crearFacturaBono(curBono);
  }
  function datosFacturaBono(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_datosFacturaBono(curBono);
  }
  function copiaLineasFacturaBono(curBono: FLSqlCursor, idFactura: Number): Number {
    return this.ctx.gym_copiaLineasFacturaBono(curBono, idFactura);
  }
  function datosLineaFacturaBono(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_datosLineaFacturaBono(curBono);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubGym */
/////////////////////////////////////////////////////////////////
//// PUB GYM ////////////////////////////////////////////////////
class pubGym extends ifaceCtx
{
  function pubGym(context)
  {
    ifaceCtx(context);
  }
  function pub_crearFacturaBono(curBono: FLSqlCursor): Number {
    return this.crearFacturaBono(curBono);
  }
}
//// PUB GYM ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
function gym_crearFacturaBono(curBono: FLSqlCursor): Number {
  var util: FLUtil = new FLUtil();
  var idFactura: Number;

  if (!this.iface.curFactura)
  {
    this.iface.curFactura = new FLSqlCursor("facturascli");
  }

  this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
  this.iface.curFactura.refreshBuffer();

  if (!this.iface.datosFacturaBono(curBono))
  {
    return false;
  }

  if (!this.iface.curFactura.commitBuffer())
  {
    return false;
  }

  idFactura = this.iface.curFactura.valueBuffer("idfactura");
  if (!this.iface.copiaLineasFacturaBono(curBono, idFactura))
  {
    return false;
  }

  this.iface.curFactura.select("idfactura = " + idFactura);
  if (!this.iface.curFactura.first())
  {
    return false;
  }

  if (!formRecordfacturascli.iface.pub_actualizarLineasIva(this.iface.curFactura))
  {
    return false;
  }

  this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
  this.iface.curFactura.refreshBuffer();

  if (!this.iface.totalesFactura())
  {
    return false;
  }

  if (!this.iface.curFactura.commitBuffer())
  {
    return false;
  }

  return idFactura;
}

function gym_datosFacturaBono(curBono: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var codAlmacen: String = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");

  var codCliente: String;
  codCliente = curBono.valueBuffer("codclientefact");
  if (!codCliente)
  {
    MessageBox.warning(util.translate("scripts", "Error al generar la factura:\nNo se ha establecido el código del cliente"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var nomCliente: String = util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
  var cifCliente: String = util.sqlSelect("clientes", "cifnif", "codcliente = '" + codCliente + "'");

  if (!nomCliente || nomCliente == "")
  {
    nomCliente = "-";
  }
  if (!cifCliente || cifCliente == "")
  {
    cifCliente = "-";
  }

  var direccion: String;
  var qryDireccion: FLSqlQuery = new FLSqlQuery;
  with(qryDireccion)
  {
    setTablesList("dirclientes");
    setSelect("direccion, codpostal, provincia, ciudad, idprovincia, codpais");
    setFrom("dirclientes");
    setWhere("codcliente = '" + codCliente + "' AND domfacturacion = true");
    setForwardOnly(true);
  }
  if (!qryDireccion.exec())
  {
    return false;
  }
  if (!qryDireccion.first())
  {
    direccion = "-";
  }

  var serieCliente: String = util.sqlSelect("clientes", "codserie", "codcliente = '" + codCliente + "'");

  with(this.iface.curFactura)
  {
    if (codCliente && codCliente != "") {
      setValueBuffer("codcliente", codCliente);
    }
    setValueBuffer("nombrecliente", nomCliente);
    setValueBuffer("cifnif", cifCliente);
    if (direccion == "-") {
      setValueBuffer("direccion", direccion);
    } else {
      setValueBuffer("direccion", qryDireccion.value("direccion"));
      setValueBuffer("codpostal", qryDireccion.value("codpostal"));
      setValueBuffer("ciudad", qryDireccion.value("ciudad"));
      setValueBuffer("provincia", qryDireccion.value("provincia"));
      setValueBuffer("idprovincia", qryDireccion.value("idprovincia"));
      setValueBuffer("codpais", qryDireccion.value("codpais"));
    }
    setValueBuffer("fecha", curBono.valueBuffer("fechacompra"));
    setValueBuffer("hora", curBono.valueBuffer("horacompra"));
    setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
    setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
    setValueBuffer("codpago", curBono.valueBuffer("codpago"));
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("codserie", serieCliente);
    setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + flfactppal.iface.pub_valorDefectoEmpresa("coddivisa") + "'"));
    setValueBuffer("automatica", true);
    setValueBuffer("gym", true);
  }
  return true;
}

function gym_copiaLineasFacturaBono(curBono: FLSqlCursor, idFactura: Number): Number {
  if (!this.iface.curLineaFactura)
  {
    this.iface.curLineaFactura = new FLSqlCursor("lineasfacturascli");
  }

  with(this.iface.curLineaFactura)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idfactura", idFactura);
  }

  if (!this.iface.datosLineaFacturaBono(curBono))
  {
    return false;
  }

  if (!this.iface.curLineaFactura.commitBuffer())
  {
    return false;
  }

  return this.iface.curLineaFactura.valueBuffer("idlinea");
}

function gym_datosLineaFacturaBono(curBono: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia: String = curBono.valueBuffer("referencia");
  var codImpuesto: String = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'")
  var ivaIncluido: Boolean;
  with(this.iface.curLineaFactura)
  {
    setValueBuffer("referencia", referencia);
    setValueBuffer("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'"));
    setValueBuffer("cantidad", 1);
    setValueBuffer("codimpuesto", codImpuesto);
    setValueBuffer("iva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this));
    setValueBuffer("recargo", formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this));
    ivaIncluido = formRecordlineaspedidoscli.iface.pub_commonCalculateField("ivaincluido", this);
    setValueBuffer("ivaincluido", ivaIncluido);
    if (ivaIncluido) {
      setValueBuffer("pvpunitarioiva", curBono.valueBuffer("pvp"));
      setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this));
    } else {
      setValueBuffer("pvpunitario", curBono.valueBuffer("pvp"));
      setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this));
    }
    setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this));
    setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
  }
  return true;
}


//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
