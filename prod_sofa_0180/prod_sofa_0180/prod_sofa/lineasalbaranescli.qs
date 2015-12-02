
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends prod
{
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function quitarModulo()
  {
    return this.ctx.sofa_quitarModulo();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.sofa_bufferChanged(fN);
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
function sofa_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'") == "MOD") {
    this.child("fdbCantidad").setDisabled(true);
    connect(this.child("tbnQuitarModulo"), "clicked()", this, "iface.quitarModulo");
  }

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      var codCliente: String = util.sqlSelect("albaranescli", "codcliente", "idalbaran = " + cursor.valueBuffer("idalbaran"));
      if (codCliente && codCliente != "") {
        var codTarifa: String = util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + codCliente + "'", "clientes,gruposclientes");
        if (codTarifa && codTarifa != "") {
          var valorPunto: Number = parseFloat(util.sqlSelect("tarifas", "valorpunto", "codtarifa = '" + codTarifa + "'"));
          if (!valorPunto)
            valorPunto = "";
          this.child("fdbValorPunto").setValue(valorPunto);
        }
      }
      break;
    }
  }
}

function sofa_quitarModulo()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'") == "MOD") {
    MessageBox.warning(util.translate("scripts", "Este botón solo puede usarse para quitar módulos del albarán"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  var codLote: String = this.child("tdbLotesStock").cursor().valueBuffer("codlote");
  if (!codLote) {
    return;
  }
  var res: Number = MessageBox.warning(util.translate("scripts", "Va a quitar el módulo %1 del albarán.\n¿Está seguro?").arg(codLote), MessageBox.No, MessageBox.Yes);
  if (res != MessageBox.Yes) {
    return;
  }

  var curMoviStock: FLSqlCursor = new FLSqlCursor("movistock");
  curMoviStock.select("idlineaac = " + cursor.valueBuffer("idlinea") + " AND codlote = '" + codLote + "'");
  if (!curMoviStock.first())
    return;

  curMoviStock.setModeAccess(curMoviStock.Edit);
  curMoviStock.refreshBuffer();
  curMoviStock.setValueBuffer("estado", "PTE");
  curMoviStock.setNull("fechareal");
  curMoviStock.setNull("idlineaac");
  if (!curMoviStock.commitBuffer())
    return;

  this.child("fdbCantidad").setValue(cursor.valueBuffer("cantidad") - 1);

  this.child("tdbMoviStock").refresh();
  this.child("tdbLotesStock").refresh();
}

function sofa_bufferChanged(fN: String)
{
  var util: FLUtil;
  switch (fN) {
    case "valorpunto":
    case "idserietela": {
      this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
