/***************************************************************************
                 masterusuarios.qs  -  description
                             -------------------
    begin                : mar jun 20 2006
    copyright            : (C) 2004-2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; version 2 of the License.               *
***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
  var lblUsuario: Object;
  function oficial(context)
  {
    interna(context);
  }
  function setUsuario()
  {
    this.ctx.oficial_setUsuario();
  }
  function unsetUsuario()
  {
    this.ctx.oficial_unsetUsuario();
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
  this.iface.lblUsuario = this.child("lblUsuario");

  var codUsuario: String = util.readSettingEntry("scripts/flfactppal/miUsuario");
  if (!codUsuario)
    codUsuario = util.translate("scripts", "no establecido");
  this.iface.lblUsuario.text = codUsuario;
  connect(this.child("pbnSetUsuario"), "clicked()", this, "iface.setUsuario");
  connect(this.child("pbnUnsetUsuario"), "clicked()", this, "iface.unsetUsuario");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_setUsuario()
{
  if (!this.cursor())
    return;

  var util: FLUtil = new FLUtil();

  var codUsuario: String = this.cursor().valueBuffer("codigo");
  util.writeSettingEntry("scripts/flfactppal/miUsuario", codUsuario);
  this.iface.lblUsuario.text = codUsuario;
}

function oficial_unsetUsuario()
{
  if (!this.cursor())
    return;

  var util: FLUtil = new FLUtil();

  util.writeSettingEntry("scripts/flfactppal/miUsuario", "");
  this.iface.lblUsuario.text = util.translate("scripts", "no establecido");
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
