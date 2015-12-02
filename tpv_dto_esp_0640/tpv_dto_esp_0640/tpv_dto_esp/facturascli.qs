
/** @class_declaration tpvDto */
/////////////////////////////////////////////////////////////////
//// TPV DTO ESPECIAL ///////////////////////////////////////////
class tpvDto extends dtoEspecial
{
  function tpvDto(context)
  {
    dtoEspecial(context);
  }
  function actualizarLineasIva(curFactura: FLSqlCursor): Boolean {
    return this.ctx.tpvDto_actualizarLineasIva(curFactura);
  }
}
//// TPV DTO ESPECIAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvDto */
/////////////////////////////////////////////////////////////////
//// TPV DTO ESPECIAL ///////////////////////////////////////////
/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param curFactura: Cursor posicionado en la factura
\end */
function tpvDto_actualizarLineasIva(curFactura: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  if (!curFactura.valueBuffer("tpv"))
  {
    return this.iface.__actualizarLineasIva(curFactura);
  }
  var porDto: Number = parseFloat(curFactura.valueBuffer("pordtoesp"));
  if (isNaN(porDto))
  {
    porDto = 0;
  }
  if (!porDto || porDto == 0)
  {
    return this.iface.__actualizarLineasIva(curFactura);
  }

  var idFactura: String = curFactura.valueBuffer("idfactura");
  var netoExacto: Number = curFactura.valueBuffer("neto");
  var ivaExacto: Number = curFactura.valueBuffer("totaliva");
  var totalExacto: Number = curFactura.valueBuffer("total");
  var reExacto: Number = 0;

  if (!util.sqlDelete("lineasivafactcli", "idfactura = " + idFactura))
  {
    return false;
  }

  var curLineaIva: FLSqlCursor = new FLSqlCursor("lineasivafactcli");
  var qryLineasFactura: FLSqlQuery = new FLSqlQuery;
  with(qryLineasFactura)
  {
    setTablesList("lineasfacturascli");
    setSelect("codimpuesto, iva, recargo, pvptotal");
    setFrom("lineasfacturascli");
    setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY codimpuesto");
    setForwardOnly(true);
  }
  if (!qryLineasFactura.exec())
  {
    return false;
  }
  if (!qryLineasFactura.first())
  {
    return true;
  }
  with(curLineaIva)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idfactura", idFactura);
    setValueBuffer("codimpuesto", qryLineasFactura.value("codimpuesto"));
    setValueBuffer("iva", qryLineasFactura.value("iva"));
    setValueBuffer("recargo", 0);
    setValueBuffer("neto", netoExacto);
    setValueBuffer("totaliva", ivaExacto);
    setValueBuffer("totalrecargo", 0);
    setValueBuffer("totallinea", totalExacto);
  }
  if (!curLineaIva.commitBuffer())
  {
    return false;
  }
  return true;
}
//// TPV DTO ESPECIAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
