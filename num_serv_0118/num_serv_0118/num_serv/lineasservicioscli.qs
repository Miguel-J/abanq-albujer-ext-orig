
/** @class_declaration nsServicios */
//////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////////
class nsServicios extends oficial
{
  function nsServicios(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.nsServicios_init();
  }
  function validateForm(): Boolean { return this.ctx.nsServicios_validateForm(); }
  function bufferChanged(fN: String)
  {
    return this.ctx.nsServicios_bufferChanged(fN);
  }
  function controlCantidad(cantidadAuno: Boolean)
  {
    return this.ctx.nsServicios_controlCantidad(cantidadAuno);
  }
}
//// NS_SERVICIOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition nsServicios */
/////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////

function nsServicios_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Edit) {
    this.iface.controlCantidad(true);
    if (cursor.valueBuffer("numserie")) {
      this.child("fdbNumSerie").setDisabled(true);
      this.child("fdbReferencia").setDisabled(true);
    }
  }
}

function nsServicios_bufferChanged(fN: String)
{
  switch (fN) {
    case "referencia":
      this.iface.controlCantidad(true);
      break;
  }

  return this.iface.__bufferChanged(fN);
}


function nsServicios_controlCantidad(cantidadAuno: Boolean)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
    if (cantidadAuno)
      cursor.setValueBuffer("cantidad", 1);
    this.child("fdbCantidad").setDisabled(true);
    this.child("fdbNumSerie").setDisabled(false);
  } else {
    this.child("fdbCantidad").setDisabled(false);
    this.child("fdbNumSerie").setDisabled(true);
  }
}

function nsServicios_validateForm(): Boolean {
  if (this.cursor().modeAccess() == this.cursor().Edit)
    return true;

  var util: FLUtil = new FLUtil();
  if (this.cursor().valueBuffer("numserie") && util.sqlSelect("numerosserie", "id", "numserie = '" + this.cursor().valueBuffer("numserie") + "' AND vendido = 'true'"))
  {
    MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return true;
}

//// NS_SERVICIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

