
/** @class_declaration exportarCsv */
/////////////////////////////////////////////////////////////////
//// EXPORTAR_CSV ///////////////////////////////////////////////
class exportarCsv extends oficial
{
  function exportarCsv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.exportarCsv_init();
  }
  function exportar()
  {
    return this.ctx.exportarCsv_exportar();
  }
}
//// EXPORTAR_CSV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportarCsv */
/////////////////////////////////////////////////////////////////
//// EXPORTAR_CSV ///////////////////////////////////////////////
function exportarCsv_init()
{
  this.iface.__init();

  connect(this.child("tbnExportarCsv"), "clicked()", this, "iface.exportar");
}

function exportarCsv_exportar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var directorio: String = FileDialog.getExistingDirectory("", "Seleccionar directorio")
  if (!directorio) {
    return;
  }
  var dialog: Dialog = new Dialog(util.translate("scripts", "Exportar tabla a fichero .csv"), 0, "exportar");
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);

  var clientes: CheckBox = new CheckBox;
  clientes.text = util.translate("scripts", "CLIENTES");
  clientes.checked = true;
  bgroup.add(clientes);

  var dirclientes: CheckBox = new CheckBox;
  dirclientes.text = util.translate("scripts", "DIRECCIONES");
  dirclientes.checked = true;
  bgroup.add(dirclientes);

  var cuentasClientes: CheckBox = new CheckBox;
  cuentasClientes.text = util.translate("scripts", "CUENTAS BANCO");
  cuentasClientes.checked = true;
  bgroup.add(cuentasClientes);

  var contactosClientes: CheckBox = new CheckBox;
  contactosClientes.text = util.translate("scripts", "CONTACTOS");
  contactosClientes.checked = true;
  bgroup.add(contactosClientes);

  if (!dialog.exec()) {
    return false;
  }

  var camposExtra: String;
  var fromQry: String;
  if (clientes.checked == true) {
    var fichero: String = directorio + "clientes.csv";
    flfactppal.iface.pub_exportarTabla("clientes", fichero);
  }

  if (dirclientes.checked == true) {
    var fichero: String = directorio + "dirclientes.csv";
    camposExtra = "clientes.nombre";
    fromQry = "dirclientes INNER JOIN clientes ON dirclientes.codcliente = clientes.codcliente";
    flfactppal.iface.pub_exportarTabla("dirclientes", fichero, camposExtra, fromQry);
  }

  if (cuentasClientes.checked == true) {
    var fichero: String = directorio + "cuentasbancocli.csv";
    camposExtra = "clientes.nombre";
    fromQry = "cuentasbcocli INNER JOIN clientes ON cuentasbcocli.codcliente = clientes.codcliente";
    flfactppal.iface.pub_exportarTabla("cuentasbcocli", fichero, camposExtra, fromQry);
  }

  if (contactosClientes.checked == true) {
    var fichero: String = directorio + "contactoscli.csv";
    camposExtra = "clientes.nombre";
    fromQry = "crm_contactos INNER JOIN contactosclientes ON crm_contactos.codcontacto = contactosclientes.codcontacto INNER JOIN clientes ON contactosclientes.codcliente = clientes.codcliente";
    flfactppal.iface.pub_exportarTabla("crm_contactos", fichero, camposExtra, fromQry);
  }

  MessageBox.information(util.translate("scripts", "Generados ficheros .csv en :\n\n" + directorio + "\n\n"), MessageBox.Ok, MessageBox.NoButton);
}

//// EXPORTAR_CSV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
