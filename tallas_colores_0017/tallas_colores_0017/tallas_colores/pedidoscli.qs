
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.tallasColores_init();
  }
  function generarLineasTC()
  {
    this.ctx.tallasColores_generarLineasTC();
  }
}
//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////

function tallasColores_init()
{
  this.iface.__init();

  //  inacabado
  //  connect(this.child("pbnGenerarLineasTC"), "clicked()", this, "iface.generarLineasTC");
}

function tallasColores_generarLineasTC()
{
  var util: FLUtil = new FLUtil();

  var formArticulos: Object = new FLFormSearchDB("articulos");
  var curArticulos: FLSqlCursor = formArticulos.cursor();

  formArticulos.setMainWidget();
  var referencia: String = formArticulos.exec("referencia");

  if (!referencia) return false;
  debug("REF " + referencia);

  var dialog: Dialog = new Dialog(referencia, 0, "");
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var q: FLSqlQuery = new FLSqlQuery();
  var i: Number = 0;

  // Tallas
  var chkTallas: Array;
  var gbxTallas: GroupBox = new GroupBox;
  gbxTallas.title = util.translate("scripts", "Tallas");
  dialog.add(gbxTallas);

  q.setTablesList("articulostallas");
  q.setFrom("articulostallas");
  q.setSelect("talla");
  q.setWhere("referencia = '" + referencia + "'");

  if (!q.exec()) return;
  i = 0;
  while (q.next()) {
    chkTallas[i] = new CheckBox;
    chkTallas[i].text = q.value(0);
    gbxTallas.add(chkTallas[i]);
    i++;
  }

  // Colores
  var chkColores: Array;
  var gbxColores: GroupBox = new GroupBox;
  gbxColores.title = util.translate("scripts", "Colores");
  dialog.add(gbxColores);

  q.setTablesList("articuloscolores");
  q.setFrom("articuloscolores");
  q.setSelect("color");
  q.setWhere("referencia = '" + referencia + "'");

  if (!q.exec()) return;
  i = 0;
  while (q.next()) {
    chkColores[i] = new CheckBox;
    chkColores[i].text = q.value(0);
    gbxColores.add(chkColores[i]);
    i++;
  }


  if (!dialog.exec())
    return true;

  return true;
}

//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
