/***************************************************************************
                 solpresupuestosprov.qs  -  description
                             -------------------
    begin                : jue ago 28 2008
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
  function tbnCargar_clicked()
  {
    return this.ctx.oficial_tbnCargar_clicked();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function filtrarDatos()
  {
    return this.ctx.oficial_filtrarDatos();
  }
  function anadirTodasLineasOferta(): Boolean {
    return this.ctx.oficial_anadirTodasLineasOferta();
  }
  function anadirLineaOferta(codProveedor: String): Boolean {
    return this.ctx.oficial_anadirLineaOferta(codProveedor);
  }
  function eliminarTodasLineasOferta(): Boolean {
    return this.ctx.oficial_eliminarTodasLineasOferta();
  }
  function eliminarLineaOferta(): Boolean {
    return this.ctx.oficial_eliminarLineaOferta();
  }
  function generarOfertas_clicked()
  {
    return this.ctx.oficial_generarOfertas_clicked();
  }
  function generarOferta(): Boolean {
    return this.ctx.oficial_generarOferta();
  }
  function aceptarOferta_clicked()
  {
    return this.ctx.oficial_aceptarOferta_clicked();
  }
  function anularConfirmacion()
  {
    return this.ctx.oficial_anularConfirmacion();
  }
  function asignarProveedor()
  {
    return this.ctx.oficial_asignarProveedor();
  }
  function datosPresupuestoProv(curPresupuestosProv: FLSqlCursor, codProveedor: String): Boolean {
    return this.ctx.oficial_datosPresupuestoProv(curPresupuestosProv, codProveedor);
  }
  function comprobarSecuenciasSeries()
  {
    return this.ctx.oficial_comprobarSecuenciasSeries();
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
/** \C
Este formulario realiza la gestion de los albaranes a clientes.

Los albaranes pueden ser generados de forma manual o a partir de uno o mas pedidos.
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnCargar"), "clicked()", this, "iface.tbnCargar_clicked()");
  connect(this.child("tdbLineasSolPresupuestosProv").cursor(), "newBuffer()", this, "iface.filtrarDatos");
  this.iface.filtrarDatos();

  connect(this.child("pbnAnadirTodos"), "clicked()", this, "iface.anadirTodasLineasOferta()");
  connect(this.child("pbnAnadir"), "clicked()", this, "iface.anadirLineaOferta()");
  connect(this.child("pbnEliminar"), "clicked()", this, "iface.eliminarLineaOferta()");
  connect(this.child("pbnEliminarTodos"), "clicked()", this, "iface.eliminarTodasLineasOferta()");
  connect(this.child("tbnGenerarOfertas"), "clicked()", this, "iface.generarOfertas_clicked()");
  connect(this.child("pbnAceptarOferta"), "clicked()", this, "iface.aceptarOferta_clicked()");
  connect(this.child("tbnAnularConfirmacion"), "clicked()", this, "iface.anularConfirmacion()");
  connect(this.child("tbnAsignarProveedor"), "clicked()", this, "iface.asignarProveedor()");

  var cols: Array = ["codproveedor", "nombreproveedor", "pvpunitario", "dto", "plazo", "aprobado"];
  this.child("tdbLineasPresupuestosProv").setOrderCols(cols);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "codpresupuestocli": {
      var codSolicitud: String = util.sqlSelect("solpresupuestosprov", "codsolicitud", "codpresupuestocli = '" + cursor.valueBuffer("codpresupuestocli") + "' AND codsolicitud <> '" + cursor.valueBuffer("codsolicitud") + "'");
      if (codSolicitud) {
        MessageBox.information(util.translate("scripts", "Ya existe una solicitud para este presupuesto de cliente."), MessageBox.Ok, MessageBox.NoButton);
        cursor.setValueBuffer("codpresupuestocli", "");
        return false;
      }
      break;
    }
  }
}

function oficial_tbnCargar_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var idPresupuesto: String = cursor.valueBuffer("idpresupuestocli");
  if (!idPresupuesto) {
    MessageBox.information(util.translate("scripts", "Indique el presupuesto desde\nel cual quiere cargar los datos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (cursor.modeAccess() == cursor.Insert) {
    var curLineasPresupuestosProv: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
    curLineasPresupuestosProv.setModeAccess(curLineasPresupuestosProv.Insert);
    if (!curLineasPresupuestosProv.commitBufferCursorRelation()) {
      return false;
    }
  }

  cursor.transaction(false);
  try {
    if (flfacturac.iface.pub_cargarDatosSolOferta(cursor)) {
      cursor.commit();
      this.child("tdbLineasSolPresupuestosProv").refresh();
    } else {
      cursor.rollback();
    }
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la carga de los datos:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }
}

function oficial_filtrarDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setValueBuffer("referencia", this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia"));

  this.child("tdbLineasPresupuestosProv").setFilter("referencia = '" + this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia") + "'");

  this.child("tdbArticulosProv").refresh();
  this.child("tdbLineasPresupuestosProv").refresh();
}

function oficial_anadirTodasLineasOferta(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("articulosprov");
  qry.setSelect("codproveedor");
  qry.setFrom("articulosprov");
  qry.setWhere("referencia = '" + this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia") + "'");
  if (!qry.exec())
    return false;

  while (qry.next())
  {
    if (!this.iface.anadirLineaOferta(qry.value("codproveedor")))
      return false;
  }
  return true;
}

function oficial_anadirLineaOferta(codProveedor: Sring): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia");
  if (!codProveedor)
    codProveedor = this.child("tdbArticulosProv").cursor().valueBuffer("codproveedor");

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("lineaspresupuestosprov");
  qry.setSelect("idlinea");
  qry.setFrom("lineaspresupuestosprov");
  qry.setWhere("referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "' AND codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'");
  if (!qry.exec())
    return false;
  if (qry.first())
  {
    MessageBox.information(util.translate("scripts", "Ya existe una línea de oferta\ndel proveedor %1 para el artículo %2").arg(codProveedor).arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return true;
  }

  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var curLineasPresupuestosProv: FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
  curLineasPresupuestosProv.setModeAccess(curLineasPresupuestosProv.Insert);
  curLineasPresupuestosProv.refreshBuffer();

  if (referencia)
    curLineasPresupuestosProv.setValueBuffer("referencia", referencia);

  var descripcion: String = this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("descripcion");
  curLineasPresupuestosProv.setValueBuffer("descripcion", descripcion);

  var cantidad: Number = this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("cansolicitada");
  curLineasPresupuestosProv.setValueBuffer("cantidad", cantidad);

  curLineasPresupuestosProv.setValueBuffer("refproveedor", "");
  curLineasPresupuestosProv.setValueBuffer("pvpunitario", "");
  curLineasPresupuestosProv.setValueBuffer("dto", "");
  curLineasPresupuestosProv.setValueBuffer("plazo", "");

  curLineasPresupuestosProv.setValueBuffer("aprobado", false);
  curLineasPresupuestosProv.setValueBuffer("codsolicitud", cursor.valueBuffer("codsolicitud"));

  if (codProveedor)
  {
    curLineasPresupuestosProv.setValueBuffer("codproveedor", codProveedor);
    var nombreProv: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
    curLineasPresupuestosProv.setValueBuffer("nombreproveedor", nombreProv);
  }

  if (!curLineasPresupuestosProv.commitBuffer())
    return false;

  this.child("tdbLineasPresupuestosProv").refresh();
  return true;
}

function oficial_eliminarTodasLineasOferta(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  if (!util.sqlDelete("lineaspresupuestosprov", "referencia = '" + this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia") + "' AND codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'"))
    return false;

  this.child("tdbLineasPresupuestosProv").refresh();
  return true;
}

function oficial_eliminarLineaOferta(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var curLP: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
  var idLinea: String = curLP.valueBuffer("idlinea");

  var oferta: String = curLP.valueBuffer("idpresupuesto");

  var codProveedor: String = util.sqlSelect("lineaspresupuestosprov", "codproveedor", "idlinea = " + idLinea);

  if (oferta)
  {
    var res: Number = MessageBox.information(util.translate("scripts", "La línea seleccionada pertenece a una oferta de proveedor.\n¿Desea eliminarla?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }

  if (!util.sqlDelete("lineaspresupuestosprov", "codproveedor = '" + codProveedor + "' AND referencia = '" + this.child("tdbLineasSolPresupuestosProv").cursor().valueBuffer("referencia") + "' AND codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'"))
  {
    return false;
  }

  this.child("tdbLineasPresupuestosProv").refresh();
  return true;
}

function oficial_generarOfertas_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  if (!util.sqlSelect("lineaspresupuestosprov", "idlinea", "codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "' AND idpresupuesto IS NULL")) {
    MessageBox.information(util.translate("scripts", "Para generar una oferta es necesario tener lineas creadas que no pertenezcan a ninguna oferta."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  this.iface.comprobarSecuenciasSeries();

  cursor.transaction(false);
  try {
    if (this.iface.generarOferta()) {
      var res: Number = MessageBox.information(util.translate("scripts", "Ofertas generadas correctamente.\n¿Desea imprimirlas?"), MessageBox.Yes, MessageBox.No);
      if (res == MessageBox.Yes) {
        var masWhere: String = "presupuestosprov.codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'";

        if (sys.isLoadedModule("flfactinfo")) {
          var curImprimir: FLSqlCursor = new FLSqlCursor("i_presupuestosprov");
          curImprimir.setModeAccess(curImprimir.Insert);
          curImprimir.refreshBuffer();
          curImprimir.setValueBuffer("descripcion", "temp");
          flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_presupuestosprov", "", "", false, false, masWhere);
        } else {
          flfactppal.iface.pub_msgNoDisponible("Informes");
        }
      }
      cursor.commit();
    } else
      cursor.rollback();
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de las ofertas:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }
}

function oficial_comprobarSecuenciasSeries()
{
  var util: FLUtil;
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  if (!codEjercicio || codEjercicio == "")
    return;

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("secuenciasejercicios");
  qry.setSelect("codserie,id");
  qry.setFrom("secuenciasejercicios");
  qry.setWhere("codejercicio = '" + codEjercicio + "'");
  if (!qry.exec())
    return false;

  var serie: String = "";
  var cursorSecs: FLSqlCursor = new FLSqlCursor("secuencias");
  cursorSecs.setActivatedCheckIntegrity(false);
  while (qry.next()) {
    var serie: String = qry.value("codserie");
    if (!serie || serie == "")
      continue;

    cursorSecs.select("id=" + qry.value("id") + " AND nombre= 'npresupuestoprov'");
    if (!cursorSecs.next()) {
      cursorSecs.setModeAccess(cursorSecs.Insert);
      cursorSecs.refreshBuffer();
      cursorSecs.setValueBuffer("id", qry.value("id"));
      cursorSecs.setValueBuffer("nombre", "npresupuestoprov");
      cursorSecs.setValueBuffer("valor", 1);
      cursorSecs.commitBuffer()
    }
  }
}

function oficial_generarOferta(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("lineaspresupuestosprov");
  qry.setSelect("idlinea,idpresupuesto,codproveedor");
  qry.setFrom("lineaspresupuestosprov");
  qry.setWhere("codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "' AND idpresupuesto IS NULL");
  if (!qry.exec())
    return false;

  while (qry.next())
  {
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("presupuestosprov");
    q.setSelect("idpresupuesto");
    q.setFrom("presupuestosprov");
    q.setWhere("codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "' AND codproveedor = '" + qry.value("codproveedor") + "'");
    if (!q.exec())
      return false;
    if (q.first()) {
      if (!util.sqlUpdate("lineaspresupuestosprov", "idpresupuesto", q.value("idpresupuesto"), "idlinea = " + qry.value("idlinea")))
        return false;
    } else {
      var curPresupuestosProv: FLSqlCursor = new FLSqlCursor("presupuestosprov");
      curPresupuestosProv.setModeAccess(curPresupuestosProv.Insert);
      curPresupuestosProv.refreshBuffer();

      if (!this.iface.datosPresupuestoProv(curPresupuestosProv, qry.value("codproveedor")))
        return false;

      if (!curPresupuestosProv.commitBuffer())
        return false;

      if (!util.sqlUpdate("lineaspresupuestosprov", "idpresupuesto", curPresupuestosProv.valueBuffer("idpresupuesto"), "idlinea = " + qry.value("idlinea")))
        return false;
    }
  }
  this.child("tdbPresupuestosProv").refresh();
  return true;
}

function oficial_datosPresupuestoProv(curPresupuestosProv: FLSqlCursor, codProveedor: String): Boolean {
  var util: FLUtil;
  var curProveedor: FLSqlCursor = new FLSqlCursor("proveedores");
  curProveedor.select("codproveedor = '" + codProveedor + "'");
  if (!curProveedor.first())
    return false;
  curProveedor.setModeAccess(curProveedor.Browse);
  curProveedor.refreshBuffer();

  var cursor: FLSqlCursor = this.cursor();
  var hoy: Date = new Date();

  var codSerie: String = curProveedor.valueBuffer("codserie");
  if (!codSerie || codSerie == "")
    codSerie = flfactppal.iface.pub_valorDefectoEmpresa("codserie");

  curPresupuestosProv.setValueBuffer("codserie", codSerie);
  curPresupuestosProv.setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
  curPresupuestosProv.setValueBuffer("codigo", formpresupuestosprov.iface.pub_commonCalculateField("codigo", curPresupuestosProv));
  curPresupuestosProv.setValueBuffer("codproveedor", codProveedor);
  curPresupuestosProv.setValueBuffer("nombreproveedor", curProveedor.valueBuffer("nombre"));
  curPresupuestosProv.setValueBuffer("codcontacto", curProveedor.valueBuffer("codcontacto"));
  curPresupuestosProv.setValueBuffer("contacto", util.sqlSelect("crm_contactos", "nombre", "codcontacto = '" + curProveedor.valueBuffer("codcontacto") + "'"));
  curPresupuestosProv.setValueBuffer("telefono1", curProveedor.valueBuffer("telefono1"));
  curPresupuestosProv.setValueBuffer("fax", curProveedor.valueBuffer("fax"));
  curPresupuestosProv.setValueBuffer("email", curProveedor.valueBuffer("email"));
  curPresupuestosProv.setValueBuffer("codsolicitud", cursor.valueBuffer("codsolicitud"));
  curPresupuestosProv.setValueBuffer("codpresupuestocli", cursor.valueBuffer("codpresupuestocli"));
  curPresupuestosProv.setValueBuffer("femision", hoy);

  return true;
}

function oficial_aceptarOferta_clicked()
{
  var util: FLUtil = new FLUtil();
  var curLineaOferta: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
  if (!flfacturac.iface.pub_aceptarOferta(curLineaOferta))
    return false;

  this.child("tdbLineasSolPresupuestosProv").refresh();
}

function oficial_anularConfirmacion()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!util.sqlUpdate("lineassolpresupuestosprov", "confirmado", false, "codsolicitud = '" +  cursor.valueBuffer("codsolicitud") + "' AND referencia = '" + cursor.valueBuffer("referencia") + "'"))
    return false;

  if (!util.sqlUpdate("lineaspresupuestosprov", "aprobado", false, "codsolicitud = '" +  cursor.valueBuffer("codsolicitud") + "' AND referencia = '" + cursor.valueBuffer("referencia") + "'"))
    return false;

  this.child("tdbLineasSolPresupuestosProv").refresh();
}

function oficial_asignarProveedor()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("proveedores");
  f.setMainWidget();
  var codProveedor: String = f.exec("codproveedor");
  if (!codProveedor) {
    return false;
  }
  var nombreProveedor: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");

  var curLinea: FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("lineassolpresupuestosprov");
  q.setSelect("referencia,descripcion,cansolicitada");
  q.setFrom("lineassolpresupuestosprov");
  q.setWhere("codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'");
  if (!q.exec()) {
    return false;
  }
  while (q.next()) {
    curLinea.select("referencia = '" + q.value("referencia") + "' AND codproveedor = '" + codProveedor + "' AND codsolicitud = '" + cursor.valueBuffer("codsolicitud") + "'");
    if (!curLinea.first()) {
      curLinea.setModeAccess(curLinea.Insert);
      curLinea.refreshBuffer();
      curLinea.setValueBuffer("referencia", q.value("referencia"));
      curLinea.setValueBuffer("descripcion", q.value("descripcion"));
      curLinea.setValueBuffer("codsolicitud", cursor.valueBuffer("codsolicitud"));
      curLinea.setValueBuffer("codproveedor", codProveedor);
      curLinea.setValueBuffer("nombreproveedor", nombreProveedor);
      curLinea.setValueBuffer("cantidad", q.value("cansolicitada"));
      if (!curLinea.commitBuffer()) {
        return false;
      }
    }
  }
  this.child("tdbLineasPresupuestosProv").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
