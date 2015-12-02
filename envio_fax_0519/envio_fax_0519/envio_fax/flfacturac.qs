
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX ///////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function enviarFax(faxCliente: String, documento: String): Boolean {
    return this.ctx.envioFax_enviarFax(faxCliente, documento);
  }
  function componerComando(faxCliente: String, documento: String): Array {
    return this.ctx.envioFax_componerComando(faxCliente, documento);
  }
}
//// ENVIO FAX ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioFax */
/////////////////////////////////////////////////////////////////
//// PUB_ENVIO_FAX //////////////////////////////////////////////
class pubEnvioFax extends ifaceCtx
{
  function pubEnvioFax(context)
  {
    ifaceCtx(context);
  }
  function pub_enviarFax(faxCliente: String, documento: String): Boolean {
    return this.enviarFax(faxCliente, documento);
  }
}
//// PUB_ENVIO_FAX //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_enviarFax(numFax: String, documento: String): Boolean {
  var util: FLUtil = new FLUtil;
  var comando: Array = this.iface.componerComando(numFax, documento);
  if (!comando)
  {
    return false;
  }

  var res: Array = flfactppal.iface.pub_ejecutarComandoAsincrono(comando);
  if (res["ok"] == false)
  {
    return false;
  }

  return true;
}

//Función a sobrecargar
function envioFax_componerComando(numFax: String, documento: String): Array {
  var util: FLUtil = new FLUtil();
  MessageBox.information(util.translate("scripts", "Componer comando..."), MessageBox.Ok, MessageBox.NoButton);
  return true;
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
