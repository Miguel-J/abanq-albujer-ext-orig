/***************************************************************************
                 venfacturascli.qs  -  description
                             -------------------
    begin                : lun ene 15 2007
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
  function validateForm(): Boolean { return this.ctx.interna_validateForm(); }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var bloqueoCalculo: Boolean;
  var totalAplazado: Number;
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
/** \C El valor de --aplazado-- aparece como el 100% menos el total acumulado hasta el momento
\end */
function interna_init()
{
  this.iface.bloqueoCalculo = false;
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
    var query: FLSqlQuery = new FLSqlQuery();
    query.setTablesList("venfacturascli");
    query.setSelect("SUM(importe)");
    query.setFrom("venfacturascli");
    query.setWhere("idfactura = '" + cursor.valueBuffer("idfactura") + "' AND id <> " + cursor.valueBuffer("id"));
    query.exec();
    if (query.next())
      this.iface.totalAplazado = parseFloat(query.value("SUM(importe)"));
    var total: Number = cursor.cursorRelation().valueBuffer("total");
    if (cursor.modeAccess() == cursor.Insert)
      this.child("fdbImporte").setValue(total - this.iface.totalAplazado);
  }
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var importe: Number = parseFloat(cursor.valueBuffer("importe"));
  var util: FLUtil = new FLUtil();

  /** \C El --aplazado-- debe ser mayor que cero
  \end */
  if (importe <= 0)
  {
    MessageBox.critical(util.translate("scripts", "El importe debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  /** \C La suma de los importes porcentaje aplazados debe ser igual al importe de la factura
  \end */
  var nuevoAplazado: Number = parseFloat(importe + this.iface.totalAplazado);
  var total: Number = parseFloat(cursor.cursorRelation().valueBuffer("total"));
  if (nuevoAplazado > total)
  {
    MessageBox.critical(util.translate("scripts", "La suma de importes no puede superar el importe total de la factura"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String = "";
  var totalFactura: Number = parseFloat(cursor.cursorRelation().valueBuffer("total"));
  switch (fN)
  {
    case "importe": {
      valor = (totalFactura * cursor.valueBuffer("aplazado")) / 100;
      valor = util.roundFieldValue(valor, "venfacturascli", "importe");
      break;
    }
    case "aplazado": {
      valor = (cursor.valueBuffer("importe") * 100) / totalFactura;
      break;
    }
  }
  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  switch (fN) {
    case "importe": {
      if (!this.iface.bloqueoCalculo) {
        this.iface.bloqueoCalculo = true;
        this.child("fdbAplazado").setValue(this.iface.calculateField("aplazado"));
        this.iface.bloqueoCalculo = false;
      }
      break;
    }
    case "aplazado": {
      if (!this.iface.bloqueoCalculo) {
        this.iface.bloqueoCalculo = true;
        this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
        this.iface.bloqueoCalculo = false;
      }
      break;
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
