
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

  var proveedores: CheckBox = new CheckBox;
  proveedores.text = util.translate("scripts", "PROVEEDORES");
  proveedores.checked = true;
  bgroup.add(proveedores);

  var dirproveedores: CheckBox = new CheckBox;
  dirproveedores.text = util.translate("scripts", "DIRECCIONES");
  dirproveedores.checked = true;
  bgroup.add(dirproveedores);

  var cuentasProv: CheckBox = new CheckBox;
  cuentasProv.text = util.translate("scripts", "CUENTAS BANCO");
  cuentasProv.checked = true;
  bgroup.add(cuentasProv);

  var contactosProv: CheckBox = new CheckBox;
  contactosProv.text = util.translate("scripts", "CONTACTOS");
  contactosProv.checked = true;
  bgroup.add(contactosProv);

  if (!dialog.exec()) {
    return false;
  }

  var camposExtra: String;
  var fromQry: String;
  if (proveedores.checked == true) {
    var fichero: String = directorio + "proveedores.csv";
    flfactppal.iface.pub_exportarTabla("proveedores", fichero);
  }

  if (dirproveedores.checked == true) {
    var fichero: String = directorio + "dirproveedores.csv";
    camposExtra = "proveedores.nombre";
    fromQry = "dirproveedores INNER JOIN proveedores ON dirproveedores.codproveedor = proveedores.codproveedor";
    flfactppal.iface.pub_exportarTabla("dirproveedores", fichero, camposExtra, fromQry);
  }

  if (cuentasProv.checked == true) {
    var fichero: String = directorio + "cuentasbancoprov.csv";
    camposExtra = "proveedores.nombre";
    fromQry = "cuentasbcopro INNER JOIN proveedores ON cuentasbcopro.codproveedor = proveedores.codproveedor";
    flfactppal.iface.pub_exportarTabla("cuentasbcopro", fichero, camposExtra, fromQry);
  }

  if (contactosProv.checked == true) {
    var fichero: String = directorio + "contactosprov.csv";
    camposExtra = "proveedores.nombre";
    fromQry = "crm_contactos INNER JOIN contactosproveedores ON crm_contactos.codcontacto = contactosproveedores.codcontacto INNER JOIN proveedores ON contactosproveedores.codproveedor = proveedores.codproveedor";
    flfactppal.iface.pub_exportarTabla("crm_contactos", fichero, camposExtra, fromQry);
  }

  MessageBox.information(util.translate("scripts", "Generados ficheros .csv en :\n\n" + directorio + "\n\n"), MessageBox.Ok, MessageBox.NoButton);
}

//// EXPORTAR_CSV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////