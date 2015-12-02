/***************************************************************************
                              tec_printer.qs
                             -------------------
    begin                : mar jul 24 2012
    copyright            : (C) 2003-2012 by InfoSiAL S.L.
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
  var ctx;
  function interna(context)
  {
    this.ctx = context;
  }
  function main()
  {
    this.ctx.interna_main();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var w_;
  var printerName_;
  var activePrintJob_;
  var cmdsPrintJob_;

  function oficial(context)
  {
    interna(context);
  }
  function convertToHex(data)
  {
    return this.ctx.oficial_convertToHex(data);
  }
  function tecToEscHex(str)
  {
    return this.ctx.oficial_tecToEscHex(str);
  }

  function beginPrintJob()
  {
    this.ctx.oficial_beginPrintJob();
  }
  function endPrintJob()
  {
    this.ctx.oficial_endPrintJob();
  }

  function setPrinterName(printerName)
  {
    this.ctx.oficial_setPrinterName(printerName);
  }
  function sendCmd(strCmd, printerName)
  {
    this.ctx.oficial_sendCmd(strCmd, printerName);
  }
  function testPrinter()
  {
    this.ctx.oficial_testPrinter();
  }

  function setLabelSize(pitchLen, printWidth, printLen, paperWidth)
  {
    this.ctx.oficial_setLabelSize(pitchLen, printWidth, printLen, paperWidth);
  }
  function issueLabel(aaaa, bbbcdefgh)
  {
    this.ctx.oficial_issueLabel(aaaa, bbbcdefgh);
  }
  function posFineAdjust(abbb, cddd, eff)
  {
    this.ctx.oficial_posFineAdjust(abbb, cddd, eff);
  }
  function printDensityFineAdjust(abb, c)
  {
    this.ctx.oficial_printDensityFineAdjust(abb, c);
  }
  function imageBufferClear()
  {
    this.ctx.oficial_imageBufferClear();
  }
  function clearArea(aaaa, bbbb, cccc, dddd, e)
  {
    this.ctx.oficial_clearArea(aaaa, bbbb, cccc, dddd, e);
  }
  function drawLine(aaaa, bbbb, cccc, dddd, e, f, ggg)
  {
    this.ctx.oficial_drawLine(aaaa, bbbb, cccc, dddd, e, f, ggg);
  }
  function bitmapFontFormat(aaa, bbbb, cccc, d, e, ff, ghh, ii, j, Jkkll,
                            Mm, noooooooooo, Zpp, Pq)
  {
    this.ctx.oficial_bitmapFontFormat(aaa, bbbb, cccc, d, e, ff, ghh, ii, j, Jkkll,
                                      Mm, noooooooooo, Zpp, Pq)
  }
  function outlineFontFormat(aa, bbbb, cccc, dddd, eeee, f, ghhh, ii, j, Mk,
                             lmmmmmmmmmm, Znn, Po)
  {
    this.ctx.oficial_outlineFontFormat(aa, bbbb, cccc, dddd, eeee, f, ghhh, ii, j, Mk,
                                       lmmmmmmmmmm, Znn, Po);
  }
  function barCodeFormat(aa, bbbb, cccc, d, e, ff, k, llll, mnnnnnnnnnn, ooo, p, qq)
  {
    this.ctx.oficial_barCodeFormat(aa, bbbb, cccc, d, e, ff, k, llll, mnnnnnnnnnn, ooo, p, qq);
  }
  function bitmapFontData(aaa, str)
  {
    this.ctx.oficial_bitmapFontData(aaa, str);
  }
  function outlineFontData(aa, str)
  {
    this.ctx.oficial_outlineFontData(aa, str);
  }
  function barCodeData(aa, str)
  {
    this.ctx.oficial_barCodeData(aa, str);
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
  function pub_beginPrintJob()
  {
    this.beginPrintJob();
  }
  function pub_endPrintJob()
  {
    this.endPrintJob();
  }
  function pub_setPrinterName(printerName)
  {
    this.setPrinterName(printerName);
  }
  function pub_sendCmd(strCmd, printerName)
  {
    return this.sendCmd(strCmd, printerName);
  }
  function pub_setLabelSize(pitchLen, printWidth, printLen, paperWidth)
  {
    this.setLabelSize(pitchLen, printWidth, printLen, paperWidth);
  }
  function pub_issueLabel(aaaa, bbbcdefgh)
  {
    this.issueLabel(aaaa, bbbcdefgh);
  }
  function pub_posFineAdjust(abbb, cddd, eff)
  {
    this.posFineAdjust(abbb, cddd, eff)
  }
  function pub_printDensityFineAdjust(abb, c)
  {
    this.printDensityFineAdjust(abb, c);
  }
  function pub_imageBufferClear()
  {
    this.imageBufferClear();
  }
  function pub_clearArea(aaaa, bbbb, cccc, dddd, e)
  {
    this.clearArea(aaaa, bbbb, cccc, dddd, e);
  }
  function pub_drawLine(aaaa, bbbb, cccc, dddd, e, f, ggg)
  {
    this.drawLine(aaaa, bbbb, cccc, dddd, e, f, ggg);
  }
  function pub_bitmapFontFormat(aaa, bbbb, cccc, d, e, ff, ghh, ii, j, Jkkll,
                                Mm, noooooooooo, Zpp, Pq)
  {
    this.bitmapFontFormat(aaa, bbbb, cccc, d, e, ff, ghh, ii, j, Jkkll,
                          Mm, noooooooooo, Zpp, Pq)
  }
  function pub_outlineFontFormat(aa, bbbb, cccc, dddd, eeee, f, ghhh, ii, j, Mk,
                                 lmmmmmmmmmm, Znn, Po)
  {
    this.outlineFontFormat(aa, bbbb, cccc, dddd, eeee, f, ghhh, ii, j, Mk,
                           lmmmmmmmmmm, Znn, Po);
  }
  function pub_barCodeFormat(aa, bbbb, cccc, d, e, ff, k, llll, mnnnnnnnnnn, ooo, p, qq)
  {
    this.barCodeFormat(aa, bbbb, cccc, d, e, ff, k, llll, mnnnnnnnnnn, ooo, p, qq);
  }
  function pub_bitmapFontData(aaa, str)
  {
    this.bitmapFontData(aaa, str);
  }
  function pub_outlineFontData(aa, str)
  {
    this.outlineFontData(aa, str);
  }
  function pub_barCodeData(aa, str)
  {
    this.barCodeData(aa, str);
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
function interna_main()
{
  var _i = this.iface;
  var mng = aqApp.db().managerModules();
  var w = mng.createUI("tec_printer.ui");

  _i.w_ = w;

  var settings = new AQSettings;
  var key = "TEC_PRINTER/";
  w.child("lePrinterName").text = settings.readEntry(key + "printerName");
  w.child("teCmds").text = settings.readEntry(key + "Cmds");

  connect(w.child("pbTest"), "clicked()", _i, "testPrinter()");
  w.exec();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_convertToHex(data)
{
  var str = "";
  var j = (data >> 4) & 15;
  if (j <= 9)
    str += j.toString();
  else
    str += String.fromCharCode(j + 55);
  j = data & 15;
  if (j <= 9)
    str += j.toString();
  else
    str += String.fromCharCode(j + 55);
  return str;
}

function oficial_tecToEscHex(str)
{
  var _i = this.iface;

  var s = "ESC:";
  for (var i = 0; i < str.length; ++i) {
    var ch = str.charAt(i);

    if (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r')
      continue;

    if (i > 0)
      s += ',';

    if (ch == '{') {
      s += "1B";
      continue;
    }

    if (ch == '}') {
      s += "00";
      continue;
    }

    if (ch == '|') {
      s += "0A";
      continue;
    }

    if (ch == '[') {
      ++i;
      switch (str.charAt(i)) {
        case 'E':
          s += "1B";
          i += 3;
          break;
        case 'L':
          s += "0A";
          i += 2;
          break;
        case 'N':
          s += "00";
          i += 3;
          break;
        default:
          debug("ERROR EN SECUENCIA");
      }
      continue;
    }

    s += _i.convertToHex(str.charCodeAt(i));
  }

  return s;
}

function oficial_beginPrintJob()
{
  var _i = this.iface;

  if (_i.activePrintJob_) {
    debug("beginPrintJob(): Ya hay un trabajo de impresión iniciado");
    return;
  }
  _i.activePrintJob_ = true;
  _i.cmdsPrintJob_ = "";
}

function oficial_endPrintJob()
{
  var _i = this.iface;

  if (!_i.activePrintJob_) {
    debug("endPrintJob: No hay ningún trabajo de impresión iniciado");
    return;
  }
  _i.activePrintJob_ = false;
  if (!_i.cmdsPrintJob_ || _i.cmdsPrintJob_.isEmpty()) {
    debug("endPrintJob: No hay comandos en el trabajo de impresión activo");
    return;
  }

  debug(_i.printerName_ + ": " + _i.cmdsPrintJob_);

  var printer = new FLPosPrinter;
  printer.setPrinterName(_i.printerName_);
  printer.send(_i.tecToEscHex(_i.cmdsPrintJob_));
  printer.flush();
  _i.cmdsPrintJob_ = "";
}

function oficial_setPrinterName(printerName)
{
  var _i = this.iface;

  _i.printerName_ = printerName;
}

function oficial_sendCmd(strCmd, printerName)
{
  var _i = this.iface;

  if (_i.activePrintJob_) {
    _i.cmdsPrintJob_ += strCmd;
    return;
  }

  if (!printerName)
    printerName = _i.printerName_;

  debug(printerName + ": " + strCmd);

  var printer = new FLPosPrinter;
  printer.setPrinterName(printerName);
  printer.send(_i.tecToEscHex(strCmd));
  printer.flush();
}

function oficial_testPrinter()
{
  var _i = this.iface;

  if (!_i.w_ || _i.w_ == undefined)
    return;

  var strCmd = _i.w_.child("teCmds").text;
  var printerName = _i.w_.child("lePrinterName").text;

  var settings = new AQSettings;
  var key = "TEC_PRINTER/";
  settings.writeEntry(key + "printerName", printerName);
  settings.writeEntry(key + "Cmds", strCmd);

  if (strCmd.startsWith("//QSA CODE")) {
    try {
      eval(strCmd);
    } catch (e) {
      sys.errorMsgBox("" + e);
    }
  } else
    _i.sendCmd(strCmd, printerName);
}

function oficial_setLabelSize(pitchLen, printWidth, printLen, paperWidth)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]";
  cmd += pitchLen;
  cmd += "," + printWidth;
  cmd += "," + printLen;
  if (paperWidth)
    cmd += "," + paperWidth;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_issueLabel(aaaa, bbbcdefgh)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]XS;I";
  cmd += "," + aaaa;
  cmd += "," + bbbcdefgh;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_posFineAdjust(abbb, cddd, eff)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]AX;";
  cmd += abbb;
  cmd += "," + cddd;
  cmd += "," + eff;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_printDensityFineAdjust(abb, c)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]AY;";
  cmd += abb;
  cmd += "," + c;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_imageBufferClear()
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]C";
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_clearArea(aaaa, bbbb, cccc, dddd, e)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]XR;";
  cmd += aaaa;
  cmd += "," + bbbb;
  cmd += "," + cccc;
  cmd += "," + dddd;
  cmd += "," + e;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_drawLine(aaaa, bbbb, cccc, dddd, e, f, ggg)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]LC;";
  cmd += aaaa;
  cmd += "," + bbbb;
  cmd += "," + cccc;
  cmd += "," + dddd;
  cmd += "," + e;
  cmd += "," + f;
  if (ggg)
    cmd += "," + ggg;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_bitmapFontFormat(aaa, bbbb, cccc, d, e, ff, ghh, ii, j, Jkkll,
                                  Mm, noooooooooo, Zpp, Pq)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]PC";
  cmd += aaa + ";";
  cmd += bbbb;
  cmd += "," + cccc;
  cmd += "," + d;
  cmd += "," + e;
  cmd += "," + ff;

  if (ghh)
    cmd += "," + ghh;

  cmd += "," + ii;
  cmd += "," + j;

  if (Jkkll)
    cmd += "," + Jkkll;

  if (Mm)
    cmd += "," + Mm;

  if (noooooooooo)
    cmd += "," + noooooooooo;

  if (Zpp)
    cmd += "," + Zpp;

  if (Pq)
    cmd += "," + Pq;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_outlineFontFormat(aa, bbbb, cccc, dddd, eeee, f, ghhh, ii, j, Mk,
                                   lmmmmmmmmmm, Znn, Po)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]PV";
  cmd += aa + ";";
  cmd += bbbb;
  cmd += "," + cccc;
  cmd += "," + dddd;
  cmd += "," + eeee;
  cmd += "," + f;

  if (ghhh)
    cmd += "," + ghhh;

  cmd += "," + ii;
  cmd += "," + j;

  if (Mk)
    cmd += "," + Mk;

  if (lmmmmmmmmmm)
    cmd += "," + lmmmmmmmmmm;

  if (Znn)
    cmd += "," + Znn;

  if (Po)
    cmd += "," + Po;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_barCodeFormat(aa, bbbb, cccc, d, e, ff, k, llll, mnnnnnnnnnn, ooo, p, qq)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]XB";
  cmd += aa + ";";
  cmd += bbbb;
  cmd += "," + cccc;
  cmd += "," + d;
  cmd += "," + e;
  cmd += "," + ff;
  cmd += "," + k;
  cmd += "," + llll;

  if (mnnnnnnnnnn)
    cmd += "," + mnnnnnnnnnn;

  if (ooo)
    cmd += "," + ooo;

  if (p)
    cmd += "," + p;

  if (qq)
    cmd += "," + qq;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_bitmapFontData(aaa, str)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]RC";
  cmd += aaa + ";";
  cmd += str;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_outlineFontData(aa, str)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]RV";
  cmd += aa + ";";
  cmd += str;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}

function oficial_barCodeData(aa, str)
{
  var _i = this.iface;

  var cmd = "";

  cmd += "[ESC]RB";
  cmd += aa + ";";
  cmd += str;
  cmd += "[LF][NUL]";

  _i.sendCmd(cmd);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
