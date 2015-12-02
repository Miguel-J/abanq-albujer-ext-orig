/***************************************************************************
                 masterintrastat.qs  -  description
                             -------------------
    begin                : jue ene 29 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    return this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
  function presTelematica()
  {
    return this.ctx.oficial_presTelematica();
  }
  function validarDatosFichero(qry: FLSqlQuery)
  {
    return this.ctx.oficial_validarDatosFichero(qry);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  connect(this.child("toolButtonAeat"), "clicked()", this, "iface.presTelematica()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Genera un fichero para realizar la presentación telemática de la declaración de intrastat
\end */
function oficial_presTelematica()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return;

  var dialog: Object = new Dialog(util.translate("scripts", "Intrastat"));
  var bgroup: Object = new GroupBox;
  dialog.add(bgroup);

  var clientes = new RadioButton;
  clientes.text = "Expedición";
  bgroup.add(clientes);
  var proveedores = new RadioButton;
  proveedores.text = "Introducción";
  bgroup.add(proveedores);
  if (!dialog.exec()) {
    return false;
  }
  var nombreFichero: String = FileDialog.getSaveFileName("*.*");
  if (!nombreFichero) {
    return;
  }

  var file: Object = new File(nombreFichero);
  file.open(File.WriteOnly);
  var contenido: String = "";
  var qry = new FLSqlQuery();

  if (clientes.checked == true) {
    qry.setTablesList("lineasintrastatcli");
    qry.setSelect("codiso, codprovincia, codcondicionentrega, codnaturaleza, codmodotransporte, codpuerto, codmercancia, codpaisorigen, codregimen, masaneta, udssuplementarias, importefacturado, valorestadistico");
    qry.setFrom("lineasintrastatcli");
  }
  if (proveedores.checked == true) {
    qry.setTablesList("lineasintrastatprov");
    qry.setSelect("codiso, codprovincia, codcondicionentrega, codnaturaleza, codmodotransporte, codpuerto, codmercancia, codpaisorigen, codregimen, masaneta, udssuplementarias, importefacturado, valorestadistico");
    qry.setFrom("lineasintrastatprov");
  }

  qry.setWhere("idintrastat = " + cursor.valueBuffer("idintrastat"));
  if (!qry.exec()) {
    return;
  }
  var codMercancia: String = "";
  while (qry.next()) {
    this.iface.validarDatosFichero(qry);
    contenido += qry.value("codiso") + ";" + qry.value("codprovincia") + ";" + qry.value("codcondicionentrega") + ";" + qry.value("codnaturaleza") + ";" + qry.value("codmodotransporte") + ";" + qry.value("codpuerto") + ";" + qry.value("codmercancia") + ";" + qry.value("codpaisorigen") + ";" + qry.value("codregimen") + ";" + util.roundFieldValue(qry.value("masaneta"), "lineasintrastatcli", "masaneta") + ";" + qry.value("udssuplementarias") + ";" + util.roundFieldValue(qry.value("importefacturado"), "albaranescli", "total") + ";" + util.roundFieldValue(qry.value("valorestadistico"), "albaranescli", "total") + ";\n";
  }

  file.write(contenido);
  file.close();

  MessageBox.information(util.translate("scripts", "Generado fichero en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_validarDatosFichero(qry: FLSqlQuery): Boolean {
  var util: FLUtil = new FLUtil();
  if (qry.value("codiso") && qry.value("codiso").length != 2)
  {
    MessageBox.information(util.translate("scripts", "El valor del código iso no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qry.value("codprovincia") && qry.value("codprovincia").length != 2)
  {
    MessageBox.information(util.translate("scripts", "El código de la provincia no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qry.value("codcondicionentrega") && qry.value("codcondicionentrega").length != 3)
  {
    MessageBox.information(util.translate("scripts", "El valor condición de entrega no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qry.value("codnaturaleza") && qry.value("codnaturaleza").length != 2)
  {
    MessageBox.information(util.translate("scripts", "El valor naturaleza transacción no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qry.value("codmodotransporte") && qry.value("codmodotransporte").length != 1)
  {
    MessageBox.information(util.translate("scripts", "El valor modo de transporte no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qry.value("codregimen") && qry.value("codregimen").length != 1)
  {
    MessageBox.information(util.translate("scripts", "El valor régimen estadístico no tiene la longitud correcta"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
