
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  function copiarAnexosArticulo(nuevaReferencia: String): Boolean {
    return this.ctx.tallasColores_copiarAnexosArticulo(nuevaReferencia);
  }
  function copiarTablaArticulosColores(nuevaReferencia: String): Boolean {
    return this.ctx.tallasColores_copiarTablaArticulosColores(nuevaReferencia);
  }
  function datosArticuloColor(cursor: FLSqlCursor, cursorNuevo: FLSqlCursor, referencia: String): Boolean {
    return this.ctx.tallasColores_datosArticuloColor(cursor, cursorNuevo, referencia);
  }
  function copiarArticuloColor(id: Number, referencia: String): Number {
    return this.ctx.tallasColores_copiarArticuloColor(id, referencia);
  }
  function copiarTablaArticulosTallas(nuevaReferencia: String): Boolean {
    return this.ctx.tallasColores_copiarTablaArticulosTallas(nuevaReferencia);
  }
  function datosArticuloTalla(cursor: FLSqlCursor, cursorNuevo: FLSqlCursor, referencia: String): Boolean {
    return this.ctx.tallasColores_datosArticuloTalla(cursor, cursorNuevo, referencia);
  }
  function copiarArticuloTalla(id: Number, referencia: String): Number {
    return this.ctx.tallasColores_copiarArticuloTalla(id, referencia);
  }
}
//// TALLASCOLORES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////
function tallasColores_copiarAnexosArticulo(nuevaReferencia: String): Boolean {
  if (!this.iface.__copiarAnexosArticulo(nuevaReferencia))
    return false;

  if (!this.iface.copiarTablaArticulosColores(nuevaReferencia))
    return false;

  if (!this.iface.copiarTablaArticulosTallas(nuevaReferencia))
    return false;

  return true;
}

function tallasColores_copiarTablaArticulosColores(nuevaReferencia: String): Boolean {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("articuloscolores");
  q.setSelect("id");
  q.setFrom("articuloscolores");
  q.setWhere("referencia = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");

  if (!q.exec())
    return false;

  while (q.next())
  {
    if (!this.iface.copiarArticuloColor(q.value("id"), nuevaReferencia))
      return false;
  }

  return true;
}

function tallasColores_copiarArticuloColor(id: Number, referencia: String): Number {
  var curArticuloColor: FLSqlCursor = new FLSqlCursor("articuloscolores");
  curArticuloColor.select("id = " + id);
  if (!curArticuloColor.first())
    return false;
  curArticuloColor.setModeAccess(curArticuloColor.Edit);
  curArticuloColor.refreshBuffer();

  var curArticuloColorNuevo: FLSqlCursor = new FLSqlCursor("articuloscolores");
  curArticuloColorNuevo.setModeAccess(curArticuloColorNuevo.Insert);
  curArticuloColorNuevo.refreshBuffer();

  if (!this.iface.datosArticuloColor(curArticuloColor, curArticuloColorNuevo, referencia))
    return false;

  if (!curArticuloColorNuevo.commitBuffer())
    return false;

  var idNuevo: Number = curArticuloColorNuevo.valueBuffer("id");

  return idNuevo;
}

function tallasColores_datosArticuloColor(cursor: FLSqlCursor, cursorNuevo: FLSqlCursor, referencia: String): Boolean {
  cursorNuevo.setValueBuffer("referencia", referencia);
  cursorNuevo.setValueBuffer("color", cursor.valueBuffer("color"));

  return true;
}

function tallasColores_copiarTablaArticulosTallas(nuevaReferencia: String): Boolean {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("articulostallas");
  q.setSelect("id");
  q.setFrom("articulostallas");
  q.setWhere("referencia = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");

  if (!q.exec())
    return false;

  while (q.next())
  {
    if (!this.iface.copiarArticuloTalla(q.value("id"), nuevaReferencia))
      return false;
  }

  return true;
}

function tallasColores_copiarArticuloTalla(id: Number, referencia: String): Number {
  var curArticuloTalla: FLSqlCursor = new FLSqlCursor("articulostallas");
  curArticuloTalla.select("id = " + id);
  if (!curArticuloTalla.first())
    return false;
  curArticuloTalla.setModeAccess(curArticuloTalla.Edit);
  curArticuloTalla.refreshBuffer();

  var curArticuloTallaNuevo: FLSqlCursor = new FLSqlCursor("articulostallas");
  curArticuloTallaNuevo.setModeAccess(curArticuloTallaNuevo.Insert);
  curArticuloTallaNuevo.refreshBuffer();

  if (!this.iface.datosArticuloTalla(curArticuloTalla, curArticuloTallaNuevo, referencia))
    return false;

  if (!curArticuloTallaNuevo.commitBuffer())
    return false;

  var idNuevo: Number = curArticuloTallaNuevo.valueBuffer("id");

  return idNuevo;
}

function tallasColores_datosArticuloTalla(cursor: FLSqlCursor, cursorNuevo: FLSqlCursor, referencia: String): Boolean {
  cursorNuevo.setValueBuffer("referencia", referencia);
  cursorNuevo.setValueBuffer("talla", cursor.valueBuffer("talla"));

  return true;
}
//// TALLASCOLORES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
