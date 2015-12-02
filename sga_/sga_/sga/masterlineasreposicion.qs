/***************************************************************************
                 masterlineasreposicion.qs  -  description
                             -------------------
    begin                : vie jun 06 2008
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
  var tdbLineasReposicion: FLTableDB;
  function oficial(context)
  {
    interna(context);
  }
  function salida()
  {
    return this.ctx.oficial_salida();
  }
  function entrada()
  {
    return this.ctx.oficial_entrada();
  }
  function generarEntrada(idLineaR: String): Boolean {
    return this.ctx.oficial_generarEntrada(idLineaR);
  }
  function generarSalida(idLineaR: String): Boolean {
    return this.ctx.oficial_generarSalida(idLineaR);
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
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.tdbLineasReposicion = this.child("tdbLineasReposicion");

  connect(this.child("tbnEntrada"), "clicked()", this, "iface.entrada()");
  connect(this.child("tbnSalida"), "clicked()", this, "iface.salida()");

  var idUsuario: String = sys.nameUser();
  var idReposicionActiva: String = util.sqlSelect("reposicion", "idreposicion", "idusuario = '" + idUsuario + "' AND estado = 'PTE'");
  if (!idReposicionActiva) {
    MessageBox.warning(util.translate("scripts", "No hay ninguna reposición en estado PTE para el usuario %1").arg(idUsuario), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  cursor.setMainFilter("idreposicion = " + idReposicionActiva);
  this.iface.tdbLineasReposicion.refresh();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_entrada()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idUsuario = sys.nameUser();

  if (!util.sqlDelete("entrada", "idusuario = '" + idUsuario + "'"))
    return;

  var entrada: Object = new FLFormSearchDB("entrada");
  var curEntrada: FLSqlCursor = entrada.cursor();
  curEntrada.setModeAccess(curEntrada.Insert);
  curEntrada.refreshBuffer();
  curEntrada.setValueBuffer("idusuario", idUsuario);

  entrada.setMainWidget();
  if (!entrada.exec("identrada"))
    return;

  if (!curEntrada.commitBuffer())
    return false;

  var idLineaR: String = util.sqlSelect("lineasreposicion", "idlineareposicion", "codubicaciondestino = '" + curEntrada.valueBuffer("codubicaciondestino") + "' AND referencia = '" + curEntrada.valueBuffer("referencia") + "' AND estadoentrada = 'PTE'");

  if (!idLineaR) {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de reposición que coincida con los datos introducidos en la entrada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var can: String = util.sqlSelect("lineasreposicion", "cantidad", "idlineareposicion = " + idLineaR);
  if (can != curEntrada.valueBuffer("cantotal")) {
    var res: Number = MessageBox.information(util.translate("scripts", "La cantidad de entrada no coincide con la cantidad de reposición.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
  }

  var curCommit: FLSqlCursor = new FLSqlCursor("reposicion");
  curCommit.transaction(false);
  try {
    if (this.iface.generarEntrada(idLineaR)) {
      curCommit.commit();
    } else {
      curCommit.rollback();
      return false;
    }
  } catch (e) {
    curCommit.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al generar la entrada: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}


function oficial_generarEntrada(idLineaR: String): Boolean {
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date();
  var curLineas: FLSqlCursor = new FLSqlCursor("lineasreposicion");
  curLineas.select("idlineareposicion = '" + idLineaR + "'");

  if (!curLineas.first())
  {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de reposición con ese indentificador"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLineas.setModeAccess(curLineas.Edit);
  curLineas.refreshBuffer();


  var curMov: FLSqlCursor = new FLSqlCursor("movimat");
  var cantidad: String = curLineas.valueBuffer("cantidad");

  //  Movimiento de entrada
  if (curLineas.valueBuffer("estadosalida") != 'HECHO')
  {
    MessageBox.warning(util.translate("scripts", "Debe realizar primero el movimiento de salida para la reposición"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  curMov.setModeAccess(curMov.Insert);
  curMov.refreshBuffer();

  curMov.setValueBuffer("tipo", "Entrada");
  curMov.setValueBuffer("usuario", sys.nameUser());
  curMov.setValueBuffer("fecha", hoy);
  curMov.setValueBuffer("hora", hoy.toString().right(8));
  curMov.setValueBuffer("referencia", curLineas.valueBuffer("referencia"));
  curMov.setValueBuffer("idubiarticulo", curLineas.valueBuffer("idubicaciondestino"));
  curMov.setValueBuffer("codubicacion", curLineas.valueBuffer("codubicaciondestino"));
  curMov.setValueBuffer("cantidad", cantidad);
  curMov.setValueBuffer("idlineareposicion", curLineas.valueBuffer("idlineareposicion"));
  if (!curMov.commitBuffer())
    return false;

  curLineas.setValueBuffer("estadoentrada", "HECHO");
  if (!curLineas.commitBuffer())
    return false;

  return true;
}

function oficial_salida()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idUsuario = sys.nameUser();

  if (!util.sqlDelete("salida", "idusuario = '" + idUsuario + "'"))
    return;

  var salida: Object = new FLFormSearchDB("salida");
  var curSalida: FLSqlCursor = salida.cursor();
  curSalida.setModeAccess(curSalida.Insert);
  curSalida.refreshBuffer();
  curSalida.setValueBuffer("idusuario", idUsuario);

  salida.setMainWidget();
  if (!salida.exec("idsalida"))
    return;

  if (!curSalida.commitBuffer())
    return false;

  var idLineaR: String = util.sqlSelect("lineasreposicion", "idlineareposicion", "codubicacionorigen = '" + curSalida.valueBuffer("codubicacionorigen") + "' AND referencia = '" + curSalida.valueBuffer("referencia") + "' AND estadosalida = 'PTE'");

  if (!idLineaR) {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de reposición que coincida con los datos introducidos en la salida"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var can: String = util.sqlSelect("lineasreposicion", "cantidad", "idlineareposicion = " + idLineaR);
  if (can != curSalida.valueBuffer("cantotal")) {
    var res: Number = MessageBox.information(util.translate("scripts", "La cantidad de salida no coincide con la cantidad de reposición.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
  }

  var curCommit: FLSqlCursor = new FLSqlCursor("reposicion");
  curCommit.transaction(false);
  try {
    if (this.iface.generarSalida(idLineaR)) {
      curCommit.commit();
    } else {
      curCommit.rollback();
      return false;
    }
  } catch (e) {
    curCommit.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al generar la salida: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}


function oficial_generarSalida(idLineaR: String): Boolean {
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date();
  var curLineas: FLSqlCursor = new FLSqlCursor("lineasreposicion");
  curLineas.select("idlineareposicion = '" + idLineaR + "'");

  if (!curLineas.first())
  {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de reposición con ese indentificador"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLineas.setModeAccess(curLineas.Edit);
  curLineas.refreshBuffer();


  var curMov: FLSqlCursor = new FLSqlCursor("movimat");
  var cantidad: String = curLineas.valueBuffer("cantidad");

  //  Movimiento de Salida

  cantidad = parseFloat(cantidad) * -1;
  curMov.setModeAccess(curMov.Insert);
  curMov.refreshBuffer();

  curMov.setValueBuffer("tipo", "Salida");
  curMov.setValueBuffer("usuario", sys.nameUser());
  curMov.setValueBuffer("fecha", hoy);
  curMov.setValueBuffer("hora", hoy.toString().right(8));
  curMov.setValueBuffer("referencia", curLineas.valueBuffer("referencia"));
  curMov.setValueBuffer("idubiarticulo", curLineas.valueBuffer("idubicacionorigen"));
  curMov.setValueBuffer("codubicacion", curLineas.valueBuffer("codubicacionorigen"));
  curMov.setValueBuffer("cantidad", cantidad);
  curMov.setValueBuffer("idlineareposicion", curLineas.valueBuffer("idlineareposicion"));
  if (!curMov.commitBuffer())
    return false;

  curLineas.setValueBuffer("estadosalida", "HECHO");
  cantidad = parseFloat(cantidad) * -1;
  curLineas.setValueBuffer("cantidad", cantidad);

  if (!curLineas.commitBuffer())
    return false;

  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////