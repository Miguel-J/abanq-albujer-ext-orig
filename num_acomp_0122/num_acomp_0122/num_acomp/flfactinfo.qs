
/** @class_declaration funNumAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////////

class funNumAcomp extends articuloscomp
{
  function funNumAcomp(context)
  {
    articuloscomp(context);
  }
  function crearTabla(tipoDoc: String, idDoc: Number): Boolean {
    return this.ctx.funNumAcomp_crearTabla(tipoDoc, idDoc);
  }
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////

/** Para guardar el número de serie en el buffer
*/
function funNumAcomp_crearTabla(tipoDoc: String, idDoc: Number): Boolean {
  var util: FLUtil = new FLUtil();
  var qLineas: FLSqlQuery = new FLSqlQuery();
  var tabla: String;
  var id: String;
  var referencia: String;

  var curBuff: FLSqlCursor = new FLSqlCursor("i_articuloscomp_buffer");
  var numSerie: String;
  var idLinea: String;

  util.sqlDelete("i_articuloscomp_buffer", "1=1");

  switch (tipoDoc)
  {
    case "FC": {
      tabla = "lineasfacturascli";
      id = "idfactura";
      idLinea = "idlineafactura";
      break;
    }
    case "FP": {
      tabla = "lineasfacturasprov";
      id = "idfactura";
      break;
    }
    case "AC": {
      tabla = "lineasalbaranescli";
      id = "idalbaran";
      idLinea = "idlineaalbaran";
      break;
    }
    case "AP": {
      tabla = "lineasalbaranesprov";
      id = "idalbaran";
      break;
    }
    case "PC": {
      tabla = "lineaspedidoscli";
      id = "idpedido";
      break;
    }
    case "PP": {
      tabla = "lineaspedidosprov";
      id = "idpedido";
      break;
    }
    case "PR": {
      tabla = "lineaspresupuestoscli";
      id = "idpresupuesto";
      break;
    }
    default:
      return false;
  }

  qLineas.setTablesList(tabla);
  qLineas.setSelect("referencia,idlinea,cantidad");
  qLineas.setFrom(tabla);
  qLineas.setWhere(id + " = '" + idDoc + "'");

  if (!qLineas.exec())
    return false;

  while (qLineas.next())
  {

    referencia = qLineas.value(0);
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("articuloscomp");
    q.setSelect("refcomponente,cantidad");
    q.setFrom("articuloscomp");
    q.setWhere("refcompuesto = '" + referencia + "'");
    q.setOrderBy("refcomponente");

    if (!q.exec())
      return false;

    paso = 0;
    ultRef = "";

    while (q.next()) {

      var cantidad: Number = parseFloat(qLineas.value(2)) * parseFloat(q.value(1));

      if (!this.iface.crearLinea(q.value(0), cantidad, qLineas.value(1)))
        return false;

      // Número de serie al buffer
      if (!idLinea)
        continue;

      if (ultRef != q.value(0)) {
        paso = 0;
        ultRef = q.value(0);
      }

      numSerie = util.sqlSelect(tabla + "ns", "numserie", idLinea + " = " + qLineas.value(1) + " AND referencia = '" + q.value(0) + "' ORDER BY numserie OFFSET " + paso);

      if (!numSerie) {
        paso++;
        continue;
      }

      curBuff.select("idlinea = " + qLineas.value(1) + " AND referencia = '" + q.value(0) + "' ORDER BY id");
      if (curBuff.seek(paso)) {
        curBuff.setModeAccess(curBuff.Edit);
        curBuff.refreshBuffer();
        curBuff.setValueBuffer("numserie", numSerie);
        curBuff.commitBuffer();
      }

      paso++;
    }
  }

  return true;
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

