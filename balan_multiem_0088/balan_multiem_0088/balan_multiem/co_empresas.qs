/***************************************************************************
                 co_i_elerciciosempresas.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  function actualizarEjercicios(): Boolean { return this.ctx.oficial_actualizarEjercicios(); }
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
  connect(this.child("pbnActualizarEjercicios"), "clicked()", this, "iface.actualizarEjercicios");
}

/** \C Al aceptar el formulario verificamos que los ejercicios existen y pertenecen a
la empresa
*/
function interna_validateForm(): Boolean {
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_actualizarEjercicios()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.valueBuffer("nombrebd")) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar una empresa"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var nombreBD: String = cursor.valueBuffer("nombrebd");
  var conexion: String = nombreBD + "_conn";

  // Conectamos
  if (!flcontinfo.iface.pub_conectar(nombreBD))
    return;

  var curLoc: FLSqlCursor = new FLSqlCursor("co_ejerciciosempresas");
  var curRem: FLSqlCursor = new FLSqlCursor("ejercicios", conexion);

  curRem.select();
  while (curRem.next()) {
    curLoc.select("nombrebd = '" + nombreBD + "' AND codejercicio = '" + curRem.valueBuffer("codejercicio") + "'");
    if (curLoc.first())
      continue;
    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();
    curLoc.setValueBuffer("nombrebd", nombreBD);
    curLoc.setValueBuffer("codejercicio", curRem.valueBuffer("codejercicio"));
    curLoc.setValueBuffer("nomejercicio", curRem.valueBuffer("nombre"));
    curLoc.commitBuffer();
  }

  flcontinfo.iface.pub_desconectar(conexion);
  this.child("tdbEjerciciosEmpresa").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
