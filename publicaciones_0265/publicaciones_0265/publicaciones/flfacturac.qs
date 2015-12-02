
/** @class_declaration publicaciones */
/////////////////////////////////////////////////////////////////
//// PUBLICACIONES //////////////////////////////////////////////////////
class publicaciones extends oficial
{
  function publicaciones(context)
  {
    oficial(context);
  }
  function afterCommit_facturascli(curFactura: FLSqlCursor): Boolean {
    return this.ctx.publicaciones_afterCommit_facturascli(curFactura);
  }
}
//// PUBLICACIONES //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition publicaciones */
/////////////////////////////////////////////////////////////////
//// PUBLICACIONES //////////////////////////////////////////////////////

function publicaciones_afterCommit_facturascli(curFactura: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  if (curFactura.modeAccess() == curFactura.Del)
  {

    var curTab: FLSqlCursor = new FLSqlCursor("pu_periodossuscripciones");
    curTab.select("idfactura = " + curFactura.valueBuffer("idfactura"));
    while (curTab.next()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
      curTab.setValueBuffer("facturado", false);
      curTab.setNull("idfactura");
      curTab.commitBuffer();
    }
  }

  return this.iface.__afterCommit_facturascli(curFactura);
}

//// PUBLICACIONES //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
