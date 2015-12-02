
/** @class_declaration complejos */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPLEJOS ////////////////////////////////////////
class complejos extends oficial
{
  function complejos(context)
  {
    oficial(context);
  }
  function commonInit(miForm)
  {
    return this.ctx.complejos_commonInit(miForm);
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.complejos_commonBufferChanged(fN, miForm);
  }
  function habilitaPorComplejo(miForm)
  {
    return this.ctx.complejos_habilitaPorComplejo(miForm);
  }
  function tbnParamComplejo_clicked()
  {
    return this.ctx.complejos_tbnParamComplejo_clicked();
  }
  function commonGuardaLinea(cursor)
  {
    return this.ctx.complejos_commonGuardaLinea(cursor);
  }
  function dameAccionComplejo(tipo)
  {
    return this.ctx.complejos_dameAccionComplejo(tipo);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.complejos_commonCalculateField(fN, cursor);
  }
}
//// ARTICULOS COMPLEJOS ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition complejos */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPLEJOS ////////////////////////////////////////
function complejos_commonBufferChanged(fN, miForm)
{
  var _i = this.iface;
  var cursor = miForm.cursor();

  if (miForm == undefined || cursor == undefined) {
    debug(sys.translate("Formulario o cursor no válido"));
    return;
  }

  switch (fN) {
    case "referencia": {
      _i.__commonBufferChanged(fN, miForm);
      cursor.setValueBuffer("tipocomplejo", _i.commonCalculateField("tipocomplejo", cursor));
      break;
    }
    case "tipocomplejo": {
      _i.habilitaPorComplejo(miForm);
      break;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function complejos_habilitaPorComplejo(miForm)
{
  var _i = this.iface;
  var cursor = miForm.cursor();

  if (cursor.valueBuffer("tipocomplejo") == "N/A") {
    sys.disableObj(miForm, "tbnParamComplejo")
  } else {
    sys.runObjMethod(miForm, "tbnParamComplejo", "setEnabled", true);
  }
}

function complejos_commonInit(miForm)
{
  var _i = this.iface;
  _i.__commonInit(miForm);
  _i.habilitaPorComplejo(miForm);

  var tbnParamComplejo = miForm.child("tbnParamComplejo");
  if (tbnParamComplejo) {
    connect(tbnParamComplejo, "clicked()", miForm, "iface.tbnParamComplejo_clicked");
  }
}

function complejos_tbnParamComplejo_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.commonGuardaLinea(cursor)) {
    return false;
  }
  var campoIdLinea;
  switch (cursor.table()) {
    case "lineaspedidoscli": {
      campoIdLinea = "idlineapc";
      break;
    }
  }
  var idLinea = cursor.valueBuffer("idlinea");
  var accion = _i.dameAccionComplejo(cursor.valueBuffer("tipocomplejo"));
  if (!accion) {
    return false;
  }

  var f = new FLFormSearchDB(accion);
  var curAccion  = f.cursor();
  curAccion.select("idlineapc = " + cursor.valueBuffer("idlinea"));
  if (curAccion.first()) {
    curAccion.setModeAccess(curAccion.Edit);
    curAccion.refreshBuffer();
  } else {
    curAccion.setModeAccess(curAccion.Insert);
    curAccion.refreshBuffer();
    curAccion.setValueBuffer("idlineapc", cursor.valueBuffer("idlinea"));
  }
  f.setMainWidget();
  f.exec();
  if (!f.accepted()) {
    return false;
  }
  if (!curAccion.commitBuffer()) {
    return false;
  }
  var precio = curAccion.valueBuffer("precio");
  if (precio != undefined) {
    cursor.setValueBuffer("pvpunitario", precio);
  }
  var descripcion = curAccion.valueBuffer("descripcion");
  if (descripcion != undefined) {
    cursor.setValueBuffer("descripcion", descripcion);
  }
  return true;
}

function complejos_dameAccionComplejo(tipo)
{
  var a;
  switch (tipo) {
    case "Ejemplo": {
      a = "ejemploartcomplejos";
      break;
    }
    default: {
      a = tipo.toLowerCase();
    }
  }
  return a;
}

function complejos_commonCalculateField(fN, cursor)
{
  var _i = this.iface;

  var valor;
  switch (fN) {
    case "tipocomplejo": {
      valor = AQUtil.sqlSelect("articulos", "tipocomplejo", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      valor = valor ? valor : "N/A";
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function complejos_commonGuardaLinea(cursor)
{
  var indice = cursor.atFrom();
  if (!cursor.commitBuffer()) {
    return false;
  }
  //  if (!cursor.commit()) {
  //    return false;
  //  }
  //  if (!cursor.transaction(false)) {
  //    return false;
  //  }
  if (!cursor.seek(indice)) {
    return false;
  }
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();

  return true;
}
//// ARTICULOS COMPLEJOS ////////////////////////////////////////
/////////////////////////////////////////////////////////////////
