
/** @class_declaration contratosCC */
/////////////////////////////////////////////////////////////////
//// CONTRATOS CENTROS COSTE ////////////////////////////////////
class contratosCC extends oficial
{
  function contratosCC(context)
  {
    oficial(context);
  }
  function datosFactura(curFactura, codCliente, codContrato)
  {
    return this.ctx.contratosCC_datosFactura(curFactura, codCliente, codContrato);
  }
  function datosLineaFactura(datosPeriodo, codContrato)
  {
    return this.ctx.contratosCC_datosLineaFactura(datosPeriodo, codContrato);
  }
  function datosLineaAdFactura(curAA, codContrato)
  {
    return this.ctx.contratosCC_datosLineaAdFactura(curAA, codContrato);
  }
  //     function facturar(filtro) {
  //    return this.ctx.contratosCC_facturar(filtro);
  //     }
  function dameFiltroContratosAFacturar()
  {
    return this.ctx.contratosCC_dameFiltroContratosAFacturar();
  }
}
//// CONTRATOS CENTROS COSTE ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition contratosCC */
/////////////////////////////////////////////////////////////////
//// CONTRATOS CENTROS COSTE ////////////////////////////////////
function contratosCC_datosFactura(curFactura, codCliente, codContrato)
{
  var util = new FLUtil();

  if (!this.iface.__datosFactura(curFactura, codCliente)) {
    return false;
  }
  var codCentro = util.sqlSelect("contratos", "codcentro", "codigo = '" + codContrato + "'");
  var codSubCentro = util.sqlSelect("contratos", "codsubcentro", "codigo = '" + codContrato + "'");
  if (codCentro) {
    curFactura.setValueBuffer("codcentro", codCentro);
  }
  if (codSubCentro) {
    curFactura.setValueBuffer("codsubcentro", codSubCentro);
  }
  return true;
}

function contratosCC_datosLineaFactura(datosPeriodo, codContrato)
{
  var util: FLUtil;

  if (!this.iface.__datosLineaFactura(datosPeriodo, codContrato)) {
    return false;
  }

  var codCentro = util.sqlSelect("contratos", "codcentro", "codigo = '" + codContrato + "'");
  var codSubCentro = util.sqlSelect("contratos", "codsubcentro", "codigo = '" + codContrato + "'");

  if (codCentro) {
    this.iface.curLineaFactura_.setValueBuffer("codcentro", codCentro);
  }
  if (codSubCentro) {
    this.iface.curLineaFactura_.setValueBuffer("codsubcentro", codSubCentro);
  }
  return true;
}

function contratosCC_datosLineaAdFactura(curAA, codContrato)
{
  var util: FLUtil;

  if (!this.iface.__datosLineaAdFactura(curAA, codContrato)) {
    return false;
  }
  var codCentro = util.sqlSelect("contratos", "codcentro", "codigo = '" + codContrato + "'");
  var codSubCentro = util.sqlSelect("contratos", "codsubcentro", "codigo = '" + codContrato + "'");

  if (codCentro) {
    this.iface.curLineaFactura_.setValueBuffer("codcentro", codCentro);
  }
  if (codSubCentro) {
    this.iface.curLineaFactura_.setValueBuffer("codsubcentro", codSubCentro);
  }
  return true;
}

function contratosCC_dameFiltroContratosAFacturar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var filtro = this.iface.__dameFiltroContratosAFacturar();

  var f = new FLFormSearchDB("seleccionccsubcc");
  var curCC: FLSqlCursor = f.cursor();
  curCC.select();
  if (curCC.first()) {
    curCC.setModeAccess(curCC.Edit);
  } else {
    curCC.setModeAccess(curCC.Insert);
  }
  curCC.refreshBuffer();
  curCC.setValueBuffer("codcentro", "");
  curCC.setValueBuffer("codsubcentro", "");

  f.setMainWidget();
  var id = f.exec("id");
  if (!id) {
    return;
  }
  var codCentro = curCC.valueBuffer("codcentro");
  var codSubcentro = curCC.valueBuffer("codsubcentro");

  var filtroCC = "";
  if (!filtroCC) {
    if (codCentro && codCentro != "") {
      filtroCC = "codcentro = '" + codCentro + "'";
      if (codSubcentro && codSubcentro != "") {
        filtroCC += "AND codsubcentro = '" + codSubcentro + "'";
      }
    }
  }
  if (filtro && filtro != undefined) {
    filtroCC += " AND " + filtro;
  }
  return filtroCC;
}
//// CONTRATOS CENTROS COSTE ////////////////////////////////////
/////////////////////////////////////////////////////////////////
