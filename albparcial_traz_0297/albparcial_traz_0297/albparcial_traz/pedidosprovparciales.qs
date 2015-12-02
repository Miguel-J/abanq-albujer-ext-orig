
/** @class_declaration parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
class parcialLotes extends oficial
{
  var lotes: Array;
  function parcialLotes(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.parcialLotes_init();
  }
  function incluir(parcial: Boolean): Boolean {
    return this.ctx.parcialLotes_incluir(parcial);
  }
  function incluirTodos()
  {
    return this.ctx.parcialLotes_incluirTodos();
  }
  function crearMovimiento(codLote: String, cantidad: Number, idStock: Number): Number {
    return this.ctx.parcialLotes_crearMovimiento(codLote, cantidad, idStock);
  }
}
//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
function parcialLotes_init()
{
  this.iface.__init();

  var curLineas: FLSqlCursor = this.iface.tdbLineasPedidosProv.cursor();
  if (!curLineas.first())
    return;

  do {
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer();
    curLineas.setValueBuffer("lotesalbaran", "");
    if (!curLineas.commitBuffer())
      return false;
  } while (curLineas.next());

  this.iface.tdbLineasPedidosProv.refresh();
}

function parcialLotes_incluir(parcial: Boolean): Boolean {
  var util: FLUtil = new FLUtil;
  var curLinea: FLSqlCursor = this.iface.tdbLineasPedidosProv.cursor();
  if (!curLinea.isValid())
    return false;

  var idPedido: Number = parseFloat(curLinea.valueBuffer("idpedido"));
  var codAlmacen: String = util.sqlSelect("pedidosprov", "codalmacen", "idpedido = " + idPedido);
  var cantidad: Number = parseFloat(curLinea.valueBuffer("cantidad"));
  var servida: Number = parseFloat(curLinea.valueBuffer("totalenalbaran"));
  if (cantidad == servida)
  {
    MessageBox.warning(util.translate("scripts", "La línea seleccionada ya está servida"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var porLotes: Boolean = false;
  var referencia: String = curLinea.valueBuffer("referencia");
  if (!referencia || referencia == "")
    porLotes = false
    porLotes = util.sqlSelect("articulos", "porlotes", "referencia = '" + referencia + "'");

  var canAlbaran: Number;

  var idStock: Number = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen + "' AND referencia = '" + referencia + "'");
  if (!idStock)
  {
    var oArticulo = new Object();
    oArticulo.referencia = referencia;
    idStock = flfactalma.iface.pub_crearStock(codAlmacen, oArticulo);
    if (!idStock) {
      return false;
    }
  }

  var lotesAlbaran: String = curLinea.valueBuffer("lotesalbaran");
  if (!lotesAlbaran)
    lotesAlbaran == "";

  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  if (curLinea.valueBuffer("incluiralbaran"))
  {
    curLinea.setValueBuffer("incluiralbaran", false);
    curLinea.setValueBuffer("canalbaran", 0);
    curLinea.setValueBuffer("lotesalbaran", "");
  } else {
    if (porLotes)
    {
      var canLote: Number;
      var descArticulo: String = curLinea.valueBuffer("descripcion");
      var canTotal: Number = 0;
      var masLotes: Boolean = true;

      while ((canTotal < (cantidad - servida)) && masLotes) {
        var f: Object = new FLFormSearchDB("seleclote");
        var curLote: FLSqlCursor = f.cursor();
        curLote.select();
        if (!curLote.first())
          curLote.setModeAccess(curLote.Insert);
        else
          curLote.setModeAccess(curLote.Edit);

        f.setMainWidget();

        canLote = (cantidad - servida) - canTotal;

        curLote.refreshBuffer();
        curLote.setValueBuffer("referencia", referencia);
        curLote.setValueBuffer("descripcion", descArticulo);
        curLote.setValueBuffer("canlinea", (cantidad - servida));
        curLote.setValueBuffer("canlote", canLote);
        curLote.setValueBuffer("resto", canLote);

        var acpt: String = f.exec("id");
        if (acpt) {
          var nuevaCantidad: Number = parseFloat(curLote.valueBuffer("canlote"));
          var codLote: String = curLote.valueBuffer("codlote");
          canTotal += nuevaCantidad;
          var idMovimiento: Number = this.iface.crearMovimiento(codLote, nuevaCantidad, idStock);
          if (!idMovimiento)
            return false
            if (lotesAlbaran != "")
              lotesAlbaran += "|";
          lotesAlbaran += idMovimiento;
          //          lotesAlbaran += codLote + "/" + nuevaCantidad;
        } else
          masLotes = false;
        canAlbaran = canTotal;
      }
    } else {
      if (parcial)
      {
        canAlbaran = Input.getNumber(util.translate("scripts", "Indique la cantidad"), 1, 2, 0, cantidad - servida);
        if (!canAlbaran)
          return false;
      } else {
        canAlbaran = cantidad - servida;
      }
    }
    curLinea.setValueBuffer("incluiralbaran", true);
    curLinea.setValueBuffer("canalbaran", canAlbaran);
    curLinea.setValueBuffer("lotesalbaran", lotesAlbaran);
  }
  if (!curLinea.commitBuffer())
    return false;
  this.iface.tdbLineasPedidosProv.refresh();
}

function parcialLotes_incluirTodos()
{
  var util: FLUtil;
  var curLineas: FLSqlCursor = this.iface.tdbLineasPedidosProv.cursor();
  if (!curLineas.first())
    return;

  var cantidad: Number;
  var servida: Number;

  var idPedido: Number = curLineas.valueBuffer("idpedido");
  var incluir = false;
  if (util.sqlSelect("lineaspedidosprov", "idlinea", "idpedido = " + idPedido + " AND NOT incluiralbaran AND (totalenalbaran < cantidad)"))
    incluir = true;

  var codAlmacen: String = util.sqlSelect("pedidosprov", "codalmacen", "idpedido = " + idPedido);

  do {
    var porLotes: Boolean = false;
    var referencia: String = curLineas.valueBuffer("referencia");
    if (!referencia || referencia == "")
      porLotes = false
                 porLotes = util.sqlSelect("articulos", "porlotes", "referencia = '" + referencia + "'");
    cantidad = parseFloat(curLineas.valueBuffer("cantidad"));
    servida = parseFloat(curLineas.valueBuffer("totalenalbaran"));

    if (cantidad == servida)
      continue;

    var idStock: Number = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen + "' AND referencia = '" + referencia + "'");
    if (!idStock) {
      var oArticulo = new Object();
      oArticulo.referencia = referencia;
      idStock = flfactalma.iface.pub_crearStock(codAlmacen, oArticulo);
      if (!idStock) {
        return false;
      }
    }
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer();
    if (curLineas.valueBuffer("incluiralbaran") && incluir)
      continue;
    curLineas.setValueBuffer("incluiralbaran", incluir);
    if (incluir) {
      if (porLotes) {
        var lotesAlbaran: String = curLineas.valueBuffer("lotesalbaran");
        if (!lotesAlbaran)
          lotesAlbaran = "";
        var canLote: Number;
        var descArticulo: String = curLineas.valueBuffer("descripcion");
        var canTotal: Number = 0;
        var masLotes: Boolean = true;

        while ((canTotal < (cantidad - servida)) && masLotes) {
          var f: Object = new FLFormSearchDB("seleclote");
          var curLote: FLSqlCursor = f.cursor();
          curLote.select();
          if (!curLote.first())
            curLote.setModeAccess(curLote.Insert);
          else
            curLote.setModeAccess(curLote.Edit);

          f.setMainWidget();

          canLote = (cantidad - servida) - canTotal;

          curLote.refreshBuffer();
          curLote.setValueBuffer("referencia", referencia);
          curLote.setValueBuffer("descripcion", descArticulo);
          curLote.setValueBuffer("canlinea", (cantidad - servida));
          curLote.setValueBuffer("canlote", canLote);
          curLote.setValueBuffer("resto", canLote);

          var acpt: String = f.exec("id");
          if (acpt) {
            var nuevaCantidad: Number = parseFloat(curLote.valueBuffer("canlote"));
            var codLote: String = curLote.valueBuffer("codlote");
            canTotal += nuevaCantidad;
            var idMovimiento: Number = this.iface.crearMovimiento(codLote, nuevaCantidad, idStock);
            if (!idMovimiento)
              return false
                     if (lotesAlbaran != "")
                       lotesAlbaran += "|";
            lotesAlbaran += idMovimiento;
            //            lotesAlbaran += codLote + "/" + nuevaCantidad;
          } else
            masLotes = false;
        }
        curLineas.setValueBuffer("canalbaran", canTotal);
        curLineas.setValueBuffer("lotesalbaran", lotesAlbaran);
      } else
        curLineas.setValueBuffer("canalbaran", cantidad - servida);
    } else {
      curLineas.setValueBuffer("canalbaran", 0);
      curLineas.setValueBuffer("lotesalbaran", "");
    }
    if (!curLineas.commitBuffer())
      return false;

  } while (curLineas.next());

  this.iface.tdbLineasPedidosProv.refresh();
}

function parcialLotes_crearMovimiento(codLote: String, cantidad: Number, idStock: Number): Number {
  var util: FLUtil;

  if (cantidad < 0)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "Se va a generar un movimiento con cantidad negativa para un documento de Entrada.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
  }

  var fecha: Date = new Date();
  var curMoviLote: FLSqlCursor = new FLSqlCursor("movilote");
  curMoviLote.setModeAccess(curMoviLote.Insert);
  curMoviLote.refreshBuffer();
  curMoviLote.setValueBuffer("codlote", codLote);
  curMoviLote.setValueBuffer("fecha", fecha);
  curMoviLote.setValueBuffer("tipo", "Entrada");
  curMoviLote.setValueBuffer("docorigen", "AP");
  curMoviLote.setValueBuffer("idstock", idStock);
  curMoviLote.setValueBuffer("cantidad", cantidad);
  if (!curMoviLote.commitBuffer())
    return false;

  return curMoviLote.valueBuffer("id");
}
//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
