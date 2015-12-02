
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial
{
  var colEnv;
  function envases(context)
  {
    oficial(context);
  }
  function cargarTabla()
  {
    return this.ctx.envases_cargarTabla();
  }
  function construirTabla()
  {
    return this.ctx.envases_construirTabla();
  }
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_cargarTabla()
{
  var util = new FLUtil;
  var _i = this.iface;
  var tblLineas = this.child("tblLineas");
  tblLineas.setNumRows(0);

  var valorDefectoSel = _i.dameValorDefectoSel();

  var filtro = cursor.mainFilter();
  var q = new FLSqlQuery;
  q.setTablesList(_i.aDatosFR.tabla);
  q.setSelect("idlinea, referencia, cantidad, codenvase, canenvases, valormetrico, descripcion");
  q.setFrom(_i.aDatosFR.tabla);
  switch (_i.aDatosFR.tabla) {
    case "lineasfacturascli":
    case "lineasfacturasprov": {
      q.setWhere("idfactura = " + _i.aDatosFR.idfactura + " ORDER BY referencia");
      break;
    }
    case "lineasalbaranescli":
    case "lineasalbaranesprov": {
      q.setWhere("idalbaran = " + _i.aDatosFR.idalbaran + " ORDER BY referencia");
      break;
    }
    case "lineaspedidoscli":
    case "lineaspedidosprov": {
      q.setWhere("idpedido = " + _i.aDatosFR.idpedido + " ORDER BY referencia");
      break;
    }
    case "lineaspresupuestoscli": {
      q.setWhere("idpresupuesto = " + _i.aDatosFR.idpresupuesto + " ORDER BY referencia");
      break;
    }
  }
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  var f = 0, cantidad, valorMetrico;
  while (q.next()) {
    tblLineas.insertRows(f, 1);
    tblLineas.setText(f, _i.colLin, q.value("idlinea"));
    tblLineas.setText(f, _i.colSel, valorDefectoSel);
    tblLineas.setCellAlignment(f, _i.colSel, tblLineas.AlignHCenter);
    tblLineas.setCellBackgroundColor(f, _i.colSel, valorDefectoSel == "X" ? _i.verde : _i.blanco);
    tblLineas.setText(f, _i.colRef, q.value("referencia"));
    tblLineas.setCellAlignment(f, _i.colRef, tblLineas.AlignLeft);
    tblLineas.setText(f, _i.colDes, q.value("descripcion"));
    cantidad = q.value("codenvase") && q.value("codenvase") != "" ? q.value("canenvases") : q.value("cantidad");
    valorMetrico = q.value("valormetrico")
                   tblLineas.setText(f, _i.colPre, cantidad);
    tblLineas.setText(f, _i.colRec, cantidad);
    tblLineas.setText(f, _i.colEnv, valorMetrico != 1 ? "x " + valorMetrico : "");
    tblLineas.setCellAlignment(f, _i.colRec, tblLineas.AlignRight);
    f++;
  }
  tblLineas.repaintContents();
}

function envases_construirTabla()
{
  var util = new FLUtil;
  var cabecera = "", s = "*";
  var _i = this.iface;
  var c = 0;
  _i.colLin = c++;
  cabecera += util.translate("scripts", "Línea") + s;
  _i.colSel = c++;
  cabecera += util.translate("scripts", "Sel.") + s;
  _i.colRef = c++;
  cabecera += util.translate("scripts", "Referencia") + s;
  _i.colDes = c++;
  cabecera += util.translate("scripts", "Artículo") + s;
  _i.colPre = c++;
  cabecera += util.translate("scripts", "F.Anterior") + s;
  _i.colRec = c++;
  cabecera += util.translate("scripts", "F.Actual") + s ;
  _i.colEnv = c++;
  cabecera += util.translate("scripts", "U/Envase");

  var tblLineas = this.child("tblLineas");
  tblLineas.setNumCols(c);
  tblLineas.hideColumn(_i.colLin);
  tblLineas.setColumnWidth(_i.colSel, 50);
  tblLineas.setColumnReadOnly(_i.colSel, true);
  tblLineas.setColumnWidth(_i.colRef, 120);
  tblLineas.setColumnReadOnly(_i.colRef, true);
  tblLineas.setColumnWidth(_i.colDes, 250);
  tblLineas.setColumnReadOnly(_i.colDes, true);
  tblLineas.setColumnWidth(_i.colPre, 50);
  tblLineas.setColumnReadOnly(_i.colPre, true);
  tblLineas.setColumnWidth(_i.colRec, 50);
  tblLineas.setColumnReadOnly(_i.colEnv, true);
  tblLineas.setColumnWidth(_i.colEnv, 100);
  tblLineas.setColumnLabels(s, cabecera);

  _i.blanco = new Color(250, 250, 250);
  _i.verde = new Color(50, 200, 50);
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
