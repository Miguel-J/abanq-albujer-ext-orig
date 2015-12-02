/***************************************************************************
                 masterreposicion.qs  -  description
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
  function oficial(context)
  {
    interna(context);
  }
  function generar()
  {
    return this.ctx.oficial_generar();
  }
  function crearReposicion(): Boolean {
    return this.ctx.oficial_crearReposicion();
  }
  function crearLineasReposicion(idReposicion: String): Boolean {
    return this.ctx.oficial_crearLineasReposicion(idReposicion);
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
  connect(this.child("tbnGenerar"), "clicked()", this, "iface.generar()");
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_generar()
{
  var util: FLUtil = new FLUtil;
  var idUsuario: String = sys.nameUser();

  if (util.sqlSelect("reposicion", "idreposicion", "idusuario = '" + idUsuario + "' AND estado = 'PTE'")) {
    MessageBox.warning(util.translate("scripts", "Ya existe una reposición pendiente para el usuario indicado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var curTrans: FLSqlCursor = new FLSqlCursor("reposicion");
  curTrans.transaction(false);
  try {
    if (this.iface.crearReposicion())
      curTrans.commit();
    else
      curTrans.rollback();
  } catch (e) {
    curTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Error al crear el registro de reposición: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

}

function oficial_crearReposicion(): Boolean {
  var hoy: Date = new Date();
  var idUsuario: String = sys.nameUser();
  var curR: FLSqlCursor = new FLSqlCursor("reposicion");
  curR.setModeAccess(curR.Insert);
  curR.refreshBuffer();

  curR.setValueBuffer("idusuario", idUsuario);
  curR.setValueBuffer("fecha", hoy);
  curR.setValueBuffer("hora", hoy.toString().right(8));
  curR.setValueBuffer("estado", "PTE");
  if (!curR.commitBuffer())
    return false;

  var idReposicion: String = curR.valueBuffer("idreposicion");
  if (!idReposicion)
    return false;

  if (!this.iface.crearLineasReposicion(idReposicion))
    return false;

  return true;
}

function oficial_crearLineasReposicion(idReposicion: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;

  var qryUbi: FLSqlQuery = new FLSqlQuery;
  with(qryUbi)
  {
    setTablesList("ubicacionesarticulo,lineasreposicion,ubicaciones,zonas");
    setSelect("u.id, u.cantidadactual, u.referencia, u.codubicacion, u.capacidadmax");
    setFrom("ubicacionesarticulo u LEFT OUTER JOIN lineasreposicion lr ON (u.id = lr.idubicaciondestino AND lr.estadoentrada = 'PTE') INNER JOIN ubicaciones ub ON u.codubicacion = ub.codubicacion INNER JOIN zonas z ON ub.codzona = z.codzona");
    setWhere("u.cantidadactual <= u.cantidadlim AND lr.idlineareposicion IS NULL AND z.tipo = 'PICKING'");
    setForwardOnly(true);
  }
  if (!qryUbi.exec())
    return false;

  var cantidad: Number;
  var numLineas: Number = 0;
  while (qryUbi.next())
  {
    var curLineaR: FLSqlCursor = new FLSqlCursor("lineasreposicion");
    curLineaR.setModeAccess(curLineaR.Insert);
    curLineaR.refreshBuffer();

    cantidad = parseFloat(qryUbi.value("u.capacidadmax")) - parseFloat(qryUbi.value("u.cantidadactual"));
    var q: FLSqlQuery = new FLSqlQuery;
    with(q) {
      setTablesList("ubicacionesarticulo,zonas,ubicaciones");
      setSelect("u.id, u.codubicacion");
      setFrom("ubicacionesarticulo u INNER JOIN ubicaciones ub ON u.codubicacion = ub.codubicacion INNER JOIN zonas z ON ub.codzona = z.codzona");
      setWhere("u.referencia = '" + qryUbi.value("u.referencia") + "' AND u.cantidadactual >= " + cantidad + " AND z.tipo = 'MASIVO'");
      setForwardOnly(true);
    }

    if (!q.exec())
      return false;

    if (!q.first()) {
      MessageBox.warning(util.translate("scripts", "No hay ubicaciones de MASIVO que contengan el artículo:\nReferencia %1").arg(qryUbi.value("u.referencia")), MessageBox.Ok, MessageBox.NoButton);
      continue;
    }

    curLineaR.setValueBuffer("idreposicion", idReposicion);
    curLineaR.setValueBuffer("codubicacionorigen", q.value("u.codubicacion"));
    curLineaR.setValueBuffer("idubicacionorigen", q.value("u.id"));
    curLineaR.setValueBuffer("codubicaciondestino", qryUbi.value("u.codubicacion"));
    curLineaR.setValueBuffer("idubicaciondestino", qryUbi.value("u.id"));
    curLineaR.setValueBuffer("referencia", qryUbi.value("u.referencia"));
    curLineaR.setValueBuffer("estadoentrada", "PTE");
    curLineaR.setValueBuffer("estadosalida", "PTE");
    curLineaR.setValueBuffer("cantidad", cantidad);
    if (!curLineaR.commitBuffer())
      return false;

    numLineas++;
  }
  if (numLineas == 0)
  {
    /*    MessageBox.warning(util.translate("scripts", "No se ha creado ninguna línea de reposición. La reposición no se creará"), MessageBox.Ok, MessageBox.NoButton);*/
    MessageBox.warning(util.translate("scripts", "No hay ubicaciones de PICKING con cantidad inferior al límite de reposición"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.child("tableDBRecords").refresh();
  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////