
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
class lotesEnv extends envases
{
  function lotesEnv(context)
  {
    envases(context);
  }
  function cargarTabla()
  {
    return this.ctx.lotesEnv_cargarTabla();
  }
}
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// TRAZA ENVASES ///////////////////////////////////////////////
function lotesEnv_cargarTabla()
{
  var util = new FLUtil;
  var _i = this.iface;
  var tblLineas = this.child("tblLineas");
  tblLineas.setNumRows(0);

  var valorDefectoSel = _i.dameValorDefectoSel();

  var filtro = cursor.mainFilter();
  var q = new FLSqlQuery;
  q.setTablesList(_i.aDatosFR.tabla);
  q.setSelect("l.idlinea, l.referencia, l.cantidad, l.descripcion, l.codenvase, l.canenvases, l.valormetrico, COUNT(ml.id), MAX(ml.codlote)");
  switch (_i.aDatosFR.tabla) {
    case "lineasfacturascli": {
      q.setFrom("lineasfacturascli l LEFT OUTER JOIN movilote ml ON l.idlinea = ml.idlineafc");
      break;
    }
    case "lineasfacturasprov": {
      q.setFrom("lineasfacturasprov l LEFT OUTER JOIN movilote ml ON l.idlinea = ml.idlineafp");
      break;
    }
    default: {
      return;
    }
  }
  q.setWhere("idfactura = " + _i.aDatosFR.idfactura + " GROUP BY l.idlinea, l.referencia, l.cantidad, l.descripcion, l.codenvase, l.canenvases, l.valormetrico ORDER BY l.referencia");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  var f = 0, lotes, desc, cantidad, valorMetrico;
  debug(q.sql());
  while (q.next()) {
    lotes = q.value("COUNT(ml.id)");
    lotes = isNaN(lotes) ? 0 : lotes;
    desc = q.value("l.descripcion");
    switch (lotes) {
      case 0: {
        break;
      }
      case 1: {
        desc = "L." + q.value("MAX(ml.codlote)") + ". " + desc;
        break;
      }
      default: {
        desc = util.translate("scripts", "(Varios lotes)") + ". " + desc;
        tblLineas.setRowReadOnly(f, true);
        break;
      }
    }

    tblLineas.insertRows(f, 1);
    tblLineas.setText(f, _i.colLin, q.value("l.idlinea"));
    tblLineas.setText(f, _i.colSel, valorDefectoSel);
    tblLineas.setCellAlignment(f, _i.colSel, tblLineas.AlignHCenter);
    tblLineas.setCellBackgroundColor(f, _i.colSel, valorDefectoSel == "X" ? _i.verde : _i.blanco);
    tblLineas.setText(f, _i.colRef, q.value("l.referencia"));
    tblLineas.setCellAlignment(f, _i.colRef, tblLineas.AlignLeft);
    tblLineas.setText(f, _i.colDes, desc);
    cantidad = q.value("l.codenvase") && q.value("l.codenvase") != "" ? q.value("l.canenvases") : q.value("l.cantidad");
    valorMetrico = q.value("l.valormetrico")
                   tblLineas.setText(f, _i.colPre, cantidad);
    tblLineas.setText(f, _i.colRec, cantidad);
    tblLineas.setText(f, _i.colEnv, valorMetrico != 1 ? "x " + valorMetrico : "");
    tblLineas.setCellAlignment(f, _i.colRec, tblLineas.AlignRight);
    f++;
  }
  tblLineas.repaintContents();
}
//// TRAZA ENVASES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
