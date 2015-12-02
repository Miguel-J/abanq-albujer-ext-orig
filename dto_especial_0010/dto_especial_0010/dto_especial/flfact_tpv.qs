
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DESCUENTO ESPECIAL /////////////////////////////////////////
class dtoEspecial extends oficial
{
  function dtoEspecial(context)
  {
    oficial(context);
  }
  function totalesFactura(curComanda)
  {
    return this.ctx.dtoEspecial_totalesFactura(curComanda);
  }
}
//// DESCUENTO ESPECIAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DESCUENTO ESPECIAL /////////////////////////////////////////
function dtoEspecial_totalesFactura(curComanda)
{
  with(this.iface.curFactura) {
    setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", this));
    setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", this));
    setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
  }

  return true;
}
//// DESCUENTO ESPECIAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
