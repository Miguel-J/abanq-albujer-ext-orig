/***************************************************************************
                           masterliquidaciones.qs
                             -------------------
    begin                : jue sep 29 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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

/** @class_declaration liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES //////////////////////////////////////////////////
class liqAgentes extends interna
{
  var curLiquidacion_: FLSqlCursor;
  var curFactura_: FLSqlCursor;
  var curLineaFactura_: FLSqlCursor;
  var docLiquidacion_: String;
  function liqAgentes(context)
  {
    interna(context);
  }
  function grafica()
  {
    this.ctx.liqAgentes_grafica();
  }
  function eliminarliquidaciones()
  {
    return this.ctx.liqAgentes_eliminarliquidaciones();
  }
  function generarFactura(): Boolean {
    return this.ctx.liqAgentes_generarFactura();
  }
  function datosFactura(cursor: FLSqlCursor): Boolean {
    return this.ctx.liqAgentes_datosFactura(cursor);
  }
  function datosLineaFactura(cursor: FLSqlCursor, idFactura: Number): Boolean {
    return this.ctx.liqAgentes_datosLineaFactura(cursor, idFactura);
  }
  function totalesFactura(cursor: FLSqlCursor): Boolean {
    return this.ctx.liqAgentes_totalesFactura(cursor);
  }
  function pbGenerarFactura_clicked(): Boolean {
    return this.ctx.liqAgentes_pbGenerarFactura_clicked();
  }
  function imprimir()
  {
    return this.ctx.liqAgentes_imprimir();
  }
  function pbnGenerarLiqAgentes_clicked()
  {
    return this.ctx.liqAgentes_pbnGenerarLiqAgentes_clicked();
  }
  function generarLiquidacion(codAgente: String, curGenerarLiq: FLSqlCursor): String {
    return this.ctx.liqAgentes_generarLiquidacion(codAgente, curGenerarLiq);
  }
  function datosLiquidacion(curGenerarLiq: FLSqlCursor): Boolean {
    return this.ctx.liqAgentes_datosLiquidacion(curGenerarLiq);
  }
  function totalesLiquidacion(curGenerarLiq: FLSqlCursor): Boolean {
    return this.ctx.liqAgentes_totalesLiquidacion(curGenerarLiq);
  }
}
//// LIQAGENTES ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends liqAgentes
{
  function head(context)
  {
    liqAgentes(context);
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
  this.iface.docLiquidacion_ = flfactppal.iface.pub_valorDefecto("docliquidacion");

  connect(this.child("toolButtonDelete"), "clicked()", this, "iface.eliminarliquidaciones");
  connect(this.child("pbGenerarFactura"), "clicked()", this, "iface.pbGenerarFactura_clicked");
  connect(this.child("pbnGenerarLiqAgentes"), "clicked()", this, "iface.pbnGenerarLiqAgentes_clicked");
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir");

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  if (codEjercicio) {
    this.cursor().setMainFilter("codejercicio IN ('" + codEjercicio + "', '') OR codejercicio IS NULL");
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////////
/** \C Elimina una liquidación quitando el código de la liquidación a las facturas asociadas
\end */
function liqAgentes_eliminarliquidaciones()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codLiquidacion = cursor.valueBuffer("codliquidacion");
  if (!codLiquidacion) {
    return false;
  }
  var util: FLUtil = new FLUtil();

  var tabla: String, clave: String, nombre: String, campoLock: String;
  switch (this.iface.docLiquidacion_) {
    case "Albaranes": {
      tabla = "albaranescli";
      clave = "idalbaran";
      nombre = "albaranes";
      campoLock = "ptefactura";
      break;
    }
    default: {
      tabla = "facturascli";
      clave = "idfactura";
      nombre = "facturas";
      campoLock = "editable";
      break;
    }
  }

  var res: Number = MessageBox.information(sys.translate("La liquidación %1 será borrada y sus facturas o albaranes asociados serán desvinculados de la misma ¿Está seguro?").arg(codLiquidacion), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
  if (res != MessageBox.Yes) {
    return false;
  }
  if (!AQUtil.execSql("UPDATE facturascli SET codliquidacion = NULL WHERE codliquidacion = '" + codLiquidacion + "'")) {
    return false;
  }
  if (!AQUtil.execSql("UPDATE albaranescli SET codliquidacion = NULL WHERE codliquidacion = '" + codLiquidacion + "'")) {
    return false;
  }
  //  var q:FLSqlQuery = new FLSqlQuery();
  //  q.setTablesList(tabla);
  //  q.setSelect(clave);
  //  q.setFrom(tabla);
  //  q.setWhere("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
  //  q.setForwardOnly(true);
  //  if (!q.exec()) {
  //    return false;
  //  }
  //  if (q.size() != 0) {
  //    var res:Number = MessageBox.warning(util.translate("scripts", "Esta liquidación tiene %1 asociadas. Si la elimina se borrará el código de la liquidación de %2 ¿Desea continuar?").arg(nombre).arg(nombre), MessageBox.Yes, MessageBox.No);
  //    if (res != MessageBox.Yes) {
  //      return false;
  //    }
  //    var curDocs:FLSqlCursor = new FLSqlCursor(tabla);
  //    curDocs.setActivatedCheckIntegrity(false);
  //    curDocs.setActivatedCommitActions(false);
  //    while (q.next()) {
  //      curDocs.select(clave + " = " + q.value(0));
  //      if (!curDocs.first()) {
  //        continue;
  //      }
  //      var editable:String = curDocs.valueBuffer(campoLock);
  //      if (!editable) {
  //        curDocs.setUnLock(campoLock, true);
  //        curDocs.select(clave + " = " + q.value(0));
  //        if (!curDocs.first()) {
  //          return false;
  //        }
  //      }
  //
  //      curDocs.setModeAccess( curDocs.Edit );
  //      curDocs.refreshBuffer();
  //      curDocs.setNull("codliquidacion");
  //      if (!curDocs.commitBuffer()) {
  //        return false;
  //      }
  //      if (!editable) {
  //        curDocs.select(clave + " = " + q.value(0));
  //        if (!curDocs.first()) {
  //          return false;
  //        }
  //        curDocs.setUnLock(campoLock, false);
  //        if (!curDocs.commitBuffer()) {
  //          return false;
  //        }
  //      }
  //    }
  //  }
  var curLiquidacion: FLSqlCursor = new FLSqlCursor("liquidaciones");
  curLiquidacion.select("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
  curLiquidacion.first();
  curLiquidacion.setModeAccess(curLiquidacion.Del);
  curLiquidacion.refreshBuffer();
  if (!curLiquidacion.commitBuffer()) {
    return false;
  }
  this.child("tableDBRecords").refresh();
}

/** \C Muestra una grafica de las liquidaciones
\end */
function liqAgentes_grafica()
{
  var tabla: String, clave: String, nombre: String, campoLock: String;
  switch (this.iface.docLiquidacion_) {
    case "Albaranes": {
      tabla = "albaranescli";
      clave = "idalbaran";
      nombre = sys.translate("albaranes");
      campoLock = "ptefactura";
      break;
    }
    default: {
      tabla = "facturascli";
      clave = "idfactura";
      nombre = sys.translate("facturas");
      campoLock = "editable";
      break;
    }
  }

  var cursor: FLSqlCursor = this.cursor();
  var qryDocs: FLSqlQuery = new FLSqlQuery();

  qryDocs.setTablesList(tabla);
  qryDocs.setSelect("fecha, porcomision, neto");
  qryDocs.setFrom(tabla);
  qryDocs.setWhere("codliquidacion='" + cursor.valueBuffer("codliquidacion") + "'");
  qryDocs.setOrderBy("fecha");
  qryDocs.setForwardOnly(true);

  if (qryDocs.exec()) {
    if (qryDocs.size() > 0) {
      var stdin: String, datos: String, fechaInicio: String, fechaFin: String;
      var util: FLUtil = new FLUtil();

      qryDocs.first();
      fechaInicio = util.dateAMDtoDMA(qryDocs.value("fecha"));
      datos = fechaInicio + " " + (qryDocs.value("porcomision") * qryDocs.value("neto") / 100) + "\n";

      qryDocs.last();
      fechaFin = util.dateAMDtoDMA(qryDocs.value("fecha"));
      qryDocs.first();
      while (qryDocs.next())
        datos += util.dateAMDtoDMA(qryDocs.value("fecha")) + " " + (qryDocs.value("porcomision") * qryDocs.value("neto") / 100) + "\n";

      stdin =  "set title \"Liquidación : " + cursor.valueBuffer("codliquidacion") + "\"";
      stdin += "\nset xdata time";
      stdin += "\nset timefmt \"\%d-\%m-\%Y\"";
      stdin += "\nset xrange [\"" + fechaInicio + "\" : \"" + fechaFin + "\"]";
      stdin += "\nset format x \"\%d-\%m\"";
      stdin += "\nset grid";
      stdin += "\nplot '-' using 1:2 with lines smooth bezier\n";
      stdin += datos;

      Process.execute(["gnuplot", "-persist"], stdin);
    }
  }
}

/** \C Genera una factura de proveedor para la liquidación seleccionada
Comprueba antes de generar la factura que haya un porveedor asociadoa al agente de la liquidación.
Si ya hay una factura creada muestra un mensaje de aviso.
\end */
function liqAgentes_pbGenerarFactura_clicked()
{
  var util: FLUtil = new FLUtil();

  if (!util.sqlSelect("agentes", "codproveedor", "codagente = '" + this.cursor().valueBuffer("codagente") + "'")) {
    MessageBox.warning(util.translate("scripts", "No hay ningun proveedor asociado al agente ") + this.cursor().valueBuffer("codagente") + util.translate("scripts", ".\nAntes de generar la factura debe asociar un proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return false
  }

  if (util.sqlSelect("facturasprov", "codigo", "codigo = '" + this.cursor().valueBuffer("codfactura") + "'")) {
    var res: Number = MessageBox.warning(util.translate("scripts", "Ya se ha generado una factura para esta liquidación (") + this.cursor().valueBuffer("codfactura") + util.translate("scripts", ").\nSi desea sustituirla debe eliminarla manualmente.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }

  var curT: FLSqlCursor = new FLSqlCursor("empresa");
  curT.transaction(false);
  try {
    if (this.iface.generarFactura()) {
      curT.commit();
    } else {
      curT.rollback();
    }
  } catch (e) {
    curT.rollback();
    MessageBox.warning(util.translate("scripts", "Ha habido un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
}

/** \C Crea una factura de proveedor obteniendo los datos del proveedor asociado al agnete y de la empresa
@return true si se ha creado correctamente y false si ha habido algún error
\end */
function liqAgentes_generarFactura(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") || flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") == "")
  {
    MessageBox.information(util.translate("scripts", "No existe referencia de IVA para la liquidación.\nDeberá crear un artículo con los datos a introducir en la línea de la factura y\n asignarlo en el formulario de datos generales del módulo de almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  this.iface.curFactura_ = new FLSqlCursor("facturasprov");
  this.iface.curFactura_.setModeAccess(this.iface.curFactura_.Insert);
  this.iface.curFactura_.refreshBuffer();

  if (!this.iface.datosFactura(cursor))
  {
    return false;
  }

  if (!this.iface.curFactura_.commitBuffer())
  {
    return false;
  }
  var idFactura: Number = this.iface.curFactura_.valueBuffer("idfactura");

  this.iface.curLineaFactura_ = new FLSqlCursor("lineasfacturasprov");
  this.iface.curLineaFactura_.setModeAccess(this.iface.curLineaFactura_.Insert);
  this.iface.curLineaFactura_.refreshBuffer();

  if (!this.iface.datosLineaFactura(cursor, idFactura))
  {
    return false;
  }
  if (!this.iface.curLineaFactura_.commitBuffer())
  {
    return false;
  }

  this.iface.curFactura_.select("idfactura = " + idFactura);
  if (this.iface.curFactura_.first())
  {
    this.iface.curFactura_.setModeAccess(this.iface.curFactura_.Edit);
    this.iface.curFactura_.refreshBuffer();

    if (!this.iface.totalesFactura(cursor)) {
      return false;
    }
    if (!this.iface.curFactura_.commitBuffer()) {
      return false;
    }
  }

  MessageBox.information(util.translate("scripts", "Se ha creado la factura %1").arg(util.sqlSelect("facturasprov", "codigo", "idfactura = " + idFactura)), MessageBox.Ok, MessageBox.NoButton);

  var curLiq: FLSqlCursor = new FLSqlCursor("liquidaciones");
  curLiq.select("codliquidacion = '" + cursor.valueBuffer("codliquidacion") + "'");
  if (!curLiq.first())
  {
    return false;
  }
  curLiq.setModeAccess(curLiq.Edit);
  curLiq.refreshBuffer();
  curLiq.setValueBuffer("codfactura", util.sqlSelect("facturasprov", "codigo", "idfactura = " + idFactura));
  if (!curLiq.commitBuffer())
  {
    return false;
  }
  return true;
}

function liqAgentes_datosFactura(cursor: FLSqlCursor): Boolean {
  var util: FLUtil;
  var fecha: Date = new Date();
  var hora: String = fecha.toString().right(8);
  var codProveedor: String = util.sqlSelect("agentes", "codproveedor", "codagente = '" + cursor.valueBuffer("codagente") + "'");
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var serie: String = util.sqlSelect("proveedores", "codserie", "codproveedor = '" + codProveedor + "'")

  var datosDoc: Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "facturasprov");
  if (!datosDoc.ok)
  {
    return false;
  }
  if (datosDoc.modificaciones == true)
  {
    codEjercicio = datosDoc.codEjercicio;
    fecha = datosDoc.fecha;
  }

  if (!util.sqlSelect("secuenciasejercicios", "id", "codejercicio = '" + codEjercicio + "' AND codserie = '" + serie + "'"))
    serie = util.sqlSelect("secuenciasejercicios", "codserie", "codejercicio = '" + codEjercicio + "'");

  var pago: String = util.sqlSelect("proveedores", "codpago", "codproveedor = '" + codProveedor + "'")
  if (!pago)
  {
    pago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
  }
  var divisa: String = util.sqlSelect("proveedores", "coddivisa", "codproveedor = '" + codProveedor + "'")
  if (!divisa)
  {
    divisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  }
  this.iface.curFactura_.setValueBuffer("numero", 0);
  this.iface.curFactura_.setValueBuffer("codserie", serie);
  this.iface.curFactura_.setValueBuffer("codejercicio", codEjercicio);
  this.iface.curFactura_.setValueBuffer("fecha", fecha);
  this.iface.curFactura_.setValueBuffer("hora", hora);
  this.iface.curFactura_.setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
  this.iface.curFactura_.setValueBuffer("codpago", pago);
  this.iface.curFactura_.setValueBuffer("coddivisa", divisa);
  this.iface.curFactura_.setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + divisa + "'"));
  this.iface.curFactura_.setValueBuffer("codproveedor", codProveedor);
  this.iface.curFactura_.setValueBuffer("cifnif", util.sqlSelect("proveedores", "cifnif", "codproveedor = '" + codProveedor + "'"));
  this.iface.curFactura_.setValueBuffer("nombre", util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'"));
  this.iface.curFactura_.setValueBuffer("automatica", false);
  this.iface.curFactura_.setValueBuffer("numproveedor", sys.translate("L. %1").arg(cursor.valueBuffer("codliquidacion")));
  if (flfactppal.iface.pub_extension("iva_nav"))
  {
    this.iface.curFactura_.setValueBuffer("codgrupoivaneg", AQUtil.sqlSelect("proveedores", "codgrupoivaneg", "codproveedor = '" + codProveedor + "'"));
  }
  return true;
}

function liqAgentes_datosLineaFactura(cursor: FLSqlCursor, idFactura: Number): Boolean {
  var util: FLUtil;

  var codEjercicio: String = util.sqlSelect("facturasprov", "codejercicio", "idfactura = " + idFactura);
  var total = parseFloat(cursor.valueBuffer("total"));

  this.iface.curLineaFactura_.setValueBuffer("idfactura", idFactura);
  this.iface.curLineaFactura_.setValueBuffer("referencia", flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion"));
  this.iface.curLineaFactura_.setValueBuffer("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") + "'"));
  this.iface.curLineaFactura_.setValueBuffer("pvpunitario", total);
  this.iface.curLineaFactura_.setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", this.iface.curLineaFactura_));
  this.iface.curLineaFactura_.setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this.iface.curLineaFactura_));
  this.iface.curLineaFactura_.setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this.iface.curLineaFactura_));
  this.iface.curLineaFactura_.setValueBuffer("cantidad", 1);
  this.iface.curLineaFactura_.setValueBuffer("pvpsindto", total);
  this.iface.curLineaFactura_.setValueBuffer("pvptotal", total);

  var irpf: Number = util.sqlSelect("agentes", "irpf", "codagente = '" + cursor.valueBuffer("codagente") + "'");
  this.iface.curLineaFactura_.setValueBuffer("irpf", irpf);

  var datosCtaLiq: Array = flfacturac.iface.pub_datosCtaEspecial("LIQAGE", codEjercicio);
  if (datosCtaLiq.error == 0)
  {
    this.iface.curLineaFactura_.setValueBuffer("codsubcuenta", datosCtaLiq.codsubcuenta);
    this.iface.curLineaFactura_.setValueBuffer("idsubcuenta", datosCtaLiq.idsubcuenta);
  }

  return true;
}

function liqAgentes_totalesFactura(cursor: FLSqlCursor): Boolean {
  var total = parseFloat(cursor.valueBuffer("total"));
  this.iface.curFactura_.setValueBuffer("neto", total);
  this.iface.curFactura_.setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", this.iface.curFactura_));
  this.iface.curFactura_.setValueBuffer("totalirpf", formfacturasprov.iface.pub_commonCalculateField("totalirpf", this.iface.curFactura_));
  this.iface.curFactura_.setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", this.iface.curFactura_));
  this.iface.curFactura_.setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", this.iface.curFactura_));
  this.iface.curFactura_.setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", this.iface.curFactura_));
  return true;
}

/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la liquidación seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function liqAgentes_imprimir()
{
  if (sys.isLoadedModule("flfactinfo")) {
    if (!this.cursor().isValid())
      return;
    var codigo: String = this.cursor().valueBuffer("codliquidacion");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_liquidaciones");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_liquidaciones_codliquidacion", codigo);
    curImprimir.setValueBuffer("h_liquidaciones_codliquidacion", codigo);

    var informe: String;
    switch (this.iface.docLiquidacion_) {
      case "Albaranes": {
        informe = "i_liquidaciones_alb";
        break;
      }
      default: {
        informe = "i_liquidaciones";
        break;
      }
    }
    flfactinfo.iface.pub_lanzarInforme(curImprimir, informe);
  } else {
    flfactppal.iface.pub_msgNoDisponible("Informes");
  }
}

/** \C
Abre y procesa el resultado del formulario de generación automática de liquidaciones
\end */
function liqAgentes_pbnGenerarLiqAgentes_clicked()
{
  debug("liqAgentes_pbnGenerarLiqAgentes_clicked");
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("generarliqagentes");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt: String = f.exec("id");
  debug("acpt " + acpt);
  if (acpt) {
    if (!cursor.commitBuffer()) {
      debug("!commitBuffer()");
      return false;
    }
    var curTransaccion: FLSqlCursor = new FLSqlCursor("empresa");
    var curGenerarLiq: FLSqlCursor = new FLSqlCursor("generarliqagentes");
    curGenerarLiq.select();
    if (curGenerarLiq.first()) {
      var agentes: String = curGenerarLiq.valueBuffer("agentes");
      debug("agentes " + agentes);
      if (!agentes || agentes == "") {
        MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún agente"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var aAgentes: Array = agentes.split(", ");
      var totalAgentes: Number = aAgentes.length;
      var codAgente: String;
      var filtroFacturas: String;
      AQUtil.createProgressDialog(util.translate("scripts", "Generando liquidaciones"), totalAgentes);
      AQUtil.setProgress(1);
      var j: Number = 0;
      for (var i: Number = 0; i < totalAgentes; i++) {
        codAgente = aAgentes[i];
        debug("codAgente " + codAgente);
        curTransaccion.transaction(false);
        try {
          if (this.iface.generarLiquidacion(codAgente, curGenerarLiq)) {
            curTransaccion.commit();
          } else {
            curTransaccion.rollback();
            sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
            MessageBox.warning(util.translate("scripts", "Falló la creación de la liquidación correspondiente al agente: %1").arg(codAgente), MessageBox.Ok, MessageBox.NoButton);
            return;
          }
        } catch (e) {
          curTransaccion.rollback();
          sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
          MessageBox.critical(util.translate("scripts", "Error al generar la liquidación para el agente %1:").arg(codAgente) + e, MessageBox.Ok, MessageBox.NoButton);
        }
        AQUtil.setProgress(++j);
      }
      AQUtil.setProgress(totalAgentes);
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      MessageBox.information(util.translate("scripts", "Se han generado %1 nuevas liquidaciones").arg(j), MessageBox.Ok, MessageBox.NoButton);
      this.child("tableDBRecords").refresh();
    }
  }
  return true;
}

/** \D Genera un registro de liquidación y asocia al mismo las facturas que cumplen los criterios impuestos en el cursor de generacion
@param  codAgente: Agente asociado a la liquidación
@param  curGenerarLiq: Cursor que contiene los criterios de búsqueda de las facturas
@return código de la liquidación generada o false si hay un error
\end */
function liqAgentes_generarLiquidacion(codAgente: String, curGenerarLiq: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;

  if (!this.iface.curLiquidacion_)
  {
    this.iface.curLiquidacion_ = new FLSqlCursor("liquidaciones");
  }
  this.iface.curLiquidacion_.setModeAccess(this.iface.curLiquidacion_.Insert);
  this.iface.curLiquidacion_.refreshBuffer();

  var codLiquidacion: String = util.nextCounter("codliquidacion", this.iface.curLiquidacion_);
  this.iface.curLiquidacion_.setValueBuffer("codliquidacion", codLiquidacion);
  this.iface.curLiquidacion_.setValueBuffer("codagente", codAgente);
  if (!this.iface.datosLiquidacion(curGenerarLiq))
  {
    return false;
  }
  if (!this.iface.curLiquidacion_.commitBuffer())
  {
    return false;
  }

  var filtro: String = flfactppal.iface.pub_obtenFiltroFacturas(codAgente, curGenerarLiq.valueBuffer("fechadesde"), curGenerarLiq.valueBuffer("fechahasta"), curGenerarLiq.valueBuffer("codejercicio"), this.iface.docLiquidacion_);
  if (!flfactppal.iface.pub_asociarFacturasLiq(filtro, codLiquidacion, this.iface.docLiquidacion_))
  {
    return false;
  }

  this.iface.curLiquidacion_.select("codliquidacion = '" + codLiquidacion + "'");
  if (!this.iface.curLiquidacion_.first())
  {
    return false;
  }
  this.iface.curLiquidacion_.setModeAccess(this.iface.curLiquidacion_.Edit);
  this.iface.curLiquidacion_.refreshBuffer();
  if (!this.iface.totalesLiquidacion())
  {
    return false;
  }
  if (!this.iface.curLiquidacion_.commitBuffer())
  {
    return false;
  }

  return codLiquidacion;
}

/** \D Informa los datos de una nueva liquidación con los del cursor de generación
@param  curGenerarLiq: Cursor de generación
\end */
function liqAgentes_datosLiquidacion(curGenerarLiq: FLSqlCursor): Boolean {
  this.iface.curLiquidacion_.setValueBuffer("fecha", curGenerarLiq.valueBuffer("fecha"));
  this.iface.curLiquidacion_.setValueBuffer("fechadesde", curGenerarLiq.valueBuffer("fechadesde"));
  this.iface.curLiquidacion_.setValueBuffer("fechahasta", curGenerarLiq.valueBuffer("fechahasta"));
  this.iface.curLiquidacion_.setValueBuffer("codejercicio", curGenerarLiq.valueBuffer("codejercicio"));
  return true;
}

/** \D Informa los datos totalizados de una nueva liquidación
\end */
function liqAgentes_totalesLiquidacion(curGenerarLiq: FLSqlCursor): Boolean {
  var hoy: Date = new Date;

  //  var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(this.iface.curLiquidacion_.valueBuffer("codagente"), this.iface.curLiquidacion_.valueBuffer("fechadesde"), this.iface.curLiquidacion_.valueBuffer("fechahasta"), this.iface.curLiquidacion_.valueBuffer("codejercicio"), this.iface.docLiquidacion_);

  var tabla: String;
  switch (this.iface.docLiquidacion_)
  {
    case "Albaranes": {
      tabla = "albaranescli";
      break;
    }
    default: {
      tabla = "facturascli";
      break;
    }
  }

  var filtro: String = tabla + ".codliquidacion = '" + this.iface.curLiquidacion_.valueBuffer("codliquidacion") + "'";

  this.iface.curLiquidacion_.setValueBuffer("total", flfactppal.iface.pub_calcularLiquidacionAgente(filtro, this.iface.docLiquidacion_));
  return true;
}

//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
