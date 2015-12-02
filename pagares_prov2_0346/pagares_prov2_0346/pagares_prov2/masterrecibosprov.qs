
/** @class_declaration pagaresProv2 */
/////////////////////////////////////////////////////////////////
//// PAGARES PROV 2 ///////////////////////////////////////////////
class pagaresProv2 extends proveed
{
  var tdbRecords: Object;
  function pagaresProv2(context)
  {
    proveed(context);
  }
  function init()
  {
    this.ctx.pagaresProv2_init();
  }
  function imprimir()
  {
    return this.ctx.pagaresProv2_imprimir();
  }
  function asociarAPagare()
  {
    return this.ctx.pagaresProv2_asociarAPagare();
  }
  function whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.ctx.pagaresProv2_whereAgrupacion(curAgrupar);
  }
  function pub_whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.ctx.pagaresProv2_whereAgrupacion(curAgrupar);
  }
  function generarPagares(codPago: String, where: String, fecha: String): Boolean {
    return this.ctx.pagaresProv2_generarPagares(codPago, where, fecha);
  }
  function datosPagare(curFactura: FLSqlCursor, where: String): Boolean {
    return this.ctx.pagaresProv2_datosPagare(curFactura, where);
  }
  function borrarPagare(): Boolean {
    return this.ctx.pagaresProv2_borrarPagare();
  }
  function tienenPagos(idFactura: Number): String {
    return this.ctx.pagaresProv2_tienenPagos(idFactura);
  }
  function pagaresRelacionados(idFactura: Number, idPagare: Number): String {
    return this.ctx.pagaresProv2_pagaresRelacionados(idFactura, idPagare)
  }
  function idPagaresRelacionados(idFactura: Number): String {
    return this.ctx.pagaresProv2_idPagaresRelacionados(idFactura)
  }
  function borrarRecibos(whereFactura: String): Boolean {
    return this.ctx.pagaresProv2_borrarRecibos(whereFactura);
  }
  function liberarFactura(idFactura: Number)
  {
    return this.ctx.pagaresProv2_liberarFactura(idFactura);
  }
}
//// PAGARES PROV 2 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresProv2 */
/////////////////////////////////////////////////////////////////
//// PAGARES PROV 2 ////////////////////////////////////////////////////

function pagaresProv2_init()
{
  this.iface.tdbRecords = this.child("tableDBRecords");
  connect(this.child("pbnAsociarAPagare"), "clicked()", this, "iface.asociarAPagare");
  connect(this.child("pbnBorrarPagare"), "clicked()", this, "iface.borrarPagare");

  this.iface.__init();
}

/** \C
Al pulsar el botón de asociar a pagaré se abre la ventana de agrupar facturas de proveedor
\end */
function pagaresProv2_asociarAPagare()
{
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("agruparfacturasprov");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;
  var codProveedor: String;

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt: String = f.exec("id");
  if (acpt) {
    cursor.commitBuffer();
    var curAgruparFacturas: FLSqlCursor = new FLSqlCursor("agruparfacturasprov");
    curAgruparFacturas.select();

    if (curAgruparFacturas.first()) {

      where = "idfactura IN (" + curAgruparFacturas.valueBuffer("lista") + ")";

      var fechaPagare: String = curAgruparFacturas.valueBuffer("fecha");
      var codPago: String = curAgruparFacturas.valueBuffer("codpago");

      if (!this.iface.generarPagares(codPago, where, fechaPagare))
        return;
    }

    f.close();
    this.iface.tdbRecords.refresh();
  }
}

/** \D
Genera el pagaré asociado a una o más facturas
@param where: Sentencia where para la consulta de búsqueda de los facturas a agrupar
@return Identificador del pagaré creado, False: si hay error
\end */
function pagaresProv2_generarPagares(codPago: String, where: String, fecha: String): Boolean {
  var util: FLUtil = new FLUtil();
  var totalFacturas: Number = util.sqlSelect("facturasprov", "count(idfactura)", where + " AND (idpagare IS NULL OR idpagare = 0)");
  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Generando pagarés..."), totalFacturas);
  util.setProgress(paso);


  var curPagare: FLSqlCursor = new FLSqlCursor("recibosprov");
  curPagare.setModeAccess(curPagare.Insert);
  curPagare.refreshBuffer();

  var idPagare: Number = curPagare.valueBuffer("idrecibo");
  var idLastFactura: String;

  // Recorrido por todas las facturas para sumar el total del pagaré y actualizarlas
  // Al final nos quedamos con el código más bajo
  var total: Number = 0;
  var curFacturas: FLSqlCursor = new FLSqlCursor("facturasprov");
  curFacturas.select(where + " AND (idpagare IS NULL OR idpagare = 0) ORDER BY codigo DESC");
  while (curFacturas.next())
  {
    total += curFacturas.valueBuffer("total");
    debug(total);
    curFacturas.setModeAccess(curFacturas.Edit);
    curFacturas.refreshBuffer();
    curFacturas.setValueBuffer("idpagare",  idPagare);
    curFacturas.setValueBuffer("editable",  false);

    idLastFactura = curFacturas.valueBuffer("idfactura");

    if (!curFacturas.commitBuffer()) {
      debug("Problema al modificar el idpagare de la factura " + curFacturas.valueBuffer("codigo"));
      return false;
    }

    util.setProgress(paso++);
  }

  this.iface.borrarRecibos(where);

  var numPlazo: Number = 1;
  var idPagarePpal: Number;
  var numero: Number;
  var curPlazos: FLSqlCursor = new FLSqlCursor("plazos");
  curPlazos.select("codpago = '" + codPago + "' ORDER BY dias");
  while (curPlazos.next())
  {
    importeRecibo = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
    diasAplazado = curPlazos.valueBuffer("dias");

    // Datos del pagaré tomados de la primera factura
    curFacturas.select("idfactura = " + idLastFactura);
    if (curFacturas.first()) {

      // Para el cálculo del vencimiento
      curFacturas.setValueBuffer("fecha", fecha);
      var fechaVto: String = flfactteso.iface.calcFechaVencimientoProv(curFacturas, numPlazo, diasAplazado);

      util.setLabelText("Generando pagaré " + numPlazo);

      // El mismo para todos los pagarés generados
      if (numPlazo++ == 1) {
        idPagarePpal = curPagare.valueBuffer("idrecibo");
      } else {
        curPagare.setModeAccess(curPagare.Insert);
        curPagare.refreshBuffer();
      }

      curPagare.setValueBuffer("importe", importeRecibo);
      curPagare.setValueBuffer("espagare", true);
      curPagare.setValueBuffer("importeeuros", importeRecibo);
      curPagare.setValueBuffer("fecha", fecha);
      curPagare.setValueBuffer("fechav", fechaVto);

      numero = flfacturac.iface.pub_cerosIzquierda(numPlazo - 1, 2)
               curPagare.setValueBuffer("codigo", curFacturas.valueBuffer("codigo") + "-PG" + numero);
      curPagare.setValueBuffer("estado", "Emitido"); //*
      curPagare.setValueBuffer("idremesa", 0); //*
      curPagare.setValueBuffer("numero", numPlazo); //*
      curPagare.setValueBuffer("idfactura", curFacturas.valueBuffer("idfactura")); //*
      curPagare.setValueBuffer("codproveedor", curFacturas.valueBuffer("codproveedor"));
      curPagare.setValueBuffer("nombreproveedor", curFacturas.valueBuffer("nombre"));
      curPagare.setValueBuffer("cifnif", curFacturas.valueBuffer("cifnif"));
      curPagare.setValueBuffer("coddivisa", curFacturas.valueBuffer("coddivisa"));
      curPagare.setValueBuffer("codserie", curFacturas.valueBuffer("codserie"));
      curPagare.setValueBuffer("idpagareppal", idPagarePpal);
    } else
      return false;

    if (!curPagare.commitBuffer()) {
      debug("ESS");
      return false;
    }
  }

  util.destroyProgressDialog();

  return idPagare;
}

/** \D Borra un recibo sólo en caso de que sea pagaré y no tenga pagos/devoluciones y
actualiza las facturas de proveedor incluidas en el pagare
*/
function pagaresProv2_borrarPagare()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isValid())
    return;

  if (!cursor.valueBuffer("espagare")) {
    MessageBox.information(util.translate("scripts", "Sólo es posible eliminar los pagarés, no los recibos normales"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idFactura: Number = cursor.valueBuffer("idfactura");
  debug(idFactura);
  var idPagare: Number = this.iface.idPagaresRelacionados(idFactura);

  var pagaresConPagos: String = this.iface.tienenPagos(idFactura);
  if (pagaresConPagos != "") {
    MessageBox.information(util.translate("scripts", "Este pagaré no puede eliminarse porque existen pagos/devoluciones para estos pagarés:\n%0").arg(pagaresConPagos), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var pagaresRelacionados: String = this.iface.pagaresRelacionados(idFactura, cursor.valueBuffer("idrecibo"));
  var msg: String = util.translate("scripts", "¿Seguro que desea eliminar el pagaré?");
  if (pagaresRelacionados != "") msg += util.translate("scripts", "\nSe eliminarán también los pagarés que fueron generados con éste:\n%0").arg(pagaresRelacionados);
  var res: Number = MessageBox.warning(msg, MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return false;


  var totalFacturas: Number = util.sqlSelect("facturasprov", "count(idfactura)", "idpagare = " + idPagare);
  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Eliminando pagarés..."), totalFacturas);
  util.setProgress(paso);

  var curPagares: FLSqlCursor = new FLSqlCursor("recibosprov");
  curPagares.select("idfactura = " + idFactura);
  while (curPagares.next()) {
    curPagares.setModeAccess(curPagares.Del);
    curPagares.refreshBuffer();
    if (!curPagares.commitBuffer()) {
      debug("Error al intentar eliminar el pagaré " + curPagares.valueBuffer("codigo"));
      return false;
    }
  }

  // Actualizar el idpagare de las facturas a 0
  var curFacturas: FLSqlCursor = new FLSqlCursor("facturasprov");
  curFacturas.select("idpagare = " + idPagare);
  while (curFacturas.next()) {
    if (idPagare)
      this.iface.liberarFactura(curFacturas.valueBuffer("idfactura"));
  }

  util.setLabelText(util.translate("scripts", "Regenerando recibos..."));
  if (idPagare) {
    curFacturas.select("idpagare = " + idPagare);
    while (curFacturas.next()) {
      curFacturas.setModeAccess(curFacturas.Edit);
      curFacturas.refreshBuffer();
      curFacturas.setValueBuffer("idpagare", 0);
      curFacturas.commitBuffer();
      util.setProgress(paso++);
    }
  }

  util.destroyProgressDialog();
  this.iface.tdbRecords.refresh();
}

/** \D Borra los recibos asociados a las facturas que engloba el pagaré.
*/
function pagaresProv2_borrarRecibos(whereFactura: String): Boolean {
  var curRecibos: FLSqlCursor = new FLSqlCursor("recibosprov");
  var idFactura: Number;

  var curFacturas: FLSqlCursor = new FLSqlCursor("facturasprov");
  curFacturas.select(whereFactura);

  while (curFacturas.next())
  {
    idFactura = curFacturas.valueBuffer("idfactura");

    curRecibos.select("idfactura = " + idFactura + " AND espagare = false");
    while (curRecibos.next()) {
      curRecibos.setModeAccess(curRecibos.Del);
      curRecibos.refreshBuffer();
      if (!curRecibos.commitBuffer()) return false;
    }
  }
}

/** \D Comprueba si un pagaré u otro generado por la misma agrupación,
en caso de pago de varios plazos, tienen pagos asociados
@return Cadena con los códigos de pagarés que tienen pagos
*/
function pagaresProv2_tienenPagos(idFactura: Number): String {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("recibosprov,pagosdevolprov");
  q.setFrom("recibosprov INNER JOIN pagosdevolprov ON recibosprov.idrecibo = pagosdevolprov.idrecibo");
  q.setSelect("DISTINCT recibosprov.codigo");
  q.setWhere("recibosprov.idfactura = " + idFactura);

  if (!q.exec())
  {
    debug("Error al buscar pagos de pagarés relacionados con la factura " + idFactura);
    return false;
  }

  var result: String = "";

  while (q.next())
    result += "\n" + q.value(0);

  return result;
}

/** \D Devuelve la lista de pagarés generado por la misma agrupación
@return Cadena con los códigos de pagarés que tienen pagos
*/
function pagaresProv2_pagaresRelacionados(idFactura: Number, idPagare: Number): String {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("recibosprov");
  q.setFrom("recibosprov");
  q.setSelect("codigo");
  q.setWhere("idfactura = " + idFactura + " AND idrecibo <> " + idPagare);

  if (!q.exec())
  {
    debug("Error al buscar pagos de pagarés relacionados el pagaré = " + idPagare);
    return false;
  }

  var result: String = "";

  while (q.next())
    result += "\n" + q.value(0);

  return result;
}

/** \D Devuelve el idpagare de las facturas cuando se va a eliminar un pagaré.
En caso de el pagaré forme parte de un conjunto (pago a plazos) todas las facturas
tienen el idpagare del primer pagaré, que puede no ser el que estamos tratando de
eliminar
*/
function pagaresProv2_idPagaresRelacionados(idFactura: Number): Number {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("facturasprov");
  q.setFrom("facturasprov");
  q.setSelect("idpagare");
  q.setWhere("idfactura = " + idFactura);

  if (!q.exec())
  {
    debug("Error al buscar idpagare de pagarés relacionados con la factura = " + idFactura);
    return false;
  }
  if (!q.first())
  {
    debug("No se encontró el idpagare de pagarés relacionados con la factura = " + idFactura);
    return false;
  }
  return q.value(0);
}

/** \D Desbloquea la factura tras eliminar un pagaré
*/
function pagaresProv2_liberarFactura(idFactura: Number)
{
  var curFactura: FLSqlCursor = new FLSqlCursor("facturasprov");
  with(curFactura) {
    select("idfactura = " + idFactura);
    first();
    setUnLock("editable", true);
    setModeAccess(Edit);
    refreshBuffer();
    if (!commitBuffer()) {
      debug("Error al intentar liberar la factura " + valueBuffer("codigo"));
      return false;
    }
  }
}

/** \D Genera la cláusula where en la consulta para agregar
facturas en función a los parámetros de filtrado del formulario
\end */
function pagaresProv2_whereAgrupacion(curAgrupar: FLSqlCursor): String {
  var codProveedor: String = curAgrupar.valueBuffer("codproveedor");
  var codDivisa: String = curAgrupar.valueBuffer("coddivisa");
  var codSerie: String = curAgrupar.valueBuffer("codserie");
  var codEjercicio: String = curAgrupar.valueBuffer("codejercicio");
  var fechaDesde: String = curAgrupar.valueBuffer("fechadesde");
  var fechaHasta: String = curAgrupar.valueBuffer("fechahasta");
  var where: String = "1=1";
  if (codProveedor && !codProveedor.isEmpty())
    where += " AND codproveedor = '" + codProveedor + "'";
  where = where + " AND fecha >= '" + fechaDesde + "'";
  where = where + " AND fecha <= '" + fechaHasta + "'";
  if (codDivisa && !codDivisa.isEmpty())
    where = where + " AND coddivisa = '" + codDivisa + "'";
  if (codSerie && !codSerie.isEmpty())
    where = where + " AND codserie = '" + codSerie + "'";

  return where;
}

/** \D Imprime con el formato de pagaré cuando es necesario
*/
function pagaresProv2_imprimir()
{
  if (flfacturac.isLoadedModule("flfactinfo")) {
    if (!this.cursor().isValid())
      return;

    var codigo: String = this.cursor().valueBuffer("codigo");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_recibosprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_recibosprov_codigo", codigo);
    curImprimir.setValueBuffer("h_recibosprov_codigo", codigo);

    if (this.cursor().valueBuffer("espagare"))
      flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pagaresprov", "", "", "", "", "", "i_recibosprov");
    else
      flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_recibosprov");

  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// PAGARES PROV 2 ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
