
/** @class_declaration servDtoEsp */
/////////////////////////////////////////////////////////////////
//// SERV_DTOESP /////////////////////////////////////////////////
class servDtoEsp extends oficial
{
  function servDtoEsp(context)
  {
    oficial(context);
  }
  function buscarPorDtoEsp(where: String): Number {
    return this.ctx.servDtoEso_buscarPorDtoEsp(where);
  }
  function datosAlbaran(cursor: FLSqlCursor, curAlbaran: FLSqlCursor, where: String): Boolean {
    return this.ctx.servDtoEsp_datosAlbaran(cursor, curAlbaran, where);
  }
  function totalesAlbaran(curAlbaran: FLSqlCursor): Boolean {
    return this.ctx.servDtoEsp_totalesAlbaran(curAlbaran);
  }
}
//// SERV_DTOESP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servDtoEsp */
/////////////////////////////////////////////////////////////////
//// SERV_DTOESP ////////////////////////////////////////////////
/** \D
Busca el porcentaje de descuento especial realizado a los servicios que se agruparán en el albarán. Si existen dos servicios con distinto porcentaje devuelve un código de error.
@param where: Cláusula where para buscar los servicios
@return porcenteje de descuento (-1 si hay error);
*/
function servDtoEso_buscarPorDtoEsp(where: String): Number {
  var util: FLUtil = new FLUtil;
  var porDtoEsp: Number = util.sqlSelect("servicioscli", "pordtoesp", where);
  var porDtoEsp2: Number = util.sqlSelect("servicioscli", "pordtoesp", where + " AND pordtoesp <> " + porDtoEsp);
  if (!porDtoEsp2 && isNaN(parseFloat(porDtoEsp2)))
    return porDtoEsp;
  else
    return -1;
}

function servDtoEsp_datosAlbaran(cursor: FLSqlCursor, curAlbaran: FLSqlCursor, where: String): Boolean {
  var util: FLUtil = new FLUtil();
  var porDtoEsp: Number = this.iface.buscarPorDtoEsp(where);
  if (porDtoEsp == -1)
  {
    MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para servicios con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  curAlbaran.setValueBuffer("pordtoesp", porDtoEsp);

  if (!this.iface.__datosAlbaran(cursor, curAlbaran, where))
    return false;

  return true;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function servDtoEsp_totalesAlbaran(curAlbaran: FLSqlCursor): Boolean {
  with(curAlbaran)
  {
    setValueBuffer("netosindtoesp", formalbaranescli.iface.pub_commonCalculateField("netosindtoesp", this));
    setValueBuffer("dtoesp", formalbaranescli.iface.pub_commonCalculateField("dtoesp", this));
  }

  return this.iface.__totalesAlbaran(curAlbaran);
}
//// SERV_DTOESP ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
