
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN /////////////////////////////////////////////////
class prod extends oficial
{
  var porLotes;
  var pbnEditLote;
  function prod(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.prod_init();
  }
  function initLotes()
  {
    return this.ctx.prod_initLotes();
  }
  function calculaCantidadLotes()
  {
    return this.ctx.prod_calculaCantidadLotes();
  }
  function editarLote()
  {
    return this.ctx.prod_editarLote();
  }
  function bufferChanged(fN)
  {
    return this.ctx.prod_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.prod_calculateField(fN);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.prod_commonCalculateField(fN, cursor);
  }
  function controlTrazable()
  {
    return this.ctx.prod_controlTrazable();
  }
}
//// PRODUCCIÓN /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubProd */
/////////////////////////////////////////////////////////////////
//// PUB PRODUCCION /////////////////////////////////////////////
class pubProd extends ifaceCtx
{
  function pubProd(context)
  {
    ifaceCtx(context);
  }
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
  }
}
//// PUB PRODUCCION /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PROD ///////////////////////////////////////////////////////
/** \C Una vez establecida, no podrá modificarse la referencia de los artículos y si el artículo es por lotes tampoco podrá modificarse la cantidad.
\end */
function prod_init()
{
  var _i = this.iface;
  this.iface.__init();

  this.iface.pbnEditLote = this.child("pbnEditLote");
  connect(this.iface.pbnEditLote, "clicked()", this, "iface.editarLote()");

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Edit: {
      this.child("fdbReferencia").setDisabled(true);
    }
  }
  //  this.child("tdbMoviStock").cursor().setMainFilter("idlineaac = " + cursor.valueBuffer("idlinea"));
  //  this.child("tdbMoviStock").refresh();
  this.child("tdbLotesStock").cursor().setMainFilter("codlote IN (SELECT codlote FROM movistock WHERE idlineaac = " + cursor.valueBuffer("idlinea") + ")");
  this.child("tdbLotesStock").refresh();

  _i.initLotes();
}

function prod_initLotes()
{
  var _i = this.iface;
  connect(this.child("tdbMoviStock").cursor(), "bufferCommited()", _i, "calculaCantidadLotes()");
  this.child("tdbMoviStock").cursor().setAction("movistockalbaran");
  _i.controlTrazable();
}

function prod_controlTrazable()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var referencia = cursor.valueBuffer("referencia");

  _i.porLotes = flfactalma.iface.pub_esTrazable(referencia);
  if (_i.porLotes) {
    this.child("gbxMoviStock").setDisabled(false);
    this.child("fdbCantidad").setDisabled(true);
    _i.calculaCantidadLotes()
  } else {
    this.child("gbxMoviStock").setDisabled(true);
    this.child("fdbCantidad").setDisabled(false);
    this.child("fdbReferencia").setDisabled(false);
  }
}

function prod_calculaCantidadLotes()
{
  var _i = this.iface;
  sys.setObjText(this, "fdbCantidad", _i.calculateField("cantidadtrazable"));
}

function prod_editarLote()
{
  var codLote = this.child("tdbLotesStock").cursor().valueBuffer("codlote");
  debug("codLote " + codLote);
  if (!codLote || codLote == "") {
    return false;
  }

  this.child("tdbLotesStock").cursor().editRecord();
}

function prod_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "cantidadtrazable": {
      valor = _i.commonCalculateField(fN, cursor);
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
    }
  }
  return valor;
}

function prod_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "cantidadtrazable": {
      valor = AQUtil.sqlSelect("movistock", "SUM(cantidad)", "idlineaac = " + cursor.valueBuffer("idlinea"));
      valor = isNaN(valor) ? 0 : valor;
      valor *= -1;
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function prod_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "referencia": {
      _i.controlTrazable();
      _i.__bufferChanged(fN);
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}
//// PROD ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
