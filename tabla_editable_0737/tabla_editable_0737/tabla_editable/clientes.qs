
/** @class_declaration tablaEditable */
/////////////////////////////////////////////////////////////////
//// TABLA EDITABLE /////////////////////////////////////////////
class tablaEditable extends oficial
{
  function tablaEditable(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.tablaEditable_init();
  }
  function tablaDirecciones()
  {
    return this.ctx.tablaEditable_tablaDirecciones();
  }
  function valueChanged(fN, cursor)
  {
    return this.ctx.tablaEditable_valueChanged(fN, cursor);
  }
  function bufferComitedTE()
  {
    return this.ctx.tablaEditable_bufferComitedTE();
  }
  function validateCursorTE(cursor)
  {
    return this.ctx.tablaEditable_validateCursorTE(cursor);
  }
}
//// TABLA EDITABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tablaEditable */
/////////////////////////////////////////////////////////////////
//// TABLA DIRECCIONES //////////////////////////////////////////
function tablaEditable_init()
{
  var _i = this.iface;
  _i.__init();
  //_i.tablaDirecciones();
  this.child("groupBox14").close();
}

function tablaEditable_tablaDirecciones()
{
  var cursor = this.cursor();

  var oParam = new Object;
  oParam.controlTabla = "tblDirecciones";
  oParam.container = this;
  var c = 0;
  oParam.cols = [];
  oParam.cols[c] = flfactppal.iface.pub_dameColTE();
  oParam.cols[c]["fN"] = "id";
  oParam.cols[c]["visible"] = false;
  c++;
  oParam.cols[c] = flfactppal.iface.pub_dameColTE();
  oParam.cols[c]["fN"] = "direccion";
  c++;
  oParam.cols[c] = flfactppal.iface.pub_dameColTE();
  oParam.cols[c]["fN"] = "codpostal";
  c++;
  oParam.cols[c] = flfactppal.iface.pub_dameColTE();
  oParam.cols[c]["fN"] = "provincia";
  oParam.cols[c]["editable"] = false;
  c++;
  oParam.cols[c] = flfactppal.iface.pub_dameColTE();
  oParam.cols[c]["fN"] = "dto";
  c++;

  oParam.tabla = "dirclientes";
  oParam.fF = "codcliente";
  oParam.fR = "codcliente";
  oParam.cR = cursor;
  oParam.fBufferChanged = "formRecordclientes.iface.valueChanged";
  oParam.fBufferCommited = "formRecordclientes.iface.bufferComitedTE";
  oParam.fValidateCursor = "formRecordclientes.iface.validateCursorTE";

  flfactppal.iface.pub_cargaTablaEditable(oParam);
}

function tablaEditable_valueChanged(fN, cursor)
{
  switch (fN) {
    case "direccion": {
      cursor.setValueBuffer("codpostal", cursor.valueBuffer("codpostal") + 1);
      break;
    }
    case "codpostal": {
      cursor.setValueBuffer("provincia", cursor.valueBuffer("provincia") + "P");
      break;
    }
  }
  return true;
}

function tablaEditable_bufferComitedTE()
{
  MessageBox.information("BC");
}

function tablaEditable_validateCursorTE(cursor)
{
  if (cursor.valueBuffer("dto") > 2) {
    MessageBox.information("error");
    return false;
  }
  return true;
}
//// TABLA DIRECCIONES //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
