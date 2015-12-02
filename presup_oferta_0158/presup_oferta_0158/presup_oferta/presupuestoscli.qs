
/** @class_declaration presOferta */
/////////////////////////////////////////////////////////////////
//// PRES_OFERTA //////////////////////////////////////////////
class presOferta extends oficial
{
  function presOferta(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.presOferta_init();
  }
  function actualizarLista()
  {
    return this.ctx.presOferta_actualizarLista();
  }
  function mostrarInformacion()
  {
    return this.ctx.presOferta_mostrarInformacion();
  }
}
//// PRES_OFERTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition presOferta */
/////////////////////////////////////////////////////////////////
//// PRES_OFERTA //////////////////////////////////////////////

function presOferta_init()
{
  this.iface.__init();
  connect(this.child("toolButtonLista"), "clicked()", this, "iface.actualizarLista");
  connect(this.child("toolButtonInfo"), "clicked()", this, "iface.mostrarInformacion");
}

function presOferta_actualizarLista()
{
  var codPlantilla = this.cursor().valueBuffer("codplantilla");
  if (!codPlantilla)
    return;

  var util: FLUtil = new FLUtil();
  var res = MessageBox.information(util.translate("scripts", "Se va a regenerar la lista de parámetros\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return false;

  var idPresupuesto = this.cursor().valueBuffer("idpresupuesto");

  if (this.cursor().modeAccess() == this.cursor().Insert) {
    var curES: FLSqlCursor = this.child("tdbParamPresupuesto").cursor();
    curES.setModeAccess(curES.Insert);
    if (!curES.commitBufferCursorRelation())
      return;
  }

  // borrar la tabla
  util.sqlDelete("parampresupuesto", "idpresupuesto = " + idPresupuesto);

  var curParam: FLSqlCursor = new FLSqlCursor("parampresupuesto");

  var curTab: FLSqlCursor = new FLSqlCursor("paraminforme");
  curTab.select("codplantilla = '" + codPlantilla + "'");
  while (curTab.next()) {
    curParam.setModeAccess(curParam.Insert);
    curParam.refreshBuffer();
    curParam.setValueBuffer("idpresupuesto", idPresupuesto);
    curParam.setValueBuffer("codparametro", curTab.valueBuffer("codigo"));
    curParam.commitBuffer();
  }

  this.child("tdbParamPresupuesto").refresh();
}

function presOferta_mostrarInformacion()
{
  var util: FLUtil = new FLUtil();
  var i: Number;
  var mensaje: String = formpresupuestoscli.iface.pub_mensajeOtrosDatos();
  MessageBox.information(util.translate("scripts", "%1").arg(mensaje), MessageBox.Ok, MessageBox.NoButton);
}
//// PRES_OFERTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
