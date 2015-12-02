
/** @class_declaration factPerDto */
/////////////////////////////////////////////////////////////////
//// FACT PER DTO ///////////////////////////////////////////////
class factPerDto extends oficial
{
  function factPerDto(context)
  {
    oficial(context);
  }
  function totalesFactura(curFactura: FLSqlCursor)
  {
    return this.ctx.factPerDto_totalesFactura(curFactura);
  }
}
//// FACT PER DTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition factPerDto */
/////////////////////////////////////////////////////////////////
//// FACT PER DTO ///////////////////////////////////////////////

function factPerDto_totalesFactura(curFactura: FLSqlCursor)
{
  with(curFactura) {
    setModeAccess(Edit);
    refreshBuffer();
    setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", curFactura));
    setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", curFactura));
    setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", curFactura));
    setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", curFactura));
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", curFactura));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", curFactura));
    setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", curFactura));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", curFactura));
    setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
  }
}

//// FACT PER DTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
