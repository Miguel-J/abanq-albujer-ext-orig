
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function ejecutarComandoAsincrono(comando: String): Array {
    return this.ctx.envioFax_ejecutarComandoAsincrono(comando);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
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
  function pub_ejecutarComandoAsincrono(comando: String): Array {
    return this.ejecutarComandoAsincrono(comando);
  }
}

//// PUB_ENVIO_FAX //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
/** \D
Ejecuta un comando externo de forma asíncrona
@param  comando: Comando a ejecutar
@return Array con dos datos:
  ok: True si no hay error, false en caso contrario
  salida: Mensaje de stdout o stderr obtenido
\end */
function envioFax_ejecutarComandoAsincrono(comando: String): Array {
  var res: Array = [];
  Process.execute(comando);
  if (Process.stderr != "")
  {
    res["ok"] = false;
    res["salida"] = Process.stderr;
  } else {
    res["ok"] = true;
    res["salida"] = Process.stdout;
  }
  return res;
}

//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
