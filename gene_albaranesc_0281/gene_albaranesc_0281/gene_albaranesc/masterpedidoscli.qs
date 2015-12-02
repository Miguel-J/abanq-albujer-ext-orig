
/** @class_declaration geneAlbc */
/////////////////////////////////////////////////////////////////
//// GENE_ALBC //////////////////////////////////////////////////
class geneAlbc extends oficial
{
  var curPedido_: FLSqlCursor;
  function geneAlbc(context)
  {
    oficial(context);
  }
  function pbnGenerarAlbaran_clicked()
  {
    return this.ctx.geneAlbc_pbnGenerarAlbaran_clicked();
  }
  function generarAlbaranParcial(curPedido: FLSqlCursor): Number {
    return this.ctx.geneAlbc_generarAlbaranParcial(curPedido);
  }
  function copiaLineasParcial(idPedido: Number, idAlbaran: Number): Boolean {
    return this.ctx.geneAlbc_copiaLineasParcial(idPedido, idAlbaran);
  }
  function lineaParcialCopiable(curLineaPedido, idAlbaran)
  {
    return this.ctx.geneAlbc_lineaParcialCopiable(curLineaPedido, idAlbaran);
  }
  function dameCantidadLineaAlbaran(curLineaPedido)
  {
    return this.ctx.geneAlbc_dameCantidadLineaAlbaran(curLineaPedido);
  }
  function copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.geneAlbc_copiaLineaPedidoParcial(curLineaPedido, idAlbaran);
  }
  function pbnGenerarFactura_clicked()
  {
    return this.ctx.geneAlbc_pbnGenerarFactura_clicked();
  }
}
//// GENE_ALBC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubGeneAlbc */
/////////////////////////////////////////////////////////////////
//// PUB GENEALBC ///////////////////////////////////////////////
class pubGeneAlbc extends ifaceCtx
{
  function pubGeneAlbc(context)
  {
    ifaceCtx(context);
  }
  function pub_generarAlbaranParcial(curPedido: FLSqlCursor): Number {
    return this.generarAlbaranParcial(curPedido);
  }
}
//// PUB GENEALBC ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition geneAlbc */
/////////////////////////////////////////////////////////////////
//// GENE_ALBC //////////////////////////////////////////////////
function geneAlbc_pbnGenerarAlbaran_clicked()
{
  flfacturac.iface.geneFacturaCli = false;
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return;
  if (!cursor.valueBuffer("editable"))
    return;

  var idPedido: String = cursor.valueBuffer("idpedido");
  delete this.iface.curPedido_;
  this.iface.curPedido_ = new FLSqlCursor("pedidoscli");
  this.iface.curPedido_.select("idpedido = " + idPedido);
  if (!this.iface.curPedido_.first())
    return;

  this.iface.curPedido_.setAction("pedidoscliparciales");
  connect(this.iface.curPedido_, "bufferCommited()", this, "iface.procesarEstado");
  this.iface.curPedido_.editRecord();
}

/** \D Genera un albarán a partir de un pedido, y de los datos a incluir especificados para cada línea desde el formulario personalizado
@param  curPedido: Cursor posicionado en el pedido base
@return true si el albarán se genera correctamente, false en caso contrario
\end */
function geneAlbc_generarAlbaranParcial(curPedido: FLSqlCursor): Number {
  var where: String = "idpedido = " + curPedido.valueBuffer("idpedido");

  if (!this.iface.curAlbaran)
    this.iface.curAlbaran = new FLSqlCursor("albaranescli");

  this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Insert);
  this.iface.curAlbaran.refreshBuffer();

  if (!this.iface.datosAlbaran(curPedido, where))
    return false;

  if (!this.iface.curAlbaran.commitBuffer())
  {
    return false;
  }

  var idAlbaran: Number = this.iface.curAlbaran.valueBuffer("idalbaran");

  var qryPedidos: FLSqlQuery = new FLSqlQuery();
  qryPedidos.setTablesList("pedidoscli");
  qryPedidos.setSelect("idpedido");
  qryPedidos.setFrom("pedidoscli");
  qryPedidos.setWhere(where);

  if (!qryPedidos.exec())
    return false;

  var idPedido: String;
  while (qryPedidos.next())
  {
    idPedido = qryPedidos.value(0);
    if (!this.iface.copiaLineasParcial(idPedido, idAlbaran))
      return false;
  }

  this.iface.curAlbaran.select("idalbaran = " + idAlbaran);
  if (this.iface.curAlbaran.first())
  {
    this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Edit);
    this.iface.curAlbaran.refreshBuffer();

    if (!this.iface.totalesAlbaran())
      return false;

    if (this.iface.curAlbaran.commitBuffer() == false)
      return false;
  }
  return idAlbaran;
}

/** \D
Copia las líneas de un pedido como líneas de su albarán asociado, en base a lo establecido en el formulario de generación de albaranes personalizado
@param idPedido: Identificador del pedido
@param idAlbaran: Identificador del albarán
@return VERDADERO si no hay error. FALSE en otro caso.
\end */
function geneAlbc_copiaLineasParcial(idPedido: Number, idAlbaran: Number): Boolean {
  var _i = this.iface;
  var _fP = flfactppal.iface;

  var cantidad: Number;
  var totalEnAlbaran: Number;

  if (_fP.pub_extension("numeros_linea"))
  {
    _i.numLinea_ = 0;
  }

  var curLineaPedido: FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
  curLineaPedido.select("idpedido = " + idPedido);
  while (curLineaPedido.next())
  {
    curLineaPedido.setModeAccess(curLineaPedido.Edit);
    curLineaPedido.refreshBuffer();
    cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
    totalEnAlbaran = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
    if (_i.lineaParcialCopiable(curLineaPedido, idAlbaran)) {
      if (!_i.copiaLineaPedidoParcial(curLineaPedido, idAlbaran)) {
        return false;
      }
      curLineaPedido.setValueBuffer("totalenalbaran", cantidad + totalEnAlbaran);
      if (!curLineaPedido.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

function geneAlbc_lineaParcialCopiable(curLineaPedido, idAlbaran)
{
  var cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
  return (cantidad != 0)
}

       function geneAlbc_dameCantidadLineaAlbaran(curLineaPedido)
{
  var _i = this.iface;
  var oDatos = new Object;
  oDatos.cantidad = cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
  var comprobarStock = _i.comprobarStockEnAlbaranado(curLineaPedido, oDatos.cantidad);
  if (!comprobarStock["ok"]) {
    return false;
  }
  if (!comprobarStock["haystock"]) {
    oDatos.cantidad = comprobarStock["cantidad"];
  }
  return oDatos;
}

/** \D
Copia una líneas de un pedido en su albarán asociado, para albaranes generados con el formulario personalizado
@param curdPedido: Cursor posicionado en la línea de pedido a copiar
@param idAlbaran: Identificador del albarán
@return identificador de la línea de albarán creada si no hay error. FALSE en otro caso.
\end */
function geneAlbc_copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
  var _i = this.iface;
  var _fP = flfactppal.iface;
  //  var util:FLUtil = new FLUtil;

  /// Sí se puede, porque se puede albaranar parcial y cerrar a la vez, en la ventana de albaranes parciales
  //  if (curLineaPedido.valueBuffer("cerrada")) {
  //    MessageBox.warning(sys.translate("No se pueden servir líneas cerradas."), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }

  if (!_i.curLineaAlbaran)
    _i.curLineaAlbaran = new FLSqlCursor("lineasalbaranescli");

  var cantidad;
  if (_fP.pub_extension("numeros_serie"))
  {
    cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
    if (AQUtil.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'")) {
      for (var i = 0; i < cantidad; i++) {
        with(_i.curLineaAlbaran) {
          setModeAccess(Insert);
          refreshBuffer();
          setValueBuffer("idalbaran", idAlbaran);
        }

        if (!_i.datosLineaAlbaran(curLineaPedido))
          return false;

        if (!_i.curLineaAlbaran.commitBuffer())
          return false;
      }

      return _i.curLineaAlbaran.valueBuffer("idlinea");
    }
  }
  cantidad = parseFloat(curLineaPedido.valueBuffer("cantidad"));
  with(_i.curLineaAlbaran)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idalbaran", idAlbaran);
    setValueBuffer("cantidad", cantidad);
  }

  if (!_i.datosLineaAlbaran(curLineaPedido))
  {
    return false;
  }

  if (!_i.curLineaAlbaran.commitBuffer())
  {
    return false;
  }
  return _i.curLineaAlbaran.valueBuffer("idlinea");
}

function geneAlbc_pbnGenerarFactura_clicked()
{
  flfacturac.iface.geneFacturaCli = true;
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return;
  if (!cursor.valueBuffer("editable"))
    return;

  var idPedido: String = cursor.valueBuffer("idpedido");
  delete this.iface.curPedido_;
  this.iface.curPedido_ = new FLSqlCursor("pedidoscli");
  this.iface.curPedido_.select("idpedido = " + idPedido);
  if (!this.iface.curPedido_.first())
    return;

  this.iface.curPedido_.setAction("pedidoscliparciales");
  connect(this.iface.curPedido_, "bufferCommited()", this, "iface.procesarEstado");
  this.iface.curPedido_.editRecord();
  //  var _i = this.iface;
  //  var idAlbaran;
  //
  //  var curAlbaran = new FLSqlCursor("albaranescli");
  //  var curLineasPedido = new FLSqlCursor("lineaspedidoscli");
  //  var cursor = this.cursor();
  //  var where = "idpedido = " + cursor.valueBuffer("idpedido");
  //
  //  if (cursor.valueBuffer("editable") == false) {
  //    MessageBox.warning(sys.translate("El pedido ya está servido. Genere la factura desde la ventana de albaranes"), MessageBox.Ok, MessageBox.NoButton);
  //    _i.procesarEstado();
  //    return;
  //  }
  //  _i.pbnGAlbaran.setEnabled(false);
  //  _i.pbnGFactura.setEnabled(false);
  //
  //  cursor.transaction(false);
  //  try {
  //    // Establecemos el valor canalbaran para que no se generen albaranes sin líneas
  //    curLineasPedido.select(where);
  //    while(curLineasPedido.next()) {
  //      curLineasPedido.setModeAccess(curLineasPedido.Edit);
  //      curLineasPedido.refreshBuffer();
  //      curLineasPedido.setValueBuffer("canalbaran",parseFloat(curLineasPedido.valueBuffer("cantidad")) - parseFloat(curLineasPedido.valueBuffer("totalenalbaran")));
  //      if(!curLineasPedido.commitBuffer()) {
  //        cursor.rollback();
  //        return false;
  //      }
  //    }
  //
  //
  //    idAlbaran = _i.generarAlbaran(where, cursor);
  //    if (idAlbaran) {
  //      cursor.commit();
  //      cursor.transaction(false);
  //      where = "idalbaran = " + idAlbaran;
  //      curAlbaran.select(where);
  //      if (curAlbaran.first()) {
  //        if (formalbaranescli.iface.pub_generarFactura(where, curAlbaran))
  //          cursor.commit();
  //        else
  //          cursor.rollback();
  //      } else
  //        cursor.rollback();
  //    } else
  //      cursor.rollback();
  //  }
  //  catch (e) {
  //    cursor.rollback();
  //    MessageBox.critical(sys.translate("Hubo un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  //  }
  //
  //  _i.tdbRecords.refresh();
  //  _i.procesarEstado();
  //
  //  flfacturac.iface.geneFacturaCli = false;
}
//// GENE_ALBC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
