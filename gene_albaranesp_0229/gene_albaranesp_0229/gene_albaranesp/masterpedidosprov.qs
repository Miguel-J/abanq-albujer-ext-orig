
/** @class_declaration geneAlbp */
/////////////////////////////////////////////////////////////////
//// GENE_ALBP //////////////////////////////////////////////////
class geneAlbp extends oficial
{
  var curPedidoAP_;
  function geneAlbp(context)
  {
    oficial(context);
  }
  function pbnGenerarAlbaran_clicked()
  {
    return this.ctx.geneAlbp_pbnGenerarAlbaran_clicked();
  }
  function refrescaPedidos()
  {
    return this.ctx.geneAlbp_refrescaPedidos();
  }
  function pbnGenerarFactura_clicked()
  {
    return this.ctx.geneAlbp_pbnGenerarFactura_clicked();
  }
  function generarAlbaranParcial(curPedido: FLSqlCursor): Number {
    return this.ctx.geneAlbp_generarAlbaranParcial(curPedido);
  }
  function copiaLineasParcial(idPedido: Number, idAlbaran: Number): Boolean {
    return this.ctx.geneAlbp_copiaLineasParcial(idPedido, idAlbaran);
  }
  function ordenCopiaLineasParcial()
  {
    return this.ctx.geneAlbp_ordenCopiaLineasParcial();
  }
  function datosLineaParcial(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.geneAlbp_datosLineaParcial(curLineaPedido);
  }
  function copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.geneAlbp_copiaLineaPedidoParcial(curLineaPedido, idAlbaran);
  }
}
//// GENE_ALBP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubGeneAlbp */
/////////////////////////////////////////////////////////////////
//// PUB GENEALBP ///////////////////////////////////////////////
class pubGeneAlbp extends ifaceCtx
{
  function pubGeneAlbp(context)
  {
    ifaceCtx(context);
  }
  function pub_generarAlbaranParcial(curPedido: FLSqlCursor): Number {
    return this.generarAlbaranParcial(curPedido);
  }
}
//// PUB GENEALBP ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition geneAlbp */
/////////////////////////////////////////////////////////////////
//// GENE_ALBP //////////////////////////////////////////////////
function geneAlbp_pbnGenerarAlbaran_clicked()
{
  var _i = this.iface;
  flfacturac.iface.geneFacturaProv = false;
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return;
  if (!cursor.valueBuffer("editable"))
    return;

  var idPedido: String = cursor.valueBuffer("idpedido");
  if (!_i.curPedidoAP_) {
    _i.curPedidoAP_ = new FLSqlCursor("pedidosprov");
  }

  _i.curPedidoAP_.select("idpedido = " + idPedido);
  if (!_i.curPedidoAP_.first())
    return;
  _i.curPedidoAP_.setAction("pedidosprovparciales");
  disconnect(_i.curPedidoAP_, "bufferCommited()", _i, "refrescaPedidos");
  connect(_i.curPedidoAP_, "bufferCommited()", _i, "refrescaPedidos");
  _i.curPedidoAP_.editRecord();
}

function geneAlbp_refrescaPedidos()
{
  var _i = this.iface;
  if (_i.tdbRecords) {
    _i.tdbRecords.refresh();
  }
}

/** \D Genera un albarán a partir de un pedido, y de los datos a incluir especificados para cada línea desde el formulario personalizado
@param  curPedido: Cursor posicionado en el pedido base
@return true si el albarán se genera correctamente, false en caso contrario
\end */
function geneAlbp_generarAlbaranParcial(curPedido: FLSqlCursor): Number {
  var where: String = "idpedido = " + curPedido.valueBuffer("idpedido");

  if (!this.iface.curAlbaran)
    this.iface.curAlbaran = new FLSqlCursor("albaranesprov");

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
  qryPedidos.setTablesList("pedidosprov");
  qryPedidos.setSelect("idpedido");
  qryPedidos.setFrom("pedidosprov");
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
function geneAlbp_ordenCopiaLineasParcial()
{
  return " ORDER BY idlinea";
}

function geneAlbp_copiaLineasParcial(idPedido: Number, idAlbaran: Number): Boolean {
  var _i = this.iface;
  var cantidad: Number;
  var totalEnAlbaran: Number;
  var curLineaPedido: FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
  curLineaPedido.select("idpedido = " + idPedido + _i.ordenCopiaLineasParcial());
  while (curLineaPedido.next())
  {
    curLineaPedido.setModeAccess(curLineaPedido.Edit);
    curLineaPedido.refreshBuffer();
    cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
    totalEnAlbaran = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
    if (cantidad > 0) {
      if (!this.iface.copiaLineaPedidoParcial(curLineaPedido, idAlbaran)) {
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

/** \D
Copia una líneas de un pedido en su albarán asociado, para albaranes generados con el formulario personalizado
@param curdPedido: Cursor posicionado en la línea de pedido a copiar
@param idAlbaran: Identificador del albarán
@return identificador de la línea de albarán creada si no hay error. FALSE en otro caso.
\end */
function geneAlbp_copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
  var _i = this.iface;
  var _fP = flfactppal.iface;

  if (curLineaPedido.valueBuffer("cerrada"))
  {
    MessageBox.warning(sys.translate("No se pueden servir líneas cerradas."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!_i.curLineaAlbaran)
    _i.curLineaAlbaran = new FLSqlCursor("lineasalbaranesprov");

  var cantidad;
  //  var cantidadServida = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));

  if (_fP.pub_extension("numeros_serie"))
  {
    if (AQUtil.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'")) {
      cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
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

  cantidad = parseFloat(curLineaPedido.valueBuffer("canalbaran"));

  with(_i.curLineaAlbaran)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idalbaran", idAlbaran);
    setValueBuffer("cantidad", cantidad);
  }

  //  if(!this.iface.datosLineaParcial(curLineaPedido))
  //    return false;
  if (!_i.datosLineaAlbaran(curLineaPedido))
    return false;

  if (!_i.curLineaAlbaran.commitBuffer())
    return false;

  return _i.curLineaAlbaran.valueBuffer("idlinea");
}

function geneAlbp_datosLineaParcial(curLineaPedido: FLSqlCursor): Boolean {
  var util: FLUtil;

  var cantidad: Number = parseFloat(curLineaPedido.valueBuffer("canalbaran"));
  var pvpSinDto: Number = parseFloat(curLineaPedido.valueBuffer("pvpsindto")) * cantidad / parseFloat(curLineaPedido.valueBuffer("cantidad"));
  pvpSinDto = util.roundFieldValue(pvpSinDto, "lineasalbaranesprov", "pvpsindto");

  with(this.iface.curLineaAlbaran)
  {
    setValueBuffer("idlineapedido", curLineaPedido.valueBuffer("idlinea"));
    setValueBuffer("idpedido", curLineaPedido.valueBuffer("idpedido"));
    setValueBuffer("referencia", curLineaPedido.valueBuffer("referencia"));
    setValueBuffer("descripcion", curLineaPedido.valueBuffer("descripcion"));
    setValueBuffer("pvpunitario", curLineaPedido.valueBuffer("pvpunitario"));
    setValueBuffer("cantidad", cantidad);
    setValueBuffer("codimpuesto", curLineaPedido.valueBuffer("codimpuesto"));
    setValueBuffer("iva", curLineaPedido.valueBuffer("iva"));
    setValueBuffer("recargo", curLineaPedido.valueBuffer("recargo"));
    setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
    setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
  }

  this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", pvpSinDto);
  this.iface.curLineaAlbaran.setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaAlbaran));

  return true;
}

function geneAlbp_pbnGenerarFactura_clicked()
{
  flfacturac.iface.geneFacturaProv = true;
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return;
  if (!cursor.valueBuffer("editable"))
    return;

  var idPedido: String = cursor.valueBuffer("idpedido");
  var curPedido: FLSqlCursor = new FLSqlCursor("pedidosprov");

  curPedido.select("idpedido = " + idPedido);
  if (!curPedido.first())
    return;
  curPedido.setAction("pedidosprovparciales");
  curPedido.editRecord();
  //  var idAlbaran:Number;
  //  var idFactura:Number;
  //  var util:FLUtil = new FLUtil;
  //  var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
  //  var cursor:FLSqlCursor = this.cursor();
  //  var where:String = "idpedido = " + cursor.valueBuffer("idpedido");
  //
  //  if (cursor.valueBuffer("editable") == false) {
  //    MessageBox.warning(util.translate("scripts", "El pedido ya está servido. Genere la factura desde la ventana de albaranes"), MessageBox.Ok, MessageBox.NoButton);
  //    this.iface.procesarEstado();
  //    return;
  //  }
  //  this.iface.pbnGAlbaran.setEnabled(false);
  //  this.iface.pbnGFactura.setEnabled(false);
  //
  //  cursor.transaction(false);
  //  try {
  //    idAlbaran = this.iface.generarAlbaran(where, cursor);
  //    if (idAlbaran) {
  //      where = "idalbaran = " + idAlbaran;
  //      curAlbaran.select(where);
  //      if (curAlbaran.first()) {
  //        cursor.commit();
  //        cursor.transaction(false);
  //        idFactura = formalbaranesprov.iface.pub_generarFactura(where, curAlbaran);
  //        if (idFactura) {
  //          cursor.commit();
  //        } else
  //          cursor.rollback();
  //      } else
  //        cursor.rollback();
  //    } else
  //      cursor.rollback();
  //     }
  //  catch (e) {
  //    cursor.rollback();
  //    MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  //  }
  //
  //  this.iface.tdbRecords.refresh();
  //  this.iface.procesarEstado();
}
//// GENE_ALBP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
