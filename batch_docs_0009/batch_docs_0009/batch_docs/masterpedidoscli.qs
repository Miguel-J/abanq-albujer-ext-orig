
/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends oficial
{
  var pbnBatchPresupuestos;
  function batchDocs(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.batchDocs_init();
  }
  function pbnBatchPresupuestos_clicked()
  {
    return this.ctx.batchDocs_pbnBatchPresupuestos_clicked();
  }
  function whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.ctx.batchDocs_whereAgrupacion(curAgrupar);
  }
}
//// BATCH_DOCS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBatchDocs */
/////////////////////////////////////////////////////////////////
//// PUB_BATCH_DOCS /////////////////////////////////////////////
class pubBatchDocs extends ifaceCtx
{
  function pubBatchDocs(context)
  {
    ifaceCtx(context);
  }
  function pub_whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.whereAgrupacion(curAgrupar);
  }
}
//// PUB_BATCH_DOCS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
function batchDocs_init()
{
  this.iface.__init();

  this.iface.pbnBatchPresupuestos = this.child("pbnBatchPresupuestos");
  connect(this.iface.pbnBatchPresupuestos, "clicked()", this, "iface.pbnBatchPresupuestos_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
\end */
function batchDocs_pbnBatchPresupuestos_clicked()
{
  var f: Object = new FLFormSearchDB("agruparpresupuestoscli");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt: String = f.exec("codejercicio");
  if (acpt) {
    cursor.commitBuffer();
    var curAgruparPresupuestos: FLSqlCursor = new FLSqlCursor("agruparpresupuestoscli");
    curAgruparPresupuestos.select();
    if (curAgruparPresupuestos.first()) {
      where = this.iface.whereAgrupacion(curAgruparPresupuestos);
      var excepciones: String = curAgruparPresupuestos.valueBuffer("excepciones");
      if (!excepciones.isEmpty())
        where += " AND idpresupuesto NOT IN (" + excepciones + ")";

      var qryAgruparPresupuestos: FLSqlQuery = new FLSqlQuery;
      qryAgruparPresupuestos.setTablesList("presupuestoscli");
      qryAgruparPresupuestos.setSelect("idpresupuesto");
      qryAgruparPresupuestos.setFrom("presupuestoscli");
      qryAgruparPresupuestos.setWhere(where);

      if (!qryAgruparPresupuestos.exec())
        return;

      var curPresupuesto: FLSqlCursor = new FLSqlCursor("presupuestoscli");
      var wherePedido: String;
      while (qryAgruparPresupuestos.next()) {
        wherePedido = "idpresupuesto = " + qryAgruparPresupuestos.value(0);
        curPresupuesto.transaction(false);
        curPresupuesto.select(wherePedido);
        if (!curPresupuesto.first()) {
          curPresupuesto.rollback();
          return;
        }
        curPresupuesto.setValueBuffer("fecha", curAgruparPresupuestos.valueBuffer("fecha"));
        if (formpresupuestoscli.iface.pub_generarPedido(curPresupuesto)) {
          curPresupuesto.commit();
        } else {
          curPresupuesto.rollback();
          return;
        }
      }
    }

    f.close();
    this.iface.tdbRecords.refresh();
  }
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los pedidos a agrupar
@param curAgrupar: Cursor de la tabla agruparpedidoscli que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function batchDocs_whereAgrupacion(curAgrupar: FLSqlCursor): String {
  var codCliente: String = curAgrupar.valueBuffer("codcliente");
  var nombreCliente: String = curAgrupar.valueBuffer("nombrecliente");
  var cifNif: String = curAgrupar.valueBuffer("cifnif");
  var codAlmacen: String = curAgrupar.valueBuffer("codalmacen");
  var codPago: String = curAgrupar.valueBuffer("codpago");
  var codDivisa: String = curAgrupar.valueBuffer("coddivisa");
  var codSerie: String = curAgrupar.valueBuffer("codserie");
  var codEjercicio: String = curAgrupar.valueBuffer("codejercicio");
  var fechaDesde: String = curAgrupar.valueBuffer("fechadesde");
  var fechaHasta: String = curAgrupar.valueBuffer("fechahasta");
  var where: String = "editable = true";
  if (!codCliente.isEmpty())
    where += " AND codcliente = '" + codCliente + "'";
  if (!cifNif.isEmpty())
    where += " AND cifnif = '" + cifNif + "'";
  if (!codAlmacen.isEmpty())
    where = where + " AND codalmacen = '" + codAlmacen + "'";
  where = where + " AND fecha >= '" + fechaDesde + "'";
  where = where + " AND fecha <= '" + fechaHasta + "'";
  if (!codPago.isEmpty() != "")
    where = where + " AND codpago = '" + codPago + "'";
  if (!codDivisa.isEmpty())
    where = where + " AND coddivisa = '" + codDivisa + "'";
  if (!codSerie.isEmpty())
    where = where + " AND codserie = '" + codSerie + "'";
  if (!codEjercicio.isEmpty())
    where = where + " AND codejercicio = '" + codEjercicio + "'";
  return where;
}
//// BATCH_DOCS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////