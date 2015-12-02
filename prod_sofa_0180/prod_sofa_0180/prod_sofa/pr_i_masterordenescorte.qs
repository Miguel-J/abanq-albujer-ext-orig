/***************************************************************************
                 pr_i_masterordenescorte.qs  -  description
                             -------------------
    begin                : vie ago 10 2007
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
  function lanzar(cursor: FLSqlCursor)
  {
    return this.ctx.oficial_lanzar(cursor);
  }
  function rutaCorte(nodo: FLDomNode, campo: String): String {
    return this.ctx.oficial_rutaCorte(nodo, campo);
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
  function pub_lanzar(cursor: FLSqlCursor)
  {
    return this.lanzar(cursor);
  }
  function pub_rutaCorte(nodo, campo)
  {
    return this.rutaCorte(nodo, campo);
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
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar(cursor: FLSqlCursor)
{
  var util: FLUtil = new FLUtil;
  if (!cursor)
    cursor = this.cursor()

             var seleccion: String = cursor.valueBuffer("id");
  if (!seleccion)
    return;
  var nombreInforme: String = "pr_i_ordenescorte";

  var idTipoOpcionMarcada: String = util.sqlSelect("tiposopcioncomp", "idtipoopcion", "tipo = 'MARCADA'");
  if (!idTipoOpcionMarcada) {
    MessageBox.warning(util.translate("scripts", "No tiene definido un tipo de opción MARCADA para artículos compuestos.\nSin esta definición no es posible calcular la tela de los módulos.\nCree un tipo de opción con nombre 'MARCADA' en el módulo de almacén."), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  var masWhere: String = "tiposopcionartcomp.idtipoopcion = " + idTipoOpcionMarcada;

  flprodinfo.iface.pub_lanzarInforme(cursor, "pr_i_ordenescorte", "", "", false, false, masWhere);
}

function oficial_rutaCorte(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var codLoteCorte: String = nodo.attributeValue("lotesstock.codlote");
  var codLoteModulo: String = util.sqlSelect("lotesstock ls INNER JOIN movistock ms ON ls.codlote = ms.codlote", "ms.codloteprod", "ls.codlote = '" + codLoteCorte + "' AND ms.codloteprod IS NOT NULL", "lotesstock,movistock");
  if (!codLoteModulo)
    return "Error";

  var codRuta: String = util.sqlSelect("lotesstock ls INNER JOIN pr_ordenesproduccion op ON ls.codordenproduccion = op.codorden", "op.codruta", "ls.codlote = '" + codLoteModulo + "'", "lotesstock,pr_ordenesproduccion");
  if (!codRuta)
    codRuta = "";

  return codRuta;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
