
/** @class_declaration numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
class numerosLinea extends oficial
{
  function numerosLinea(context)
  {
    oficial(context);
  }
  function intercambiarOrden(cursor, direccion, id)
  {
    return this.ctx.numerosLinea_intercambiarOrden(cursor, direccion, id);
  }
  function controlNumLinea(curLinea)
  {
    return this.ctx.numerosLinea_controlNumLinea(curLinea);
  }
  function afterCommit_lineaspresupuestoscli(curLP)
  {
    return this.ctx.numerosLinea_afterCommit_lineaspresupuestoscli(curLP);
  }
  function afterCommit_lineaspedidoscli(curLP)
  {
    return this.ctx.numerosLinea_afterCommit_lineaspedidoscli(curLP);
  }
  function afterCommit_lineasalbaranescli(curLA)
  {
    return this.ctx.numerosLinea_afterCommit_lineasalbaranescli(curLA);
  }
  function afterCommit_lineasfacturascli(curLF)
  {
    return this.ctx.numerosLinea_afterCommit_lineasfacturascli(curLF);
  }
}
//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
/** \D Mueve la línea seleccionada hacia arriba o hacia abajo en función de la dirección

@param  direccion: Indica la dirección en la que hay que mover la línea. Valores:
  1: Hacia abajo
  -1: Hacia arriba
@param cursor: Indica el cursor que vamos a utilizar
@param idTabla: Indica el campo identificador de la tabla que estamos usando
\end */
function numerosLinea_intercambiarOrden(cursor, direccion, id)
{
  var util: FLUtil = new FLUtil;
  var tablaLineas = cursor.table();

  var orden1 = cursor.valueBuffer("numlinea");
  var orden2;

  if (direccion == -1) {
    orden2 = util.sqlSelect(tablaLineas, "numlinea", "numlinea < '" + orden1 + "' AND " + id + " = " + cursor.valueBuffer(id) + " ORDER BY numlinea DESC");
  } else {
    orden2 = util.sqlSelect(tablaLineas, "numlinea", "numlinea > '" + orden1 + "' AND " + id + " = " + cursor.valueBuffer(id) + " ORDER BY numlinea");
  }
  if (!orden2) {
    return false;
  }
  var curInt: FLSqlCursor = new FLSqlCursor(tablaLineas);
  curInt.select("numlinea = '" + orden2 + "' AND " + id + " = " + cursor.valueBuffer(id));
  if (!curInt.first()) {
    return false;
  }

  curInt.setModeAccess(curInt.Edit);
  curInt.refreshBuffer();
  curInt.setValueBuffer("numlinea", "-1");
  curInt.commitBuffer();

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("numlinea", orden2);
  cursor.commitBuffer();

  curInt.setModeAccess(curInt.Edit);
  curInt.refreshBuffer();
  curInt.setValueBuffer("numLinea", orden1);
  curInt.commitBuffer();
  return true;
}

function numerosLinea_afterCommit_lineaspresupuestoscli(curLP)
{
  var _i = this.iface;
  try {
    if (!_i.__afterCommit_lineaspresupuestoscli(curLP)) {
      return false;
    }
  } catch (e) {}

  if (!_i.controlNumLinea(curLP)) {
    return false;
  }
  return true;
}

function numerosLinea_afterCommit_lineaspedidoscli(curLP)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineaspedidoscli(curLP)) {
    return false;
  }
  if (!_i.controlNumLinea(curLP)) {
    return false;
  }
  return true;
}

function numerosLinea_afterCommit_lineasalbaranescli(curLA)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineasalbaranescli(curLA)) {
    return false;
  }
  if (!_i.controlNumLinea(curLA)) {
    return false;
  }
  return true;
}

function numerosLinea_afterCommit_lineasfacturascli(curLF)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineasfacturascli(curLF)) {
    return false;
  }
  if (!_i.controlNumLinea(curLF)) {
    return false;
  }
  return true;
}

/** \D Si existe una línea con el mismo número, el resto de líneas se renumera para evitar duplicidades
  \end */
function numerosLinea_controlNumLinea(curLinea)
{
  if (curLinea.modeAccess() != curLinea.Insert && curLinea.modeAccess() != curLinea.Edit) {
    return  true;
  }
  var tabla = curLinea.table();
  switch (tabla) {
    case "lineaspresupuestoscli": {
      idDoc = "idpresupuesto";
      break;
    }
    case "lineaspedidoscli": {
      idDoc = "idpedido";
      break;
    }
    case "lineasalbaranescli": {
      idDoc = "idalbaran";
      break;
    }
    case "lineasfacturascli": {
      idDoc = "idfactura";
      break;
    }
  }
  var valorIdDoc = curLinea.valueBuffer(idDoc);
  var idLinea = curLinea.valueBuffer("idlinea");
  var numLinea = curLinea.valueBuffer("numlinea");
  debug("select idlinea from " + tabla + " where " + idDoc + " = " + valorIdDoc + " AND idlinea <> " + idLinea + " AND numlinea = " + numLinea);
  var idLineaDup = AQUtil.sqlSelect(tabla, "idlinea", idDoc + " = " + valorIdDoc + " AND idlinea <> " + idLinea + " AND numlinea = " + numLinea);
  if (!idLineaDup) {
    return true;
  }
  var curLineas = new FLSqlCursor(tabla);
  curLineas.setActivatedCheckIntegrity(false);
  curLineas.setActivatedCommitActions(false);
  curLineas.select(idDoc + " = " + valorIdDoc + " AND idlinea <> " + idLinea + " AND numlinea >= " + numLinea + " ORDER BY numlinea, idlinea");
  while (curLineas.next()) {
    numLinea++;
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer()        ;
    curLineas.setValueBuffer("numlinea", numLinea);
    if (!curLineas.commitBuffer()) {
      return false;
    }
  }
  return true;
}
//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
