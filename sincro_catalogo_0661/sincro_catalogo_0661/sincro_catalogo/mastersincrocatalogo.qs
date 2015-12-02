/***************************************************************************
                 mastersincrocatalogo.qs  -  description
                             -------------------
    begin                : lun nov 15 2010
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
  var logFile_;
  function oficial(context)
  {
    interna(context);
  }
  /**function sincroCatalogo() {
    return this.ctx.oficial_sincroCatalogo();
  }*/
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
  /**function pub_sincroCatalogo() {
    return this.sincroCatalogo();
  }*/
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
/** \C La tabla de regularizaciones de stocks se muestra en modo de sólo lectura
\end */
function interna_init()
{
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** Esto estaba hecho antes de modificar la sincronización para hacerla más genérica.
function oficial_sincroCatalogo()
{
  debug("Entra!");
  var util = new FLUtil;
  var _i = this.iface;

  var cursor = new FLSqlCursor("tpv_tiendas");
  var msg;
  var h = new Date;
  var sH = h.toString().left(10);
  var sT = h.toString().right(8);
  _i.logFile_ = new File(Dir.home + "/sincro_catalogo_" + sH + ".log");
  _i.logFile_.open(File.WriteOnly);
  _i.logFile_.writeLine(util.translate("scripts", "%1. Inicio sincronización").arg(sT));

  if (!formRecordsincrocatalogo.iface.conectar()) {
    msg = util.translate("scripts", "Error en la conexión");
    _i.logFile_.writeLine(msg);
    _i.logFile_.close();
    return false;
  }
  if (!formRecordsincrocatalogo.iface.sincronizarTrans(true)) {
    msg = util.translate("scripts", "Error en la sincronización");
    _i.logFile_.writeLine(msg);
  }
  var observaciones = formRecordsincrocatalogo.iface.dameResultadosSincro();
  if (observaciones && observaciones != "") {
    var l = observaciones.split("\n");
    for (var i = 0; i < l.length; i++) {
      _i.logFile_.writeLine(l[i]);
    }
  }
  h = new Date;
  var sT = h.toString().right(8);
  _i.logFile_.writeLine(util.translate("scripts", "%1. Fin sincronización").arg(sT));
  _i.logFile_.close();
}*/

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
