
/** @class_declaration multiPed */
//////////////////////////////////////////////////////////////////
//// ALB_MULTI_PED ////////////////////////////////////////////////
class multiPed extends oficial
{
  var tbnAsociarLineasPedido: Object;
  function multiPed(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multiPed_init();
  }
  function abrirSeleccionPedidos()
  {
    return this.ctx.multiPed_abrirSeleccionPedidos();
  }
}
//// ALB_MULTI_PED ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition multiPed */
//////////////////////////////////////////////////////////////////
//// ALB_MULTI_PED ////////////////////////////////////////////////
function multiPed_init()
{
  this.iface.__init();

  this.iface.tbnAsociarLineasPedido = this.child("tbnAsociarLineasPedido");
  connect(this.iface.tbnAsociarLineasPedido, "clicked()", this, "iface.abrirSeleccionPedidos");
}

function multiPed_abrirSeleccionPedidos()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbLineasAlbaranesProv").cursor().commitBufferCursorRelation())
      return false;
  }

  var codProveedor: String = cursor.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
    return;

  var idAlbaran: Number = cursor.valueBuffer("idalbaran");
  if (!idAlbaran)
    return;

  var f: Object = new FLFormSearchDB("asociarlineaspedido");
  var curSelLineasPedido: FLSqlCursor = f.cursor();
  curSelLineasPedido.select();
  if (!curSelLineasPedido.first())
    curSelLineasPedido.setModeAccess(curSelLineasPedido.Insert);
  else
    curSelLineasPedido.setModeAccess(curSelLineasPedido.Edit);

  curSelLineasPedido.refreshBuffer();

  f.setMainWidget();
  curSelLineasPedido.setValueBuffer("referencia", "");
  curSelLineasPedido.setValueBuffer("codproveedor", codProveedor);
  curSelLineasPedido.setValueBuffer("idalbaran", idAlbaran);


  var curEmpresa: FLSqlCursor = new FLSqlCursor("empresa");
  curEmpresa.transaction(false);
  try {
    f.exec("id");
    if (f.accepted()) {
      curEmpresa.commit();
      this.iface.calcularTotales();
      this.child("tdbLineasAlbaranesProv").refresh();
    } else
      curEmpresa.rollback();
  } catch (e) {
    curEmpresa.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la asociación de líneas de pedido:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }
}
//// ALB_MULTI_PED ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
