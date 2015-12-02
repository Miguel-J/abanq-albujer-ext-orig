/***************************************************************************
                 paradas.qs  -  description
                             -------------------
    begin                : mie dic 03 2008
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
    return this.ctx.interna_init();
  }
  function calculateField(fN: String): Number {
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
  var bloqueoProvincia: Boolean;
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
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  this.iface.bloqueoProvincia = false;

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbOrden").setValue(this.iface.calculateField("orden"));
  }

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_calculateField(fN: String): Number {
  var cursor: FLSqlCursor = this.cursor();
  var valor: Number;

  switch (fN)
  {
    case "orden": {
      var codRuta: String = cursor.valueBuffer("codruta");
      var qryContador: FLSqlQuery = new FLSqlQuery;
      with(qryContador) {
        setTablesList("paradas");
        setSelect("MAX(orden)");
        setFrom("paradas");
        setWhere("codruta = '" + codRuta + "'");
      }
      if (!qryContador.exec())
        return;
      if (qryContador.first()) {
        var contador: Number = parseFloat(qryContador.value("MAX(orden)"));
        valor = ++contador;
      }
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
function oficial_bufferChanged(fN)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codcliente": {
      var qry: FLSqlQuery = new FLSqlQuery;
      with(qry) {
        setTablesList("dirclientes");
        setSelect("id,direccion,ciudad,idprovincia,provincia,codpais");
        setFrom("dirclientes");
        setWhere("codcliente = '" + cursor.valueBuffer("codcliente") + "'");
        setForwardOnly(true);
      }
      if (!qry.exec()) {
        return false;
      }

      if (qry.size() != 1) {
        this.child("fdbCodDir").setValue("");
        this.child("fdbDireccion").setValue("");
        this.child("fdbCiudad").setValue("");
        this.child("fdbIdProvincia").setValue("");
        this.child("fdbProvincia").setValue("");
        this.child("fdbCodPais").setValue("");
        return;
      }

      if (qry.first()) {
        this.child("fdbCodDir").setValue(qry.value("id"));
        this.child("fdbDireccion").setValue(qry.value("direccion"));
        this.child("fdbCiudad").setValue(qry.value("ciudad"));
        this.child("fdbIdProvincia").setValue(qry.value("idprovincia"));
        this.child("fdbProvincia").setValue(qry.value("provincia"));
        this.child("fdbCodPais").setValue(qry.value("codpais"));
      }
    }
    case "provincia": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        flfactppal.iface.pub_obtenerProvincia(this);
        this.iface.bloqueoProvincia = false;
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
