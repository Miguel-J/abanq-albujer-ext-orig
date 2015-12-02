
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  var tbnEnviarFax;
  function envioFax(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.envioFax_init();
  }
  function enviarDocumentoFax()
  {
    return this.ctx.envioFax_enviarDocumentoFax();
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_init()
{
  this.iface.__init();
  this.iface.tbnEnviarFax = this.child("tbnEnviarFax");
  connect(this.iface.tbnEnviarFax, "clicked()", this, "iface.enviarDocumentoFax()");
}

function envioFax_enviarDocumentoFax()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var tabla: String;
  var numFax: String = "";
  var rutaDocumento: String = "";

  var rutaIntermedia: String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
  if (!rutaIntermedia.endsWith("/")) {
    rutaIntermedia += "/";
  }
  var datosFax: Array = flfactinfo.iface.datosFax;
  if (datosFax) {
    var tipoInforme: String = datosFax.tipoInforme;
    switch (tipoInforme) {
      case "presupuestoscli": {
        tabla = "clientes";
        var codPresupuesto: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El cliente no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "Pr_" + codPresupuesto + ".pdf";
        break;
      }
      case "pedidoscli": {
        tabla = "clientes";
        var codPedido: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El cliente no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "P_" + codPedido + ".pdf";
        break;
      }
      case "albaranescli": {
        tabla = "clientes";
        var codAlbaran: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El cliente no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "A_" + codAlbaran + ".pdf";
        break;
      }
      case "facturascli": {
        tabla = "clientes";
        var codFactura: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El cliente no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "F_" + codFactura + ".pdf";
        break;
      }
      case "reciboscli": {
        tabla = "clientes";
        var codRecibo: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El cliente no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "R_" + codRecibo + ".pdf";
        break;
      }
      case "pedidosprov": {
        tabla = "proveedores";
        var codPedido: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El proveedor no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "P_" + codPedido + ".pdf";
        break;
      }
      case "albaranesprov": {
        tabla = "proveedores";
        var codAlbaran: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El proveedor no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "A_" + codAlbaran + ".pdf";
        break;
      }
      case "facturasprov": {
        tabla = "proveedores";
        var codFactura: String = datosFax.codDocumento;
        numFax = datosFax.numFax;
        if (!numFax || numFax == "") {
          MessageBox.warning(util.translate("scripts", "El proveedor no tiene fax asignado.\nDeberá informarlo en su ficha"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        rutaDocumento = rutaIntermedia + "F_" + codFactura + ".pdf";
        break;
      }
    }
  }
  delete flfactinfo.iface.datosFax; /// Para que no se quede para el próximo informe
  flfactinfo.iface.datosFax = false;

  var dialog = new Dialog;
  dialog.caption = "Número de fax";
  dialog.okButtonText = "Aceptar"
                        dialog.cancelButtonText = "Cancelar";

  var fax = new LineEdit;
  fax.label = "Fax: ";
  fax.text = numFax;
  dialog.add(fax);

  if (dialog.exec()) {
    numFax = fax.text;
  }

  if (!rutaDocumento || rutaDocumento == "") {
    var nombre: String = Input.getText(util.translate("scripts", "Nombre del fichero a enviar"));
    if (!nombre || nombre == "") {
      return false;
    }
    if (!nombre.toLowerCase().endsWith(".pdf")) {
      nombre += ".pdf";
    }
    rutaDocumento = rutaIntermedia + nombre;
  }
  this.iface.visor.printReportToPDF(rutaDocumento);

  var documento: String = rutaDocumento;

  if (!flfacturac.iface.pub_enviarFax(numFax, documento)) {
    MessageBox.information(util.translate("scripts", "Fallo al enviar el fax"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  MessageBox.information(util.translate("scripts", "Enviado el documento al fax: %1").arg(numFax), MessageBox.Ok, MessageBox.NoButton);
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
