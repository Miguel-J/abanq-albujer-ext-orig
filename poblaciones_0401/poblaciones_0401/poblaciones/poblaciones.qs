/***************************************************************************
                 poblaciones.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  function validateForm(): Boolean {
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
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idProvincia: String = cursor.valueBuffer("idprovincia");
  if (!idProvincia || idProvincia == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer la provincia"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var codPais: String = cursor.valueBuffer("codpais");
  if (!codPais || codPais == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el país"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!util.sqlSelect("provincias", "idprovincia", "idprovincia = " + idProvincia + " AND codpais = '" + codPais + "'"))
  {
    var provincia: String = util.sqlSelect("provincias", "provincia", "idprovincia = " + idProvincia);
    MessageBox.warning(util.translate("scripts", "La provincia %1 no pertenece a %2").arg(provincia).arg(codPais), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codProvincia: String = cursor.valueBuffer("codprovincia");
  if (util.sqlSelect("provincias", "codigo", "idprovincia = " + idProvincia) != codProvincia)
  {
    var provincia: String = util.sqlSelect("provincias", "provincia", "idprovincia = " + idProvincia);
    MessageBox.warning(util.translate("scripts", "El código %1 no pertenece a la provincia %2").arg(codProvincia).arg(provincia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  /// Se permite que el código de población sea nulo, pero si no lo es dicho código no puede estar repetido en el mismo país
  var codPoblacion: String = cursor.valueBuffer("codpoblacion");
  if (codPais && codPoblacion != "")
  {
    var idPoblacion: String = cursor.valueBuffer("idpoblacion");
    if (util.sqlSelect("poblaciones", "idpoblacion", "codpais = '" + codPais + "' AND codpoblacion = '" + codPoblacion + "' AND idpoblacion <> " + idPoblacion)) {
      MessageBox.warning(util.translate("scripts", "Ya existe otra población con código %1 para %2").arg(codPoblacion).arg(codPais), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
