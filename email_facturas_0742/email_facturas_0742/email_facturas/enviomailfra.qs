/***************************************************************************
                 enviomailfra.qs  -  description
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
    return this.ctx.interna_init();
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var correos_;
  function oficial(context)
  {
    interna(context);
  }
  function filtrarTabla()
  {
    return this.ctx.oficial_filtrarTabla();
  }
  function enviarMail()
  {
    return this.ctx.oficial_enviarMail();
  }
  function sigMap_mapped(idFactura)
  {
    return this.ctx.oficial_sigMap_mapped(idFactura);
  }
  function seleccionarTodo()
  {
    return this.ctx.oficial_seleccionarTodo();
  }
  function quitarTodo()
  {
    return this.ctx.oficial_quitarTodo();
  }
  function mostrarSeleccionadas()
  {
    return this.ctx.oficial_mostrarSeleccionadas();
  }
  function soloSeleccionadas_clicked()
  {
    return this.ctx.oficial_soloSeleccionadas_clicked();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function orderCols()
  {
    return this.ctx.oficial_orderCols();
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

  connect(this.child("tbnBuscar"), "clicked()", _i, "filtrarTabla");
  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnEnviar"), "clicked()", _i, "enviarMail");
  connect(this.child("tbnSelecTodos"), "clicked()", _i, "seleccionarTodo");
  connect(this.child("tbnQuitarTodos"), "clicked()", _i, "quitarTodo");
  connect(this.child("chkSoloSeleccionados"), "clicked()", _i, "soloSeleccionadas_clicked");

  this.child("tdbFacturas").setOrderCols(_i.orderCols());
  this.child("tdbFacturas").refresh(true, true);
  _i.mostrarSeleccionadas();
  _i.filtrarTabla();
}

function interna_validateForm()
{
  var cursor = this.cursor();

  var arrayFacturas = this.child("tdbFacturas").primarysKeysChecked();
  var listaFras = arrayFacturas.toString();

  cursor.setValueBuffer("listafacturas", listaFras);

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_orderCols()
{
  return ["idfactura", "codigo", "emailenviado"];
}
function oficial_bufferChanged(fN: String)
{
  var _i = this.iface;

  switch (fN) {
    case "reenviar": {
      _i.filtrarTabla();
      break;
    }
  }
}

function oficial_soloSeleccionadas_clicked()
{
  var _i = this.iface;

  if (this.child("chkSoloSeleccionados").checked) {
    var arrayFacturas = this.child("tdbFacturas").primarysKeysChecked();
    var listaFras = arrayFacturas.toString();
    var filtro = "1=2";
    if (listaFras && listaFras != "")
      filtro = "idfactura IN (" + listaFras + ")";

    this.child("tdbFacturas").setFilter(filtro);
    this.child("tdbFacturas").refresh();
  } else {
    _i.filtrarTabla();
  }
}

function oficial_mostrarSeleccionadas()
{
  var cursor = this.cursor();

  var filtro = "1=2";

  if (cursor.valueBuffer("listafacturas") && cursor.valueBuffer("listafacturas") != "")
    filtro = "idfactura IN (" + cursor.valueBuffer("listafacturas") + ")";

  var qryFra = new FLSqlQuery();
  qryFra.setSelect("idfactura");
  qryFra.setFrom("facturascli")
  qryFra.setWhere(filtro);

  if (!qryFra.exec())
    return false;

  while (qryFra.next()) {
    this.child("tdbFacturas").setPrimaryKeyChecked(qryFra.value("idfactura"), true);
  }

  this.child("tdbFacturas").refresh();
}

function oficial_seleccionarTodo()
{
  var filtro = this.child("tdbFacturas").filter();
  var qryFra = new FLSqlQuery();
  qryFra.setSelect("idfactura");
  qryFra.setFrom("facturascli")
  qryFra.setWhere(filtro);

  if (!qryFra.exec())
    return false;

  while (qryFra.next()) {
    this.child("tdbFacturas").setPrimaryKeyChecked(qryFra.value("idfactura"), true);
  }

  this.child("tdbFacturas").refresh();
}

function oficial_quitarTodo()
{
  this.child("tdbFacturas").clearChecked();
  this.child("tdbFacturas").refresh();
}

function oficial_filtrarTabla()
{
  var fechaDesde = this.child("fdbFechaDesde").value();
  var fechaHasta = this.child("fdbFechaHasta").value();
  var reenviar = this.child("fdbReenviar").value();

  var filtro = "codcliente IN (SELECT codcliente from clientes where enviomailfra)";

  if (fechaDesde && fechaDesde != "") {
    if (filtro && filtro != "") {
      filtro += " AND ";
    }
    filtro += "fecha >= '" + fechaDesde + "'";
  }

  if (fechaDesde && fechaDesde != "") {
    if (filtro && filtro != "") {
      filtro += " AND ";
    }
    filtro += "fecha <= '" + fechaHasta + "'";
  }

  if (!reenviar) {
    if (filtro && filtro != "") {
      filtro += " AND ";
    }
    filtro += "emailenviado = false";
  }

  this.child("tdbFacturas").setFilter(filtro);
  this.child("tdbFacturas").refresh();
}

function oficial_enviarMail()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var arrayFacturas = this.child("tdbFacturas").primarysKeysChecked();
  var listaFras = arrayFacturas.toString();

  var dirCorreSaliente = AQUtil.sqlSelect("facturac_general", "hostcorreosaliente", "1=1");
  if (!dirCorreSaliente || dirCorreSaliente == "") {
    dirCorreSaliente = "localhost";
  }

  var codificacion = AQUtil.readSettingEntry("scripts/flfacturac/encodingLocal");
  var asunto = cursor.valueBuffer("asunto");
  asunto = sys.fromUnicode(asunto, codificacion);
  var cuerpoCorreo = cursor.valueBuffer("cuerpo");
  var emailDestino = "";
  var ruta = AQUtil.readSettingEntry("scripts/flfacturac/rutaAdjuntos");
  if (!ruta || ruta == "") {
    MessageBox.warning(sys.translate("Debe establecer la ruta para guardar los ficheros adjuntos en los datos de configuración."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var listaNoEnviadas = "";
  var idFactura;
  _i.correos_ = [];
  var sigMap = new AQSignalMapper(this);
  connect(sigMap, "mapped(QString)", _i, "sigMap_mapped");
  AQUtil.createProgressDialog("Enviando facturas", arrayFacturas.length);
  for (var i = 0; i < arrayFacturas.length; i++) {
    AQUtil.setProgress(i);
    idFactura = arrayFacturas[i];
    _i.correos_[idFactura] = new FLSmtpClient;
    var correo = _i.correos_[idFactura];
    sigMap.setMapping(_i.correos_[idFactura], idFactura);
    connect(_i.correos_[idFactura], "statusChanged(QString, int)", sigMap, "map()");

    var codigo = AQUtil.sqlSelect("facturascli", "codigo", "idfactura = " + arrayFacturas[i]);
    emailDestino = AQUtil.sqlSelect("clientes c inner join facturascli f on c.codcliente = f.codcliente", "c.email", "f.idfactura = " + arrayFacturas[i], "clientes,facturascli");
    if (!emailDestino || emailDestino == "") {
      if (listaNoEnviadas && listaNoEnviadas != "")
        listaNoEnviadas += ", ";
      listaNoEnviadas += codigo;
      continue;
    }

    correo.setMailServer(dirCorreSaliente);
    var remite = AQUtil.sqlSelect("empresa", "email", "1=1");
    if (!remite || remite == "") {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      MessageBox.warning(sys.translate("Debe establecer email en el formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }


    var oParam = formfacturascli.iface.dameParamInforme(arrayFacturas[i]);
    if (!oParam) {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }

    oParam.datosPdf = new Object;
    oParam.datosPdf.pdf = true;
    oParam.datosPdf.ruta = ruta + codigo + ".pdf";

    var curImprimir = new FLSqlCursor("i_facturascli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
    curImprimir.setValueBuffer("h_facturascli_codigo", codigo);

    flfactinfo.iface.pub_lanzaInforme(curImprimir, oParam);
    correo.addAttachment(oParam.datosPdf.ruta);

    try {
      correo.setMimeType("text/plain");
      correo.setBody(cuerpoCorreo);

    } catch (e) {
      MessageBox(e);
      correo.setBody(cuerpoCorreo);
    }

    correo.setFrom(remite);
    correo.setTo(emailDestino);
    correo.setSubject(asunto);

    correo.startSend();

  }
  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);

  if (listaNoEnviadas && listaNoEnviadas != "")  {
    MessageBox.warning(sys.translate("Las siguientes facturas no pudieron enviarse:\n%1").arg(listaNoEnviadas), MessageBox.Ok, MessageBox.NoButton);

  } else {
    MessageBox.warning(sys.translate("En proceso de envío ha terminado con éxito"), MessageBox.Ok, MessageBox.NoButton);
  }

  this.child("tdbFacturas").clearChecked();
  this.child("tdbFacturas").refresh();
  cursor.setValueBuffer("listafacturas", "");
  this.child("pushButtonAccept").animateClick();
}

function oficial_sigMap_mapped(idFactura)
{
  var _i = this.iface;
  var status =  _i.correos_[idFactura].lastStateCode();
  if (status == _i.correos_[idFactura].SendOk) {
    if (!AQUtil.execSql("UPDATE facturascli SET emailenviado = true WHERE idfactura = " + idFactura)) {
      return false;
    }
    if (this.child("tdbFacturas")) {
      this.child("tdbFacturas").refresh();
    }
  }
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
