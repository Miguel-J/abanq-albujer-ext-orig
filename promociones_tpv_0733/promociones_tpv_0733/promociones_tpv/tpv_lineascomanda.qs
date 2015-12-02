
/** @class_declaration promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promocionesTpv extends ivaIncluido
{
  function promocionesTpv(context)
  {
    ivaIncluido(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.promocionesTpv_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.promocionesTpv_bufferChanged(fN);
  }
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promocionesTpv */
////////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV //////////////////////////////////////////////

function promocionesTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "referencia": {
      var idPromo = _i.commonCalculateField("idpromo", cursor);
      if (idPromo == "") {
        cursor.setNull("idpromo");
        cursor.setNull("desccortapromo");
      } else {
        cursor.setValueBuffer("idpromo", idPromo);
      }
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    case "idpromo": {
      var descPromo = _i.commonCalculateField("desccortapromo", cursor);
      if (descPromo == "") {
        cursor.setNull("desccortapromo");
      } else {
        cursor.setValueBuffer("desccortapromo", descPromo);
      }
      break;
    }
    default: {
      return _i.__bufferChanged(fN);
      break;
    }
  }
}

function promocionesTpv_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  var referencia = cursor.valueBuffer("referencia");
  var curRel = cursor.cursorRelation();

  switch (fN) {
    case "idpromo": {
      var hoy = new Date;
      valor = AQUtil.sqlSelect("promociones p INNER JOIN articulospromociones ap ON p.idpromo = ap.idpromo INNER JOIN clientespromociones cp ON p.idpromo = cp.idpromo", "p.idpromo", "ap.referencia = '" + referencia + "' AND cp.codcliente = '" + curRel.valueBuffer("codcliente") + "' AND '" + hoy + "' BETWEEN p.desde AND p.hasta ORDER by duracion ASC", "promociones,articulospromociones,clientespromociones");
      debug(" ------------------------------- idpromo: " + valor);
      if (!valor) {
        valor = "";
      }
      break;
    }
    case "desccortapromo": {
      var hoy = new Date;
      var idPromo = cursor.valueBuffer("idpromo");
      valor = AQUtil.sqlSelect("promociones", "desccorta", "idpromo = '" + idPromo + "'");
      debug(" ------------------------------- desccortapromo: " + valor);
      if (!valor) {
        valor = "";
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

//// PROMOCIONES TPV //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
