/***************************************************************************
                 articuloscomp.qs  -  description
                             -------------------
    begin                : jue oct 27 2004
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String)
  {
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
  function oficial(context)
  {
    interna(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
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
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
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
/** \C El valor de --stockfis-- se calcula automáticamente para cada artículo como la suma de existencias del artículo en todos los almacenes.
\end */
function interna_init()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.child("fdbRefComponente").setFilter("1 = 1");

  var referencia: String = "";
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      referencia = formRecordarticulos.iface.referenciaComp_;
      if (referencia && referencia != "") {
        cursor.setValueBuffer("refcompuesto", referencia);
      } else {
        referencia = cursor.valueBuffer("refcompuesto");
      }

      idTipoOpcionArt = formRecordarticulos.iface.idTipoOpcionArt_;
      if (idTipoOpcionArt) {
        var idOpcionArticulo =  formRecordarticulos.iface.pub_buscarOpcionActual(idTipoOpcionArt);
        this.child("fdbIdTipoOpcionArt").setValue(idTipoOpcionArt);
        this.child("fdbIdOpcionArticulo").setValue(idOpcionArticulo);
      }

      if (!referencia || referencia == "")
        referencia = this.child("fdbRefCompuesto").value();

      var lista: String = "";
      if (referencia && referencia != "") {
        lista = flfactalma.iface.pub_calcularFiltroReferencia(referencia);

        if (lista && lista != "")
          this.child("fdbRefComponente").setFilter("1 = 1 AND referencia NOT IN (" + lista + ")");
      }
      break;
    }
    case cursor.Edit : {
      this.child("fdbRefComponente").setDisabled(true);
      this.child("fdbRefCompuesto").setDisabled(true);
      break;
    }
  }

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

  this.child("fdbIdTipoOpcionArt").setFilter("referencia = '" + cursor.valueBuffer("refcompuesto") + "'");
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    default: {
      valor = _i.commonCalculateField(fN, cursor);
    }
  }

  return valor;
}

function interna_validateForm()
{
  var _i = this.iface;
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    default: {
    }
  }

  return valor;
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    default: {
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
