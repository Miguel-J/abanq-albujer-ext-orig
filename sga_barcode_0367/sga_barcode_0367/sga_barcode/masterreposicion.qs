
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ////////////////////////////////////////////////
class sgaBarcode extends oficial
{
  function sgaBarcode(context)
  {
    oficial(context);
  }
  function crearLineasReposicion(idReposicion: String): Boolean {
    return this.ctx.sgaBarcode_crearLineasReposicion(idReposicion);
  }
}
//// SGA_BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ////////////////////////////////////////////////
function sgaBarcode_crearLineasReposicion(idReposicion: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;

  var qryUbi: FLSqlQuery = new FLSqlQuery;
  with(qryUbi)
  {
    setTablesList("ubicacionesarticulo,lineasreposicion,ubicaciones,zonas");
    setSelect("u.id, u.cantidadactual, u.referencia, u.barcode, u.talla, u.color, u.codubicacion, u.capacidadmax");
    setFrom("ubicacionesarticulo u LEFT OUTER JOIN lineasreposicion lr ON (u.id = lr.idubicaciondestino AND lr.estadoentrada = 'PTE') INNER JOIN ubicaciones ub ON u.codubicacion = ub.codubicacion INNER JOIN zonas z ON ub.codzona = z.codzona");
    setWhere("u.cantidadactual <= u.cantidadlim AND lr.idlineareposicion IS NULL AND z.tipo = 'PICKING'");
    setForwardOnly(true);
  }
  if (!qryUbi.exec())
    return false;

  var cantidad: Number;
  var numLineas: Number = 0;
  while (qryUbi.next())
  {
    var curLineaR: FLSqlCursor = new FLSqlCursor("lineasreposicion");
    curLineaR.setModeAccess(curLineaR.Insert);
    curLineaR.refreshBuffer();

    cantidad = parseFloat(qryUbi.value("u.capacidadmax")) - parseFloat(qryUbi.value("u.cantidadactual"));
    var q: FLSqlQuery = new FLSqlQuery;
    with(q) {
      setTablesList("ubicacionesarticulo,zonas,ubicaciones");
      setSelect("u.id, u.codubicacion");
      setFrom("ubicacionesarticulo u INNER JOIN ubicaciones ub ON u.codubicacion = ub.codubicacion INNER JOIN zonas z ON ub.codzona = z.codzona");
      setWhere("u.referencia = '" + qryUbi.value("u.referencia") + "' AND u.cantidadactual >= " + cantidad + " AND z.tipo = 'MASIVO'");
      setForwardOnly(true);
    }

    if (!q.exec())
      return false;

    if (!q.first()) {
      MessageBox.warning(util.translate("scripts", "No hay ubicaciones de MASIVO que contengan el artículo:\nReferencia %1").arg(qryUbi.value("u.referencia")), MessageBox.Ok, MessageBox.NoButton);
      continue;
    }

    curLineaR.setValueBuffer("idreposicion", idReposicion);
    curLineaR.setValueBuffer("codubicacionorigen", q.value("u.codubicacion"));
    curLineaR.setValueBuffer("idubicacionorigen", q.value("u.id"));
    curLineaR.setValueBuffer("codubicaciondestino", qryUbi.value("u.codubicacion"));
    curLineaR.setValueBuffer("idubicaciondestino", qryUbi.value("u.id"));
    curLineaR.setValueBuffer("referencia", qryUbi.value("u.referencia"));
    curLineaR.setValueBuffer("barcode", qryUbi.value("u.barcode"));
    curLineaR.setValueBuffer("talla", qryUbi.value("u.talla"));
    curLineaR.setValueBuffer("color", qryUbi.value("u.color"));
    curLineaR.setValueBuffer("estadoentrada", "PTE");
    curLineaR.setValueBuffer("estadosalida", "PTE");
    curLineaR.setValueBuffer("cantidad", cantidad);
    if (!curLineaR.commitBuffer())
      return false;

    numLineas++;
  }
  if (numLineas == 0)
  {
    /*    MessageBox.warning(util.translate("scripts", "No se ha creado ninguna línea de reposición. La reposición no se creará"), MessageBox.Ok, MessageBox.NoButton);*/
    MessageBox.warning(util.translate("scripts", "No hay ubicaciones de PICKING con cantidad inferior al límite de reposición"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.child("tableDBRecords").refresh();
  return true;
}

//// SGA_BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
