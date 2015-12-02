
/** @class_declaration exportarCsv */
/////////////////////////////////////////////////////////////////
//// EXPORTAR_CSV //////////////////////////////////////////////
class exportarCsv extends oficial
{
  function exportarCsv(context)
  {
    oficial(context);
  }
  function exportarTabla(tabla: String, fichero: String, camposExtra: String, fromQry: String)
  {
    return this.ctx.exportarCsv_exportarTabla(tabla, fichero, camposExtra, fromQry);
  }
  function seleccionarCampos(tabla: String): String {
    return this.ctx.exportarCsv_seleccionarCampos(tabla);
  }
}
//// EXPORTAR_CSV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubExportarCsv */
/////////////////////////////////////////////////////////////////
//// PUB_EXPORTAR_CSV ///////////////////////////////////////////
class pubExportarCsv extends ifaceCtx
{
  function pubExportarCsv(context)
  {
    ifaceCtx(context);
  }
  function pub_exportarTabla(tabla: String, fichero: String, camposExtra: String, fromQry: String)
  {
    return this.exportarTabla(tabla, fichero, camposExtra, fromQry);
  }
  function pub_seleccionarCampos(tabla: String): String {
    return this.seleccionarCampos(tabla);
  }
}

//// PUB_EXPORTAR_CSV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportarCsv */
/////////////////////////////////////////////////////////////////
//// EXPORTAR_CSV ///////////////////////////////////////////////
function exportarCsv_exportarTabla(tabla: String, fichero: String, camposExtra: String, fromQry: String): String {
  var util: FLUtil = new FLUtil();
  var file = new File(fichero);
  file.open(File.WriteOnly);

  var contenido: String = "";
  var select: String = this.iface.seleccionarCampos(tabla);
  if (camposExtra)
  {
    select += "," + camposExtra;
  }
  var cabecera: String;
  var campoTabla: Array;
  var numCampos: Array = select.split(",");
  for (var i: Number = 0; i < numCampos.length; i++)
  {
    if (cabecera) {
      cabecera += "|";
    }
    campoTabla = numCampos[i].split(".");
    cabecera += util.fieldNameToAlias(campoTabla[1], tabla);
  }

  contenido += cabecera + "\n";
  var from: String = tabla;
  if (fromQry)
  {
    from = fromQry;
  }
  var qry: FLSqlQuery = new FLSqlQuery;
  qry.setTablesList(tabla);
  qry.setSelect(select);
  qry.setFrom(from);
  qry.setWhere("1 = 1");
  qry.setForwardOnly(true);
  if (!qry.exec())
  {
    return false;
  }

  util.createProgressDialog(util.translate("scripts", "Exportando tabla %1").arg(tabla), 3);
  var progreso = 0;


  var linea: String;
  while (qry.next())
  {
    linea = "";
    for (i = 0; i < numCampos.length; i++) {
      if (linea) {
        linea += "|";
      }
      linea += qry.value(i);
    }
    contenido += linea + "\n";
    progreso++;
  }

  file.write(contenido + "\r\n");
  file.close();
  util.setProgress(progreso);
  util.destroyProgressDialog();
}

function exportarCsv_seleccionarCampos(tabla: String): String {
  var util: FLUtil = new FLUtil();
  var camposTabla: Array;
  var xmlMetadata: FLDomDocument = new FLDomDocument;
  var metadata: String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
  if (!metadata)
  {
    return false;
  }
  xmlMetadata.setContent(metadata);
  var nodoField: FLDomNode;
  var nombreCampo: String;
  var i: Number = 0;
  var botonesEj: Array = [];
  var dialog: Dialog = new Dialog(util.translate("scripts", "Campos a exportar de la tabla %1").arg(tabla), 0, "exportar");
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");
  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);

  for (nodoField = xmlMetadata.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling())
  {
    if (nodoField.nodeName() != "field") {
      continue;
    }

    nodoName = nodoField.namedItem("name");
    if (!nodoName) {
      return;
    }

    camposTabla[i] = new Array(2);
    camposTabla[i]["nombre"] = nodoName.firstChild().nodeValue();
    campo = new CheckBox;
    campo.text = util.fieldNameToAlias(nodoName.firstChild().nodeValue(), tabla);
    campo.checked = true;
    bgroup.add(campo);
    camposTabla[i]["check"] = campo;
    if (i % 20 == 0 && i != 0) {
      bgroup.newColumn();
    }
    i++;
  }

  if (!dialog.exec())
  {
    return;
  }

  var select: String = "";
  for (i = 0; i < camposTabla.length; i++)
  {
    campo = camposTabla[i]["check"];
    if (campo.checked) {
      if (select) {
        select += ",";
      }
      select += tabla + "." + camposTabla[i]["nombre"];
    }
  }
  return select;
}

//// EXPORTAR_CSV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
