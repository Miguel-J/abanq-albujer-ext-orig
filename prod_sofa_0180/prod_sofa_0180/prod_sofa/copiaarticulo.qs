/***************************************************************************
                 copiaarticulo.qs  -  description
                             -------------------
    begin                : mar sep 18 2007
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
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  switch (fN)
  {
    case "referencia": {
      valor = formRecordarticulos.iface.pub_construirReferencia(cursor);
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
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil;

  switch (fN) {
    case "idmodelo":
    case "configuracion": {
      switch (cursor.valueBuffer("codfamilia")) {
        case "MOD":
        case "CORT":
        case "ESQ": {
          this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
          break;
        }
      }
      break;
    }
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN /////////////////////////////////////////////////
function prod_init()
{
  this.iface.__init();


  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var referencia: String = this.child("fdbRefCompuesto").value();

  if (referencia && referencia != "") {
    var idTipoProceso: String;
    if (referencia == formRecordarticulos.cursor().valueBuffer("referencia")) {
      idTipoProceso = formRecordarticulos.cursor().valueBuffer("idtipoproceso");
    } else {
      if (formRecordarticuloscomponente.cursor() && referencia == formRecordarticuloscomponente.cursor().valueBuffer("referencia")) {
        idTipoProceso = formRecordarticuloscomponente.cursor().valueBuffer("idtipoproceso");
      } else {
        idTipoProceso = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
      }
    }

    debug(idTipoProceso);

    this.child("fdbIdTipoTareaPro").setFilter("idtipoproceso = '" + idTipoProceso + "'");
  }

  switch (cursor.modeAccess()) {
    case cursor.Edit : {
      this.child("fdbCodfamilia").setDisabled(true);
    }
    break;
  }
  this.iface.bufferChanged("codfamiliacomponente");
  this.iface.bloqueo = false;
}

function prod_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codFamilia: String = cursor.valueBuffer("codfamiliacomponente");
  var refComponente: String = cursor.valueBuffer("refcomponente");

  if ((!codFamilia || codFamilia == "") && (!refComponente || refComponente == ""))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer una familia o un componente"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (util.sqlSelect("articulos", "tipostock", "referencia = '" + refComponente + "'") == "Grupo base")
  {
    var procesoComponente: String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + refComponente + "'");
    if (procesoComponente && procesoComponente != "") {
      var procesoCompuesto: String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + cursor.valueBuffer("refcompuesto") + "'");
      if (procesoCompuesto && procesoCompuesto != "" && procesoCompuesto != procesoComponente) {
        MessageBox.warning(util.translate("scripts", "El componente es un grupo base.\nEl componente tiene un proceso de fabricación asociado (%1) que no coincide con el proceso del artículo compuesto (%2).").arg(procesoComponente).arg(procesoCompuesto), MessageBox.Ok, MessageBoxNoButton);
        return false;
      }
    }
  }

  return true;
}

function prod_bufferChanged(fN: String)
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codFamilia: String = this.child("fdbCodfamilia").value();
  var refComponente: String = this.child("fdbRefComponente").value();

  switch (fN) {
    case "codfamiliacomponente": {
      if (!this.iface.bloqueo) {
        this.iface.bloqueo = true;
        if (codFamilia && codFamilia != "") {
          this.child("lblFamilia").text = util.translate("scripts", "Se escogerá cualquier componente de la familia indicada");
          this.child("lblComponente").text = util.translate("scripts", "Valor por defecto");
          /*
                    this.child("fdbRefComponente").setValue("");
                    this.child("fdbDescComponente").setValue("");
                    this.child("fdbRefComponente").setDisabled(true);
                    this.child("fdbDescComponente").setDisabled(true);
          */
        } else {
          this.child("lblFamilia").text = "";
          this.child("lblComponente").text = util.translate("scripts", "Valor fijo del componente");;
          /*
                    this.child("fdbRefComponente").setDisabled(false);
                    this.child("fdbDescComponente").setDisabled(false);
          */
        }
        this.iface.bloqueo = false;
      }
      break;
    }

    case "refcomponente": {
      if (util.sqlSelect("articulos", "tipostock", "referencia = '" + cursor.valueBuffer("refcomponente") + "'") == "Grupo base") {
        this.child("fdbIdTipoTareaPro").setValue("");
        this.child("fdbIdTipoTareaPro").setDisabled(true);
        this.child("fdbDiasAntelacion").setValue(0);
        this.child("fdbDiasAntelacion").setDisabled(true);
      } else {
        this.child("fdbIdTipoTareaPro").setDisabled(false);
        this.child("fdbDiasAntelacion").setDisabled(false);
      }
      /*
            if (!this.iface.bloqueo){
              this.iface.bloqueo = true;
              if (refComponente && refComponente != "") {
                this.child("fdbCodfamilia").setValue("");
                this.child("fdbDescFamilia").setValue("");
                this.child("fdbCodfamilia").setDisabled(true);
              }
              if (!refComponente || refComponente == "")
                this.child("fdbCodfamilia").setDisabled(false);
              this.iface.bloqueo = false;
            }
      */
      break;
    }
    default : {
    }
  }

  return true;
}

//// PRODUCCIÓN /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////