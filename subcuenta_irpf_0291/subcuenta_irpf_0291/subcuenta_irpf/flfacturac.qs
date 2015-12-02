
/** @class_declaration subcuentaIrpf */
/////////////////////////////////////////////////////////////////
//// SUBCUENTA_IRPF /////////////////////////////////////////////
class subcuentaIrpf extends oficial
{
  function subcuentaIrpf(context)
  {
    oficial(context);
  }
  function generarPartidasIRPF(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.subcuentaIrpf_generarPartidasIRPF(curFactura, idAsiento, valoresDefecto);
  }
  function generarPartidasIRPFProv(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.subcuentaIrpf_generarPartidasIRPFProv(curFactura, idAsiento, valoresDefecto);
  }
}
//// SUBCUENTA_IRPF /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition subcuentaIrpf */
/////////////////////////////////////////////////////////////////
//// SUBCUENTA_IRPF /////////////////////////////////////////////
function subcuentaIrpf_generarPartidasIRPF(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var irpf: Number = parseFloat(curFactura.valueBuffer("totalirpf"));
  if (irpf == 0)
    return true;
  var debe: Number = 0;
  var debeME: Number = 0;
  var ctaIrpf: Array = [];
  var idSubcuentaIrpf: Number = 0;
  var codSubcuentaIrpf: String = "";
  var codCliente: String = curFactura.valueBuffer("codcliente");
  if (codCliente && codCliente != "")
  {
    idSubcuentaIrpf = util.sqlSelect("clientes", "idsubcuentairpf", "codcliente = '" + codCliente + "'");
    codSubcuentaIrpf = util.sqlSelect("clientes", "codsubcuentairpf", "codcliente = '" + codCliente + "'");
  }

  if (!idSubcuentaIrpf || !codSubcuentaIrpf || codSubcuentaIrpf == "")
  {
    ctaIrpf = this.iface.datosCtaEspecial("IRPF", valoresDefecto.codejercicio);
    if (ctaIrpf.error != 0) {
      MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nIRPF (IRPF para clientes).\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  } else {
    ctaIrpf["idsubcuenta"] = idSubcuentaIrpf;
    ctaIrpf["codsubcuenta"] = codSubcuentaIrpf;
  }

  ctaIrpf.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaIrpf.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaIrpf.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No existe la subcuenta de IRPF %1 para el ejercicio %2.\nAntes de generar el asiento debe crear esta subcuenta.").arg(ctaIrpf.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var monedaSistema: Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
  if (monedaSistema)
  {
    debe = irpf;
    debeME = 0;
  } else {
    debe = irpf * parseFloat(curFactura.valueBuffer("tasaconv"));
    debeME = irpf;
  }
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
    setValueBuffer("idasiento", idAsiento);
    setValueBuffer("debe", debe);
    setValueBuffer("haber", 0);
    setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }

  this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function subcuentaIrpf_generarPartidasIRPFProv(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var irpf: Number = parseFloat(curFactura.valueBuffer("totalirpf"));
  if (irpf == 0)
    return true;
  var haber: Number = 0;
  var haberME: Number = 0;
  var ctaIrpf: Array = [];
  var idSubcuentaIrpf: Number = 0;
  var codSubcuentaIrpf: String = "";
  var codProveedor: String = curFactura.valueBuffer("codproveedor");
  if (codProveedor && codProveedor != "")
  {
    idSubcuentaIrpf = util.sqlSelect("proveedores", "idsubcuentairpf", "codproveedor = '" + codProveedor + "'");
    codSubcuentaIrpf = util.sqlSelect("proveedores", "codsubcuentairpf", "codproveedor = '" + codProveedor + "'");
  }

  if (!idSubcuentaIrpf || !codSubcuentaIrpf || codSubcuentaIrpf == "")
  {
    ctaIrpf.codsubcuenta = util.sqlSelect("lineasfacturasprov lf INNER JOIN articulos a ON lf.referencia = a.referencia", "a.codsubcuentairpfcom", "lf.idfactura = " + curFactura.valueBuffer("idfactura") + " AND a.codsubcuentairpfcom IS NOT NULL", "lineasfacturasprov,articulos");
    if (ctaIrpf.codsubcuenta) {
      var hayDistintasSubcuentas: String = util.sqlSelect("lineasfacturasprov lf INNER JOIN articulos a ON lf.referencia = a.referencia", "a.referencia", "lf.idfactura = " + curFactura.valueBuffer("idfactura") + " AND (a.codsubcuentairpfcom <> '" + ctaIrpf.codsubcuenta + "' OR a.codsubcuentairpfcom  IS NULL)", "lineasfacturasprov,articulos");
      if (hayDistintasSubcuentas) {
        MessageBox.warning(util.translate("scripts", "No es posible generar el asiento contable de una factura que tiene artículos asignados a distintas subcuentas de IRPF.\nDebe corregir la asociación de las subcuentas de IRPF a los artículos o bien crear distintas facturas para cada subcuenta."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
      }
    } else {
      ctaIrpf = this.iface.datosCtaEspecial("IRPFPR", valoresDefecto.codejercicio);
      if (ctaIrpf.error != 0) {
        MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nIRPFPR (IRPF para proveedores / acreedores).\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
      }
    }
  } else {
    ctaIrpf["idsubcuenta"] = idSubcuentaIrpf;
    ctaIrpf["codsubcuenta"] = codSubcuentaIrpf;
  }

  ctaIrpf.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaIrpf.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaIrpf.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No existe la subcuenta de IRPF %1 para el ejercicio %2.\nAntes de generar el asiento debe crear esta subcuenta.").arg(ctaIrpf.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var monedaSistema: Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
  if (monedaSistema)
  {
    haber = irpf;
    haberME = 0;
  } else {
    haber = irpf * parseFloat(curFactura.valueBuffer("tasaconv"));
    haberME = irpf;
  }
  haber = util.roundFieldValue(haber, "co_partidas", "haber");
  haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
    setValueBuffer("idasiento", idAsiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }

  this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor")

  if (!curPartida.commitBuffer())
    return false;

  return true;
}
//// SUBCUENTA_IRPF /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
