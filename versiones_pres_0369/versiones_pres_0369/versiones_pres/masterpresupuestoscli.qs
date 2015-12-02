
/** @class_declaration versionesPres */
/////////////////////////////////////////////////////////////////
//// VERSIONES PRESUPUESTOS //////////////////////////////////////////////
class versionesPres extends oficial
{
  var curPresupuesto: FLSqlCursor;
  var pbnCopiarPresupuesto: Object;
  var pbnActivarVersion: Object;
  var chkOcultarInactivas: Object;
  var chkSoloPresupuesto: Object;
  var camposPres: Array;
  var camposLinPres: Array;

  function versionesPres(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.versionesPres_init();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.versionesPres_commonCalculateField(fN, cursor);
  }
  function generarPedido(curPresupuesto: FLSqlCursor, where: String): Number {
    return this.ctx.versionesPres_generarPedido(curPresupuesto, where);
  }
  function copiarPresupuesto_clicked()
  {
    return this.ctx.versionesPres_copiarPresupuesto_clicked();
  }
  function copiarPresupuesto(codigo: String): String {
    return this.ctx.versionesPres_copiarPresupuesto(codigo);
  }
  function datosPresupuesto(cursor: FLSqlCursor, codigo: String): Boolean {
    return this.ctx.versionesPres_datosPresupuesto(cursor, codigo);
  }
  function copiarLineasPresupuesto(codigoOri: String, idPresupuesto: Number): Boolean  {
    return this.ctx.versionesPres_copiarLineasPresupuesto(codigoOri, idPresupuesto);
  }
  function procesarEstado()
  {
    return this.ctx.versionesPres_procesarEstado();
  }
  function controlFiltro()
  {
    return this.ctx.versionesPres_controlFiltro();
  }
  function activarVersion()
  {
    return this.ctx.versionesPres_activarVersion();
  }
  function informarCamposPres()
  {
    return this.ctx.versionesPres_informarCamposPres();
  }
  function informarCamposLinPres()
  {
    return this.ctx.versionesPres_informarCamposLinPres();
  }
}
//// VERSIONES PRESUPUESTOS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition versionesPres */
//////////////////////////////////////////////////////////////////
//// VERSIONES PRESUPUESTOS /////////////////////////////////////////////////////

function versionesPres_init()
{
  this.iface.pbnCopiarPresupuesto = this.child("pbnCopiarPresupuesto");
  this.iface.pbnActivarVersion = this.child("pbnActivarVersion");
  this.iface.chkOcultarInactivas = this.child("chkOcultarInactivas");
  this.iface.chkSoloPresupuesto = this.child("chkSoloPresupuesto");
  this.iface.chkOcultarInactivas.checked = true;

  this.iface.__init();

  this.iface.curPresupuesto = this.cursor();
  connect(this.iface.pbnCopiarPresupuesto, "clicked()", this, "iface.copiarPresupuesto_clicked");
  connect(this.iface.pbnActivarVersion, "clicked()", this, "iface.activarVersion");
  connect(this.iface.chkOcultarInactivas, "clicked()", this, "iface.controlFiltro");
  connect(this.iface.chkSoloPresupuesto, "clicked()", this, "iface.controlFiltro");

  this.iface.informarCamposPres();
  this.iface.informarCamposLinPres();
  this.iface.controlFiltro();
}


function versionesPres_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  // El código se calcula sólo al insertar un nuevo presupuesto normal, para que no lo sobreescriba al editar una versión
  if (fN == "codigo" && cursor.table() == "presupuestoscli")
    if (cursor.modeAccess() == cursor.Insert)
    {
      valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));
      return valor;
    } else
      return;

  return this.iface.__commonCalculateField(fN, cursor);
}


/** \D Para cliente potencial
*/
function versionesPres_generarPedido(curPresupuesto: FLSqlCursor, where: String): Number {
  if (!curPresupuesto.valueBuffer("clientepot"))
    return this.iface.__generarPedido(curPresupuesto, where);

  var codigo: String =  curPresupuesto.valueBuffer("codclientepot");
  if (!codigo)
    return this.iface.__generarPedido(curPresupuesto, where);

  if (where)
  {
    MessageBox.warning(util.translate("scripts",  "No se pueden agrupar presupuestos de clientes potenciales"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var util: FLUtil = new FLUtil;
  var res: Object = MessageBox.information(util.translate("scripts",  "Este presupuesto está asociado a un cliente potencial\nA continuación se va a crear un cliente real a partir del cliente potencial\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);

  if (res != MessageBox.Yes)
    return false;

  var curTab: FLSqlCursor = new FLSqlCursor("clientespot");
  curTab.select("codigo = '" + codigo + "'");

  // Código no válido
  if (!curTab.first())
    MessageBox.information(util.translate("scripts",  "El código del cliente potencial del presupuesto no es válido"), MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);

  var codCliente: String = formclientespot.iface.pub_aprobarCliente(curTab);
  if (!codCliente)
    return false;

  return this.iface.__generarPedido(curPresupuesto, where);
}

function versionesPres_copiarPresupuesto_clicked()
{
  var util: FLUtil;

  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isValid())
    return;

  if (this.iface.chkOcultarInactivas.checked) {
    MessageBox.information(util.translate("scripts", "Para crear una nueva versión del presupuesto,\ndesmarca la opción \"Ocultar versiones inactivas\""), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var codigo: String = cursor.valueBuffer("codigo");
  var res = MessageBox.information(util.translate("scripts", "Se va a crear una nueva versión del presupuesto %0\n\n¿Continuar?").arg(codigo), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  cursor.transaction(false);

  if (!codigo) {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  try {
    codigoNuevo = this.iface.copiarPresupuesto(codigo);
    if (codigoNuevo)
      cursor.commit();
    else
      cursor.rollback();
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al copiar el presupuesto ") + codigo + ":\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  this.iface.tdbRecords.refresh();
  var res = MessageBox.information(util.translate("scripts", "Se creó el presupuesto ") + codigoNuevo, MessageBox.Ok, MessageBox.NoButton);

  return true;
}

function versionesPres_copiarPresupuesto(codigo: String): String {
  var util: FLUtil;

  var version: String = util.sqlSelect("presupuestoscli", "codigo", "codigo like '" + codigo.left(12) + "v%' order by codigo desc");
  if (version)   // Código tipo 20090A000123-03
  {
    version = version.toString().right(2);
    var numVersion: Number = parseFloat(version) + 1;
    if (numVersion < 10)
      version = "0" + numVersion.toString();
    else
      version = numVersion.toString();
  } else // Código tipo 20090A000123
    version = "02";

  var codigoNuevo: String = codigo.left(12) + "v" + version;

  var curNuevoPresupuesto: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curNuevoPresupuesto.setModeAccess(curNuevoPresupuesto.Insert);
  curNuevoPresupuesto.refreshBuffer();

  if (!this.iface.datosPresupuesto(curNuevoPresupuesto, codigoNuevo))
    return false;

  if (!curNuevoPresupuesto.commitBuffer())
    return false;

  if (!this.iface.copiarLineasPresupuesto(codigo, curNuevoPresupuesto.valueBuffer("idpresupuesto")))
    return false;

  if (!util.sqlUpdate("presupuestoscli", "versionactiva", "false", "codigo like '" + codigo.left(12) + "%' AND codigo <> '" + codigoNuevo + "'"))
    return false;

  return codigoNuevo;
}

function versionesPres_datosPresupuesto(cursor: FLSqlCursor, codigo: String): Boolean {
  var hoy: Date = new Date();

  cursor.setValueBuffer("codigo", codigo);
  cursor.setValueBuffer("editable", true);
  cursor.setValueBuffer("fecha", hoy);

  for (var i: Number = 0; i < this.iface.camposPres.length; i++)
    cursor.setValueBuffer(this.iface.camposPres[i] , this.iface.curPresupuesto.valueBuffer(this.iface.camposPres[i]));

  return true;
}

function versionesPres_copiarLineasPresupuesto(codigoOri: String, idPresupuestoDes: Number): Boolean {
  var util: FLUtil = new FLUtil;
  var curLineasOri: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
  var curLineasDes: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");

  var idPresupuestoOri: Number = util.sqlSelect("presupuestoscli", "idpresupuesto", "codigo = '" + codigoOri + "'");
  if (!idPresupuestoOri)
  {
    debug("No se encuentra el presupuesto origen " + codigoOri);
    return;
  }

  curLineasOri.select("idpresupuesto = " + idPresupuestoOri);
  while (curLineasOri.next())
  {

    /*    curLineasOri.copyRecord();
        curLineasOri.setModeAccess(curLineasOri.Edit);
        curLineasOri.refreshBuffer();
        curLineasOri.setValueBuffer("idpresupuesto", idPresupuestoDes);
        curLineasOri.commitBuffer();*/

    curLineasDes.setModeAccess(curLineasDes.Insert);
    curLineasDes.refreshBuffer();
    curLineasDes.setValueBuffer("idpresupuesto", idPresupuestoDes);
    for (var i: Number = 0; i < this.iface.camposLinPres.length; i++)
      curLineasDes.setValueBuffer(this.iface.camposLinPres[i], curLineasOri.valueBuffer(this.iface.camposLinPres[i]));
    curLineasDes.commitBuffer();
  }

  return true;
}

function versionesPres_procesarEstado()
{
  this.iface.__procesarEstado();

  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.valueBuffer("editable"))
    return;

  var util: FLUtil = new FLUtil;
  var yaAprobado: Boolean = false;
  var versionActiva: Boolean = false;

  // Hay un presupuesto de otra versión ya aprobado?
  if (util.sqlSelect("presupuestoscli", "codigo", "editable = false AND codigo like '" + cursor.valueBuffer("codigo").left(12) + "%'"))
    yaAprobado = true;

  if (cursor.valueBuffer("versionactiva"))
    versionActiva = true;

  if (!versionActiva && !yaAprobado)
    this.iface.pbnActivarVersion.setEnabled(true);
  else
    this.iface.pbnActivarVersion.setEnabled(false);

  if (!yaAprobado)
    this.iface.pbnCopiarPresupuesto.setEnabled(true);
  else
    this.iface.pbnCopiarPresupuesto.setEnabled(false);

  if (versionActiva && !yaAprobado)
    this.iface.pbnGPedido.setEnabled(true);
  else
    this.iface.pbnGPedido.setEnabled(false);

}

function versionesPres_activarVersion()
{
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.valueBuffer("editable"))
    return;

  var util: FLUtil = new FLUtil;
  var res = MessageBox.warning(util.translate("scripts", "Se va a activar el presupuesto %0\n\n¿Continuar?").arg(cursor.valueBuffer("codigo")), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  util.sqlUpdate("presupuestoscli", "versionactiva", false, "codigo like '" + cursor.valueBuffer("codigo").left(12) + "%'");
  util.sqlUpdate("presupuestoscli", "versionactiva", true, "codigo = '" + cursor.valueBuffer("codigo") + "'");

  this.iface.tdbRecords.refresh();
}


function versionesPres_controlFiltro()
{
  var cursor: FLSqlCursor = this.cursor();

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var filtro: String = "codejercicio = '" + codEjercicio + "'";

  if (this.iface.chkOcultarInactivas.checked)
    filtro += " AND versionactiva = true";

  if (this.iface.chkSoloPresupuesto.checked && cursor.isValid())
    filtro += " AND codigo like '" + cursor.valueBuffer("codigo").left(12) + "%'";

  this.iface.tdbRecords.cursor().setMainFilter(filtro);
  this.iface.tdbRecords.refresh();
}

function versionesPres_informarCamposPres()
{
  this.iface.camposPres = ["codcliente", "nombrecliente", "cifnif", "total", "observaciones", "fechasalida", "coddivisa", "codserie", "numero", "neto", "porcomision", "totaleuros", "totaliva", "totalirpf", "irpf", "totalrecargo", "codpago", "codalmacen", "codagente", "direccion", "codpostal", "ciudad", "provincia", "apartado", "codpais", "codejercicio", "tasaconv", "recfinanciero", "codoportunidad", "finoferta", "estado"];
}

function versionesPres_informarCamposLinPres()
{
  this.iface.camposLinPres = ["referencia", "descripcion", "pvpunitario", "cantidad", "pvpsindto", "pvptotal", "codimpuesto", "iva", "dtolineal", "dtopor", "recargo", "irpf"];
}
//// VERSIONES PRESUPUESTOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
