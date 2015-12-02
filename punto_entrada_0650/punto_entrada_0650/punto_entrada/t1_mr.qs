/***************************************************************************
                 t1_mr.qs  -  description
                             -------------------
    begin                : mie ago 17 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
  function muestraRelaciones()
  {
    return this.ctx.oficial_muestraRelaciones();
  }
  function eventFilter(o, e)
  {
    return this.ctx.oficial_eventFilter(o, e);
  }
  function drawIt(p)
  {
    return this.ctx.oficial_drawIt(p);
  }
  function pinta()
  {
    return this.ctx.oficial_pinta();
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
function interna_init()
{
  this.w_ = this.child("lblMR");
  this.w_.eventFilterFunction = this.name + ".iface.eventFilter";
  this.w_.allowedEvents = [ AQS.Paint, AQS.Close ];
  this.w_.installEventFilter(this.w_);

  //  this.iface.muestraRelaciones();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_muestraRelaciones()
{
  //  this.iface.tblRelaciones_.clear();
  var aElemento = formt1_principal.iface.pub_dameElementoActual();
  var _iPpal = formt1_principal.iface;

  var totalRelaciones = _iPpal.aRelaciones_.length;
  var nombreRel, card, textoRel;
  var aDatosRel;

  var lblMR = this.child("lblMR"); //this.child("gbxMR");

  var p = new QPainter;
  //  if (!p.begin(this.child("lblMR").paintDevice()))
  if (!p.begin(lblMR.paintDevice()))
    return;
  debug("pintando");
  var f = new Font;
  f.family = "times";
  f.pointSize = 18;
  f.bold = true;

  p.setFont(f);
  p.setWindow(0, 0, 500, 500);   // defines coordinate system

  for (var i = 0; i < 36; ++i) {
    var matrix = new QWMatrix;
    matrix.translate(250.0, 250.0);
    matrix.shear(0.0, 0.3);
    matrix.rotate(parseFloat(i * 10.0));
    p.setWorldMatrix(matrix);

    var c = new QColor(0, 0, 0);
    c.setHsv(i * 10, 255, 255);
    p.setBrush(c);
    p.drawRect(70, -10, 80, 10);

    var n = String("H=%1").argDec(i * 10);
    p.drawText(80 + 70 + 5, 0, n);
  }

  p.end();

  lblMR.update();
  return;

  var iFila = 0;
  for (var iRel = 0; iRel < totalRelaciones; iRel++) {
    nombreRel = this.iface.aRelaciones_[iRel]["nombre"];
    card = this.iface.aRelaciones_[iRel]["card"];
    aDatosRel = this.iface.dameDatosRelacion(aElemento["tipo"], aElemento["clave"], iRel);
    if (aDatosRel) {
      try  {
        if (aDatosRel["c"]["Cuenta"] == 0 && this.iface.aRelaciones_[iRel]["solomostrarsihay"]) {
          continue;
        }
        if (aDatosRel["c"]["Cuenta"] == 1) {
          card = "11";
        }
      } catch (e) {}
    }
    this.iface.tblRelaciones_.insertRows(iFila);
    this.iface.tblRelaciones_.setRowHeight(iFila, 32);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_IDREL, iRel);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_TIPO, nombreRel);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_CARD, card);
    this.iface.dibujarIconoTabla(this.iface.tblRelaciones_, iFila, this.iface.CR_ICONO, this.iface.aRelaciones_[iRel]["nombre"]);

    if (aDatosRel) {
      textoRel = this.iface.componTextoRel(this.iface.aRelaciones_[iRel]["textoRel"], aDatosRel);
      this.iface.tblRelaciones_.setText(iFila, this.iface.CR_DESC, textoRel);
    }
    iFila++;
  }
  return true;
}

function oficial_eventFilter(o, e)
{
  debug("e " + e.type);
  var _i = this.iface;
  switch (e.type) {
    case AQS.Paint:
      _i.pinta();
      break;
    case AQS.Close:
      killTimer(this.tid_);
      this.w_.removeEventFilter(this.w_);
      this.w_ = undefined;
      break;
  }
}

function oficial_pinta()
{
  if (this.w_ == undefined) {
    return;
  }
  var paint = new QPainter;
  paint.flush();
  paint.begin(this.w_.paintDevice());
  this.iface.drawIt(paint);
  paint.end();
}

function oficial_cargarDatos()
{
  var aElemento = formt1_principal.iface.pub_dameElementoActual();
  var _iPpal = formt1_principal.iface;

  var totalRelaciones = _iPpal.aRelaciones_.length;

}

function oficial_drawIt(p)
{
  var f = new Font;
  f.family = "times";
  f.pointSize = 18;
  f.bold = true;

  p.setFont(f);
  p.setWindow(0, 0, 1000, 1000);   // defines coordinate system
  //  p.setWindow(0, 0, this.w_.width, this.w_.height);   // defines coordinate system
  /* QRect v = paint->viewport();
          int d = QMIN( v.width(), v.height() );
  The device may not be square and we want the clock to be, so we find its current viewport and compute its shortest side.

          paint->setViewport( v.left() + (v.width()-d)/2,
                              v.top() + (v.height()-d)/2, d, d );*/

  var matrix = new QWMatrix;
  var diam = 500, dCir = 100,  dCirPpal = 150, x, y, r = -90 * Math.PI / 180;
  var rCir = dCir / 2, rCirPpal = dCirPpal / 2, radio = diam / 2;
  //  matrix.translate(radio + (rCir), radio + (rCir));
  matrix.translate(500, 500);
  //  matrix.shear(0.0, 0.3);
  //  matrix.rotate(parseFloat(i * 10.0));
  p.setWorldMatrix(matrix);

  var b2 = new QBrush(new Color("khaki")); //, AQS.Dense6Pattern);

  var _iPpal = formt1_principal.iface;
  var aElemento = formt1_principal.iface.pub_dameElementoActual();
  var tipo = aElemento["tipo"];

  var totalRelaciones = _iPpal.aRelaciones_.length;
  var numObjetos = totalRelaciones;
  var rad = (360 / numObjetos) * Math.PI / 180;
  var tipoRel;
  p.drawEllipse(0 - radio, 0 - radio, diam, diam)
  for (var i = 0; i < numObjetos; i++) {
    tipoRel = _iPpal.aRelaciones_[i]["nombre"]
              x = radio * Math.cos(r);
    y = radio * Math.sin(r);
    p.setBrush(b2);
    p.drawLine(0, 0, x, y);
    p.drawEllipse(x - (rCir), y - (rCir), dCir, dCir);
    var pixIcono = formt1_principal.iface.aElementos_[tipoRel]["icono"];
    if (pixIcono) {
      var r = new Rect(x - rCir, y - rCir, rCir, rCir);
      p.drawPixmap(r, pixIcono);
    }
    p.drawText(x, y, _iPpal.aRelaciones_[i]["nombre"]);
    r += rad;
  }
  var bE = new QBrush(new Color("DarkSeaGreen"));
  p.setBrush(bE);
  p.drawEllipse(0  - (rCirPpal), 0 - (rCirPpal), dCirPpal, dCirPpal);
  p.drawText(0, 0, aElemento["tipo"] + " " + aElemento["clave"]);

  //  var pixIcono = this.iface.aElementos_[tipo]["icono"];
  var pixIcono = formt1_principal.iface.aElementos_[tipo]["icono"];
  if (pixIcono) {
    var r = new Rect(0 - rCirPpal, 0 - rCirPpal, rCirPpal,  rCirPpal)
    p.drawPixmap(r, pixIcono);
  }

  var xmlPic = tipo in formt1_principal.iface.aElementos_ ? formt1_principal.iface.aElementos_[tipo]["xmlPic"] : false;
  if (!xmlPic) {
    xmlPic = formt1_principal.iface.damePicElementoDefecto(aElemento["tipo"]);
    if (!xmlPic) {
      return false;
    }
  }

  var pixSize = new Size(dCir, dCir);
  if (!formt1_principal.iface.dibujaPicture(p, xmlPic, pixSize, formt1_principal.iface.aDatosElemento_["c"])) {
    return false;
  }

  //   for (var i = 0; i < 36; ++i) {
  //     var matrix = new QWMatrix;
  //     matrix.translate(250.0, 250.0);
  //     matrix.shear(0.0, 0.3);
  //     matrix.rotate(parseFloat(i * 10.0));
  //     p.setWorldMatrix(matrix);
  //
  //     var c = new QColor(0, 0, 0);
  //     c.setHsv(i * 10, 255, 255);
  //     p.setBrush(c);
  //     p.drawRect(70, -10, 80, 10);
  //
  //     var n = String("H=%1").argDec(i * 10);
  //     p.drawText(80 + 70 + 5, 0, n);
  //   }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
