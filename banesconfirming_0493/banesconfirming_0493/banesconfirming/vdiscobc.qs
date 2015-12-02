/***************************************************************************
                      vdiscobc.qs  -  description
                             -------------------
    begin                : mar jun 02 2009
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
    return this.ctx.interna_init();
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
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
  var idBanesto: String;
  var sumaFacturas: Number;
  var sumaRegistros: Number;
  function oficial(context)
  {
    interna(context);
  }
  function establecerFichero()
  {
    return this.ctx.oficial_establecerFichero();
  }
  function registroCabecera1(): String {
    return this.ctx.oficial_registroCabecera1();
  }
  function registroCabecera2(): String {
    return this.ctx.oficial_registroCabecera2();
  }
  function registroProveedor010(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroProveedor010(curRecibo);
  }
  function registroProveedor011(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroProveedor011(curRecibo);
  }
  function registroProveedor012(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroProveedor012(curRecibo);
  }
  function registroProveedor013(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroProveedor013(curRecibo);
  }
  function registroProveedor014(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroProveedor014(curRecibo);
  }
  function registroFacturas020(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroFacturas020(curRecibo);
  }
  function registroFacturas021(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroFacturas021(curRecibo);
  }
  function registroFacturas022(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_registroFacturas022(curRecibo);
  }
  function totales(): String {
    return this.ctx.oficial_totales();
  }
  function quitarPuntoDecimales(dato: String): String {
    return this.ctx.oficial_quitarPuntoDecimales(dato);
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

  this.iface.idBanesto = flfactppal.iface.pub_valorDefectoEmpresa("idbanesto");

  this.iface.sumaFacturas = 0;
  this.iface.sumaRegistros = 0;
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
  return true;
}

/** \C Se genera el fichero de texto con los datos de la remesa en el fichero especificado
\end */
function interna_acceptedForm()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil =  new FLUtil();
  var file: Object = new File(this.child("ledFichero").text);
  var fileIso = new File(this.child("ledFichero").text + ".iso8859");

  fileIso.open(File.WriteOnly);
  file.open(File.WriteOnly);

  var linea: String;
  linea = this.iface.registroCabecera1();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");

  linea = this.iface.registroCabecera2();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");

  var curRecibos: FLSqlCursor = new FLSqlCursor("recibosprov");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + cursor.valueBuffer("idremesa") + ")");
  var datos: String;
  while (curRecibos.next()) {
    this.iface.sumaFacturas++;

    datos = this.iface.registroProveedor010(curRecibos);
    if (!datos) {
      return;
    }
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroProveedor011(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroProveedor012(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroProveedor013(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroProveedor014(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroFacturas020(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroFacturas021(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");

    datos = this.iface.registroFacturas022(curRecibos);
    if (!datos)
      return;
    file.write(datos + "\r\n");
    fileIso.write(sys.fromUnicode(datos, "ISO-8859-15") + "\r\n");
  }

  linea = this.iface.totales();
  file.write(linea + "\r\n");
  fileIso.write(sys.fromUnicode(linea, "ISO-8859-15") + "\r\n");

  file.close();

  MessageBox.information(util.translate("scripts", "Generado fichero de recibos Banesto Confirming en: \n\n%1\n\n").arg(this.child("ledFichero").text), MessageBox.Ok, MessageBox.NoButton);
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
function oficial_registroCabecera1(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "001";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);

  //Nombre del cliente pagador
  var nombreOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
  if (!nombreOrdenante || nombreOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Nombre\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nombreOrdenante = nombreOrdenante.toString().toUpperCase();
  reg += flfactppal.iface.pub_espaciosDerecha(nombreOrdenante, 50);

  //Número C.S.B. de la entidad bancaria
  var numeroConfirming: String = flfactppal.iface.pub_valorDefectoEmpresa("idbanesto");
  if (!numeroConfirming || numeroConfirming == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: Nº cliente confirming\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(numeroConfirming, 4);

  //Moneda de la remesa
  reg += flfactppal.iface.pub_espaciosDerecha(cursor.valueBuffer("coddivisa"), 3);

  //Tipo de remesa
  reg += "00";

  //Referencia de la remesa
  reg += flfactppal.iface.pub_espaciosDerecha(cursor.valueBuffer("idremesa"), 16);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 10);

  return reg;
}

/** \D Crea el texto de cabecera del segundo registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroCabecera2(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "002";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);

  //Fecha de emisión de la remesa
  var fecha: Date = cursor.valueBuffer("fecha");
  var fechaEmision: String = flfactppal.iface.pub_cerosIzquierda(fecha.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fecha.getMonth().toString(), 2) + fecha.getYear().toString().right(4);
  reg += flfactppal.iface.pub_espaciosDerecha(fechaEmision, 8);

  //A la orden
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  //Cruzado
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  //Timbre
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  //Envío
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  //Firmar
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 72);
  return reg;
}


/** \D Crea el texto del primer registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroProveedor010(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "010";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Cod.proveedor\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codProveedor = codProveedor.toString().toUpperCase();
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //CIF del proveedor
  var nifProveedor: String = curRecibo.valueBuffer("cifnif");
  if (!nifProveedor || nifProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: N.I.F. proveedor\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nifProveedor = nifProveedor.toString().toUpperCase();
  nifProveedor = nifProveedor.left(9);
  reg += flfactppal.iface.pub_espaciosDerecha(nifProveedor, 9);

  //Nombre del proveedor
  var nombreProveedor: String = curRecibo.valueBuffer("nombreproveedor");
  if (!nombreProveedor || nombreProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Nombre proveedor\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nombreProveedor = nombreProveedor.toString().toUpperCase();
  reg += flfactppal.iface.pub_espaciosDerecha(nombreProveedor, 72);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 4);

  return reg;
}

/** \D Crea el texto del segundo registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroProveedor011(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "011";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Domicilio del proveedor
  var direccion: String = curRecibo.valueBuffer("direccion");
  if (!direccion || direccion == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Dirección del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(direccion, 72);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 13);

  return reg;
}

/** \D Crea el texto del tercer registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroProveedor012(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "012";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Ciudad del proveedor
  var ciudadProv: String = curRecibo.valueBuffer("ciudad");
  if (!ciudadProv || ciudadProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Ciudad.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ciudadProv = ciudadProv.toString().toUpperCase();
  reg += flfactppal.iface.pub_espaciosDerecha(ciudadProv, 36);

  //Código postal del proveedor
  var codPostalProv: String = curRecibo.valueBuffer("codpostal");
  if (!codPostalProv || codPostalProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código postal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codPostalProv, 8);

  //Provincia del proveedor
  var provinciaProv: String = curRecibo.valueBuffer("provincia");
  if (!provinciaProv || provinciaProv == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Provincia.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(provinciaProv, 36);

  //Código ISO del país de domicilio del proveedor
  var isoPais: String = util.sqlSelect("paises", "codiso", "codpais = '" + curRecibo.valueBuffer("codpais") + "'");
  if (!isoPais)
  {
    MessageBox.information(util.translate("scripts", "Debe informar el codigo ISO del país %1").arg(curRecibo.valueBuffer("codpais")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(isoPais, 2);

  //Código ISO del país de residencia del proveedor
  reg += flfactppal.iface.pub_espaciosDerecha(isoPais, 2);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  return reg;
}

/** \D Crea el texto del cuarto registro individual por abono a proveedor
@param restoDir: Resto de la dirección que queda por incluir en el fichero
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroProveedor013(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "013";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Teléfono del proveedor
  var telefonoProv: String = util.sqlSelect("proveedores", "telefono1", "codproveedor = '" + curRecibo.valueBuffer("codproveedor") + "'");
  telefonoProv = flfactppal.iface.pub_quitarEspaciosIntermedios(telefonoProv);
  reg += flfactppal.iface.pub_espaciosDerecha(telefonoProv, 15);

  //Fax del proveedor
  var faxProv: String = util.sqlSelect("proveedores", "fax", "codproveedor = '" + curRecibo.valueBuffer("codproveedor") + "'");
  faxProv = flfactppal.iface.pub_quitarEspaciosIntermedios(faxProv);
  reg += flfactppal.iface.pub_espaciosDerecha(faxProv, 15);

  //Dirección electrónica del proveedor
  var emailProv: String = util.sqlSelect("proveedores", "email", "codproveedor = '" + curRecibo.valueBuffer("codproveedor") + "'");
  reg += flfactppal.iface.pub_espaciosDerecha(emailProv, 55);

  return reg;
}

/** \D Crea el texto del quinto registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroProveedor014(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "014";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Tipo de proveedor
  reg += flfactppal.iface.pub_espaciosDerecha("", 6);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 79);

  return reg;
}

/** \D Crea el texto del sexto registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroFacturas020(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "020";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Número de la orden de pago
  var idRemesa: String = cursor.valueBuffer("idremesa");
  if (!idRemesa || idRemesa == "")
  {
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(idRemesa, 12);

  //Código de la factura
  var numFactura: String = util.sqlSelect("facturasprov", "codigo", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  reg += flfactppal.iface.pub_espaciosDerecha(numFactura, 12);

  //Signo de la factura
  var importe: String = parseFloat(util.sqlSelect("facturasprov", "total", "idfactura = " + curRecibo.valueBuffer("idfactura")));
  if (importe < 0)
  {
    reg += "C";
  } else {
    reg += "A";
  }

  //Importe de la factura
  importe = util.roundFieldValue(importe, "facturasprov", "total");
  importe = this.iface.quitarPuntoDecimales(importe);
  reg += flfactppal.iface.pub_cerosIzquierda(importe, 12);

  //Moneda de la factura
  reg += flfactppal.iface.pub_espaciosDerecha("", 3);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 10);

  //Código estadistico del banco de españa
  reg += flfactppal.iface.pub_espaciosDerecha("", 6);

  //Referencia de la factura enviada al cliente
  reg += flfactppal.iface.pub_espaciosDerecha(curRecibo.valueBuffer("codigo"), 16);

  //Neto de la factura
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  return reg;
}

/** \D Crea el texto del septimo registro individual por abono a proveedor
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroFacturas021(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "021";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente del pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  //Fecha de emisión de la factura (emisión del recibo)
  //  var fecha:Date = util.sqlSelect("facturasprov", "fecha", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  var fecha: Date = curRecibo.valueBuffer("fecha");
  var fechaEmision: String = flfactppal.iface.pub_cerosIzquierda(fecha.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fecha.getMonth().toString(), 2) + fecha.getYear().toString().right(4);
  reg += flfactppal.iface.pub_espaciosDerecha(fechaEmision, 8);

  //Fecha de vencimiento de la factura (vencimiento del recibo)
  //  var fecha:Date = curRecibo.valueBuffer("fecha");
  var fecha: Date = curRecibo.valueBuffer("fechav");
  var fechaVencimiento: String = flfactppal.iface.pub_cerosIzquierda(fecha.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fecha.getMonth().toString(), 2) + fecha.getYear().toString().right(4);
  reg += flfactppal.iface.pub_espaciosDerecha(fechaVencimiento, 8);

  //Instrumento de pago de la factura
  reg += "TR";

  //Concepto de la factura
  var concepto: String = "Recibo: " + curRecibo.valueBuffer("codigo");
  reg += flfactppal.iface.pub_espaciosDerecha(concepto, 67);

  return reg;
}

function oficial_registroFacturas022(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "022";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Código del proveedor
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 12);

  var swift: String = util.sqlSelect("cuentasbcopro", "swift", "codcuenta = '" + curRecibo.valueBuffer("codcuenta") + "'");
  var paisSwift: String;
  if (swift)
  {
    paisSwift = swift.substring(4, 6);
  }
  if (paisSwift == "ES")
  {
    //Entidad destino del pago
    var entidad: String = curRecibo.valueBuffer("ctaentidad");
    if (!entidad || entidad == "") {
      MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Entidad.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    reg += flfactppal.iface.pub_espaciosDerecha(entidad, 4);

    //Sucursal destino del pago
    var sucursal: String = curRecibo.valueBuffer("ctaagencia");
    if (!sucursal || sucursal == "") {
      MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Sucursal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    reg += flfactppal.iface.pub_espaciosDerecha(sucursal, 4);

    //Dígito de control de la cuenta destino del pago
    var dc: String = curRecibo.valueBuffer("dc");
    if (!dc || dc == "") {
      MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: D.C.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    reg += flfactppal.iface.pub_espaciosDerecha(dc, 2);

    //Número de cuenta destino del pago
    var cuenta: String = curRecibo.valueBuffer("cuenta");
    if (!cuenta || cuenta == "") {
      MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Cuenta.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    reg += flfactppal.iface.pub_espaciosDerecha(cuenta, 10);
  } else {
    reg += flfactppal.iface.pub_espaciosDerecha("", 20);
  }

  //Código IBAN de la cuenta del proveedor
  var iban: String = util.sqlSelect("cuentasbcopro", "iban", "codcuenta = '" + curRecibo.valueBuffer("codcuenta") + "'");
  if (iban)
  {
    reg += flfactppal.iface.pub_espaciosDerecha(iban, 34);
  } else {
    reg += flfactppal.iface.pub_espaciosDerecha("", 34);
  }

  //Código SWIFT del banco destino de la transferencia
  var swift: String = util.sqlSelect("cuentasbcopro", "swift", "codcuenta = '" + curRecibo.valueBuffer("codcuenta") + "'");
  if (swift)
  {
    reg += flfactppal.iface.pub_espaciosDerecha(swift, 11);
  } else {
    reg += flfactppal.iface.pub_espaciosDerecha("", 11);
  }

  //Pais destino de la transferencia
  var codIso: String = util.sqlSelect("paises", "codiso", "codpais = '" + curRecibo.valueBuffer("codpais") + "'");
  if (!codIso || codIso == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Cod.Iso del país.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codIso, 2);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 18);

  return reg;
}


/** \D Calcula el total del valor de recibos para el ordenante
@return Texto con el total para ser volcado a disco
\end */
function oficial_totales(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "099";
  this.iface.sumaRegistros++;

  //Código del ordenante del cliente pagador
  var codOrdenante: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!codOrdenante || codOrdenante == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el siguiente dato en el formulario de empresa: NIF\nDebe editar y corregir el formulario de empresa antes de generar el fichero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codOrdenante = codOrdenante.toString().toUpperCase();
  codOrdenante = codOrdenante.left(10);
  reg += flfactppal.iface.pub_espaciosDerecha(codOrdenante, 10);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);

  //Importe total de la remesa
  var impRemesa: String = util.roundFieldValue(cursor.valueBuffer("total"), "remesasprov", "total");
  impRemesa = this.iface.quitarPuntoDecimales(impRemesa);
  reg += flfactppal.iface.pub_cerosIzquierda(impRemesa, 12);

  //Número total de facturas de la remesa
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaFacturas, 10);

  //Nümero de registros de la remesa
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegistros, 10);

  //Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 53);

  return reg;
}

function oficial_quitarPuntoDecimales(dato: String): String {
  var res: String = "";
  var i: Number;
  var caracter: String;
  dato = dato.toString();
  for (i = 0; i < dato.length; i++)
  {
    caracter = dato.charAt(i);
    if (caracter && caracter != ".") {
      res += caracter;
    }
  }
  return res;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
