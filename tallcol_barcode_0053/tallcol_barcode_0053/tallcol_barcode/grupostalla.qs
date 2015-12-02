/***************************************************************************
                 grupostalla.qs  -  description
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

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var tbnSubir: Object;
  var tbnBajar: Object;

  function oficial(context)
  {
    interna(context);
  }
  function tbnSubir_clicked()
  {
    return this.ctx.oficial_tbnSubir_clicked();
  }
  function tbnBajar_clicked()
  {
    return this.ctx.oficial_tbnBajar_clicked();
  }
  function intercambiarOrden(direccion)
  {
    return this.ctx.oficial_intercambiarOrden(direccion);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
\end */
function interna_init()
{
  this.iface.tbnSubir = this.child("pbnSubirOrden");
  this.iface.tbnBajar = this.child("pbnBajarOrden");

  connect(this.iface.tbnSubir, "clicked()", this, "iface.tbnSubir_clicked");
  connect(this.iface.tbnBajar, "clicked()", this, "iface.tbnBajar_clicked");

  this.child("tdbTallas").putFirstCol("orden");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Mueve la talla seleccionada hacia arriba (antes) en el orden
\end */
function oficial_tbnSubir_clicked()
{
  this.iface.intercambiarOrden(-1);
}

/** \D Mueve la talla seleccionada hacia abajo (después) en el orden
\end */
function oficial_tbnBajar_clicked()
{
  this.iface.intercambiarOrden(1);
}

/** \D Mueve la talla seleccionada hacia arriba o hacia abajo en función de la dirección

@param  direction: Indica la dirección en la que hay que mover la talla. Valores:
  1: Hacia abajo
  -1: Hacia arriba
\end */
function oficial_intercambiarOrden(direccion)
{
  var util: FLUtil = new FLUtil;
  var curGrupo = this.cursor();
  var cursor: FLSqlCursor = this.child("tdbTallas").cursor();

  var orden1 = cursor.valueBuffer("orden");
  var orden2;

  var row = this.child("tdbTallas").currentRow();

  if (direccion == -1)

    orden2 = util.sqlSelect("tallas", "orden", "orden < '" + orden1 + "' AND codgrupotalla = '" + curGrupo.valueBuffer("codgrupotalla") + "' ORDER BY orden DESC");
  else
    orden2 = util.sqlSelect("tallas", "orden",  "orden > '" + orden1 + "' AND codgrupotalla = '" + curGrupo.valueBuffer("codgrupotalla") + "' ORDER BY orden");

  if (!orden2)
    return;

  var curInt: FLSqlCursor = new FLSqlCursor("tallas");
  curInt.select("orden = '" + orden2 + "' AND codgrupotalla = '" + curGrupo.valueBuffer("codgrupotalla") + "'");
  if (!curInt.first())
    return;

  curInt.setModeAccess(curInt.Edit);
  curInt.refreshBuffer();
  curInt.setValueBuffer("orden", "-1");
  curInt.commitBuffer();

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("orden", orden2);
  cursor.commitBuffer();

  curInt.setModeAccess(curInt.Edit);
  curInt.refreshBuffer();
  curInt.setValueBuffer("orden", orden1);
  curInt.commitBuffer();

  this.child("tdbTallas").refresh();
  row += direccion;
  this.child("tdbTallas").setCurrentRow(row);
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