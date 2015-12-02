/***************************************************************************
                 i_plantillasodt.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
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
    this.ctx.interna_init();
  }
  function calculateCounter(): String { return this.ctx.interna_calculateCounter(); }
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
  function establecerDocPlantilla()
  {
    return this.ctx.oficial_establecerDocPlantilla() ;
  }
  function abrirDocPlantilla()
  {
    return this.ctx.oficial_abrirDocPlantilla() ;
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init()
{
  var util: FLUtil = new FLUtil();

  connect(this.child("pbnEstablecerDocPlantilla"), "clicked()", this, "iface.establecerDocPlantilla");
  connect(this.child("pbnAbrirDocPlantilla"), "clicked()", this, "iface.abrirDocPlantilla");
}

function interna_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  return util.nextCounter("codigo", this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_establecerDocPlantilla()
{
  var util: FLUtil = new FLUtil();
  var rutaPlantillas: String = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");

  if (!File.isDir(rutaPlantillas)) {
    MessageBox.information(util.translate("scripts", "No se ha establecido una ruta correcta a las plantillas"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var ficheros: Array = FileDialog.getOpenFileNames(rutaPlantillas, "*.odt;*.ott", util.translate("scripts", "Fichero de plantilla"));
  if (!ficheros)
    return;

  var objetoFich = new File(ficheros[0]);
  this.child("fdbFichero").setValue(objetoFich.name);
}

function oficial_abrirDocPlantilla()
{
  var util: FLUtil = new FLUtil();
  var rutaPlantillas: String = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");

  if (!File.isDir(rutaPlantillas)) {
    MessageBox.information(util.translate("scripts", "No se ha establecido una ruta correcta a las plantillas"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var fichero: String = this.child("fdbFichero").value();
  if (!fichero) {
    MessageBox.information(util.translate("scripts", "No se ha establecido el fichero"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!File.exists(rutaPlantillas + fichero)) {
    MessageBox.information(util.translate("scripts", "No se encontró el fichero"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var comandoOOW: String = util.readSettingEntry("scripts/flfacturac/comandoWriter");
  if (!comandoOOW) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  comando = new Array(comandoOOW, rutaPlantillas + fichero);
  var proceso = new Process();
  proceso.arguments = comando;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
