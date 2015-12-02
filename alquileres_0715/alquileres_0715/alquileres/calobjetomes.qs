
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  var refAlquiler_;
  const ALQ_RESERVADO_ = 2, ALQ_NO_RESERVADO_ = 1;
  function alquiler(context)
  {
    oficial(context);
  }
  function cargaOcupacion()
  {
    return this.ctx.alquiler_cargaOcupacion();
  }
  function muestraDetalleDia(f, c)
  {
    return this.ctx.alquiler_muestraDetalleDia(f, c);
  }
  function conectaTabla()
  {
    return this.ctx.alquiler_conectaTabla();
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_cargaOcupacion()
{
  var util = new FLUtil;
  var _i = this.iface;
  var cursor = _i.container_.cursor();
  var dia = _i.dia1MesActual_;
  var mes = dia.getMonth();
  var idPeriodo;
  switch (cursor.table()) {
    case "calobjetomes": {
      var tipoObjeto = cursor.valueBuffer("tipoobjeto");
      if (tipoObjeto != "articulos" && tipoObjeto != "alquilerarticulos") {
        return _i.__cargaOcupacion();
      }
      if (tipoObjeto == "articulos") {
        idPeriodo = 0;
        _i.refAlquiler_ = cursor.valueBuffer("idobjeto");
      } else {
        idPeriodo = cursor.valueBuffer("idobjeto");
        _i.refAlquiler_ = util.sqlSelect("alquilerarticulos", "referencia", "idperiodoalq = " + idPeriodo);
      }
      break;
    }
    case "articulos": {
      idPeriodo = 0;
      _i.refAlquiler_ = cursor.valueBuffer("referencia");
      break;
    }
    default: {
      return _i.__cargaOcupacion();
    }
  }
  var qAlq = new FLSqlQuery;
  qAlq.setSelect("fechadesde, fechahasta, reservado");
  qAlq.setFrom("alquilerarticulos");
  qAlq.setWhere("referencia = '" + _i.refAlquiler_ + "' AND fechahasta >= '" + _i.diaInicio_.toString() + "' AND fechadesde <= '" + _i.diaFin_.toString() + "' AND idperiodoalq <> " + idPeriodo);
  qAlq.setForwardOnly(true);
  if (!qAlq.exec()) {
    return false;
  }
  var diaCal, fechaCal, reservado;
  var clrReservado = new Color("red");
  var clrNoReservado = new Color("orange");
  while (qAlq.next()) {
    reservado = qAlq.value("reservado");
    for (fechaCal = qAlq.value("fechadesde"); util.daysTo(fechaCal, qAlq.value("fechahasta")) >= 0; fechaCal = util.addDays(fechaCal, 1)) {
      debug("fechaCal " + fechaCal + " - Hasta " + qAlq.value("fechahasta") + " van " + util.daysTo(fechaCal, qAlq.value("fechahasta")) + " dias");
      diaCal = fechaCal.toString().left(10);
      if (!(diaCal in _i.aDiaTabla_)) {
        continue;
      }
      switch (_i.aDiaTabla_[diaCal].ocupado) {
        case _i.ALQ_RESERVADO_: {
          continue;
        }
        case _i.ALQ_NO_RESERVADO_: {
          if (!reservado) {
            continue;
          }
          break;
        }
      }
      var pixCelda = _i.damePixCelda(fechaCal, reservado ? clrReservado : clrNoReservado);
      _i.tblCalendario_.setPixmap(_i.aDiaTabla_[diaCal].f, _i.aDiaTabla_[diaCal].c, pixCelda);
      _i.aDiaTabla_[diaCal].ocupado = reservado ? _i.ALQ_RESERVADO_ : _i.ALQ_NO_RESERVADO_;
    }
  }
}

function alquiler_conectaTabla()
{
  var _i = this.iface;
  connect(_i.tblCalendario_, "clicked(int, int)", _i, "muestraDetalleDia");
}

function alquiler_muestraDetalleDia(f, c)
{
  var _i = this.iface;
  var util = new FLUtil;
  var fecha = _i.aDiasMes_[f][c];
  var q = new FLSqlQuery;
  q.setSelect("a.fechadesde, a.horadesde, a.fechahasta, a.horahasta, a.codcliente, c.nombre, pc.codigo, ac.codigo, fc.codigo");
  q.setFrom("alquilerarticulos a INNER JOIN clientes c ON a.codcliente = c.codcliente LEFT OUTER JOIN lineaspedidoscli lp ON a.idperiodoalq = lp.idperiodoalq LEFT OUTER JOIN pedidoscli pc ON lp.idpedido = pc.idpedido LEFT OUTER JOIN lineasalbaranescli la ON a.idperiodoalq = la.idperiodoalq LEFT OUTER JOIN albaranescli ac ON la.idalbaran = ac.idalbaran LEFT OUTER JOIN lineasfacturascli lf ON a.idperiodoalq = lf.idperiodoalq LEFT OUTER JOIN facturascli fc ON lf.idfactura = fc.idfactura");
  q.setWhere("a.referencia = '" + _i.refAlquiler_ + "' AND a.fechadesde <= '" + fecha + "' AND a.fechahasta >= '" + fecha + "' ORDER BY a.fechadesde, a.horadesde");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var txt = "", tipoDoc, doc;
  var horaDesde, horaHasta;
  while (q.next()) {
    horaDesde = q.value("a.horadesde").toString().right(8);
    horaDesde = horaDesde.left(5);
    horaHasta = q.value("a.horahasta").toString().right(8);
    horaHasta = horaHasta.left(5);
    doc = q.value("pc.codigo");
    tipoDoc = util.translate("scripts", "Pedido");
    if (!doc) {
      doc = q.value("ac.codigo");
      tipoDoc = util.translate("scripts", "Albarán");
    }
    if (!doc) {
      doc = q.value("fc.codigo");
      tipoDoc = util.translate("scripts", "Factura");
    }
    if (!doc) {
      doc = "";
      tipoDoc = "";
    }
    txt += "\n" + util.dateAMDtoDMA(q.value("a.fechadesde")) + " " + horaDesde + " - " + util.dateAMDtoDMA(q.value("a.fechahasta")) + " " + horaHasta + ". " + tipoDoc + " " + doc + ". " + q.value("c.nombre");
  }
  _i.container_.child("lblOcupacion").text = txt;
  //  if (txt != "") {
  //    MessageBox.information(util.translate("scripts", "Ocupación :%1").arg(txt), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  //  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
