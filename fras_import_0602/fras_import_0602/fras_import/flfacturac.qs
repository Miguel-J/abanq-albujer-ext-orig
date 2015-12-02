
/** @class_declaration frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
class frasImport extends oficial
{
  function frasImport(context)
  {
    oficial(context);
  }
  function datosPartidaFactura(curPartida: FLSqlCursor, curFactura: FLSqlCursor, tipo: String, concepto: String)
  {
    return this.ctx.frasImport_datosPartidaFactura(curPartida, curFactura, tipo, concepto);
  }
  function datosPartidaIVAFacturaImport(curPartida, curFactura, tipo, concepto, curFacturaImport)
  {
    return this.ctx.frasImport_datosPartidaIVAFacturaImport(curPartida, curFactura, tipo, concepto, curFacturaImport);
  }
  function afterCommit_facturasprov(curF)
  {
    return this.ctx.frasImport_afterCommit_facturasprov(curF);
  }
  function controlFacturaImport(curF)
  {
    return this.ctx.frasImport_controlFacturaImport(curF);
  }
  function actualizaFacturaDUA(idFacturaImport, idFacturaDUA)
  {
    return this.ctx.frasImport_actualizaFacturaDUA(idFacturaImport, idFacturaDUA);
  }
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
function frasImport_datosPartidaFactura(curPartida, curFactura, tipo, concepto)
{
  var _i = this.iface;
  _i.__datosPartidaFactura(curPartida, curFactura, tipo, concepto);

  if (curFactura.isNull("dua")) {
    return true;
  }
  var refImport = flfactalma.iface.pub_valorDefectoAlmacen("refivaimport");
  if (!refImport) {
    return true;
  }
  var codSubcuentaIvaImport = AQUtil.sqlSelect("articulos", "codsubcuentacom", "referencia = '" + refImport + "'");
  if (!codSubcuentaIvaImport || codSubcuentaIvaImport != curPartida.valueBuffer("codsubcuenta")) {
    return true;
  }
  var curFacturaImport;
  if (!curFactura.isNull("idfacturaimport")) {
    curFacturaImport = new FLSqlCursor("facturasprov");
    curFacturaImport.select("idfactura = " + curFactura.valueBuffer("idfacturaimport"));
    if (!curFacturaImport.first()) {
      return false;
    }
    curFacturaImport.setModeAccess(curFacturaImport.Browse);
    curFacturaImport.refreshBuffer();
  }
  if (!_i.datosPartidaIVAFacturaImport(curPartida, curFactura, tipo, concepto, curFacturaImport)) {
    return false;
  }
  return true;
}

function frasImport_datosPartidaIVAFacturaImport(curPartida, curFactura, tipo, concepto, curFacturaImport)
{
  var _i = this.iface;

  curPartida.setValueBuffer("tipodocumento", "Factura de proveedor");
  curPartida.setValueBuffer("documento", curFactura.valueBuffer("dua"));
  curPartida.setValueBuffer("baseimponible", curFactura.valueBuffer("baseimport"));
  curPartida.setValueBuffer("iva", curFactura.valueBuffer("tipoivaimport"));

  var codProveedor, codSerie, cifProv;
  if (curFacturaImport) {
    codProveedor = curFacturaImport.valueBuffer("codproveedor");
    codSerie = curFacturaImport.valueBuffer("codserie");
    cifProv = curFacturaImport.valueBuffer("cifnif");
  } else {
    codProveedor = curFactura.valueBuffer("codproveedor");
    codSerie = curFactura.valueBuffer("codserie");
    cifProv = curFactura.valueBuffer("cifnif");
  }

  var valoresDefecto = [];
  valoresDefecto.codejercicio = curFactura.valueBuffer("codejercicio");
  var ctaProveedor = flfactppal.iface.pub_datosCtaProveedor(codProveedor, valoresDefecto);
  if (ctaProveedor.error != 0) {
    MessageBox.warning(sys.translate("Error al obtener la subcuenta asociada al proveedor %1 para el ejercicio %2.\nEs necesaria para generar la partida de IVA importación").arg(codProveedor).arg(curFactura.valueBuffer("codejercicio")), MessageBox.Ok, MessageBox.NoButton);
  }
  var codSubcuentaProv = ctaProveedor.codsubcuenta;

  var idSubcuentaProv = ctaProveedor.idsubcuenta;
  curPartida.setValueBuffer("cifnif", cifProv);
  curPartida.setValueBuffer("idcontrapartida", idSubcuentaProv);
  curPartida.setValueBuffer("codcontrapartida", codSubcuentaProv);

  curPartida.setValueBuffer("codserie", codSerie);

  return true;
}

function frasImport_afterCommit_facturasprov(curF)
{
  var _i = this.iface;
  if (!_i.__afterCommit_facturasprov(curF)) {
    return false;
  }
  if (!_i.controlFacturaImport(curF)) {
    return false;
  }
  return true;
}

function frasImport_controlFacturaImport(curF)
{
  var _i = this.iface;
  switch (curF.modeAccess()) {
    case curF.Insert: {
      if (curF.isNull("idfacturaimport")) {
        return true;
      }
      if (!_i.actualizaFacturaDUA(curF.valueBuffer("idfacturaimport"), curF.valueBuffer("idfactura"))) {
        return false;
      }
      break;
    }
    case curF.Edit: {
      if (curF.valueBuffer("idfacturaimport") != curF.valueBufferCopy("idfacturaimport")) {
        if (curF.valueBufferCopy("idfacturaimport") && curF.valueBufferCopy("idfacturaimport") != "") {
          if (!_i.actualizaFacturaDUA(curF.valueBufferCopy("idfacturaimport"), "NULL")) {
            return false;
          }
        }
        if (curF.valueBuffer("idfacturaimport") && curF.valueBuffer("idfacturaimport") != "") {
          if (!_i.actualizaFacturaDUA(curF.valueBuffer("idfacturaimport"), curF.valueBuffer("idfactura"))) {
            return false;
          }
        }
      }
      break;
    }
    case curF.Del: {
      if (curF.isNull("idfacturaimport")) {
        return true;
      }
      if (!_i.actualizaFacturaDUA(curF.valueBuffer("idfacturaimport"), "NULL")) {
        return false;
      }
      break;
    }
  }
  return true;
}

function frasImport_actualizaFacturaDUA(idFacturaImport, idFacturaDUA)
{
  var curF = new FLSqlCursor("facturasprov");
  curF.setActivatedCheckIntegrity(false);
  curF.setActivatedCommitActions(false);
  curF.select("idfactura = " + idFacturaImport);
  if (!curF.first()) {
    return true;
  }
  var editable = curF.valueBuffer("editable");
  if (!editable) {
    curF.setUnLock("editable", true);
    curF.select("idfactura = " + idFacturaImport);
    if (!curF.first()) {
      return false;
    }
  }
  curF.setModeAccess(curF.Edit);
  curF.refreshBuffer();
  if (idFacturaDUA == "NULL") {
    curF.setNull("idfacturadua");
  } else {
    curF.setValueBuffer("idfacturadua", idFacturaDUA);
  }
  if (!curF.commitBuffer()) {
    return false;
  }
  if (!editable) {
    curF.select("idfactura = " + idFacturaImport);
    if (!curF.first()) {
      return false;
    }
    curF.setUnLock("editable", false);
  }
  return true;
}
//// FRAS IMPORT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
