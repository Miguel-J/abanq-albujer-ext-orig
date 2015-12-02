
/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends oficial
{
  function batchDocs(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.batchDocs_init();
  }
  function pbnBatchAlbaranes_clicked(): Boolean {
    return this.ctx.batchDocs_pbnBatchAlbaranes_clicked();
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

  pbnBatchAlbaranes = this.child("pbnBatchAlbaranes");
  connect(pbnBatchAlbaranes, "clicked()", this, "iface.pbnBatchAlbaranes_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
*/
function batchDocs_pbnBatchAlbaranes_clicked(): Boolean {
  var f: Object = new FLFormSearchDB("agruparalbaranescli");
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
  if (acpt)
  {
    cursor.commitBuffer();
    var curAgruparAlbaranes: FLSqlCursor = new FLSqlCursor("agruparalbaranescli");
    curAgruparAlbaranes.select();
    if (curAgruparAlbaranes.first()) {
      where = this.iface.whereAgrupacion(curAgruparAlbaranes);
      var excepciones: String = curAgruparAlbaranes.valueBuffer("excepciones");
      if (!excepciones.isEmpty())
        where += " AND idalbaran NOT IN (" + excepciones + ")";

      var qryAgruparAlbaranes: FLSqlQuery = new FLSqlQuery;
      qryAgruparAlbaranes.setTablesList("albaranescli");
      qryAgruparAlbaranes.setSelect("idalbaran");
      qryAgruparAlbaranes.setFrom("albaranescli");
      qryAgruparAlbaranes.setWhere(where);

      if (!qryAgruparAlbaranes.exec())
        return false;

      var curAlbaran: FLSqlCursor = new FLSqlCursor("albaranescli");
      var whereFactura: String;
      while (qryAgruparAlbaranes.next()) {
        whereFactura = "idalbaran = " + qryAgruparAlbaranes.value(0);
        curAlbaran.transaction(false);
        curAlbaran.select(whereFactura);
        if (!curAlbaran.first()) {
          curAlbaran.rollback();
          return false;
        }
        curAlbaran.setValueBuffer("fecha", curAgruparAlbaranes.valueBuffer("fecha"));
        if (formalbaranescli.iface.pub_generarFactura(whereFactura, curAlbaran)) {
          curAlbaran.commit();
        } else {
          curAlbaran.rollback();
          return false;
        }
      }
    }

    f.close();
    if (this.iface.tdbRecords)
      this.iface.tdbRecords.refresh();
  }  else {
    f.close();
    return false;
  }

  return true;
}
//// BATCH_DOCS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////