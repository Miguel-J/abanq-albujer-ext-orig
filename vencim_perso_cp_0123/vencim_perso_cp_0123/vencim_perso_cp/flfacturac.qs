
/** @class_declaration venFacturasProv */
/////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ///////////////////////////////////////////////
class venFacturasProv extends oficial
{
  function venFacturasProv(context)
  {
    oficial(context);
  }
  function afterCommit_facturascli(curFactura: FLSqlCursor): Boolean {
    return this.ctx.venFacturasProv_afterCommit_facturascli(curFactura);
  }
  function afterCommit_facturasprov(curFactura: FLSqlCursor): Boolean {
    return this.ctx.venFacturasProv_afterCommit_facturasprov(curFactura);
  }
}
//// VENFACTURASPROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition venFacturasProv */
//////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ////////////////////////////////////////////////

/* \C Siempre se regeneran recibos cuando hay vencimientos manuales
\end */
function venFacturasProv_afterCommit_facturascli(curFactura: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  if (!util.sqlSelect("venfacturascli", "id", "idfactura = " + curFactura.valueBuffer("idfactura")))
    return interna_afterCommit_facturascli(curFactura);

  if (sys.isLoadedModule("flfactteso") && curFactura.valueBuffer("tpv") == false)
  {
    if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
      if (curFactura.valueBuffer("total") == curFactura.valueBufferCopy("total")
      && curFactura.valueBuffer("codpago") == curFactura.valueBufferCopy("codpago")
      && curFactura.valueBuffer("fecha") == curFactura.valueBufferCopy("fecha")) {
        if (flfactteso.iface.pub_regenerarRecibosCli(curFactura) == false)
          return false;
      }
    }
  }

  return interna_afterCommit_facturascli(curFactura);
}

/* \C Siempre se regeneran recibos cuando hay vencimientos manuales
\end */
function venFacturasProv_afterCommit_facturasprov(curFactura: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  if (!util.sqlSelect("venfacturasprov", "id", "idfactura = " + curFactura.valueBuffer("idfactura")))
    return interna_afterCommit_facturasprov(curFactura);

  if (sys.isLoadedModule("flfactteso"))
  {
    if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
      if (curFactura.valueBuffer("total") == curFactura.valueBufferCopy("total")
      && curFactura.valueBuffer("codpago") == curFactura.valueBufferCopy("codpago")
      && curFactura.valueBuffer("fecha") == curFactura.valueBufferCopy("fecha")) {
        if (flfactteso.iface.pub_regenerarRecibosProv(curFactura) == false)
          return false;
      }
    }
  }

  return interna_afterCommit_facturasprov(curFactura);
}

//// VENFACTURASCLI ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
