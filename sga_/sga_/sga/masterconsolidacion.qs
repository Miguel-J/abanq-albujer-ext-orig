/***************************************************************************
                 masterconsolidacion.qs  -  description
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
  var tdbLineasPP: FLTableDB;
  var codPedidoCli_: String;
  var lblEstado: Object;
  var ledCesta: Object;
  var ledUbiConso: Object;
  var tbnIniciarConso: Object;
  var tbnBuscarUbiConso: Object;
  var tbnBuscarCesta: Object;
  var tbnConsolidar: Object;
  function oficial(context)
  {
    interna(context);
  }
  function buscarPedido()
  {
    return this.ctx.oficial_buscarPedido();
  }
  function consolidarLinea(curConsoMat: FLSqlCursor): Boolean {
    return this.ctx.oficial_consolidarLinea(curConsoMat);
  }
  function tbnIniciarConso_clicked()
  {
    return this.ctx.oficial_tbnIniciarConso_clicked();
  }
  function iniciarLinea(curLineaPP: FLSqlCursor): Boolean {
    return this.ctx.oficial_iniciarLinea(curLineaPP);
  }
  function tbnBuscarUbiConso_clicked()
  {
    return this.ctx.oficial_tbnBuscarUbiConso_clicked();
  }
  function tbnBuscarCesta_clicked()
  {
    return this.ctx.oficial_tbnBuscarCesta_clicked();
  }
  function crearSalidaCesta(curLineaPP: FLSqlCursor, cantidad: Number): Boolean {
    return this.ctx.oficial_crearSalidaCesta(curLineaPP, cantidad);
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
  var util: FLUtil = new FLUtil();

  this.iface.ledCesta = this.child("ledCesta");
  this.iface.ledUbiConso = this.child("ledUbiConso");
  this.iface.lblEstado = this.child("lblEstado");
  this.iface.tdbLineasPP = this.child("tdbLineasPedidosPicking");
  this.iface.tbnIniciarConso = this.child("tbnIniciarConso");
  this.iface.tbnBuscarUbiConso = this.child("tbnBuscarUbiConso");
  this.iface.tbnBuscarCesta = this.child("tbnBuscarCesta");
  this.iface.tbnConsolidar = this.child("tbnConsolidar");

  var idUsuario: String = sys.nameUser();

  this.iface.codPedidoCli_ = false;

  connect(this.iface.ledCesta, "returnPressed()", this, "iface.buscarPedido");
  connect(this.iface.ledUbiConso, "returnPressed()", this, "iface.buscarPedido");
  connect(this.iface.tbnIniciarConso, "clicked()", this, "iface.tbnIniciarConso_clicked");
  connect(this.iface.tbnBuscarUbiConso, "clicked()", this, "iface.tbnBuscarUbiConso_clicked");
  connect(this.iface.tbnBuscarCesta, "clicked()", this, "iface.tbnBuscarCesta_clicked");
  connect(this.iface.tbnConsolidar, "clicked()", this, "iface.buscarPedido");

  this.child("tbnIniciarConso").close();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_buscarPedido()
{
  debug(0);
  var util: FLUtil = new FLUtil;

  if (this.iface.ledCesta.text == "")
    return false;
  debug(1);
  var qryPedido: FLSqlQuery = new FLSqlQuery;
  qryPedido.setTablesList("pedidoscli");
  qryPedido.setSelect("codigo, codubiconso, fecha, nombrecliente");
  qryPedido.setFrom("pedidoscli");
  qryPedido.setWhere("codcesta = '" + this.iface.ledCesta.text + "' AND estadopicking IN ('EN CESTA', 'EN CONSOLIDACIÓN')");
  qryPedido.setForwardOnly(true);
  debug(2);
  if (!qryPedido.exec())
    return false;

  if (!qryPedido.first()) {
    MessageBox.warning(util.translate("scripts", "No hay ningún pedido picking con estado EN CESTA o EN CONSOLIDACIÓN para la cesta %1").arg(this.iface.ledCesta.text), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug(3);
  this.iface.codPedidoCli_ = qryPedido.value("codigo");

  this.iface.tdbLineasPP.cursor().setMainFilter("codpedido = '" + this.iface.codPedidoCli_ + "'");
  this.iface.tdbLineasPP.refresh();

  if (this.iface.ledUbiConso.text == "")
    return false;
  debug(4);
  if (!util.sqlSelect("ubicaciones", "codubicacion", "codubicacion = '" + this.iface.ledUbiConso.text + "'")) {
    MessageBox.warning(util.translate("scripts", "La ubicación de consolidación indicada no existe en la tabla de ubicaciones"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug(5);
  var codUbiCosoPedido: String = qryPedido.value("codubiconso");
  if (!codUbiCosoPedido || codUbiCosoPedido == "") {
    if (!util.sqlUpdate("pedidoscli", "codubiconso,estadopicking", this.iface.ledUbiConso.text + ",EN CONSOLIDACIÓN", "codigo = '" + this.iface.codPedidoCli_ + "'"))
      return false;
    codUbiCosoPedido = this.iface.ledUbiConso.text;
  }
  debug(6);
  if (codUbiCosoPedido != this.iface.ledUbiConso.text) {
    MessageBox.warning(util.translate("scripts", "El pedido %1 ya está asignado a la ubicación de consolidación %2").arg(this.iface.codPedidoCli_).arg(codUbiCosoPedido), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug(7);
  this.iface.lblEstado.text = util.translate("scripts", "Pedido %1. Cliente %2. Fecha %3. U.C. %4").arg(this.iface.codPedidoCli_).arg(qryPedido.value("nombrecliente")).arg(util.dateAMDtoDMA(qryPedido.value("fecha"))).arg(codUbiCosoPedido);

  var idConsoMat: String;
  var idUsuario: String = sys.nameUser();

  var falta: Boolean = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedido = '" + this.iface.codPedidoCli_ + "' AND estado <> 'SIN STOCK' AND cantidad <> consolidado");
  while (falta) {

    if (!util.sqlDelete("consomat", "idusuario = '" + idUsuario + "'"))
      return;

    var consoMat: Object = new FLFormSearchDB("consomat");
    var curConsoMat: FLSqlCursor = consoMat.cursor();
    curConsoMat.setModeAccess(curConsoMat.Insert);
    curConsoMat.refreshBuffer();
    curConsoMat.setValueBuffer("idusuario", idUsuario);

    consoMat.setMainWidget();
    if (!consoMat.exec("id"))
      break;

    idConsoMat = curConsoMat.valueBuffer("id");
    if (!curConsoMat.commitBuffer())
      return false;

    curConsoMat.select("id = " + idConsoMat);
    if (!curConsoMat.first())
      return false;

    curConsoMat.setModeAccess(curConsoMat.Browse);
    curConsoMat.refreshBuffer();

    curConsoMat.transaction(false);
    try {
      if (this.iface.consolidarLinea(curConsoMat)) {
        curConsoMat.commit();
      } else {
        curConsoMat.rollback();
      }
    } catch (e) {
      curConsoMat.rollback();
      MessageBox.critical(util.translate("scripts", "Error al consolidar una línea de pedido de picking: ") + e, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    delete consoMat;
    this.iface.tdbLineasPP.refresh();

    falta = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedido = '" + this.iface.codPedidoCli_ + "' AND estado <> 'SIN STOCK' AND cantidad <> consolidado");
  }
  if (!falta) {
    MessageBox.information(util.translate("scripts", "El pedido %1 está TERMINADO").arg(this.iface.codPedidoCli_), MessageBox.Ok, MessageBox.NoButton);
  }
}

function oficial_consolidarLinea(curConsoMat: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var cantidad: Number;
  var cantidadLinea: Number;
  var cantidadActual: Number;
  var cantidadNueva: Number;

  var curLineaPP: FLSqlCursor = new FLSqlCursor("lineaspedidospicking");

  cantidad = parseFloat(curConsoMat.valueBuffer("cantotal"));
  if (!cantidad || isNaN(cantidad))
    cantidad = 0;

  curLineaPP.select("codpedido= '" + this.iface.codPedidoCli_ + "' AND codcestaubicacion = '" + this.iface.ledCesta.text + "' AND referencia = '" + curConsoMat.valueBuffer("referencia") + "' AND estado = 'EN CESTA'");
  if (!curLineaPP.first())
  {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea del pedido %1 que coincida con los datos introducidos.").arg(this.iface.codPedidoCli_), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLineaPP.setModeAccess(curLineaPP.Edit);
  curLineaPP.refreshBuffer();

  cantidadLinea = parseFloat(curLineaPP.valueBuffer("cantidad"));
  if (!cantidadLinea || isNaN(cantidadLinea))
    cantidadLinea = 0;
  cantidadActual = parseFloat(curLineaPP.valueBuffer("consolidado"));
  if (!cantidadActual || isNaN(cantidadActual))
    cantidadActual = 0;
  cantidadNueva = cantidad + cantidadActual;

  if (cantidadNueva > cantidadLinea)
  {
    MessageBox.warning(util.translate("scripts", "La suma de la cantidad especificada (%1) más la cantidad ya consolidada(%2) es superior a la cantidad de la línea (%3)").arg(cantidad).arg(cantidadActual).arg(cantidadLinea), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!this.iface.crearSalidaCesta(curLineaPP, cantidad))
    return false;

  if (cantidadLinea == cantidadNueva)
    curLineaPP.setValueBuffer("estado", "TERMINADO");

  curLineaPP.setValueBuffer("consolidado", cantidadNueva);
  if (!curLineaPP.commitBuffer())
    return false;

  return true;
}

function oficial_crearSalidaCesta(curLineaPP: FLSqlCursor, cantidad: Number): Boolean {
  var curMoviMat: FLSqlCursor = new FLSqlCursor("movimat");

  var hoy: Date = new Date;
  var idUsuario: String = sys.nameUser();

  curMoviMat.setModeAccess(curMoviMat.Insert);
  curMoviMat.refreshBuffer();
  curMoviMat.setValueBuffer("fecha", hoy);
  curMoviMat.setValueBuffer("hora", hoy.toString().right(8));
  curMoviMat.setValueBuffer("idubiarticulo", curLineaPP.valueBuffer("idcestaubicacion"));
  curMoviMat.setValueBuffer("codubicacion", curLineaPP.valueBuffer("codcestaubicacion"));
  curMoviMat.setValueBuffer("tipo", "Salida");
  curMoviMat.setValueBuffer("cantidad", cantidad * -1);
  curMoviMat.setValueBuffer("usuario", idUsuario);
  curMoviMat.setValueBuffer("referencia", curLineaPP.valueBuffer("referencia"));

  if (!curMoviMat.commitBuffer())
    return false;

  return true;
}

function oficial_tbnIniciarConso_clicked()
{
  var util: FLUtil = new FLUtil;
  var curLineasPP: FLSqlCursor = this.iface.tdbLineasPP.cursor();
  var idLineaPP: String = curLineasPP.valueBuffer("idlineapedidopicking");
  if (!idLineaPP)
    return;

  var res: Number = MessageBox.warning(util.translate("scripts", "Va a poner a cero el contador de artículos consolidados para la línea de pedido seleccionada.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return;

  curLineasPP.transaction(false);
  try {
    if (this.iface.iniciarLinea(curLineasPP)) {
      curLineasPP.commit();
    } else {
      curLineasPP.rollback();
    }
  } catch (e) {
    curLineasPP.rollback();
    MessageBox.critical(util.translate("scripts", "Error al poner a cero el contador de artículos consolidados: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.iface.tdbLineasPP.refresh();
}

function oficial_iniciarLinea(curLineaPP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  curLineaPP.setModeAccess(curLineaPP.Edit);
  curLineaPP.refreshBuffer();

  if (!util.sqlDelete("movimat", "idubiarticulo = " + curLineaPP.valueBuffer("idcestaubicacion") + " AND tipo = 'Salida' AND codtransferencia = '" + curLineaPP.valueBuffer("codtransferencia") + "'"))
    return false;

  curLineaPP.setValueBuffer("estado", "EN CESTA");
  curLineaPP.setValueBuffer("consolidado", 0);

  if (!curLineaPP.commitBuffer())
    return false;

  return true;
}

function oficial_tbnBuscarUbiConso_clicked()
{
  var valor: String = flfactalma.iface.pub_seleccionarUbicacion("CONSOLIDACIÓN");
  if (valor && valor != "")
    this.iface.ledUbiConso.text = valor;
}

function oficial_tbnBuscarCesta_clicked()
{
  var valor: String = flfactalma.iface.pub_seleccionarUbicacion("CESTAS");
  if (valor && valor != "")
    this.iface.ledCesta.text = valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////