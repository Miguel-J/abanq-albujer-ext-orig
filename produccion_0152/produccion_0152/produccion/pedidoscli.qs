
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN /////////////////////////////////////////////////
class prod extends oficial
{
  function prod(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.prod_validateForm();
  }
  function init()
  {
    return this.ctx.prod_init();
  }
  function calcularTotales()
  {
    return this.ctx.prod_calcularTotales();
  }
  function refrescarLotes()
  {
    return this.ctx.prod_refrescarLotes();
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN /////////////////////////////////////////////////
function prod_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("fechasalida") != cursor.valueBufferCopy("fechasalida"))
  {
    if (!flfactalma.iface.pub_modificarFechaPedidoCli(cursor))
      return false;
  }
  //  var qryStocks:FLSqlQuery = new FLSqlQuery()
  //  with (qryStocks) {
  //    setTablesList("movistock,lineaspedidosprov");
  //    setSelect("ms.idstock");
  //    setFrom("lineaspedidoscli lp INNER JOIN movistock ms ON lp.idlinea = ms.idlineapc");
  //    setWhere("lp.idpedido = " + cursor.valueBuffer("idpedido") + " AND ms.estado = 'PTE' GROUP BY idstock");
  //    setForwardOnly(true);
  //  }
  //  if (!qryStocks.exec())
  //    return false;
  //  while (qryStocks.next()) {
  //    if (!flfactalma.iface.pub_comprobarEvolStock(qryStocks.value("ms.idstock")))
  //      return false;
  //  }
  return true;
}

function prod_init()
{
  this.iface.__init();
  this.iface.refrescarLotes();
}

function prod_calcularTotales()
{
  this.iface.__calcularTotales();
  this.iface.refrescarLotes();
}

function prod_refrescarLotes()
{
  var cursor: FLSqlCursor = this.cursor();

  var qryLotes: FLSqlQuery = new FLSqlQuery();
  qryLotes.setTablesList("movistock,lineaspedidoscli");
  qryLotes.setSelect("ms.codlote");
  qryLotes.setFrom("lineaspedidoscli lp INNER JOIN movistock ms ON lp.idlinea = ms.idlineapc");
  qryLotes.setWhere("idpedido = " + cursor.valueBuffer("idpedido"));
  qryLotes.setForwardOnly(true);
  if (!qryLotes.exec())
    return;

  var listaLotes: String = "";
  while (qryLotes.next()) {
    if (listaLotes != "")
      listaLotes += ", "
                    listaLotes += "'" + qryLotes.value("ms.codlote") + "'";
  }
  if (listaLotes && listaLotes != "")
    this.child("tdbLotesStock").cursor().setMainFilter("codlote IN (" + listaLotes + ")");
  else
    this.child("tdbLotesStock").cursor().setMainFilter("1 = 2");

  this.child("tdbLotesStock").refresh();
}

//// PRODUCCIÓN /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
