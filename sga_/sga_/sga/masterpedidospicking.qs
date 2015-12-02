/***************************************************************************
                 masterpedidospicking.qs  -  description
                             -------------------
    begin                : jue jun 05 2008
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
  var tdbRecords: FLTableDB;
  var tbnAsignarCesta: Object;
  var tbnCrearPicking: Object;
  function oficial(context)
  {
    interna(context);
  }
  function asignarCesta(): Boolean {
    this.ctx.oficial_asignarCesta();
  }
  function preguntarCesta(): String {
    return this.ctx.oficial_preguntarCesta();
  }
  function crearUbicacion(codUbicacion: String): Boolean {
    return this.ctx.oficial_crearUbicacion(codUbicacion);
  }
  function crearPedidoPicking_clicked()
  {
    return this.ctx.oficial_crearPedidoPicking_clicked();
  }
  function crearPedidoPicking(): Boolean {
    return this.ctx.oficial_crearPedidoPicking();
  }
  function crearLineasPicking(idPedido: String, codPedidoPicking: String): Number {
    return this.ctx.oficial_crearLineasPicking(idPedido, codPedidoPicking);
  }
  function procesarEstado()
  {
    return this.ctx.oficial_procesarEstado();
  }
  function cestaValida(codCesta: String): Boolean {
    return this.ctx.oficial_cestaValida(codCesta);
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
  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.tbnAsignarCesta = this.child("tbnAsignarCesta");
  this.iface.tbnCrearPicking = this.child("tbnCrearPicking");

  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");

  connect(this.child("tbnAsignarCesta"), "clicked()", this, "iface.asignarCesta()");
  connect(this.child("tbnCrearPicking"), "clicked()", this, "iface.crearPedidoPicking_clicked()");

  this.iface.procesarEstado();
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_asignarCesta(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var qryCesta: FLSqlQuery = new FLSqlQuery;
  with(qryCesta)
  {
    setTablesList("lineaspedidospicking");
    setSelect("idpedido");
    setFrom("lineaspedidospicking");
    setWhere("codpedidopicking = '" + cursor.valueBuffer("codpedidopicking") + "' AND codcestaubicacion IS NULL GROUP BY idpedido");
    setForwardOnly(true);
  }

  if (!qryCesta.exec())
    return false;

  while (qryCesta.next())
  {
    var codUbicacion: String;
    var numCesta: String;
    do {
      numCesta = this.iface.preguntarCesta();

      codUbicacion = util.sqlSelect("ubicaciones u INNER JOIN zonas z ON u.codzona = z.codzona", "u.codubicacion", "u.numcesta = '" + numCesta + "' AND z.tipo = 'CESTAS'", "ubicaciones,zonas");
      if (!codUbicacion) {
        codUbicacion = false;
        var res: Number = MessageBox.information(util.translate("scripts", "No existe ninguna ubicación con ese número de cesta.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.Cancel);
        if (res != MessageBox.Yes)
          return;
      }
      if (!this.iface.cestaValida(codUbicacion))
        codUbicacion = false;
    } while (!codUbicacion);
    if (!util.sqlDelete("ubicacionesarticulo", "codubicacion = '" + codUbicacion + "'"))
      return false;

    if (!util.sqlUpdate("pedidoscli", "estadopicking,codcesta", "EN CESTA," + codUbicacion, "idpedido = '" +  qryCesta.value("idpedido") + "'"))
      return false;

    if (!util.sqlUpdate("lineaspedidospicking", "codcestaubicacion,estado", codUbicacion + "," + "ACTIVO", "codpedidopicking = '" + cursor.valueBuffer("codpedidopicking") + "' AND idpedido = '" +  qryCesta.value("idpedido") + "'"))
      return false;

    if (!this.iface.crearUbicacion(codUbicacion))
      return false;
  }
  this.iface.procesarEstado();
  var codPedidoP: String = cursor.valueBuffer("codpedidopicking");
  if (!util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + codPedidoP + "' AND estado = 'PTE CESTAS'"))
  {
    MessageBox.information(util.translate("scripts", "Cestas asignadas al pedido Picking %1").arg(codPedidoP), MessageBox.Ok, MessageBox.NoButton);
  }
  return true;
}

function oficial_preguntarCesta(): String {
  var idUsuario: String = sys.nameUser();
  var f: Object = new FLFormSearchDB("numerocesta");
  var curCesta: FLSqlCursor = f.cursor();

  curCesta.select("idusuario = '" + idUsuario + "'");
  if (!curCesta.first())
    curCesta.setModeAccess(curCesta.Insert);
  else
    curCesta.setModeAccess(curCesta.Edit);

  f.setMainWidget();
  curCesta.refreshBuffer();
  curCesta.setValueBuffer("idusuario", idUsuario);
  curCesta.setValueBuffer("numcesta", "");

  var numCesta: String = f.exec("numcesta");
  if (!numCesta)
    return false;

  curCesta.commitBuffer();
  return numCesta;
}

function oficial_crearUbicacion(codUbicacion: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var curLinea: FLSqlCursor = new FLSqlCursor("lineaspedidospicking");
  curLinea.select("codcestaubicacion = '" + codUbicacion + "' AND codpedidopicking = '" + cursor.valueBuffer("codpedidopicking") + "'");
  var curUbi: FLSqlCursor = new FLSqlCursor("ubicacionesarticulo");
  var idUbiCesta: String;
  while (curLinea.next())
  {
    curLinea.setModeAccess(curLinea.Edit);
    curLinea.refreshBuffer();
    idUbiCesta = util.sqlSelect("ubicacionesarticulo", "id", "codubicacion = '" + codUbicacion + "'");
    if (!idUbiCesta || idUbiCesta == "") {
      curUbi.setModeAccess(curUbi.Insert);
      curUbi.refreshBuffer();
      curUbi.setValueBuffer("codubicacion", codUbicacion);
      curUbi.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
      curUbi.setValueBuffer("cantidadactual", 0);
      if (!curUbi.commitBuffer())
        return false;
      idUbiCesta = curUbi.valueBuffer("id");
    }
    curLinea.setValueBuffer("idcestaubicacion", idUbiCesta);
    if (!curLinea.commitBuffer())
      return false;
  }
  return true;
}

function oficial_crearPedidoPicking_clicked()
{
  var util: FLUtil = new FLUtil;
  var curCommit: FLSqlCursor = new FLSqlCursor("pedidoscli");
  curCommit.transaction(false);
  try {
    if (this.iface.crearPedidoPicking()) {
      curCommit.commit();
    } else {
      curCommit.rollback();
      return false;
    }
  } catch (e) {
    curCommit.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al crear el pedido picking: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}


function oficial_crearPedidoPicking(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idUsuario: String = sys.nameUser();
  var hoy: Date = new Date();

  var maxPP: Number = parseFloat(flfactppal.iface.pub_valorDefectoEmpresa("maxpedpick"));
  if (!maxPP || isNaN(maxPP))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el máximo número de pedidos por pedido de picking y usuario\nen el formulario de empresa."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codPedidoPicking: String = util.nextCounter("codpedidopicking", cursor);

  cursor.setModeAccess(cursor.Insert);
  cursor.refreshBuffer();
  cursor.setValueBuffer("codpedidopicking", codPedidoPicking);
  cursor.setValueBuffer("idusuario", idUsuario);
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("estado", "PTE CESTAS");
  if (!cursor.commitBuffer())
    return false;

  var numeroLineas: Number;
  var idPedido: String;
  var curPedCli: FLSqlCursor = new FLSqlCursor("pedidoscli");
  curPedCli.select("enpreparacion = true AND (codpedidopicking = '' OR codpedidopicking IS NULL) ORDER BY prioridad");
  if (curPedCli.size() == 0)
  {
    MessageBox.warning(util.translate("scripts", "No hay ningún pedido de cliente para asociar al pedido de picking"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var nPedido: Number = 1;
  while (curPedCli.next())
  {
    curPedCli.setModeAccess(curPedCli.Edit);
    curPedCli.refreshBuffer();
    idPedido = curPedCli.valueBuffer("idpedido");
    numeroLineas = this.iface.crearLineasPicking(idPedido, codPedidoPicking);

    if (!numeroLineas || numeroLineas == -1)
      return false;

    curPedCli.setValueBuffer("codpedidopicking", codPedidoPicking);
    curPedCli.setValueBuffer("estadopicking", "PTE CESTAS");

    if (!curPedCli.commitBuffer())
      return false;

    if (nPedido >= maxPP)
      break;
    nPedido++;
  }

  return true;
}

function oficial_crearLineasPicking(idPedido: String, codPedidoPicking: String): Number {
  var util: FLUtil = new FLUtil;
  var num: Number = 0;
  var cantPicking: Number = 0;
  var codUbicacion: String;
  var idUbicacion: String;
  var qryLineas: FLSqlQuery = new FLSqlQuery;
  with(qryLineas)
  {
    setTablesList("lineaspedidoscli,pedidoscli");
    setSelect("codigo, idlinea, referencia, cantidad");
    setFrom("lineaspedidoscli INNER JOIN pedidoscli ON lineaspedidoscli.idpedido = pedidoscli.idpedido");
    setWhere("lineaspedidoscli.idpedido = " + idPedido);
    setForwardOnly(true);
  }

  if (!qryLineas.exec())
    return false;

  while (qryLineas.next())
  {
    //    maxCant = util.sqlSelect("articulos","maxpicking","referencia = '" + qryLineas.value("referencia") + "'");
    //    if (!maxCant || isNaN(maxCant))
    //      maxCant = 0;
    //    if (maxCant == 0) {
    //      MessageBox.information(util.translate("scripts", "Debe establecer el campo Máxima cantidad por pedido para el artículo %1 en el formulario de artículos").arg(qryLineas.value("referencia")), MessageBox.Ok, MessageBox.NoButton);
    //      return false;
    //    }
    //    cantPicking = qryLineas.value("cantidad") % maxCant;
    cantPicking = qryLineas.value("cantidad");
    idUbicacion = util.sqlSelect("ubicaciones u INNER JOIN zonas z ON z.codzona = u.codzona INNER JOIN ubicacionesarticulo ub ON u.codubicacion = ub.codubicacion", "ub.id", "ub.referencia = '" + qryLineas.value("referencia") + "' AND z.tipo = 'PICKING'", "ubicaciones,zonas,ubicacionesarticulo");
    if (!idUbicacion || idUbicacion == "") {
      MessageBox.information(util.translate("scripts", "No existe una ubicacion en zona picking para el artículo:\nReferencia %1").arg(qryLineas.value("referencia")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    codUbicacion = util.sqlSelect("ubicacionesarticulo", "codubicacion", "id = " + idUbicacion);
    if (!codUbicacion || codUbicacion == "") {
      MessageBox.information(util.translate("scripts", "No existe código de ubicacion para ese identificador"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    var curPedPic: FLSqlCursor = new FLSqlCursor("lineaspedidospicking");
    curPedPic.setModeAccess(curPedPic.Insert);
    curPedPic.refreshBuffer();
    curPedPic.setValueBuffer("codpedidopicking", codPedidoPicking);
    curPedPic.setValueBuffer("codpedido", qryLineas.value("codigo"));
    curPedPic.setValueBuffer("idpedido", idPedido);
    curPedPic.setValueBuffer("idlinea", qryLineas.value("idlinea"));
    curPedPic.setValueBuffer("referencia", qryLineas.value("referencia"));
    curPedPic.setValueBuffer("cantidad", cantPicking);
    curPedPic.setValueBuffer("codubicacion",  codUbicacion);
    curPedPic.setValueBuffer("id", idUbicacion);
    curPedPic.setValueBuffer("estado", "PTE CESTAS");
    if (!curPedPic.commitBuffer())
      return false;
    num ++;
  }

  if (num == 0)
    return -1;

  return num;
}

function oficial_procesarEstado()
{
  if (this.cursor().valueBuffer("estado") == "PTE CESTAS") {
    this.iface.tbnAsignarCesta.enabled = true;
  } else {
    this.iface.tbnAsignarCesta.enabled = false;
  }
}

function oficial_cestaValida(codCesta: String): Boolean {
  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("ubicacionesarticulo", "id", "codubicacion = '" + codCesta + "'"))
  {
    MessageBox.warning(util.translate("scripts", "La cesta %1 ya está en uso (tiene articulos asociados)").arg(codCesta), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////