
/** @class_declaration asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
class asoPresup extends oficial
{
  var pbnAPedido: Object;
  function asoPresup(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.asoPresup_init();
  }
  function whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.ctx.asoPresup_whereAgrupacion(curAgrupar);
  }
  function asociarAPedido()
  {
    return this.ctx.asoPresup_asociarAPedido();
  }
  function recordDelBeforepedidoscli()
  {
    return this.ctx.asoPresup_recordDelBeforepedidoscli()
  };
}
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubAsoPresup */
/////////////////////////////////////////////////////////////////
//// PUB ASOCIAR PRESUPUESTOS////////////////////////////////////
class pubAsoPresup extends ifaceCtx
{
  function pubAsoPresup(context)
  {
    ifaceCtx(context);
  }
  function pub_whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.whereAgrupacion(curAgrupar);
  }
}
//// PUB ASOCIAR PRESUPUESTOS////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
function asoPresup_init()
{
  this.iface.__init();

  this.iface.pbnAPedido = this.child("pbnAsociarAPedido");
  connect(this.iface.pbnAPedido, "clicked()", this, "iface.asociarAPedido");
}

/** \C
Al pulsar el botón de asociar a pedido se abre la ventana de agrupar presupuestos de cliente
\end */
function asoPresup_asociarAPedido()
{
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("agruparpresupuestoscli");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;
  var codCliente: String;

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
      var excepciones = curAgruparPresupuestos.valueBuffer("excepciones");
      if (!excepciones.isEmpty())
        where += " AND idpresupuesto NOT IN (" + excepciones + ")";

      var qryAgruparPresupuestos = new FLSqlQuery;
      qryAgruparPresupuestos.setTablesList("presupuestoscli");
      qryAgruparPresupuestos.setSelect("codcliente");
      qryAgruparPresupuestos.setFrom("presupuestoscli");
      qryAgruparPresupuestos.setWhere(where + " GROUP BY codcliente");
      if (!qryAgruparPresupuestos.exec())
        return;

      var totalClientes: Number = qryAgruparPresupuestos.size();
      util.createProgressDialog(util.translate("scripts", "Generando pedidos"), totalClientes);
      util.setProgress(1);
      var j: Number = 0;

      var curPresupuesto: FLSqlCursor = new FLSqlCursor("presupuestoscli");
      var wherePedido: String;
      while (qryAgruparPresupuestos.next()) {
        codCliente = qryAgruparPresupuestos.value(0);
        wherePedido = where + " AND codcliente = '" + codCliente + "'";
        curPresupuesto.transaction(false);
        curPresupuesto.select(wherePedido);
        if (!curPresupuesto.first()) {
          curPresupuesto.rollback();
          util.destroyProgressDialog();
          return;
        }
        curPresupuesto.setValueBuffer("fecha", curAgruparPresupuestos.valueBuffer("fecha"));
        try {
          if (formpresupuestoscli.iface.pub_generarPedido(curPresupuesto, wherePedido))
            curPresupuesto.commit();
          else {
            curPresupuesto.rollback();
            util.destroyProgressDialog();
            return;
          }
        } catch (e) {
          curPresupuesto.rollback();
          util.destroyProgressDialog();
          MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del pedido:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        util.setProgress(++j);
      }
      util.setProgress(totalClientes);
      util.destroyProgressDialog();
    }
    f.close();
    this.iface.tdbRecords.refresh();
  }
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los presupuestos a agrupar
@param curAgrupar: Cursor de la tabla agruparpresupuestos que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function asoPresup_whereAgrupacion(curAgrupar: FLSqlCursor): String {
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

/** \C
Al borrar una pedido, sus presupuestos asociado será desbloqueado para permitir su edición
\end */
function asoPresup_recordDelBeforepedidoscli()
{
  var idPedido: String = this.cursor().valueBuffer("idpedido");
  if (!idPedido)
    return;

  var curPresupuestos: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curPresupuestos.select("idpedido = " + idPedido);
  while (curPresupuestos.next()) {
    var curPresupuesto: FLSqlCursor = new FLSqlCursor("presupuestoscli");
    with(curPresupuesto) {
      select("idpresupuesto = " + curPresupuestos.valueBuffer("idpresupuesto"));
      first();
      setUnLock("editable", true);
      select("idpresupuesto = " + curPresupuestos.valueBuffer("idpresupuesto"));
      first();
      setModeAccess(Edit);
      refreshBuffer();
      setValueBuffer("idpedido", 0);
      commitBuffer();
    }
  }
}

//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

