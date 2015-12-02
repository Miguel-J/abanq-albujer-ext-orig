/***************************************************************************
                      vdiscosr.qs  -  description
                             -------------------
    begin                : jue mar 29 2007
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
  var totalOpPago: Number;
  var totalOpDev: Number;
  var importeTotal: Number;

  function oficial(context)
  {
    interna(context);
  }
  function establecerFichero()
  {
    return this.ctx.oficial_establecerFichero();
  }
  function cabeceraPresentador(): String {
    return this.ctx.oficial_cabeceraPresentador();
  }
  function individualOperacion(cursor: FLSqlCursor): String {
    return this.ctx.oficial_individualOperacion(cursor);
  }
  function totalGeneral(): String {
    return this.ctx.oficial_totalGeneral();
  }
  function from10toradix(v: String, radix: Number): String {
    return this.ctx.oficial_from10toradix(v, radix);
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
  var cursor: FLSqlCursor = this.cursor();

  this.child("fdbDivisa").setDisabled(true);
  this.child("pushButtonAcceptContinue").close();
  this.child("pushButtonFirst").close();
  this.child("pushButtonLast").close();
  this.child("pushButtonNext").close();
  this.child("pushButtonPrevious").close();

  if (cursor.modeAccess() == cursor.Edit) {
    var qry: FLSqlQuery = new FLSqlQuery();

    qry.setTablesList("remesas");
    qry.setSelect("comercio,clavecomercio,terminal");
    qry.setFrom("remesas");
    qry.setWhere("idremesa <> " + cursor.valueBuffer("idremesa"));
    qry.setForwardOnly(true);

    if (qry.exec() && qry.first()) {
      if (cursor.isNull("comercio"))
        cursor.setValueBuffer("comercio", qry.value(0));
      if (cursor.isNull("clavecomercio"))
        cursor.setValueBuffer("clavecomercio", qry.value(1));
      if (cursor.isNull("terminal"))
        cursor.setValueBuffer("terminal", qry.value(2));
    }
  }

  connect(this.child("pbExaminar"), "clicked()", this, "iface.establecerFichero");
}

/** \C El nombre del fichero de destino debe indicarse
\end */
function interna_validateForm(): Boolean {
  if (this.child("leFichero").text.isEmpty())
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
  this.iface.totalOpPago = 0;
  this.iface.totalOpDev = 0;
  this.iface.importeTotal = 0;

  var fileAux: Object = new File(this.child("leFichero").text);
  var fileName: String = Dir.cleanDirPath(fileAux.path + "/" + fileAux.baseName.left(26) + ".txt");

  var file: Object = new File(fileName);
  file.open(File.WriteOnly);

  file.write(this.iface.cabeceraPresentador() + "\r\n");

  var curRecibos: FLSqlCursor = new FLSqlCursor("reciboscli");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolcli WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ")");
  while (curRecibos.next())
    file.write(this.iface.individualOperacion(curRecibos) + "\r\n");

  file.write(this.iface.totalGeneral() + "\r\n");

  file.close();

  var util: FLUtil = new FLUtil();
  MessageBox.information(util.translate("scripts", "Generado fichero de operaciones para ServiRed en: \n\n%1\n\n").arg(this.child("leFichero").text), MessageBox.Ok, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
  var fileName: String = FileDialog.getSaveFileName("*.txt");
  var fileAux: Object = new File(fileName);

  fileName = Dir.cleanDirPath(fileAux.path + "/" + fileAux.baseName.left(26) + ".txt");

  this.child("leFichero").text = fileName;
}

/** \D Crea el texto de cabecera con los datos del presentador de la remesa
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraPresentador(): String {
  var util: FLUtil = new FLUtil();
  var reg: String = "012.0";
  var codcuenta: String = this.cursor().valueBuffer("codcuenta");
  var entidad: String = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + codcuenta + "'");
  var comercio: String = this.cursor().valueBuffer("comercio");
  var date: Date = new Date();

  var fecha: String = date.getYear().toString() +
  flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) +
  flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) +
  " " +
  flfactppal.iface.pub_cerosIzquierda(date.getHours().toString(), 2) +
  flfactppal.iface.pub_cerosIzquierda(date.getMinutes().toString(), 2) +
  flfactppal.iface.pub_cerosIzquierda(date.getSeconds().toString(), 2);

  reg += fecha;
  reg += flfactppal.iface.pub_cerosIzquierda(entidad, 4).right(4);
  reg += flfactppal.iface.pub_cerosIzquierda(comercio, 9).right(9);

  return reg;
}

/** \D Crea un registro de operaciones

@param cursor Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_individualOperacion(cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var reg: String = "02";

  var codDec: String = cursor.valueBuffer("codigo");
  var codHex: String = this.iface.from10toradix(codDec.mid(6, 6), 16);
  var codAll: String = codDec.left(6) + codHex + codDec.right(3);
  var identificador: String = flfactppal.iface.pub_espaciosDerecha(codAll.replace(/00/g, "$"), 12).left(12);
  var tipoOp: String = "10";
  var tipoPago: String = "0";
  var tipoDatos: String = "0";

  var importeNum: Number = parseFloat(cursor.valueBuffer("importe"));
  var pedidoBase: String = "";

  if (importeNum < 0.0)
  {
    tipoOp = "30";
    importeNum = importeNum * (-1.0);
    pedidoBase = cursor.valueBuffer("pedido");
    this.iface.totalOpDev++;
  } else
    this.iface.totalOpPago++;

  this.iface.importeTotal += importeNum;

  var importe: String = flfactppal.iface.pub_cerosIzquierda(util.buildNumber(importeNum, "f", 2), 13).right(13);
  var tarjeta: String = "";
  var caducidad: String = "";
  var cvc2: String = "";
  var monedaISO = "";

  if (tipoOp == "10" || tipoOp == "20")
  {
    tarjeta = flfactppal.iface.pub_cerosIzquierda(cursor.valueBuffer("numerocc"), 19).right(19);
    caducidad = flfactppal.iface.pub_cerosIzquierda(cursor.valueBuffer("anocc").right(2), 2) + flfactppal.iface.pub_cerosIzquierda(cursor.valueBuffer("mescc"), 2);
    cvc2 = flfactppal.iface.pub_espaciosDerecha(cursor.valueBuffer("cvvcc"), 5);
    monedaISO = util.sqlSelect("divisas", "codiso", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");

    if (!monedaISO)
      monedaISO = "978";
    else if (monedaISO.isEmpty())
      monedaISO = "978";

    monedaISO = flfactppal.iface.pub_cerosIzquierda(monedaISO, 3).right(3);
  }

  var comercio: String = flfactppal.iface.pub_cerosIzquierda(this.cursor().valueBuffer("comercio"), 9).right(9);
  var terminal: String = flfactppal.iface.pub_cerosIzquierda(this.cursor().valueBuffer("terminal"), 2).right(2);
  var claveComercio: String = this.cursor().valueBuffer("clavecomercio");

  reg += identificador + tipoOp + tipoPago + tipoDatos;
  if (tipoOp == "10" || tipoOp == "20")
    reg += tarjeta + caducidad + cvc2 + importe + monedaISO;
  else
    reg += importe + pedidoBase;
  reg += comercio + terminal;

  var firma: String = flfactppal.iface.pub_espaciosDerecha(util.sha1(reg + claveComercio), 40);

  reg += firma;

  return reg;
}

/** \D Calcula el total del valor de recibos general

@return Texto con el total para ser volcado a disco
\end */
function oficial_totalGeneral(): String {
  var util: FLUtil = new FLUtil();
  var reg: String = "03";

  var totalOp: String = flfactppal.iface.pub_cerosIzquierda(this.iface.totalOpPago + this.iface.totalOpDev, 6).right(6);
  var totalOpPago: String = flfactppal.iface.pub_cerosIzquierda(this.iface.totalOpPago, 6).right(6);
  var totalOpDev: String = flfactppal.iface.pub_cerosIzquierda(this.iface.totalOpDev, 6).right(6);
  var totalOpPreAut: String = flfactppal.iface.pub_cerosIzquierda("0", 6);
  var totalOpConf: String = flfactppal.iface.pub_cerosIzquierda("0", 6);
  var importeTotal: String = flfactppal.iface.pub_cerosIzquierda(util.buildNumber(this.iface.importeTotal, "f", 2), 16).right(16);

  reg += totalOp + totalOpPago + totalOpPreAut + totalOpDev + totalOpConf;
  reg += importeTotal;

  return reg;
}

function oficial_from10toradix(v: String, radix: Number): String {
  var retval = '';
  var ConvArray = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F');
  var intnum;
  var tmpnum;
  var i = 0;

  intnum = parseInt(v, 10);
  if (isNaN(intnum))
  {
    retval = 'NaN';
  } else {
    while (intnum > 0.9)
    {
      i++;
      tmpnum = intnum;
      retval = ConvArray[tmpnum % radix] + retval;
      intnum = Math.floor(tmpnum / radix);
      if (i > 100) {
        retval = 'NaN';
        break;
      }
    }
  }

  return retval;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
