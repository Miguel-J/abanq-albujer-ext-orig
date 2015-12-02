
/** @class_declaration servEnvases */
/////////////////////////////////////////////////////////////////
//// SERV_ENVASES ///////////////////////////////////////////////
class servEnvases extends oficial
{
  function servEnvases(context)
  {
    oficial(context);
  }
  function datosLineaServicio(curLineaServicio: FLSqlCursor, curLineaAlbaran: FLSqlCursor, idAlbaran: Number): Boolean {
    return this.ctx.servEnvases_datosLineaServicio(curLineaServicio, curLineaAlbaran, idAlbaran);
  }
}
//// SERV_ENVASES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servEnvases */
/////////////////////////////////////////////////////////////////
//// SERV_ENVASES ///////////////////////////////////////////////
function servEnvases_datosLineaServicio(curLineaServicio: FLSqlCursor, curLineaAlbaran: FLSqlCursor, idAlbaran: Number): Boolean {
  with(curLineaAlbaran)
  {
    setValueBuffer("valormetrico", curLineaServicio.valueBuffer("valormetrico"));
    setValueBuffer("canenvases", curLineaServicio.valueBuffer("canenvases"));
    setValueBuffer("codenvase", curLineaServicio.valueBuffer("codenvase"));
  }

  return this.iface.__datosLineaServicio(curLineaServicio, curLineaAlbaran, idAlbaran);
}
//// SERV_ENVASES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
