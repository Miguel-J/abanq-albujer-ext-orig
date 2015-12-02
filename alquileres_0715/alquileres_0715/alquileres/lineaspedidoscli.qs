
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  var  seAlquila_, bloqAlq_, curAlq_;
  function alquiler(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.alquiler_init();
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.alquiler_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.alquiler_commonCalculateField(fN, cursor);
  }
  function habilitaPorAlquiler(miForm)
  {
    return this.ctx.alquiler_habilitaPorAlquiler(miForm);
  }
  function commonTbnCalendario_clicked(miForm)
  {
    return this.ctx.alquiler_commonTbnCalendario_clicked(miForm);
  }
  function tbnCalendario_clicked()
  {
    return this.ctx.alquiler_tbnCalendario_clicked();
  }
  function dameFiltroReferencia()
  {
    return this.ctx.alquiler_dameFiltroReferencia();
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubAlquiler */
/////////////////////////////////////////////////////////////////
//// PUB ALQUILER ///////////////////////////////////////////////
class pubAlquiler extends ifaceCtx
{
  function pubAlquiler(context)
  {
    ifaceCtx(context);
  }
  function pub_habilitaPorAlquiler(miForm)
  {
    return this.habilitaPorAlquiler(miForm);
  }
  function pub_commonTbnCalendario_clicked(miForm)
  {
    return this.commonTbnCalendario_clicked(miForm);
  }
}
//// PUB ALQUILER ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_dameFiltroReferencia()
{
  return "(sevende OR sealquila)";
}

function alquiler_init()
{
  var _i = this.iface;
  _i.__init();
  _i.bloqAlq_ = false;

  connect(this.child("tbnCalendario"), "clicked()", _i, "tbnCalendario_clicked");
  var cursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Edit: {

      break;
    }
  }
  _i.calculateField("sealquila");
  _i.habilitaPorAlquiler(this);
}
function alquiler_commonCalculateField(fN, cursor)
{
  debug("alquiler_commonCalculateField " + fN);
  var util = new FLUtil;
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "sealquila": {
      _i.seAlquila_ = util.sqlSelect("articulos", "sealquila", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      break;
    }
    case "datehastaalq": {
      var fD = cursor.valueBuffer("fechadesdealq");
      if (!fD || fD == undefined) {
        return false;
      }
      var hD = cursor.valueBuffer("horadesdealq");
      if (!hD || hD == undefined) {
        return false;
      }
      var sDesde = fD.toString().left(10) + "T" + hD.toString().right(8);
      var tDesde = Date.parse(sDesde);
      if (!tDesde) {
        return false;
      }
      var h = cursor.valueBuffer("cantidad");
      h = isNaN(h) ? 0 : h;
      var tHasta = tDesde + (h * 60 * 60 * 1000);
      var dHasta = new Date(tHasta);
      valor = dHasta;
      break;
    }
    case "horasalq": {
      var fD = cursor.valueBuffer("fechadesdealq");
      if (!fD || fD == undefined) {
        return false;
      }
      var hD = cursor.valueBuffer("horadesdealq");
      if (!hD || hD == undefined) {
        return false;
      }
      var sDesde = fD.toString().left(10) + "T" + hD.toString().right(8);
      var tDesde = Date.parse(sDesde);
      if (!tDesde) {
        return false;
      }
      var fH = cursor.valueBuffer("fechahastaalq");
      if (!fH || fH == undefined) {
        return false;
      }
      var hH = cursor.valueBuffer("horahastaalq");
      if (!hH || hH == undefined) {
        return false;
      }
      var sHasta = fH.toString().left(10) + "T" + hH.toString().right(8);
      var tHasta = Date.parse(sHasta);
      if (!tHasta) {
        return false;
      }
      var ms = tHasta - tDesde;
      var h = ms / (60 * 60 * 1000);
      valor = util.roundFieldValue(h, "lineaspedidoscli", "cantidad");
      break;
    }
    case "txtsolape": {
      valor = new Object;
      valor.texto = "";
      valor.color = undefined;
      if (cursor.isNull("fechadesdealq") || cursor.isNull("fechahastaalq")) {
        break;
      }
      /// Por un fallo que considera null 00:00:00
      var horaDesde = cursor.isNull("horadesdealq") ? "00:00:01" : cursor.valueBuffer("horadesdealq");
      var horaHasta = cursor.isNull("horahastaalq") ? "00:00:01" : cursor.valueBuffer("horahastaalq");
      if (!_i.curAlq_) {
        _i.curAlq_ = new FLSqlCursor("alquilerarticulos");
      }
      _i.curAlq_.setModeAccess(_i.curAlq_.Insert);
      _i.curAlq_.refreshBuffer();
      _i.curAlq_.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
      _i.curAlq_.setValueBuffer("idperiodoalq", cursor.isNull("idperiodoalq") ? 0 : cursor.valueBuffer("idperiodoalq"));
      _i.curAlq_.setValueBuffer("fechadesde", cursor.valueBuffer("fechadesdealq"));
      _i.curAlq_.setValueBuffer("fechahasta", cursor.valueBuffer("fechahastaalq"));
      _i.curAlq_.setValueBuffer("horadesde", horaDesde);
      _i.curAlq_.setValueBuffer("horahasta", horaHasta);
      var solape = flfactalma.iface.pub_haySolapeAlquiler(_i.curAlq_);
      switch (solape) {
        case 1: {
          valor.texto = util.translate("scripts", "Periodo presupuestado");
          valor.color = new Color("orange");
          break;
        }
        case 2: {
          valor.texto = util.translate("scripts", "Periodo reservado");
          valor.color = new Color("red");
          break;
        }
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor
}

       function alquiler_commonBufferChanged(fN, miForm)
{
  debug("alquiler_commonBufferChanged " + fN);
  var _i = this.iface;
  var cursor = miForm.cursor();

  switch (fN) {
    case "referencia": {
      _i.__commonBufferChanged(fN, miForm);
      _i.commonCalculateField("sealquila", cursor);
      _i.habilitaPorAlquiler(miForm)
      if (!_i.seAlquila_) {
        miForm.cursor().setNull("idperiodoalq");
      }
      break;
    }
    case "fechadesdealq":
    case "horadesdealq":
    case "cantidad": {
      _i.__commonBufferChanged(fN, miForm);
      if (!_i.seAlquila_) {
        break;
      }
      if (!_i.bloqAlq_) {
        _i.bloqAlq_ = true;
        var dHasta = _i.commonCalculateField("datehastaalq", cursor);
        if (dHasta) {
          miForm.child("fdbFechaHastaAlq").setValue(dHasta);
          miForm.child("fdbHoraHastaAlq").setValue(dHasta);
        }
        var oSolape = _i.commonCalculateField("txtsolape", cursor);
        if (oSolape) {
          miForm.child("lblAlqSolapado").text = oSolape.texto;
          miForm.child("lblAlqSolapado").paletteForegroundColor = oSolape.color;
        }
        _i.bloqAlq_ = false;
      }
      break;
    }
    case "fechahastaalq":
    case "horahastaalq": {
      if (!_i.seAlquila_) {
        break;
      }
      if (!_i.bloqAlq_) {
        _i.bloqAlq_ = true;
        var h = _i.commonCalculateField("horasalq", cursor);
        if (!isNaN(h)) {
          miForm.child("fdbHorasAlq").setValue(h);
        }
        var oSolape = _i.commonCalculateField("txtsolape", cursor);
        if (oSolape) {
          miForm.child("lblAlqSolapado").text = oSolape.texto;
          miForm.child("lblAlqSolapado").paletteForegroundColor = oSolape.color;
        }
        _i.bloqAlq_ = false;
      }
      break;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function alquiler_habilitaPorAlquiler(miForm)
{
  var _i = this.iface;
  if (_i.seAlquila_) {
    miForm.child("gbxAlquiler").setEnabled(true);
  } else {
    miForm.child("gbxAlquiler").setEnabled(false);
    miForm.child("fdbFechaDesdeAlq").setValue("NULL");
    miForm.child("fdbHoraDesdeAlq").setValue("NULL");
    miForm.child("fdbFechaHastaAlq").setValue("NULL");
    miForm.child("fdbHoraHastaAlq").setValue("NULL");
    miForm.cursor().setNull("fechadesdealq");
    miForm.cursor().setNull("fechahastaalq");
    miForm.cursor().setNull("horadesdealq");
    miForm.cursor().setNull("horahastaalq");
  }
}

function alquiler_commonTbnCalendario_clicked(miForm)
{
  var cursor = miForm.cursor();
  var hoy = new Date;
  hoy.setDate(1);
  var f = new FLFormSearchDB("calobjetomes");
  var curCal = f.cursor();
  curCal.select();
  if (!curCal.first()) {
    curCal.setModeAccess(curCal.Insert);
  } else {
    curCal.setModeAccess(curCal.Edit);
  }
  f.setMainWidget();
  curCal.refreshBuffer();
  curCal.setValueBuffer("fechadesde", hoy.toString().left(10));
  if (cursor.isNull("idperiodoalq")) {
    curCal.setValueBuffer("tipoobjeto", "articulos");
    curCal.setValueBuffer("idobjeto", cursor.valueBuffer("referencia"));
  } else {
    curCal.setValueBuffer("tipoobjeto", "alquilerarticulos");
    curCal.setValueBuffer("idobjeto", cursor.valueBuffer("idperiodoalq"));
  }
  f.exec("id");
  if (!f.accepted()) {
    return false;
  }
  var desde = curCal.valueBuffer("respuesta");
  miForm.child("fdbFechaDesdeAlq").setValue(desde);
  miForm.child("fdbHoraDesdeAlq").setFocus();
}

function alquiler_tbnCalendario_clicked()
{
  var _i = this.iface;
  _i.commonTbnCalendario_clicked(this);
}

//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
