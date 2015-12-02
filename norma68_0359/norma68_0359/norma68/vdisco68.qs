/***************************************************************************
                      vdisco68.qs  -  description
                             -------------------
    begin                : mar jun 03 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  var contenidoArchivo: String;
  var datosCabPago: Array;
  var detallesPago: String;
  var zonaACabecera: String;
  var zonaABeneficiario: String;
  var zonaATotales: String;
  var zonaB: String;
  var zonaC: String;
  var zonaD: String;
  var sumaImportes: Number;
  var sumaRegistros: Number;
  var numeroPago: Number;
  var nDatoDetallePago: Number;
  const tamRegistro: Number = 100;

  // CÓDIGO DE IDENTIFICACIÓN: (se usa para el cálculo del dígito de control de números de pago). => Los dos primeros dígitos por la izquierda, que identifican el tipo de documento serán: 90 para pago domiciliado de residente y 91 para pago domiciliado de no residente. Los dos siguientes serán de interés para la entidad emisora,pudiendo aplicar aquellos que considere más convenientes para su organización.
  const codigoIdentificacion: Number = 9000;

  function oficial(context)
  {
    interna(context);
  }
  function establecerFichero()
  {
    return this.ctx.oficial_establecerFichero();
  }
  function cabeceraOrdenante(): String {
    return this.ctx.oficial_cabeceraOrdenante();
  }
  function cabeceraBeneficiario1(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_cabeceraBeneficiario1(curRecibo);
  }
  function cabeceraBeneficiario2(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_cabeceraBeneficiario2(curRecibo);
  }
  function cabeceraBeneficiario3(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_cabeceraBeneficiario3(curRecibo);
  }
  function cabeceraBeneficiario4(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_cabeceraBeneficiario4(curRecibo);
  }
  function cabeceraPago(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_cabeceraPago(curRecibo);
  }
  function detallePago(curRecibo: FLSqlCursor): String {
    return this.ctx.oficial_detallePago(curRecibo);
  }
  function totales(): String {
    return this.ctx.oficial_totales();
  }
  function calculoDCNumeroPago(): Number {
    return this.ctx.oficial_calculoDCNumeroPago();
  }
  function calcularDCIBAN(ccc: String): String {
    return this.ctx.oficial_calcularDCIBAN(ccc);
  }
  function crearCadenaCabPago(): String {
    return this.ctx.oficial_crearCadenaCabPago();
  }
  function moduloNumero(num, div)
  {
    return this.ctx.oficial_moduloNumero(num, div);
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
    child("fdbCodCuenta").setDisabled(true);
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
  var _i = this.iface;
  //En esta variable se irá guardando el contenido que se escribirá en el archivo. Pero sólo se escribirá al final.
  this.iface.contenidoArchivo = "";

  //Variable que guarda los datos de la cabecera de pago. Se vacía para cada nuevo pago.
  this.iface.datosCabPago = [];
  this.iface.datosCabPago["anterior"] = "";
  this.iface.datosCabPago["importe"] = 0;
  this.iface.datosCabPago["posterior"] = "";

  //Variable que guarda los detalles de pago. Se vacía para cada nuevo pago.
  this.iface.detallesPago = "";

  // Zona A: (2 dígitos/ NUM) Código de registro = 03
  this.iface.zonaACabecera = "03";
  this.iface.zonaABeneficiario = "06";
  this.iface.zonaATotales = "08";
  // Zona B: (2 dígitos/ NUM) Código de operación = 59 para euros.
  this.iface.zonaB = "59";
  // Zona C: (10 dígitos/ ALF) Código del ordenante: Un número identificativo de la Empresa u Organismo ordenante, que será siempre el mismo, aunque se entreguen soportes a diversas Entidades de Crédito (NIF, CIF, DNI, etc.). Es campo alfanumérico, ajustado a la derecha.
  var cifnif: String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
  this.iface.zonaC = flfactppal.iface.pub_espaciosIzquierda(cifnif, 9) + "000";

  this.iface.sumaImportes = 0;
  this.iface.sumaRegistros = 0;
  var datos: String;

  var file: Object = new File(this.child("ledFichero").text);
  file.open(File.WriteOnly);

  datos = this.iface.cabeceraOrdenante();
  if (!datos || datos.length != this.iface.tamRegistro) {
    debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
    debug("Cadena ***" + datos + "***");
    return;
  }
  this.iface.contenidoArchivo += datos + "\r\n";

  var curRecibos = new FLSqlCursor("recibosprov");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ") ORDER BY codproveedor");

  var codProvAnterior: String = "";
  this.iface.numeroPago = "0000000";
  var numPago: Number = parseInt(this.iface.numeroPago);
  this.iface.nDatoDetallePago = 15;

  var codRecibo, importe;
  while (curRecibos.next()) {
    codRecibo = curRecibos.valueBuffer("codigo");

    importe = Math.round(curRecibos.valueBuffer("importe") * 100);
    _i.sumaImportes += importe;
    // debug("procesando recibo " + codRecibo);
    // debug("Importe " + curRecibos.valueBuffer("importe") + ". Suma importes " + this.iface.sumaImportes);

    // El número de veces que podrá repetirse el mismo número de pago no podrá excederse de 29, si fuera necesario hacerlo se asignaría un nuevo número de pago.
    if ((codProvAnterior != curRecibos.valueBuffer("codproveedor")) || (this.iface.nDatoDetallePago == 44)) {
      if (this.iface.datosCabPago["anterior"] != "") {
        // Si hay datos de cabecera de pago se guardan en el contenido del archivo y se vacían.
        datos = this.iface.crearCadenaCabPago();
        if (!datos || datos.length != this.iface.tamRegistro) {
          if (!datos) {
            return;
          }
          MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cadena de cabecera de pago). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
          debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
          debug("Cadena ***" + datos + "***");
          return;
        }
        this.iface.contenidoArchivo += datos + "\r\n";
        this.iface.contenidoArchivo += this.iface.detallesPago;
        this.iface.datosCabPago = [];
        this.iface.datosCabPago["anterior"] = "";
        this.iface.datosCabPago["importe"] = 0;
        this.iface.datosCabPago["posterior"] = "";
        this.iface.detallesPago = "";
      }
      numPago ++;
      this.iface.numeroPago = flfactppal.iface.pub_cerosIzquierda(numPago, 7).left(7);
      var dcPago: Number = this.iface.calculoDCNumeroPago();
      this.iface.numeroPago = this.iface.numeroPago + dcPago.toString();

      this.iface.nDatoDetallePago = 15;

      var nifProveedor: String = curRecibos.valueBuffer("cifnif");
      if (!nifProveedor || nifProveedor == "") {
        if (!datos) {
          return;
        }
        MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: N.I.F.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibos.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      nifProveedor = nifProveedor.toString().toUpperCase();
      // Zona D: Código del Proveedor: (12 dígitos) Código de identificación fijado por el ordenante distinto para cada proveedor y que será el mismo para todas sus facturas. Debe ser el NIF.
      this.iface.zonaD = flfactppal.iface.pub_espaciosDerecha(nifProveedor, 12).right(12);

      datos = this.iface.cabeceraBeneficiario1(curRecibos);
      if (!datos || datos.length != this.iface.tamRegistro) {
        if (!datos) {
          return;
        }
        MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cabecera beneficiario 1). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
        debug("Cadena ***" + datos + "***");
        return;
      }
      this.iface.contenidoArchivo += datos + "\r\n";

      datos = this.iface.cabeceraBeneficiario2(curRecibos);
      if (!datos || datos.length != this.iface.tamRegistro) {
        if (!datos) {
          return;
        }
        MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cabecera beneficiario 2). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
        debug("Cadena ***" + datos + "***");
        return;
      }
      this.iface.contenidoArchivo += datos + "\r\n";

      datos = this.iface.cabeceraBeneficiario3(curRecibos);
      if (!datos || datos.length != this.iface.tamRegistro) {
        if (!datos) {
          return;
        }
        MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cabecera beneficiario 3). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
        debug("Cadena ***" + datos + "***");
        return;
      }
      this.iface.contenidoArchivo += datos + "\r\n";

      datos = this.iface.cabeceraBeneficiario4(curRecibos);
      if (!datos || datos.length != this.iface.tamRegistro) {
        if (!datos) {
          return;
        }
        MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cabecera beneficiario 4). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
        debug("Cadena ***" + datos + "***");
        return;
      }
      this.iface.contenidoArchivo += datos + "\r\n";

      this.iface.cabeceraPago(curRecibos);

      codProvAnterior = curRecibos.valueBuffer("codproveedor");
    }
    datos = this.iface.detallePago(curRecibos);
    if (!datos || datos.length != this.iface.tamRegistro) {
      if (!datos) {
        return;
      }
      MessageBox.warning(sys.translate("Error al procesar el recibo %1 (detalle de pago). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
      debug("Cadena ***" + datos + "***");
      return;
    }
    this.iface.detallesPago += datos + "\r\n";
    this.iface.nDatoDetallePago ++;
  }

  if (this.iface.datosCabPago["anterior"] != "") {
    // Si hay datos de cabecera de pago se guardan en el contenido del archivo.
    datos = this.iface.crearCadenaCabPago();
    if (!datos || datos.length != this.iface.tamRegistro) {
      if (!datos) {
        return;
      }
      MessageBox.warning(sys.translate("Error al procesar el recibo %1 (cabecera de pago). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
      debug("Cadena ***" + datos + "***");
      return;
    }
    this.iface.contenidoArchivo += datos + "\r\n";
    this.iface.contenidoArchivo += this.iface.detallesPago;

  }

  datos = this.iface.totales(curRecibos.size());
  if (!datos || datos.length != this.iface.tamRegistro) {
    if (!datos) {
      return;
    }
    MessageBox.warning(sys.translate("Error al procesar el recibo %1 (totales). La longitud (%2) no es la correcta (%3)").arg(codRecibo).arg(datos.length).arg(_i.tamRegistro), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
    debug("Cadena ***" + datos + "***");
    return;
  }
  this.iface.contenidoArchivo += datos + "\r\n";

  file.write(this.iface.contenidoArchivo);
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
  MessageBox.information(util.translate("scripts", "Generado fichero de Cuaderno 68 en: \n\n%1\n\n").arg(this.child("ledFichero").text), MessageBox.Ok, MessageBox.NoButton);
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

/** \D Crea el texto de cabecera del cliente ordenante
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante(): String {
  var util: FLUtil = new FLUtil();

  var date: Date = new Date();
  var fecha = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

  var idRemesa: Number = this.cursor().valueBuffer("idremesa");
  var codCuenta: String = this.cursor().valueBuffer("codCuenta");
  if (!codCuenta || codCuenta == "")
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener la cuenta de cargo."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var cuenta = util.sqlSelect("cuentasbanco", "cuenta", "codcuenta = '" + codCuenta + "'");
  if (!cuenta)
  {
    debug(1);
    return false;
  }
  var entidad = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + codCuenta + "'");
  if (!entidad)
  {
    debug(2);
    return false;
  }
  var oficina = util.sqlSelect("cuentasbanco", "ctaagencia", "codcuenta = '" + codCuenta + "'");
  if (!oficina)
  {
    debug(3);
    return false;
  }
  var dc = util.calcularDC(entidad + oficina) + util.calcularDC(cuenta);
  if (!dc)
  {
    debug(4);
    return false;
  }

  // Cálculo del dígito de contro del codigo IBAN
  var dcIBAN = this.iface.calcularDCIBAN(entidad + oficina + dc + cuenta)
  if (!dcIBAN)
  {
    debug(5);
    return false;
  }
  var reg = this.iface.zonaACabecera + this.iface.zonaB + this.iface.zonaC;
  // Zona D: (12 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 12);
  // Zona E: (3 dígitos/ NUM) Número de dato = 001
  reg += "001";
  // Zona F: (6 dígitos/ NUM) Fecha de creación del fichero (DDMMAA)
  reg += fecha;
  // G: (9 dígitos) Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 9);
  // H: (9 dígitos) IBAN de la cuenta de cargo
  // H1: (4 dígitos) Letras ES mas dígitos de control
  reg += "ES" + dcIBAN;
  // H2: (4 dígitos) Código de la entidad
  reg += flfactppal.iface.pub_cerosIzquierda(entidad, 4).right(4);
  // H3: (4 dígitos) Código de la oficina
  reg += flfactppal.iface.pub_cerosIzquierda(oficina, 4).right(4);
  // H4: (2 dígitos) Digitos de control
  reg += flfactppal.iface.pub_cerosIzquierda(dc, 2).right(2);
  // H5: (10 dígitos) Nº de cuenta
  reg += flfactppal.iface.pub_cerosIzquierda(cuenta, 10).right(10);
  // I: (30 dígitos) Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 30);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del primer registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraBeneficiario1(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var nomProveedor: String = curRecibo.valueBuffer("nombreproveedor");
  if (!nomProveedor || nomProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Nombre del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nomProveedor = nomProveedor.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;

  // Zona E: Número de dato (3 dígitos) = 010
  reg += "010";
  // Zona F: Nombre del beneficiario. Ajustado a la izquierda y completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(nomProveedor, 40);
  // G: Libre
  reg += flfactppal.iface.pub_espaciosDerecha("", 29);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del segundo registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraBeneficiario2(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var dirProveedor: String = curRecibo.valueBuffer("direccion");
  if (!dirProveedor || dirProveedor == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Direcci�n.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  dirProveedor = dirProveedor.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 011
  reg += "011";
  // Zona F: Domicilio del beneficiario. Ajustado a la izquierda, completado con blancos-
  reg += flfactppal.iface.pub_espaciosDerecha(dirProveedor, 45).left(45);
  // Zona G: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 24);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del tercer registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraBeneficiario3(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var codPostal: String = curRecibo.valueBuffer("codpostal");
  if (!codPostal || codPostal == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código Postal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codPostal = codPostal.toString().toUpperCase();

  var ciudad: String = curRecibo.valueBuffer("ciudad");
  if (!ciudad || ciudad == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Ciudad.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ciudad = ciudad.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 012
  reg += "012";
  // Zona F:
  // Zona F1: Código postal del beneficiario del pago. Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(codPostal, 5).left(5);
  // Zona F2: Plaza del beneficiario del pago. Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(ciudad, 40).left(40);
  // Zona G:
  reg += flfactppal.iface.pub_espaciosDerecha("", 24);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del cuarto registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraBeneficiario4(curRecibo: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var codPostal: String = curRecibo.valueBuffer("codpostal");
  if (!codPostal || codPostal == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Código Postal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  codPostal = codPostal.toString().toUpperCase();

  var provincia: String = curRecibo.valueBuffer("provincia");
  if (!provincia || provincia == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Provincia.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  provincia = provincia.toString().toUpperCase();

  var pais: String = util.sqlSelect("paises", "nombre", "codpais = '" + curRecibo.valueBuffer("codpais") + "'");
  if (!pais || pais == "")
  {
    MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Pais.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  pais = pais.toString().toUpperCase();

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 012
  reg += "013";
  // Zona F:
  // Zona F1: Código postal del beneficiario del pago. Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(codPostal, 9).left(9);
  // Zona F2: Provincia del beneficiario del pago. Ajustado a la izquierda, completado con blancos. Puede omitirse en el caso de que la plaza sea la capital.
  reg += flfactppal.iface.pub_espaciosDerecha(provincia, 30).left(30);
  // Zona F3: Pais del beneficiario del pago. Ajustado a la izquierda, completado con blancos.
  reg += flfactppal.iface.pub_espaciosDerecha(pais, 20).left(20);
  // Zona G:
  reg += flfactppal.iface.pub_espaciosDerecha("", 10);

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del quinto registro de la cabecera de pago
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraPago(curRecibo)
{
  var util: FLUtil = new FLUtil();

  var fechaV = curRecibo.valueBuffer("fechav");
  if (!fechaV || fechaV == "") {
    MessageBox.warning(util.translate("scripts", "Error al obtener la fecha de pago correspondiente a la remesa"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var fecha = flfactppal.iface.pub_cerosIzquierda(fechaV.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fechaV.getMonth().toString(), 2) + fechaV.getYear().toString().right(4);

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 014
  reg += "014";
  // Zona F:
  // Zona F1: Número de pago. Formado por 7 caracteres numéricos más un dígito de control. Deberá ser el mismo para todos los registros que compongan un pago. Asímismo, no podrá repetirse el mismo número de pago, para una misma cuenta ordenante a no ser que hubiera sido previamente anulado, pagado o revocado, el emitido en primer lugar.
  reg += this.iface.numeroPago;
  // Zona F2: Fecha de pago. Será la misma para un mismo número de pago. Formato ddmmaaaa.
  reg += fecha;
  // Zona F3: Importe con dos posiciones decimales sin reflejar la coma. Ajustado a la derecha completado con ceros a la izquierda, cuando sea necesario. Será la suma de los importes de los registros de detalle que compongan un pago, teniendo en cuenta su signo.
  this.iface.datosCabPago["anterior"] = reg;
  reg = "";
  //Se guardan separados en contenido anterior, el importe y el contenido posterior de la cabecera de pago para poder ir sumando al importe (inicialmente 0) los importes de los detalles de pago.
  this.iface.datosCabPago["importe"] = 0;
  // Zona F4: Indicativo de presentación.
  //      0 - Presentación.
  //      1 - Anulación. Cuando un cliente desee anular un pago comunicado en una remesa anterior, siempre que lo comunique con antelación suficiente al vencimiento del pago, debiendo informar de todos los datos anteriores (nº pago, fecha, importe).
  reg += "0";
  // Zona F5: Código ISO del país del beneficiario del pago. El pago a No Residentes cuando el importe de los pagos a un mismo beneficiario supere la cantidad establecida en cada momento para informar a Balanza de Pagos. Cuando se trate de residentes este campo vendrá a BLANCOS.
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);
  // Zona F6: Código estadístico del concepto de pago. Mismas condiciones que el campo anterior.
  reg += flfactppal.iface.pub_espaciosDerecha("", 6);
  // Zona G: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 32);

  this.iface.datosCabPago["posterior"] = reg;

  this.iface.sumaRegistros++;
  return reg;
}

/** \D Crea el texto del séptimo registro de detalle de pago
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_detallePago(curRecibo)
{
  var util: FLUtil = new FLUtil();

  var fechaF: Date = util.sqlSelect("facturasprov", "fecha", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  if (!fechaF || fechaF == "") {
    MessageBox.warning(util.translate("scripts", "Error al obtener la fecha de factura correspondiente al recibo %1").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var fechaFactura = flfactppal.iface.pub_cerosIzquierda(fechaF.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fechaF.getMonth().toString(), 2) + fechaF.getYear().toString().right(4);

  var numFactura: String = util.sqlSelect("facturasprov", "codigo", "idfactura = " + curRecibo.valueBuffer("idfactura"));
  if (!numFactura || numFactura == "") {
    MessageBox.warning(util.translate("scripts", "Error al obtener el numero de factura de proveedor correspondiente al recibo %1").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }


  //  var total:Number = parseFloat(util.sqlSelect("facturasprov", "total", "idfactura = " + curRecibo.valueBuffer("idfactura")));
  //  if(!total)
  //    total = 0;
  var total = curRecibo.valueBuffer("importe"); /// Aunque la norma dice "importe de la factura" tiene que ser el del recibo
  total = isNaN(total) ? 0 : total;

  this.iface.datosCabPago["importe"] += parseFloat(total);

  total *= 100;

  var signo = "H";
  if (total < 0) {
    signo = "D";
    total *= -1;
  }
  total = Math.round(total);
  var importe = total.toString();

  var concepto = "";

  var reg: String = this.iface.zonaABeneficiario + this.iface.zonaB + this.iface.zonaC + this.iface.zonaD;
  // Zona E: Número de dato (3 dígitos) = 016
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.nDatoDetallePago, 3);
  // Zona F:
  // Zona F1: Número de pago. El mismo registro que el contenido de Cabecera de Pago
  reg += this.iface.numeroPago;
  // Zona F2: Referencia de factura de pago. Deberá ser diferente para cada Registro de Detalle de un mismo pago.
  reg += flfactppal.iface.pub_cerosIzquierda(numFactura, 12);
  // Zona F3: Fecha de emisión de la factura de pago con formato DDMMAAAA.
  reg += fechaFactura
         // Zona F4: Importe de la factura de pago, con dos posiciones decimales sin reflejar la coma, ajustado a la derecha, completado con ceros a la izquierda, cuando sea necesario.
         reg += flfactppal.iface.pub_cerosIzquierda(importe, 12);
  // Zona F5: Signo del importe D negativo, H positivo.
  reg += signo;
  // Zona F6: Concepto por el que se efectúa el pago. Ajustado a la izquierda completado con blancos.
  var concepto: String = "Pago rec. " + curRecibo.valueBuffer("codigo");
  if (concepto.length > 26)
    concepto = concepto.left(26);
  reg += flfactppal.iface.pub_espaciosDerecha(concepto, 26);
  // Zona G: Libre (2). Esto no viene en la especificación pero es necesario para que el total sea 100.
  reg += flfactppal.iface.pub_espaciosDerecha("", 2);

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
  // F2: Número total de registros que contenga el soporte, incluidos los de Cabecera y el propio de Totales.
  reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegistros, 10);
  // F3: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 42);
  // G: Libre.
  reg += flfactppal.iface.pub_espaciosDerecha("", 5);

  return reg;
}

function oficial_calculoDCNumeroPago(): Number {
  var util: FLUtil;

  var numero: Number = parseFloat(this.iface.codigoIdentificacion.toString() + this.iface.numeroPago);
  var resto: Number = numero % 7;

  return resto;
}

function oficial_calcularDCIBAN(ccc: String): String {
  var _i = this.iface;
  if (!ccc || ccc.length != 20)
    return "";

  // CALCULO Digito Control IBAN:
  //  - Crear códgigo previo como:  + C.C.C. + Código del pais (ES) + 00.
  //  - Sustituir las letras por números: E=14 ; S=28.
  var codigoAuxiliar = ccc + "142800";
  //  - Aplicar MOD 97: calcular MOD 97 (resto del adivisión por 97 del IBAN creado).
  var dcIBAN = _i.moduloNumero(codigoAuxiliar, 97)
  // Estableciendo la diferencia entre 98 y el resto, si el resultado es un dÃ­gito anteponer un 0.
  dcIBAN = 98 - dcIBAN;
  dcIBAN = flfactppal.iface.pub_cerosIzquierda(dcIBAN, 2);
  return dcIBAN;
}

function oficial_moduloNumero(num, div)
{
  var d, i = 0, a = 1;
  var parcial = 0;
  for (i = num.length - 1; i >= 0 ; i--) {
    d = parseInt(num.charAt(i));
    parcial += (d * a);
    a = (a * 10) % div;
  }
  return parcial % div;
}

function oficial_crearCadenaCabPago()
{
  var util: FLUtil;

  var reg: String = "";

  reg += this.iface.datosCabPago["anterior"];

  var importe = parseFloat(this.iface.datosCabPago["importe"]);
  importe = isNaN(importe) ? 0 : importe;

  importe = util.roundFieldValue(importe, "facturasprov", "total") * 100;

  importe = Math.round(importe);

  reg += flfactppal.iface.pub_cerosIzquierda(importe.toString(), 12).right(12);
  reg += this.iface.datosCabPago["posterior"];

  return reg;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
