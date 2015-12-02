/***************************************************************************
                 sincrocatalogo.qs  -  description
                             -------------------
    begin                : jue nov 11 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
  function tbnSincronizar_clicked()
  {
    return this.ctx.oficial_tbnSincronizar_clicked();
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

  //  _i.mgr_ = aqApp.db().manager();

  connect(this.child("tbnSincronizar"), "clicked()", _i, "tbnSincronizar_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnSincronizar_clicked()
{
  var _i = this.iface;
  try {
    var logName = flfactalma.iface.pub_ponLogName("sincro_catalogo");

    if (!flfactppal.iface.pub_abreLogFile(logName, "/home/santiago/sincro_catalogo.txt")) {
      sys.infoMsgBox("No se ha creado el fichero del log de la sincronización.");
    }
    if (!flfactalma.iface.pub_conectarSinc("CX_CENTRAL")) {
      if (!flfactppal.iface.pub_appendTextToLogFile(logName, "Error en la conexión")) {
        sys.infoMsgBox("Error en la conexión.");
        return false;
      }
    }
    if (!flfactalma.iface.pub_sincronizarTrans(false)) {
      return false;
    }

    var observaciones: String = flfactalma.iface.pub_dameResultadosSincro();
    this.child("fdbObservaciones").setValue(observaciones);

    if (!flfactppal.iface.pub_appendTextToLogFile(logName, "Sincronización completa. Debe aceptar el formulario para fijar los cambios en la base de datos")) {
      sys.infoMsgBox("Sincronización completa. Debe aceptar el formulario para fijar los cambios en la base de datos");
    }
    sys.infoMsgBox("Sincronización completa. Debe aceptar el formulario para fijar los cambios en la base de datos");
  } catch (e) {
    sys.infoMsgBox("Errores en la sincronización: " + e);
    return false;
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
