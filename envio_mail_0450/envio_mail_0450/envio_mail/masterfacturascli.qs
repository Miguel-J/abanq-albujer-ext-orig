
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial
{
  function envioMail(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.envioMail_init();
  }
  function enviarDocumento(codFactura: String, codCliente: String)
  {
    return this.ctx.envioMail_enviarDocumento(codFactura, codCliente);
  }
  function imprimir(codFactura: String)
  {
    return this.ctx.envioMail_imprimir(codFactura);
  }
  function dameParamInformeMail(idFactura)
  {
    return this.ctx.envioMail_dameParamInformeMail(idFactura);
  }
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB ENVIO MAIL /////////////////////////////////////////////
class pubEnvioMail extends ifaceCtx
{
  function pubEnvioMail(context)
  {
    ifaceCtx(context);
  }
  function pub_enviarDocumento(codFactura: String, codCliente: String)
  {
    return this.enviarDocumento(codFactura, codCliente);
  }
}
//// PUB ENVIO MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
function envioMail_init()
{
  this.iface.__init();
  //this.child("tbnEnviarMail").close();
  connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codFactura, codCliente)
{
  var cursor = this.cursor();
  var util = new FLUtil();

  if (!codFactura) {
    codFactura = cursor.valueBuffer("codigo");
  }

  if (!codCliente) {
    codCliente = cursor.valueBuffer("codcliente");
  }

  var tabla: String = "clientes";
  var emailCliente: String = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
  if (!emailCliente) {
    return;
  }

  var rutaIntermedia: String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
  if (!rutaIntermedia.endsWith("/")) {
    rutaIntermedia += "/";
  }

  var cuerpo: String = "";
  var asunto: String = util.translate("scripts", "Factura %1").arg(codFactura);
  var rutaDocumento: String = rutaIntermedia + "F_" + codFactura + ".pdf";

  var codigo, idFactura;
  if (codFactura) {
    codigo = codFactura;
    idFactura = util.sqlSelect("facturascli", "idfactura", "codigo = '" + codigo + "'");
  } else {
    if (!cursor.isValid()) {
      return;
    }
    codigo = cursor.valueBuffer("codigo");
    idFactura = cursor.valueBuffer("idfactura");
  }

  var curImprimir: FLSqlCursor = new FLSqlCursor("i_facturascli");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
  curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
  var oParam = this.iface.dameParamInformeMail(idFactura);
  var oDatosPdf = new Object();
  oDatosPdf["pdf"] = true;
  oDatosPdf["ruta"] = rutaDocumento;
  oParam.datosPdf = oDatosPdf;
  flfactinfo.iface.pub_lanzaInforme(curImprimir, oParam);

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = emailCliente;

  var arrayAttach: Array = [];
  arrayAttach[0] = rutaDocumento;

  flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_dameParamInformeMail(idFactura)
{
  var oParam = this.iface.dameParamInforme(idFactura);
  return oParam;
}

function envioMail_imprimir(codFactura: String)
{
  var util: FLUtil = new FLUtil;

  var datosEMail: Array = [];
  datosEMail["tipoInforme"] = "facturascli";
  var codCliente: String;
  if (codFactura && codFactura != "") {
    datosEMail["codDestino"] = util.sqlSelect("facturascli", "codcliente", "codigo = '" + codFactura + "'");
    datosEMail["codDocumento"] = codFactura;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
    datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosEMail = datosEMail;
  this.iface.__imprimir(codFactura);
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
