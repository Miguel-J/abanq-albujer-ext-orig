/***************************************************************************
                 paramcolor.qs  -  description
                             -------------------
    begin                : mar abr 02 2008
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
  function mostrarGrafico(nodoPliego: FLDomNode)
  {
    return this.ctx.oficial_mostrarGrafico(nodoPliego);
  }
  function chkCarasIguales_clicked()
  {
    return this.ctx.oficial_chkCarasIguales_clicked();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function xmlColores(cursor: FLSqlCursor): String {
    return this.ctx.oficial_xmlColores(cursor);
  }
  function validarCaras(): Boolean {
    return this.ctx.oficial_validarCaras();
  }
  function habilitarDosCaras()
  {
    return this.ctx.oficial_habilitarDosCaras();
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
  function pub_xmlColores(cursor: FLSqlCursor): String {
    return this.xmlColores(cursor);
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
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("chkCarasIguales"), "clicked()", this, "iface.chkCarasIguales_clicked");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      cursor.setValueBuffer("idparamiptico", formRecordparamiptico.cursor().valueBuffer("id"));
      break;
    }
  }
  this.iface.habilitarDosCaras();
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.validarCaras())
  {
    return false;
  }
  var xml: String = this.iface.xmlColores(cursor);
  if (!xml)
  {
    return false;
  }
  cursor.setValueBuffer("xml", xml);

  if (formRecordparamiptico)
  {
    formRecordparamiptico.cursor().setValueBuffer("doscaras", cursor.valueBuffer("doscaras"));
  }

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_chkCarasIguales_clicked()
{
  if (this.child("chkCarasIguales").checked) {
    this.child("fdbDosCaras").setValue(true);
    for (var i: Number = 1; i <= 10; i++) {
      this.child("fdbColorV" + i.toString()).setValue(this.child("fdbColorF" + i.toString()).value());
      this.child("fdbColorV" + i.toString()).setDisabled(true);
    }
  } else {
    for (var i: Number = 1; i <= 10; i++) {
      this.child("fdbColorV" + i.toString()).setDisabled(false);
    }
  }
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (this.child("chkCarasIguales").checked) {
    if (fN.toString().startsWith("colorf")) {
      var indice: String = fN.right(fN.length - 6);
      this.child("fdbColorV" + indice).setValue(cursor.valueBuffer(fN));
    }
  }

  switch (fN) {
    case "doscaras": {
      if (!cursor.valueBuffer("doscaras")) {
        this.child("chkCarasIguales").setChecked(false);
        for (var i: Number = 1; i <= 10; i++) {
          this.child("fdbColorV" + i.toString()).setValue("");
        }
      }
      this.iface.habilitarDosCaras();
      break;
    }
  }
}

function oficial_habilitarDosCaras()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("doscaras")) {
    this.child("gbxVuelta").setEnabled(true);
  } else {
    this.child("gbxVuelta").setEnabled(false);
  }
}

function oficial_xmlColores(cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;

  var cuatricromia = true;
  var nombreColor: String;
  var cuentaCF = 0;
  var listaCF: String = "";
  for (var i: Number = 1; i <= 10 ; i++)
  {
    nombreColor = cursor.valueBuffer("colorf" +  i.toString());
    if (nombreColor && nombreColor != "") {
      listaCF += "\n<Color Nombre=\"" + nombreColor + "\" />";
      if (!util.sqlSelect("coloresag", "cuatricromia", "nombre = '" + nombreColor + "'")) {
        cuatricromia = false;
      }
      cuentaCF++;
    }
  }
  var cuentaCV = 0;
  var listaCV: String = "";
  for (var i: Number = 1; i <= 10 ; i++)
  {
    nombreColor = cursor.valueBuffer("colorv" + i.toString());
    if (nombreColor && nombreColor != "") {
      listaCV += "\n<Color Nombre=\"" + nombreColor + "\" />";
      if (!util.sqlSelect("coloresag", "cuatricromia", "nombre = '" + nombreColor + "'")) {
        cuatricromia = false;
      }
      cuentaCV++;
    }
  }
  var contenido: String = "<ColoresParam ";
  if (cursor.valueBuffer("doscaras"))
  {
    contenido += "DosCaras=\"true\" ";
  } else {
    contenido += "DosCaras=\"false\" ";
  }
  if (cursor.valueBuffer("coloresreg"))
  {
    contenido += "ColoresReg=\"true\" ";
  } else {
    contenido += "ColoresReg=\"false\" ";
  }
  if (cuatricromia)
  {
    contenido += "Cuatricromia=\"true\" ";
  } else {
    contenido += "Cuatricromia=\"false\" ";
  }
  contenido += "Valor=\"" + cuentaCF.toString() + "+" + cuentaCV.toString() + "\" >";
  if (cuentaCF > 0)
  {
    contenido += "\n\t<ConfigColores Cara=\"Frente\" Total=\"" + cuentaCF.toString() + "\" >";
    contenido += listaCF;
    contenido += "\n\t</ConfigColores>";
  }
  if (cuentaCV > 0)
  {
    contenido += "\n\t<ConfigColores Cara=\"Vuelta\" Total=\"" + cuentaCV.toString() + "\" >";
    contenido += listaCV;
    contenido += "\n\t</ConfigColores>";
  }
  contenido += "\n</ColoresParam>";

  return contenido;
}

function oficial_validarCaras(): Boolean {
  debug("oficial_validarCaras");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var dosCaras: Boolean = false;
  for (var i: Number = 1; i <= 10; i++)
  {
    if (!cursor.isNull("colorv" + i.toString()) && cursor.valueBuffer("colorv" + i.toString()) != "") {
      debug("i = " + i + " '" + cursor.valueBuffer("colorv" + i.toString()) + "'");
      dosCaras = true;
    }
  }
  debug("dosCaras = " + dosCaras);
  debug("cursor = " + cursor.valueBuffer("doscaras"));
  if (dosCaras != cursor.valueBuffer("doscaras"))
  {
    MessageBox.warning(util.translate("scripts", "La información de colores introducida no coincide con el valor del campo Dos caras"), MessageBox.Ok, MessageBox.NoButton);
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
/////////////////////////////////////////////////////////////////