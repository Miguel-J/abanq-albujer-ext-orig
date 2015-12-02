
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial
{
  function dtoEspecial(context)
  {
    oficial(context);
  }
  function totalesFactura(curComanda: FLSqlCursor): Boolean {
    return this.ctx.dtoEspecial_totalesFactura(curComanda);
  }
  function datosFactura(curComanda: FLSqlCursor): Boolean {
    return this.ctx.dtoEspecial_datosFactura(curComanda);
  }
}
/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesFactura(curComanda: FLSqlCursor): Boolean {
  with(this.iface.curFactura)
  {
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
    /// No se calcula para evitar descuadre en el caso de que el usuario modifica manualmente el precio total de la venta
    setValueBuffer("netosindtoesp", curComanda.valueBuffer("netosindtoesp"));
    setValueBuffer("dtoesp", curComanda.valueBuffer("dtoesp"));
    setValueBuffer("neto", curComanda.valueBuffer("neto"));
    setValueBuffer("totaliva", curComanda.valueBuffer("totaliva"));
    setValueBuffer("total", curComanda.valueBuffer("total"));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
    setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", this));
  }

  return true;
}

function dtoEspecial_datosFactura(curComanda: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  if (!this.iface.__datosFactura(curComanda))
  {
    return false;
  }
  with(this.iface.curFactura)
  {
    setValueBuffer("pordtoesp", curComanda.valueBuffer("pordtoesp"));
    setValueBuffer("total", 0); /// Evita el cálculo de asiento en commit intermedio
    setValueBuffer("totaliva", 0); /// Evita el cálculo de asiento en commit intermedio
    setValueBuffer("dtoesp", 0); /// Evita el cálculo de asiento en commit intermedio
    setValueBuffer("neto", 0); /// Evita el cálculo de asiento en commit intermedio
    setValueBuffer("netosindtoesp", 0); /// Evita el cálculo de asiento en commit intermedio
  }
  return true;
}

//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
