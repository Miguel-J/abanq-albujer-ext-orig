/***************************************************************************
                 promociones.qs  -  description
                             -------------------
    begin                : lun may 21 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function init()
  {
    this.ctx.interna_init();
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
  var _i = this.iface;
  var cursor = this.cursor();
  this.child("fdbDuracion").setDisabled(true);
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  _i.bufferChanged("desde");
  this.child("fdbCantidadTotal").close();
  this.child("fdbDtoEquivalente").close();
}

function interna_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var duracion = this.child("fdbDuracion").value();

  if (duracion <= 0) {
    MessageBox.critical(AQUtil.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial*/
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "cantidad1":
    case "cantidad2":
    case "cantidad3":
    case "cantidad4":
    case "cantidad5":
    case "dtocantidad1":
    case "dtocantidad2":
    case "dtocantidad3":
    case "dtocantidad4":
    case "dtocantidad5": {
      var totalCantidad = parseFloat(this.child("fdbCantidad1").value()) + parseFloat(this.child("fdbCantidad2").value()) + parseFloat(this.child("fdbCantidad3").value()) + parseFloat(this.child("fdbCantidad4").value()) + parseFloat(this.child("fdbCantidad5").value());
      var porcentajeTotal = parseFloat(this.child("fdbCantidad1").value()) * parseFloat(this.child("fdbDtoCantidad1").value()) + parseFloat(this.child("fdbCantidad2").value()) * parseFloat(this.child("fdbDtoCantidad2").value())  + parseFloat(this.child("fdbCantidad3").value()) * parseFloat(this.child("fdbDtoCantidad3").value()) + parseFloat(this.child("fdbCantidad4").value()) * parseFloat(this.child("fdbDtoCantidad4").value())  + parseFloat(this.child("fdbCantidad5").value()) * parseFloat(this.child("fdbDtoCantidad5").value()) ;
      var dtoEquiv = porcentajeTotal / totalCantidad;
      this.child("fdbCantidadTotal").setValue(totalCantidad);
      this.child("fdbDtoEquivalente").setValue(dtoEquiv);
      break;
    }
    case "desde":
    case "hasta": {
      var desde = this.child("fdbDesde").value();
      var hasta = this.child("fdbHasta").value();
      this.child("fdbDuracion").setValue(AQUtil.daysTo(desde, hasta));
      break;
    }
  }
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
