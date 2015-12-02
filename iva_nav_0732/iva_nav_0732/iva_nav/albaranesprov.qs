
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.ivaNav_bufferChanged(fN);
  }
  function compruebaIvaLineas()
  {
    return this.ctx.ivaNav_compruebaIvaLineas();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codgrupoivaneg": {
      _i.compruebaIvaLineas();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function ivaNav_compruebaIvaLineas()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
  if (!AQUtil.sqlSelect("gruposcontablesivaneg", "codgrupoivaneg", "codgrupoivaneg = '" + codGrupoIvaNeg + "'")) {
    return;
  }
  var curL = new FLSqlCursor("lineasalbaranesprov");
  curL.setActivatedCommitActions(false);
  curL.setActivatedCheckIntegrity(false);
  curL.select("idalbaran = " + cursor.valueBuffer("idalbaran"));
  while (curL.next()) {
    curL.setModeAccess(curL.Edit);
    curL.refreshBuffer();
    curL.setValueBuffer("iva", flfacturac.iface.pub_campoImpuesto("iva", curL.valueBuffer("codimpuesto"), cursor.valueBuffer("fecha"), codGrupoIvaNeg));
    curL.setValueBuffer("recargo", flfacturac.iface.pub_campoImpuesto("recargo", curL.valueBuffer("codimpuesto"), cursor.valueBuffer("fecha"), codGrupoIvaNeg));
    if (!curL.commitBuffer()) {
      return false;
    }
  }
  _i.calcularTotales();
  this.child("tdbLineasAlbaranesProv").refresh();
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
