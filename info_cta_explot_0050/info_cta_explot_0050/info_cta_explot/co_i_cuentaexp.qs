/***************************************************************************
                 co_i_cuentaexp.qs  -  description
                             -------------------
    begin                : mar jul 11 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
}

/** \C
La fecha de inicio del período del ejercicio no puede ser posterior a la fecha de fin. Las fechas deben estar comprendidas dentro del período del ejercicio.
\end */
function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();

  var fechaInicio: String = this.child("fdbFechaDesde").value();
  var fechaFin: String = this.child("fdbFechaHasta").value();

  if (util.daysTo(fechaInicio, fechaFin) < 0)
  {
    MessageBox.critical
    (util.
    translate("scripts", "La fecha de inicio debe ser menor que la de fin para el ejercicio 1"),
    MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (this.child("fdbEjercicio2").value())
  {
    fechaInicio = this.child("fdbFechaDesde2").value();
    fechaFin = this.child("fdbFechaHasta2").value();

    if (util.daysTo(fechaInicio, fechaFin) < 0) {
      MessageBox.critical
      (util.
      translate("scripts", "La fecha de inicio debe ser menor que la de fin para el ejercicio 2"),
      MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
