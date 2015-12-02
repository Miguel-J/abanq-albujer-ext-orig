/***************************************************************************
                 cl_averiasrevisionmaquina.qs  -  description
                             -------------------
    begin                : mar ene 29 2008
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
    return this.ctx.interna_init();
  }
  function calculateCounter(): String {
    return this.ctx.interna_calculateCounter();
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
  function verificarHabilitaciones()
  {
    return this.ctx.oficial_verificarHabilitaciones();
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
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  /// Gestión documental
  if (sys.isLoadedModule("flcolagedo")) {
    var datosGD: Array;
    datosGD["txtRaiz"] = cursor.valueBuffer("codaveria") + " - " + cursor.valueBuffer("descripcion");
    datosGD["tipoRaiz"] = "cl_averiasrevisionmaquina";
    datosGD["idRaiz"] = cursor.valueBuffer("codaveria");
    flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
  } else {
    this.child("tbwDatosAVM").setTabEnabled("gesdocu", false);
  }

  this.iface.verificarHabilitaciones();
}

function interna_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  return util.nextCounter("codaveria", this.cursor());
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "baja": {
      if (this.child("fdbBaja").value() == false) {
        cursor.setNull("fechainiciobaja");
        cursor.setNull("fechafinbaja");
        cursor.setNull("fdbCausaBaja");
      }
      this.iface.verificarHabilitaciones();
      break;
    }
  }
}

function oficial_verificarHabilitaciones()
{
  if (this.child("fdbBaja").value() == false) {
    this.child("fdbFInicioBaja").setDisabled(true);
    this.child("fdbFFinBaja").setDisabled(true);
    this.child("fdbCausaBaja").setDisabled(true);
  } else {
    this.child("fdbFInicioBaja").setDisabled(false);
    this.child("fdbFFinBaja").setDisabled(false);
    this.child("fdbCausaBaja").setDisabled(false);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
