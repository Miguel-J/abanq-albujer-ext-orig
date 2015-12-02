
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class sofa extends prod
{
  var chkMetraje: Object;
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.sofa_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.sofa_calculateField(fN);
  }
  function chkMetraje_clicked()
  {
    return this.ctx.sofa_chkMetraje_clicked();
  }
  function habilitarMetraje()
  {
    return this.ctx.sofa_habilitarMetraje();
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
function sofa_init()
{
  this.iface.__init();

  this.iface.chkMetraje = this.child("chkMetraje");
  this.iface.chkMetraje.checked = false;
  this.iface.chkMetraje.setDisabled(true);

  this.iface.habilitarMetraje();
  connect(this.iface.chkMetraje, "clicked()", this, "iface.chkMetraje_clicked");
}

function sofa_chkMetraje_clicked()
{
  this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
}

function sofa_bufferChanged(fN: String)
{
  var util: FLUtil;
  switch (fN) {
    case "referencia": {
      this.iface.__bufferChanged(fN);
      this.iface.habilitarMetraje();
      this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
      break
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function sofa_calculateField(fN: String): String {
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "pvpunitario": {
      if (!this.iface.chkMetraje.checked) {
        var codProveedor: String = cursor.cursorRelation().valueBuffer("codproveedor");
        var codDivisa: String = cursor.cursorRelation().valueBuffer("coddivisa");
        valor = util.sqlSelect("articulosprov", "costepieza", "referencia = '" + cursor.valueBuffer("referencia") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
      } else {
        valor = this.iface.__calculateField(fN);
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

function sofa_habilitarMetraje()
{
  var util: FLUtil = new FLUtil();
  var referencia: String = this.cursor().valueBuffer("referencia");
  if (!referencia || referencia == "") {
    this.iface.chkMetraje.checked = false;
    this.iface.chkMetraje.setDisabled(true);
    return;
  }
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
  if (!codFamilia || codFamilia == "") {
    this.iface.chkMetraje.checked = false;
    this.iface.chkMetraje.setDisabled(true);
    return;
  }
  if (codFamilia == "TELA")
    this.iface.chkMetraje.setDisabled(false);
  else {
    this.iface.chkMetraje.checked = false;
    this.iface.chkMetraje.setDisabled(true);
  }
}

//// PRODSOFA ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
