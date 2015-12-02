/***************************************************************************
                 calendariolab.qs  -  description
                             -------------------
    begin                : mar abr 10 2007
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

}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration calendariolab */
//////////////////////////////////////////////////////////////////
//// CALENDARIOLAB /////////////////////////////////////////////////////
class calendariolab extends oficial
{
  function calendariolab(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.calendariolab_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.calendariolab_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.calendariolab_calculateField(fN);
  }
  function dameIntervalo(tiempoInicio: Date, tiempoFin: Date): Number {
    return this.ctx.calendariolab_dameIntervalo(tiempoInicio, tiempoFin);
  }
}
//// CALENDARIOLAB /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends calendariolab
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
/**
end */

function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition calendariolab */
//////////////////////////////////////////////////////////////////
//// CALENDARIOLAB /////////////////////////////////////////////////////
function calendariolab_init()
{
  debug("SCRIPT CARGADO");
  this.iface.__init();
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function calendariolab_bufferChanged(fN: String)
{
  switch (fN) {
    case "horaentradamanana":
    case "horasalidamanana":
    case "horaentradatarde":
    case "horasalidatarde": {
      this.child("fdbTotalHoras").setValue(this.iface.calculateField("totalhoras"));
      break;
    }
  }
}

function calendariolab_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  ///hos
  switch (fN)
  {
    case "totalhoras": {
      var intervaloSegundos1: Number = this.iface.dameIntervalo(cursor.valueBuffer("horaentradamanana"), cursor.valueBuffer("horasalidamanana"));

      var intervaloSegundos2: Number = this.iface.dameIntervalo(cursor.valueBuffer("horaentradatarde"), cursor.valueBuffer("horasalidatarde"));

      valor = intervaloSegundos1 + intervaloSegundos2;
      break;
    }
  }
  return valor;
}

function calendariolab_dameIntervalo(tiempoInicio: Date, tiempoFin: Date): Number {
  debug(tiempoInicio);
  var tInicio: Date = new Date();
  var tFin: Date = new Date();
  debug(tInicio);
  if (tiempoInicio)
  {
    tInicio.setHours(tiempoInicio.getHours());
    tInicio.setMinutes(tiempoInicio.getMinutes());
    tInicio.setSeconds(tiempoInicio.getSeconds());
    debug(tInicio);
  } else{
    tInicio.setHours(0);
    tInicio.setMinutes(0);
    tInicio.setSeconds(0);

  }
  if (tiempoFin)
  {
    tFin.setHours(tiempoFin.getHours());
    tFin.setMinutes(tiempoFin.getMinutes());
    tFin.setSeconds(tiempoFin.getSeconds());
    debug(tFin);
  } else{
    tFin.setHours(0);
    tFin.setMinutes(0);
    tFin.setSeconds(0);
  }

  var msInicio: Number = tInicio.getTime();
  var msFin: Number = tFin.getTime();
  var segundos: Number = (msFin - msInicio) / 3600000;
  return segundos;
}

//// CALENDARIOLAB /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
