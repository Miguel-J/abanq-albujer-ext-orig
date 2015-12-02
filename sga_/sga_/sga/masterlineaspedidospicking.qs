/***************************************************************************
                 masterlineaspedidospicking.qs  -  description
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
  var codPedidoActual: String;
  var lblTitulo: Object;
  function oficial(context)
  {
    interna(context);
  }
  function transferenciaACesta()
  {
    return this.ctx.oficial_transferenciaACesta();
  }
  function generarTransferencia(idLineaPP: String): Boolean {
    return this.ctx.oficial_generarTransferencia(idLineaPP);
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

  var idUsuario: String = sys.nameUser();

  connect(this.child("tbnTranferenciaAcesta"), "clicked()", this, "iface.transferenciaACesta()");

  this.iface.codPedidoActual = util.sqlSelect("pedidospicking", "codpedidopicking", "idusuario = '" + idUsuario + "' AND estado = 'ACTIVO'");

  this.iface.lblTitulo = this.child("lblTitulo");
  this.iface.lblTitulo.text = util.translate("scripts", "Líneas activas para %1 (P.Picking %2)").arg(idUsuario).arg(this.iface.codPedidoActual);

  var filtro: String = "codpedidopicking = '" + this.iface.codPedidoActual + "'";

  this.child("tdbLineasPedidosPicking").cursor().setMainFilter(filtro);

  if (!this.iface.codPedidoActual) {
    MessageBox.warning(util.translate("scripts", "No existe ningún pedido activo para el usuario "), MessageBox.Ok, MessageBox.NoButton);
    this.close();
  }
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_transferenciaACesta()
{
  var util: FLUtil = new FLUtil;
  var idUsuario = sys.nameUser();

  if (!util.sqlDelete("transmat", "idusuario = '" + idUsuario + "'"))
    return;

  var transMat: Object = new FLFormSearchDB("transmat");
  var curTransMat: FLSqlCursor = transMat.cursor();
  curTransMat.setModeAccess(curTransMat.Insert);
  curTransMat.refreshBuffer();
  curTransMat.setValueBuffer("idusuario", idUsuario);

  var idUbicacionOrigen: String = util.sqlSelect("ubicacionesarticulo", "id", "codubicacionorigen = '" + curTransMat.valueBuffer("codubicacionorigen") + "'");
  curTransMat.setValueBuffer("idubicacionorigen", idUbicacionOrigen);
  var idUbicacionDestino: String = util.sqlSelect("ubicacionesarticulo", "id", "codubicaciondestino = '" + curTransMat.valueBuffer("codubicaciondestino") + "'");
  curTransMat.setValueBuffer("idubicaciondestino", idUbicacionDestino);

  transMat.setMainWidget();
  if (!transMat.exec("idtransferencia"))
    return;

  var idTransferencia: String = curTransMat.valueBuffer("idtransferencia");
  if (!curTransMat.commitBuffer())
    return false;

  curTransMat.select("idtransferencia = " + idTransferencia);
  if (!curTransMat.first())
    return false;
  curTransMat.setModeAccess(curTransMat.Browse);
  curTransMat.refreshBuffer();

  var idLineaPP: String = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + this.iface.codPedidoActual + "' AND codubicacion = '" + curTransMat.valueBuffer("codubicacionorigen") + "' AND codcestaubicacion = '" + curTransMat.valueBuffer("codubicaciondestino") + "' AND referencia = '" + curTransMat.valueBuffer("referencia") + "' AND estado = 'ACTIVO'");
  if (!idLineaPP) {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de pedido picking que coincida con los datos introducidos en la transferencia"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var canLinea: Number = parseFloat(util.sqlSelect("lineaspedidospicking", "cantidad", "idlineapedidopicking = " + idLineaPP));
  if (!canLinea || isNaN(canLinea))
    canLinea = 0;

  var canTrans: Number = parseFloat(curTransMat.valueBuffer("cantotal"));
  if (!canTrans || isNaN(canTrans))
    canTrans = 0;

  if (canTrans == 0) {
    var res: Number = MessageBox.warning(util.translate("scripts", "Ha establacido una cantidad 0. ¿Desea marcar la línea como SIN STOCK?"), MessageBox.Yes, MessageBox.No);
    if (res == MessageBox.Yes) {
      var codPedido: String = util.sqlSelect("lineaspedidospicking", "codpedido", "idlineapedidopicking = " + idLineaPP);
      if (util.sqSelect("pedidoscli", "entregasparciales", "codigo = '" + codPedido + "'")) {
        if (!util.sqlUpdate("lineaspedidospicking", "estado", "SIN STOCK", "idlineapedidopicking = " + idLineaPP))
          return false;
        return true;
      } else {
        MessageBox.warning(util.translate("scripts", "El pedido %1 no admite entregas parciales"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }

  if (canTrans > canLinea) {
    MessageBox.warning(util.translate("scripts", "Ha establacido una cantidad (%1) superior a la esperada (%2)").arg(canTrans).arg(canLinea), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (canTrans < canLinea) {
    MessageBox.warning(util.translate("scripts", "Ha establacido una cantidad (%1) inferior a la esperada (%2)").arg(canTrans).arg(canLinea), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curCommit: FLSqlCursor = new FLSqlCursor("pedidospicking");
  curCommit.transaction(false);
  try {
    if (this.iface.generarTransferencia(idLineaPP)) {
      curCommit.commit();
    } else {
      curCommit.rollback();
      return false;
    }
  } catch (e) {
    curCommit.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al generar la transferencia: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.child("tdbLineasPedidosPicking").refresh();
  if (!util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + this.iface.codPedidoActual + "' AND estado = 'ACTIVO'")) {
    MessageBox.information(util.translate("scripts", "Pedido Picking %1 TERMINADO").arg(this.iface.codPedidoActual), MessageBox.Ok, MessageBox.NoButton);
  }
}

function oficial_generarTransferencia(idLineaPP: String): Boolean {
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date();
  var curLineas: FLSqlCursor = new FLSqlCursor("lineaspedidospicking");
  curLineas.select("idlineapedidopicking = '" + idLineaPP + "'");

  if (!curLineas.first())
  {
    MessageBox.warning(util.translate("scripts", "No existe ninguna linea de pedido picking con ese indentificador"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLineas.setModeAccess(curLineas.Edit);
  curLineas.refreshBuffer();

  var curMov: FLSqlCursor = new FLSqlCursor("movimat");
  var codTransferencia: String = util.nextCounter("codtransferencia", curMov);
  var cantidad: String = curLineas.valueBuffer("cantidad");

  //  Movimiento de entrada
  curMov.setModeAccess(curMov.Insert);
  curMov.refreshBuffer();

  curMov.setValueBuffer("tipo", "Entrada");
  curMov.setValueBuffer("usuario", sys.nameUser());
  curMov.setValueBuffer("fecha", hoy);
  curMov.setValueBuffer("hora", hoy.toString().right(8));
  curMov.setValueBuffer("referencia", curLineas.valueBuffer("referencia"));
  curMov.setValueBuffer("id", curLineas.valueBuffer("idcestaubicacion"));
  curMov.setValueBuffer("codubicacion", curLineas.valueBuffer("codcestaubicacion"));
  curMov.setValueBuffer("cantidad", cantidad);
  curMov.setValueBuffer("codtransferencia", codTransferencia);
  if (!curMov.commitBuffer())
    return false;

  //  Movimiento de Salida

  cantidad = parseFloat(cantidad) * -1;
  curMov.setModeAccess(curMov.Insert);
  curMov.refreshBuffer();

  curMov.setValueBuffer("tipo", "Salida");
  curMov.setValueBuffer("usuario", sys.nameUser());
  curMov.setValueBuffer("fecha", hoy);
  curMov.setValueBuffer("hora", hoy.toString().right(8));
  curMov.setValueBuffer("referencia", curLineas.valueBuffer("referencia"));
  curMov.setValueBuffer("id", curLineas.valueBuffer("id"));
  curMov.setValueBuffer("codubicacion", curLineas.valueBuffer("codubicacion"));
  curMov.setValueBuffer("cantidad", cantidad);
  curMov.setValueBuffer("codtransferencia", codTransferencia);
  if (!curMov.commitBuffer())
    return false;

  curLineas.setValueBuffer("estado", "EN CESTA");
  curLineas.setValueBuffer("codtransferencia", codTransferencia);
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