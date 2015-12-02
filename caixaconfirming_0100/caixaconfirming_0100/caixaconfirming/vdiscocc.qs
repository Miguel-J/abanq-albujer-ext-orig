/***************************************************************************
                      vdiscocc.qs  -  description
                             -------------------
    begin                : jue dic 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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

/** @file */

/** @class_declaration interna */
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
    this.ctx.interna_init();
  }
  function validateForm(): Boolean { return this.ctx.interna_validateForm(); }
  function acceptedForm()
  {
    return this.ctx.interna_acceptedForm();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var zonaACabecera: String;
  var zonaABeneficiario: String;
  var zonaATotales: String;
  var zonaB: String;
  var zonaC: String;
  var zonaD: String;
  var idCaixa: String;
  var sumaImportes: Number;
  var sumaRegIndi: Number;
  var sumaRegistros: Number;
  function oficial(context)
  {
    interna(context);
  }
  function establecerFichero()
  {
    return this.ctx.oficial_establecerFichero();
  }
  function cabecera1(): String {
    return this.ctx.oficial_cabecera1();
  }
  function cabecera2(): String {
    return this.ctx.oficial_cabecera2();
  }
  function cabecera3(): String {
    return this.ctx.oficial_cabecera3();
  }
  function cabecera4(): String {
    return this.ctx.oficial_cabecera4();
  }
  function individualObligatorio1(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_individualObligatorio1(curRecibo);
  }
  function individualObligatorio2(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_individualObligatorio2(curRecibo);
  }
  function individualObligatorio3(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_individualObligatorio3(curRecibo);
  }
  function individualOpcional4(restoDir: String): String {
    return this.ctx.oficial_individualOpcional4(restoDir);
  }
  function individualObligatorio5(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_individualObligatorio5(curRecibo);
  }
  function individualObligatorio7(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_individualObligatorio7(curRecibo);
  }
  function totales(): String {
    return this.ctx.oficial_totales();
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
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

/** @class_declaration ifaceCtx */
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

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \D No de muestran los botones estándar de un formulario de registro
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil;
  with(form) {
    child("fdbDivisa").setDisabled(true);
    child("pushButtonAcceptContinue").close();
    child("pushButtonFirst").close();
    child("pushButtonLast").close();
    child("pushButtonNext").close();
    child("pushButtonPrevious").close();
    connect(child("pbnExaminar"), "clicked()", this, "iface.establecerFichero");
  }

  this.iface.idCaixa = flfactppal.iface.pub_valorDefectoEmpresa("idcaixa");
  if (!this.iface.idCaixa || this.iface.idCaixa.toString().length != 10) {
    MessageBox.warning(util.translate("scripts", "Debe establecer el número de cliente de confirming en el formulario de empresa.\nEste número debe tener 10 dígitos"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

}

/** \C El nombre del fichero de destino debe indicarse
\end */
function interna_validateForm(): Boolean {
  if (this.child("ledFichero").text.isEmpty())
  {
    var util: FLUtil = new FLUtil();
    MessageBox.warning(util.translate("scripts", "Hay que indicar el fichero."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  /*
  if (!flfactteso.iface.pub_comprobarCuentasDom(this.cursor().valueBuffer("idremesa")))
    return false;
  */
  return true;
}

/** \C Se genera el fichero de texto con los datos de la remesa en el fichero especificado
\end */
function interna_acceptedForm()
{
  // Zona A: (2 dígitos/ NUM) Código de registro = 01, 06, 08
  this.iface.zonaACabecera = "01";
  this.iface.zonaABeneficiario = "06";
  this.iface.zonaATotales = "08";
  // Zona B: (2 dígitos/ NUM) Código de operación = 56 para euros.
  this.iface.zonaB = "56";
  /*
  Zona C: (10 dígitos/ ALF) Código del ordenante: Un número identificativo de
  la Empresa u Organismo ordenante, que será siempre el mismo,
  aunque se entreguen soportes a diversas Entidades de Crédito (NIF,
  CIF, DNI, etc.). Es campo alfanumérico, ajustado a la derecha.
  */
  var cifnif: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  this.iface.zonaC = flfactppal.iface.pub_espaciosDerecha(cifnif, 10).right(10);

  this.iface.sumaImportes = 0;
  this.iface.sumaRegIndi = 0;
  this.iface.sumaRegistros = 0;;

  var file: Object = new File(this.child("ledFichero").text);
  var fileIso = new File(this.child("ledFichero").text + ".iso8859");

  fileIso.open(File.WriteOnly);
  file.open(File.WriteOnly);

  var linea: String;
  linea = this.iface.cabecera1();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");
  linea = this.iface.cabecera2();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");
  linea = this.iface.cabecera3();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");
  linea = this.iface.cabecera4();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");

  var curRecibos: FLSqlCursor = new FLSqlCursor("recibosprov");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ")");
  var datos: String;
  while (curRecibos.next()) {
    datos = this.iface.individualObligatorio1(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
    datos = this.iface.individualObligatorio2(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
    datos = this.iface.individualObligatorio3(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
    datos = this.iface.individualObligatorio5(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
    datos = this.iface.individualObligatorio7(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
  }

  linea = this.iface.totales(curRecibos.size());
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");

  file.close();

  var util: FLUtil = new FLUtil();
  MessageBox.information(util.translate("scripts", "Generado fichero de recibos Caixa Confirming en: \n\n%1\n\n").arg(this.child("ledFichero").text), MessageBox.Ok, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
  this.child("ledFichero").text = FileDialog.getSaveFileName("*.*");
}

/** \D Crea el texto de cabecera del primer registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabecera1(): String {
  var util: FLUtil = new FLUtil();

  var date: Date = new Date();
  var fecha = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

  var reg: String = this.iface.zonaACabecera + this.iface.zonaB + this.iface.zonaC;
  // Zona D: (12 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: (3 dígitos/ NUM) Número de dato = 001
  reg += "001";
  // Zona F:
  // F1: (6 dígitos/ NUM) Fecha de creación del fichero (DDMMAA)
  reg += fecha;
  // F2: (6 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 6);
  // F3: (4 dígitos) Entidad de destino del soporte. Fijo 2100.
  reg += "2100";
  // F4: (4 dígitos) Oficina de destino de soporte. Fijo 6202.
  reg += "6202";
  // F5: (10 dígitos) Número de cliente de Confirming facilitado por el propio departamento (01NNNNNNDD).
  reg += this.iface.idCaixa;
  // F6: (1 dígito) Detalle del cargo: Con relación = 1
  reg += "1";
  // F7: (3 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 3);
  // F8: (2 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // F9: (7 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto de cabecera del segundo registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabecera2(): String {
  var util: FLUtil = new FLUtil();

  var nombreOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
  if (!nombreOrdenante || nombreOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Nombre\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nombreOrdenante = nombreOrdenante.toString().toUpperCase();

  var reg: String = this.iface.zonaACabecera + this.iface.zonaB + this.iface.zonaC;
  // Zona D: (12 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: (3 dígitos/ NUM) Número de dato = 002
  reg += "002";
  // Zona F:
  // F1 (36 dígitos / ALF) Nombre del ordenante. Ajustado a la izquierda y relleno a blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(nombreOrdenante, 36).left(36);
  // F2: (7 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto de cabecera del tercer registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabecera3(): String {
  var util: FLUtil = new FLUtil();

  var domiOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("direccion");
  if (!domiOrdenante || domiOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Dirección\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  domiOrdenante = domiOrdenante.toString().toUpperCase();

  var reg: String = this.iface.zonaACabecera + this.iface.zonaB + this.iface.zonaC;
  // Zona D: (12 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: (3 dígitos/ NUM) Número de dato = 003
  reg += "003";

  // Zona F:
  // Zona F1: (36 dígitos / ALF) Domicilio del ordenante. Ajustado a la izquierda y relleno a blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(domiOrdenante, 36).left(36);
  // F2: (7 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto de cabecera del cuarto registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabecera4(): String {
  var util: FLUtil = new FLUtil();

  var ciudadOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("ciudad");
  if (!ciudadOrdenante || ciudadOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Ciudad\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ciudadOrdenante = ciudadOrdenante.toString().toUpperCase();

  var provOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("provincia");
  if (!provOrdenante || provOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Provincia\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  provOrdenante = provOrdenante.toString().toUpperCase();

  var reg: String = this.iface.zonaACabecera + this.iface.zonaB + this.iface.zonaC;
  // Zona D: (12 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: (3 dígitos/ NUM) Número de dato = 004
  reg += "004";

  // Zona F:
  // Zona F1: (36 dígitos / ALF) Plaza del ordenante.Ajustado a la izquierda y relleno a blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(ciudadOrdenante + " " + provOrdenante, 36).left(36);
  // F2: (7 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del primer registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualObligatorio1(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var nifProveedor: String = curRecibo.valueBuffer("cifnif");
  if (!nifProveedor || nifProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: N.I.F.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nifProveedor = nifProveedor.toString().toUpperCase();
  // Zona D: Código del Proveedor: (12 dígitos) Código de identificación fijado por el ordenante distinto para cada proveedor y que será el mismo para todas sus facturas. Debe ser el NIF.
  this.iface.zonaD = flfactppal.iface.pub_espaciosDerecha(nifProveedor, 12).right(12);

  var importe: Number = Math.round(curRecibo.valueBuffer("importe") * 100);
  this.iface.sumaImportes += importe;
  this.iface.sumaRegIndi++;

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 010
  reg += "010";
  // Zona F: Datos del abono:
  // F1: Importe (12 dígitos), ajustado a la derecha, completado con ceros a la izquierda, cuando sea necesario. Si la factura es negativa, el signo ( - ) ocupará la primera posición disponible a la izquierda del dígito más significativo del importe.
  reg += flfactppal.iface.pub_cerosIzquierda(importe, 12).right(12);
  // F2: Opcional. Número de la Entidad de Crédito receptora. Será el número asignado por el Banco de España a dicha Entidad. (4 digitos)
  reg += flfactppal.iface.pub_espaciosDerecha("", 4);
  // F3: Opcional. Número de la Sucursal de la Entidad de Crédito receptora. Dicho número es asignado por cada Entidad a sus oficinas correspondientes. (4 dígitos).
  reg += flfactppal.iface.pub_espaciosDerecha("", 4);
  // F4: Opcional. Número de cuenta donde se ha de efectuar el abono. (10 dígitos).
  reg += flfactppal.iface.pub_espaciosDerecha("", 10);
  // F5: Gastos: Código que indica por cuenta de quien deben ser los gastos de la operación: Gastos por cuenta del ordenante = 1
  reg += "1";
  // F6: Concepto de la orden: Otros conceptos = 9
  reg += "9";
  // F7: Libre (2) (Reservado para posible ampliación del código concepto).
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // F8: Opcional. Dígitos (2) de control (C.C.C.) de la cuenta de abono de la transferencia, en su caso.
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // F9: Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del segundo registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualObligatorio2(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var nomProveedor: String = curRecibo.valueBuffer("nombreproveedor");
  if (!nomProveedor || nomProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Nombre del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nomProveedor = nomProveedor.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 011
  reg += "011";
  // Zona F:
  // Zona F1: Nombre del proveedor.(36) EN MAYUSCULAS Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(nomProveedor, 36).left(36);
  // Zona F2: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del tercer registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualObligatorio3(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var dirProveedor: String = curRecibo.valueBuffer("direccion");
  if (!dirProveedor || dirProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Dirección.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  dirProveedor = dirProveedor.toString().toUpperCase();

  var restoDir: String = "";
  if (dirProveedor.length > 36)
    restoDir = dirProveedor.right(dirProveedor.length - 36);

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 012
  reg += "012";
  // Zona F:
  // Zona F1: Domicilio del proveedor. (36) Ajustado a la izquierda, completado con blancos. Si no fuera suficiente con este campo, puede continuarse el domicilio en el registro del tipo que se indica a continuación.
  reg += flfactppal.iface.pub_espaciosDerecha(dirProveedor, 36).left(36);
  // Zona F2: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  if (restoDir != "")
    reg += "\r\n" + this.iface.individualOpcional4(restoDir);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del cuarto registro individual por abono a proveedor
@param restoDir: Resto de la dirección que queda por incluir en el fichero
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualOpcional4(restoDir: String): String {
  var util: FLUtil = new FLUtil();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 013
  reg += "013";
  // Zona F:
  // Zona F1: Continuación del domicilio del proveedor. (36) Solamente se usará este registro en los casos en que no quepa dicho domicilio en el registro del tipo anterior. Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(restoDir, 36).left(36);
  // Zona F2: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del quinto registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualObligatorio5(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var codPostal: String = curRecibo.valueBuffer("codpostal");
  if (!codPostal || codPostal == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código postal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }


  var ciudadProv: String = curRecibo.valueBuffer("ciudad");
  if (!ciudadProv || ciudadProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Ciudad.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ciudadProv = ciudadProv.toString().toUpperCase();

  var provinciaProv: String = curRecibo.valueBuffer("provincia");
  if (!provinciaProv || provinciaProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Provincia.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  provinciaProv = provinciaProv.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 014
  reg += "014";
  // Zona F:
  // Zona F1: Código postal (5 dígitos)
  reg += flfactppal.iface.pub_cerosIzquierda(codPostal, 5).left(5);
  // Zona F2: plaza del proveedor (31). Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(ciudadProv + " " + provinciaProv, 31).left(31);
  // Zona F3: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 7);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del séptimo registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualObligatorio7(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var fechaFactura: String = util.sqlSelect("facturasprov", "fecha", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  if (!fechaFactura || fechaFactura == "")
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener la fecha de factura correspondiente al recibo %1").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  fechaFactura = fechaFactura.toString().mid(8, 2) + fechaFactura.toString().mid(5, 2) + fechaFactura.toString().mid(2, 2);

  var numFactura: String = util.sqlSelect("facturasprov", "numproveedor", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  if (!numFactura || numFactura == "")
  {
    numFactura = util.sqlSelect("facturasprov", "codigo", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  }
  /*
      MessageBox.warning(util.translate("scripts", "Error al obtener el numero de factura de proveedor correspondiente al recibo %1").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  */

  var fechaV: String = curRecibo.valueBuffer("fechav");
  if (!fechaV || fechaV == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Fecha de vencimiento.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  fechaV = fechaV.toString().mid(8, 2) + fechaV.toString().mid(5, 2) + fechaV.toString().mid(2, 2);

  var provinciaProv: String = curRecibo.valueBuffer("provincia");
  if (!provinciaProv || provinciaProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Provincia.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  provinciaProv = provinciaProv.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 016
  reg += "016";
  // Zona F:
  // Zona F1: Concepto por el que se efectúa el pago. Clave de conformidad, forma de pago. Cheque = C, Transferencia = T.
  reg += "T";
  // Zona F2: Fecha de factura en formato DDMMAA
  reg += fechaFactura;
  // Zona F3: Número de factura ajustado a la derecha
  reg += flfactppal.iface.pub_cerosIzquierda(numFactura, 15);
  // Zona F4: Fecha de vencimiento en formato DDMMAA
  reg += fechaV;
  // Zona F5: Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 15);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Calcula el total del valor de recibos para el ordenante
@return Texto con el total para ser volcado a disco
\end */
function oficial_totales(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.sumaRegistros++;

  var reg: String = this.iface.zonaATotales + this.iface.zonaB + this.iface.zonaC;
  // Zona D: Libre. (12 dígitos)
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: Libre. (3 dígitos)
  reg += flfactppal.iface.pub_espaciosDerecha("", 3);
  // Zona F: Datos totales:
  // F1: Posiciones de la 30 a 41 (12 dígitos) Suma de todos los importes del soporte Ajustado a la derecha, completado a ceros.
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaImportes, 12);
  // F2: Posiciones de la 42 a 49 (8 dígitos) Número de registros individuales del primer tipo, es decir, los que contienen el Número de dato "010".
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegIndi, 8);
  // F3: Posiciones de la 50 a 59 (10 dígitos) Número total de registros que contenga el soporte, incluidos los de Cabecera y el propio de Totales.
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegistros, 10);
  // F4: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 13);

  return reg;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
