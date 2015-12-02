
/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends oficial
{
  var pbnBatchPedidos: Object;
  function batchDocs(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.batchDocs_init();
  }
  function pbnBatchPedidos_clicked()
  {
    return this.ctx.batchDocs_pbnBatchPedidos_clicked();
  }
}
//// BATCH_DOCS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
function batchDocs_init()
{
  this.iface.__init();

  this.iface.pbnBatchPedidos = this.child("pbnBatchPedidos");
  connect(this.iface.pbnBatchPedidos, "clicked()", this, "iface.pbnBatchPedidos_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
\end */
function batchDocs_pbnBatchPedidos_clicked()
{
  var f: Object = new FLFormSearchDB("agruparpedidoscli");
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
    var curAgruparPedidos: FLSqlCursor = new FLSqlCursor("agruparpedidoscli");
    curAgruparPedidos.select();
    if (curAgruparPedidos.first()) {
      where = this.iface.whereAgrupacion(curAgruparPedidos);
      var excepciones: String = curAgruparPedidos.valueBuffer("excepciones");
      if (!excepciones.isEmpty())
        where += " AND idpedido NOT IN (" + excepciones + ")";

      var qryAgruparPedidos: FLSqlQuery = new FLSqlQuery;
      qryAgruparPedidos.setTablesList("pedidoscli");
      qryAgruparPedidos.setSelect("idpedido");
      qryAgruparPedidos.setFrom("pedidoscli");
      qryAgruparPedidos.setWhere(where);

      if (!qryAgruparPedidos.exec())
        return;

      var curPedido: FLSqlCursor = new FLSqlCursor("pedidoscli");
      var whereAlbaran: String;
      while (qryAgruparPedidos.next()) {
        whereAlbaran = "idpedido = " + qryAgruparPedidos.value(0);
        curPedido.transaction(false);
        curPedido.select(whereAlbaran);
        if (!curPedido.first()) {
          curPedido.rollback();
          return;
        }
        curPedido.setValueBuffer("fecha", curAgruparPedidos.valueBuffer("fecha"));
        if (formpedidoscli.iface.pub_generarAlbaran(whereAlbaran, curPedido)) {
          curPedido.commit();
        } else {
          curPedido.rollback();
          return;
        }
      }
    }

    f.close();
    this.iface.tdbRecords.refresh();
  }
}

//// BATCH_DOCS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////