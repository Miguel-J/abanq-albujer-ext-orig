
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends formacion
{
  function gym(context)
  {
    formacion(context);
  }
  function init()
  {
    return this.ctx.gym_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.gym_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.gym_calculateField(fN);
  }
  function habilitarClienteOrigen()
  {
    return this.ctx.gym_habilitarClienteOrigen();
  }
  function tbnClienteOrigen_clicked()
  {
    return this.ctx.gym_tbnClienteOrigen_clicked();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.gym_commonCalculateField(fN, cursor);
  }
  function totalizarBonos()
  {
    return this.ctx.gym_totalizarBonos();
  }
  function filtrarBonos()
  {
    return this.ctx.gym_filtrarBonos();
  }
  function tbnAsociarBono_clicked()
  {
    return this.ctx.gym_tbnAsociarBono_clicked();
  }
  function imprimirFacturaBono()
  {
    return this.ctx.gym_imprimirFacturaBono();
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubGym */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class pubGym extends ifaceCtx
{
  function pubGym(context)
  {
    ifaceCtx(context);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
  }
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
function gym_init()
{
  this.iface.__init();

  connect(this.child("tbnClienteOrigen"), "clicked()", this, "iface.tbnClienteOrigen_clicked");
  connect(this.child("tdbBonosGym").cursor(), "bufferCommited()", this, "iface.totalizarBonos");
  connect(this.child("chkIncluirCaducados"), "clicked()", this, "iface.filtrarBonos");
  connect(this.child("tbnAsociarBono"), "clicked()", this, "iface.tbnAsociarBono_clicked");
  connect(this.child("tbnImprimirFactBono"), "clicked()", this, "iface.imprimirFacturaBono");

  this.iface.habilitarClienteOrigen();
  this.iface.filtrarBonos();
}

function gym_filtrarBonos()
{
  var filtro: String = "";
  if (!this.child("chkIncluirCaducados").checked) {
    var hoy: Date = new Date;
    filtro = "(fechacaducidad IS NULL OR fechacaducidad >= '" + hoy.toString() + "') AND (cansesionesdisp > 0 OR (cansesiones = 0 OR cansesiones IS NULL))";
  }
  this.child("tdbBonosGym").setFilter(filtro);
  this.child("tdbBonosGym").refresh();
}

function gym_bufferChanged(fN: String)
{
  switch (fN) {
    case "origencliente": {
      this.iface.habilitarClienteOrigen();
      break;
    }
    case "codclienteorigen": {
      this.child("lblClienteOrigen").text = this.iface.calculateField("clienteorigen");
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function gym_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  switch (fN)
  {
    case "clienteorigen": {
      valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codclienteorigen") + "'");
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

function gym_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var valor: String;
  switch (fN)
  {
    case "cansesionesdisp": {
      valor = util.sqlSelect("bonosgym", "SUM(cansesionesdisp)", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND cansesionesdisp IS NOT NULL");
      valor = (isNaN(valor) ? 0 : valor);
      break;
    }
    default: {
      ///       valor = this.iface.__commonCalculateField(fN, cursor); (Todavía no existe en oficial)
    }
  }
  return valor;
}

function gym_habilitarClienteOrigen()
{
  var cursor: FLSqlCursor = this.cursor();
  var origenCliente: String = cursor.valueBuffer("origencliente");
  switch (origenCliente) {
    case "Otro cliente": {
      this.child("fdbCodClienteOrigen").setDisabled(false);
      this.child("tbnClienteOrigen").enabled = true;
      break;
    }
    default: {
      this.child("fdbCodClienteOrigen").setDisabled(true);
      this.child("tbnClienteOrigen").enabled = false;
      break;
    }
  }
}

function gym_tbnClienteOrigen_clicked()
{
  var util: FLUtil = new FLUtil();

  var f: Object = new FLFormSearchDB("clientes");
  f.setMainWidget();
  var codCliente: String = f.exec("codcliente");

  if (!codCliente) {
    return;
  }
  this.child("fdbCodClienteOrigen").setValue(codCliente);
}

function gym_totalizarBonos()
{
  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbCanSesionesDisp").setValue(this.iface.commonCalculateField("cansesionesdisp", cursor));
}

function gym_tbnAsociarBono_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("bonosgym");
  var curBonos: FLSqlCursor = f.cursor();

  var codCliente: String = cursor.valueBuffer("codcliente");
  var masFiltro: String = "(codcliente = '' OR codcliente IS NULL)";
  curBonos.setMainFilter(masFiltro);
  f.setMainWidget();

  var codBono: String = f.exec("codbono");
  if (!codBono) {
    return;
  }

  curBonos.setActivatedCommitActions(false);
  curBonos.select("codbono = '" + codBono + "'");
  if (!curBonos.first()) {
    return false;
  }
  curBonos.setModeAccess(curBonos.Edit);
  curBonos.refreshBuffer();
  curBonos.setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
  if (!curBonos.commitBuffer()) {
    return false;
  }
  this.iface.totalizarBonos();
  this.child("tdbBonosGym").refresh();
}

function gym_imprimirFacturaBono()
{
  var util: FLUtil = new FLUtil;
  var curBono: FLSqlCursor = this.child("tdbBonosGym").cursor();

  var codFactura: String = curBono.valueBuffer("codfactura");
  if (!codFactura || codFactura == "") {
    MessageBox.warning(util.translate("scripts", "El bono seleccionado no tiene una factura asociada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  formfacturascli.iface.pub_imprimir(codFactura);
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
