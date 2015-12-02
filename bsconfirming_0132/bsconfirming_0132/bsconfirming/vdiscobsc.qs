/***************************************************************************
                      vdiscobsc.qs  -  description
                             -------------------
    begin                : jue mar 08 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  /*
    var zonaA:String;
    var zonaB:String;
    var zonaC:String;
    var zonaD:String;
    var idCaixa:String;
    var sumaRegIndi:Number;
  */
  var sumaImportes: Number;
  var cuentaOrdenes: Number;
  var nifOrdenante: String;

  function oficial(context)
  {
    interna(context);
  }
  function establecerFichero()
  {
    return this.ctx.oficial_establecerFichero();
  }
  function formatoMoneda(valor: String, longitud: Number): String {
    return this.ctx.oficial_formatoMoneda(valor, longitud);
  }
  function formatoFecha(fecha: Date): String {
    return this.ctx.oficial_formatoFecha(fecha);
  }
  function cabeceraLote(): String {
    return this.ctx.oficial_cabeceraLote();
  }
  function datosOrden(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_datosOrden(curRecibo);
  }
  function datosCompOrden(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_datosCompOrden(curRecibo);
  }
  function totales(): String {
    return this.ctx.oficial_totales();
  }
  function soloNumeros(texto: String): String {
    return this.ctx.oficial_soloNumeros(texto);
  }
  function eliminarEspaciosIzquierda(cadena: String): String {
    return this.ctx.oficial_eliminarEspaciosIzquierda(cadena);
  }
  /*
    function cabecera1():String {
      return this.ctx.oficial_cabecera1();
    }
    function cabecera2():String {
      return this.ctx.oficial_cabecera2();
    }
    function cabecera3():String {
      return this.ctx.oficial_cabecera3();
    }
    function cabecera4():String {
      return this.ctx.oficial_cabecera4();
    }
    function individualObligatorio1(curRecibo:FLSqlCursor):String {
      return this.ctx.oficial_individualObligatorio1(curRecibo);
    }
    function individualObligatorio2(curRecibo:FLSqlCursor):String {
      return this.ctx.oficial_individualObligatorio2(curRecibo);
    }
    function individualObligatorio3(curRecibo:FLSqlCursor):String {
      return this.ctx.oficial_individualObligatorio3(curRecibo);
    }
    function individualOpcional4(restoDir:String):String {
      return this.ctx.oficial_individualOpcional4(restoDir);
    }
    function individualObligatorio5(curRecibo:FLSqlCursor):String {
      return this.ctx.oficial_individualObligatorio5(curRecibo);
    }
  */
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
  /*
    this.iface.sumaRegIndi = 0;
  */

  this.iface.sumaImportes = 0;
  this.iface.cuentaOrdenes = 0;
  this.iface.nifOrdenante = "";

  var file: Object = new File(this.child("ledFichero").text);

  file.open(File.WriteOnly);

  var linea: String;
  linea = this.iface.cabeceraLote();
  if (!linea)
    return;
  file.write(linea + "\r\n");

  /*
    file.write(this.iface.cabecera2() + "\r\n");
    file.write(this.iface.cabecera3() + "\r\n");
    file.write(this.iface.cabecera4() + "\r\n");
  */
  var curRecibos: FLSqlCursor = new FLSqlCursor("recibosprov");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ")");
  while (curRecibos.next()) {
    linea = this.iface.datosOrden(curRecibos);
    if (!linea)
      return;
    file.write(linea + "\r\n");

    linea = this.iface.datosCompOrden(curRecibos);
    if (!linea)
      return;
    file.write(linea + "\r\n");
    /*
        file.write(this.iface.individualObligatorio2(curRecibos) + "\r\n");
        file.write(this.iface.individualObligatorio3(curRecibos) + "\r\n");
        file.write(this.iface.individualObligatorio5(curRecibos) + "\r\n");
    */
  }

  linea = this.iface.totales();
  if (!linea)
    return;
  file.write(linea + "\r\n");

  file.close();

  // Genera copia del fichero en codificacion ISO
  // ### Por hacer: Incluir mas codificaciones
  file.open(File.ReadOnly);
  var content = file.read();
  file.close();

  var fileIso = new File(this.child("ledFichero").text + ".iso8859");

  fileIso.open(File.WriteOnly);
  fileIso.write(sys.fromUnicode(content, "ISO-8859-15"));
  fileIso.close();


  var util: FLUtil = new FLUtil();
  MessageBox.information(util.translate("scripts", "Generado fichero de recibos BS Confirming en: \n\n%1\n\n").arg(this.child("ledFichero").text), MessageBox.Ok, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_formatoMoneda(valor: String, longitud: Number): String {
  var util: FLUtil = new FLUtil;
  var resultado: String = "";
  var sufijo: String;

  if (!valor || isNaN(valor))
    valor = 0;

  valor = valor * 100;
  if (valor < 0)
  {
    valor = valor * -1;
    sufijo = "-";
  } else {
    sufijo = "+";
  }

  valor = Math.round(valor);
  resultado = flfactppal.iface.pub_cerosIzquierda(valor, longitud - 1);
  resultado += sufijo;

  return resultado;
}

function oficial_formatoFecha(fecha: Date): String {
  var fechaString: String = fecha.toString();
  var resultado = fechaString.left(4) + fechaString.mid(5, 2) + fechaString.mid(8, 2);
  return resultado;
}

function oficial_establecerFichero()
{
  this.child("ledFichero").text = FileDialog.getSaveFileName("*.*");
}

/** \D Crea el texto de cabecera del primer registro obligatorio
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraLote(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "";
  // Código de registro (1). 1
  reg += "1";
  // Reservado (2). En blanco;
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // Nombre ordenante (40)
  var nombre: String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
  nombre = nombre.left(40);
  reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40);
  // Fecha de la remesa (8)
  var fecha: String = this.iface.formatoFecha(cursor.valueBuffer("fecha"));
  reg += fecha;
  // NIF Ordenante (9)
  var nif: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  if (!nif || nif.length != 9)
  {
    MessageBox.warning(util.translate("scripts", "El formato del CIF de la empresa no es correcto"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nif = nif.left(9);
  this.iface.nifOrdenante = flfactppal.iface.pub_espaciosDerecha(nif, 9);
  reg += this.iface.nifOrdenante;
  // Tipo de lote (2). 65
  reg += "65";
  // Forma de envío (1). B
  reg += "B";
  // Cuenta de cargo (20)
  var qryCuenta: FLSqlQuery = new FLSqlQuery;
  with(qryCuenta)
  {
    setTablesList("cuentasbanco");
    setSelect("ctaentidad, ctaagencia, cuenta");
    setFrom("cuentasbanco");
    setWhere("codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
    setForwardOnly(true);
  }
  if (!qryCuenta.exec())
    return false;
  if (!qryCuenta.first())
  {
    return false;
  }
  var datosCuenta: String = qryCuenta.value("ctaentidad") + qryCuenta.value("ctaagencia") + util.calcularDC(qryCuenta.value("ctaentidad") + qryCuenta.value("ctaagencia")) +  util.calcularDC(qryCuenta.value("cuenta")) + qryCuenta.value("cuenta");
  if (datosCuenta.length != 20)
  {
    MessageBox.warning(util.translate("scripts", "El formato de la cuenta %1 es incorrecto.").arg(cursor.valueBuffer("codcuenta")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += datosCuenta;
  // Código activo de contrato Sabadell BS Confirming (12)
  var codBS: String = flfactppal.iface.pub_valorDefectoEmpresa("codbsconfirming");
  if (!codBS || codBS == "")
  {
    MessageBox.warning(util.translate("scripts", "El código activo de BS Confirming del formulario de empresa\nno está informado o no tiene 12 caracteres."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_cerosIzquierda(codBS, 12);;
  // Código fichero. Valor KF01 (4)
  reg += "KF01";
  // Reservado. No obligatorio (201)
  reg += flfactppal.iface.pub_espaciosDerecha("", 201);

  return reg;
}

/** \D Crea el texto de cabecera del registro de datos de la orden
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_datosOrden(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  var codRecibo: String = curRecibo.valueBuffer("codigo");
  var importe: Number = parseFloat(curRecibo.valueBuffer("importe"));

  var reg: String = "";
  // Código de registro (1). 2
  reg += "2";
  // Código proveedor (15).
  reg += flfactppal.iface.pub_espaciosDerecha(codProveedor, 15);
  // Tipo de documento (2).
  reg += "02"; //CIF
  // Documento identificativo (12).
  var nifCif: String = util.sqlSelect("proveedores", "cifnif", "codproveedor = '" + codProveedor + "'");
  if (!nifCif || nifCif.length < 9)
  {
    MessageBox.warning(util.translate("scripts", "El formato del CIF/NIF del proveedor %1 no es correcto").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(nifCif, 12);
  // Forma de pago (1).
  reg += "C"; // Cheque
  // Cuenta nacional de abono del proveedor (20)
  /*
    var codCuenta:String = curRecibo.valueBuffer("codcuenta");
    if (!codCuenta || codCuenta == "") {
      MessageBox.warning(util.translate("scripts", "No hay definida ninguna cuenta para el recibo %1.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  */
  /*
  var qryCuenta:FLSqlQuery = new FLSqlQuery;
  with (qryCuenta) {
    setTablesList("cuentasbcopro");
    setSelect("ctaentidad, ctaagencia, cuenta");
    setFrom("cuentasbcopro");
    setWhere("codcuenta = '" + codCuenta + "'");
    setForwardOnly(true);
  }
  if (!qryCuenta.exec())
    return false;
  if (!qryCuenta.first()) {
    return false;
  }
  datosCuenta = qryCuenta.value("ctaentidad") + qryCuenta.value("ctaagencia") + util.calcularDC(qryCuenta.value("ctaentidad") + qryCuenta.value("ctaagencia")) +  util.calcularDC(qryCuenta.value("cuenta")) + qryCuenta.value("cuenta");
  if (datosCuenta.length != 20) {
    MessageBox.warning(util.translate("scripts", "El formato de la cuenta %1 del recibo %2 es incorrecto.").arg(codCuenta).arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += datosCuenta;
  */
  reg += flfactppal.iface.pub_espaciosDerecha("", 20);

  // Número de factura (15)
  var numFactura: String = util.sqlSelect("facturasprov", "numproveedor", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  if (!numFactura || numFactura == "")
  {
    numFactura = util.sqlSelect("facturasprov", "codigo", "idfactura = " + curRecibo.valueBuffer("idfactura"));
    if (!numFactura || numFactura == "") {
      MessageBox.warning(util.translate("scripts", "No tiene especificado el número de factura de proveedor para el recibo %1.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  numFactura = numFactura.left(15);
  reg += flfactppal.iface.pub_espaciosDerecha(numFactura, 15);
  // Importe factura (15)
  reg += this.iface.formatoMoneda(importe, 15);
  // Fecha emisión factura (8)
  reg += this.iface.formatoFecha(curRecibo.valueBuffer("fecha"));
  // Fecha vencimiento factura (8)
  reg += this.iface.formatoFecha(curRecibo.valueBuffer("fechav"));
  // Referencia factura ordenante (15). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha(codRecibo, 30);
  // Barrado cheque (1). Oblogatorio sólo en caso de cheque. Valor "S"
  reg += "S"; //flfactppal.iface.pub_espaciosDerecha("", 1);
  // Fecha emisión pagaré (8). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha("", 8);
  // Fecha vencimiento pagaré (8). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha("", 8);
  // Tipo pagaré (1). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha("", 1);
  // Reservado (155). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha("", 155);

  this.iface.cuentaOrdenes++;
  this.iface.sumaImportes += importe;

  return reg;
}

/** \D Crea el texto de cabecera del registro de datos complementarios a la orden
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_datosCompOrden(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var codProveedor: String = curRecibo.valueBuffer("codproveedor");
  var codRecibo: String = curRecibo.valueBuffer("codigo");

  var reg: String = "";
  // Código de registro (1). 3
  reg += "3";
  // Nombre proveedor (40).
  var nombre: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
  nombre = nombre.left(40);
  reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40);
  // Idioma proveedor (2).
  reg += "08"; // Español
  // Domicilio proveedor (67).
  var qryDireccion: FLSqlQuery = new FLSqlQuery;
  with(qryDireccion)
  {
    setTablesList("dirproveedores,paises");
    setSelect("direccion, ciudad, codpostal, codiso");
    setFrom("dirproveedores LEFT OUTER JOIN paises ON dirproveedores.codpais = paises.codpais");
    setWhere("codproveedor = '" + codProveedor + "' AND direccionppal = true");
    setForwardOnly(true);
  }
  if (!qryDireccion.exec())
    return false;
  if (!qryDireccion.first())
  {
    MessageBox.warning(util.translate("scripts", "El proveedor %1 no tiene una dirección principal definida.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var direccion: String = qryDireccion.value("direccion");
  direccion = direccion.left(67)
  direccion = this.iface.eliminarEspaciosIzquierda(direccion);
  reg += flfactppal.iface.pub_espaciosDerecha(direccion, 67);
  // Plaza proveedor (40).
  var direccion: String = qryDireccion.value("ciudad");
  direccion = direccion.left(40)
  reg += flfactppal.iface.pub_espaciosDerecha(direccion, 40);
  // Código postal proveedor (5).
  var codPostal: String = qryDireccion.value("codpostal");
  codPostal = codPostal.left(5)
  reg += flfactppal.iface.pub_espaciosDerecha(codPostal, 5);
  // Apartado correos proveedor (6). No obligatorio. No se utiliza.
  reg += flfactppal.iface.pub_espaciosDerecha("", 6);
  // Teléfono proveedor (15). No obligatorio.
  var telefono: String = util.sqlSelect("proveedores", "telefono1", "codproveedor = '" + codProveedor + "'");
  if (!telefono)
    telefono = "";
  telefono = this.iface.soloNumeros(telefono);
  telefono = telefono.left(15)
  reg += flfactppal.iface.pub_espaciosDerecha(telefono, 15);
  // Fax proveedor (15). No obligatorio.
  var fax: String = util.sqlSelect("proveedores", "fax", "codproveedor = '" + codProveedor + "'");
  if (!fax)
    fax = "";
  fax = this.iface.soloNumeros(fax);
  fax = fax.left(15)
  reg += flfactppal.iface.pub_espaciosDerecha(fax, 15);
  // Correo electrónico proveedor (60). No obligatorio.
  var email: String = util.sqlSelect("proveedores", "email", "codproveedor = '" + codProveedor + "'");
  if (!email)
    email = "";
  email = email.left(60)
  reg += flfactppal.iface.pub_espaciosDerecha(email, 60);
  // Tipo envío información (1)
  reg += "1"; //Correo ordinario
  // Código país domicilio
  var codIso: String = qryDireccion.value("codiso");
  if (!codIso || codIso == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el código I.S.O. en el formulario del país asociado al proveedor %1.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  reg += flfactppal.iface.pub_espaciosDerecha(codIso, 2);
  // Código país residencia (2). Reservado uso futuro.
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // Reservado (44). No obligatorio
  reg += flfactppal.iface.pub_espaciosDerecha("", 44);

  return reg;
}


/** \D Calcula el total del valor de recibos para el ordenante
@return Texto con el total para ser volcado a disco
\end */
function oficial_totales(): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var reg: String = "";
  // Código de registro (1). 5
  reg += "5";
  // NIF Ordenante (9)
  reg += this.iface.nifOrdenante;
  // Total órdenes (7)
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.cuentaOrdenes, 7);
  // Total importe de la remesa (15)
  reg += this.iface.formatoMoneda(this.iface.sumaImportes, 15);
  // Reservado (268)
  reg += flfactppal.iface.pub_espaciosDerecha("", 268);

  return reg;
}

function oficial_soloNumeros(texto: String): String {
  var valor: String = "";
  if (!texto || texto == "")
    return valor;

  for (var i: Number = 0; i < texto.length; i++)
  {
    switch (texto.charAt(i)) {
      case "0":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9": {
        valor += texto.charAt(i);
      }
    }
  }
  return valor;
}

function oficial_eliminarEspaciosIzquierda(cadena: String): String {
  var resultado: String = "";
  var caracter: String;
  var comenzado: Boolean = false;
  for (var i: Number = 0; i < cadena.length; i++)
  {
    caracter = cadena.charAt(i);
    if (comenzado) {
      resultado += caracter;
    } else {
      if (caracter != " ") {
        resultado += caracter;
        comenzado = true;
      }
    }
  }
  return resultado;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
