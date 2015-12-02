
/** @class_declaration servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
class servclinl extends oficial
{
  var numLinea_: Number;
  function servclinl(context)
  {
    oficial(context);
  }
  function generarAlbaran(where: String, cursor: FLSqlCursor): Number {
    return this.ctx.servclinl_generarAlbaran(where, cursor);
  }
  function copiaLineas(idServicio: Number, idAlbaran: Number): Boolean {
    return this.ctx.servclinl_copiaLineas(idServicio, idAlbaran);
  }
  function datosLineaServicio(curLineaServicio: FLSqlCursor, curLineaAlbaran: FLSqlCursor, idAlbaran: Number): Boolean {
    return this.ctx.servclinl_datosLineaServicio(curLineaServicio, curLineaAlbaran, idAlbaran);
  }
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
function servclinl_generarAlbaran(where: String, cursor: FLSqlCursor): Number {
  this.iface.numLinea_ = 0;

  return this.iface.__generarAlbaran(where, cursor);
}

function servclinl_copiaLineas(idServicio: Number, idAlbaran: Number): Boolean {
  var curLineaServicio: FLSqlCursor = new FLSqlCursor("lineasservicioscli");
  curLineaServicio.select("idservicio = " + idServicio + " ORDER BY numlinea");

  while (curLineaServicio.next())
  {
    curLineaServicio.setModeAccess(curLineaServicio.Browse);
    curLineaServicio.refreshBuffer();
    if (!this.iface.copiaLineaServicio(curLineaServicio, idAlbaran))
      return false;
  }

  return true;
}

function servclinl_datosLineaServicio(curLineaServicio: FLSqlCursor, curLineaAlbaran: FLSqlCursor, idAlbaran: Number): Boolean {
  if (!this.iface.__datosLineaServicio(curLineaServicio, curLineaAlbaran, idAlbaran))
    return false;

  this.iface.numLinea_++;
  curLineaAlbaran.setValueBuffer("numlinea", this.iface.numLinea_);

  return true;
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////
