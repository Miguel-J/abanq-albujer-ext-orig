/***************************************************************************
                 pedidosaut.qs  -  description
                             -------------------
    begin                : 22-01-2007
    copyright            : (C) 2007 by Mathias Behrle
    email                : mathiasb@behrle.dyndns.org
    partly based on code by
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
  function calculateCounter(): Number {
    return this.ctx.interna_calculateCounter();
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
  function seleccionarLineas(codProveedor, codAlmacen)
  {
    return this.ctx.oficial_seleccionarLineas(codProveedor, codAlmacen);
  }
  function quitarLinea()
  {
    return this.ctx.oficial_quitarLinea();
  }
  function insertarLineas(datos: String, curPedidoAut: FLSqlCursor): Boolean {
    return this.ctx.oficial_insertarLineas(datos, curPedidoAut);
  }
  function insertarLinea(idPedidoAut: Number, eArticulo: FLDomElement, codProveedor: String): Boolean {
    return this.ctx.oficial_insertarLinea(idPedidoAut, eArticulo, codProveedor);
  }
  function deseleccionarLinea(idLinea: String, idPedidoAut: String): Boolean {
    return this.ctx.oficial_deseleccionarLinea(idLinea, idPedidoAut);
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
  function pub_insertarLineas(idLinea: String, curPedidoAut: FLSqlCursor): Boolean {
    return this.insertarLineas(idLinea, curPedidoAut);
  }
  function pub_deseleccionarLinea(idLinea: String, idPedidoAut: String): Boolean {
    return this.deseleccionarLinea(idLinea, idPedidoAut);
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
  var util: FLUtil = new FLUtil;

  var tdbArticulos: FLTableDB = this.child("tdbArticulos");

  connect(this.child("tbInsert"), "clicked()", this, "iface.seleccionarLineas");
  connect(this.child("tbDelete"), "clicked()", this, "iface.quitarLinea");


  if (cursor.valueBuffer("editable") == false) {
    tdbArticulos.setDisabled(true);
  }

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
      break;
    }
    case cursor.Edit: {
      this.child("fdbDivisa").setDisabled(true);
      break;
    }
    case cursor.Del: {
      var idPedidoAut: Number = cursor.valueBuffer("idpedidoaut");
      var codProveedor: String = cursor.valueBuffer("codproveedor");
      var referencia: String;
      var variacion: Number;
      var curLineaPedidoAut: FLSqlCursor = new FLSqlCursor("lineaspedidosaut");
      curLineaPedidoAut.select("idpedidoaut = " + idPedidoAut);
      while (curLineaPedidoAut.next()) {
        curLineaPedidoAut.setModeAccess(curLineaPedidoAut.Browse);
        curLineaPedidoAut.refreshBuffer();
        referencia = curLineaPedidoAut.valueBuffer("referencia");
        variacion = -1 * curLineaPedidoAut.valueBuffer("cantidad");
        if (!flfacturac.iface.pub_cambiarStockOrd(referencia, variacion, codProveedor))
          return false;
      }
      break;
    }
  }

  cursor.setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
  tdbArticulos.cursor().setMainFilter("idpedidoaut = " + cursor.valueBuffer("idpedidoaut"));
  tdbArticulos.refresh();
  this.child("fdbProveedor").setFocus();
}

/** \C El pedido debe tener al menos una linea
\end */
function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;

  if (this.child("tdbArticulos").cursor().size() == 0)
  {
    MessageBox.warning(util.translate("scripts", "El pedido debe contener al menos una línea de artículo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}


/** \D Calcula un nuevo código de remesa
\end */
function interna_calculateCounter(): Number {
  var util: FLUtil = new FLUtil();
  var cadena: String = util.sqlSelect("pedidosaut", "idpedidoaut", "1 = 1 ORDER BY idpedidoaut DESC");
  var valor: Number;
  if (!cadena)
    valor = 1;
  else
    valor = parseFloat(cadena) + 1;

  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Se agrega articulos a la remesa.
\end */
function oficial_seleccionarLineas()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() != cursor.Browse) {
    if (!cursor.checkIntegrity()) {
      return;
    }
  }
  var codProveedor: String = cursor.valueBuffer("codproveedor");
  var codAlmacen: String = cursor.valueBuffer("codalmacen");

  if (!codProveedor) {
    MessageBox.warning(util.translate("scripts", "Es necesario seleccionar un proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  if (!codAlmacen) {
    MessageBox.warning(util.translate("scripts", "Es necesario seleccionar un almacén"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var f: Object = new FLFormSearchDB("seleccionarticulos");
  var curLineas: FLSqlCursor = f.cursor();
  var datos: String = "";


  curLineas.select();
  if (!curLineas.first()) {
    curLineas.setModeAccess(curLineas.Insert);
  } else {
    curLineas.setModeAccess(curLineas.Edit);
  }

  // datos = referencias in lineaspedidosaut
  var qryLineasSel: FLSqlQuery = new FLSqlQuery();
  with(qryLineasSel) {
    setTablesList("lineaspedidosaut");
    setSelect("referencia, cantidad");
    setFrom("lineaspedidosaut");
    setWhere("idpedidoaut = " + cursor.valueBuffer("idpedidoaut") + " ORDER BY referencia");
    setForwardOnly(true);
  }
  if (!qryLineasSel.exec()) {
    return;
  }

  var xmlDatos: FLDomDocument = new FLDomDocument;
  xmlDatos.setContent("<PedidoAuto/>");
  var eArticulo: FLDomElement;
  while (qryLineasSel.next()) {
    eArticulo = xmlDatos.createElement("Articulo");
    eArticulo.setAttribute("Referencia", qryLineasSel.value("referencia"));
    eArticulo.setAttribute("Pedir", qryLineasSel.value("cantidad"));
    xmlDatos.firstChild().appendChild(eArticulo);
  }

  f.setMainWidget();
  curLineas.refreshBuffer();
  curLineas.setValueBuffer("datos", xmlDatos.toString(4));

  if (codProveedor && codProveedor != "") {
    curLineas.setValueBuffer("codproveedor", codProveedor);
  }

  if (codAlmacen && codAlmacen != "") {
    curLineas.setValueBuffer("codalmacen", codAlmacen);
  }

  datos = f.exec("datos");
  if (!datos || datos == "")
    return false;

  if (!this.iface.insertarLineas(datos, cursor))
    return false;

  this.child("tdbArticulos").refresh();
  this.child("fdbDivisa").setDisabled(true);
}

/** \D Se elimina la linea activa del pedido.
\end */
function oficial_quitarLinea()
{
  var cursor: FLSqlCursor = this.cursor();
  var curLineas: FLSqlCursor = this.child("tdbArticulos").cursor();

  if (!curLineas.isValid() || cursor.valueBuffer("editable") == false) {
    return;
  }

  var linea: String = curLineas.valueBuffer("idlinea");
  if (!this.iface.deseleccionarLinea(linea, cursor.valueBuffer("idpedidoaut"))) {
    return;
  }

  this.child("tdbArticulos").refresh();
}

function oficial_deseleccionarLinea(idLinea: String, idPedidoAut: String): Boolean {
  var util: FLUtil = new FLUtil;

  var curLineas: FLSqlCursor = new FLSqlCursor("lineaspedidosaut");
  curLineas.select("idlinea = " + idLinea);

  if (!curLineas.first())
  {
    return false;
  }
  curLineas.setModeAccess(curLineas.Del);
  curLineas.refreshBuffer();

  if (!curLineas.commitBuffer())
  {
    return false;
  }

  return true;
}

/** \D Asocia linas a un pedido automatico
@param  datos: Documento XML con referencias de articulos
@param  curPedidoAut: Cursor posicionado en el pedido
@return true si la asociación se realiza de forma correcta, false en caso contrario
\end */
function oficial_insertarLineas(datos: String, curPedidoAut: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idPedidoAut: String = curPedidoAut.valueBuffer("idpedidoaut");
  var codProveedor = curPedidoAut.valueBuffer("codproveedor");

  // first delete existing lineas
  var curLineas: FLSqlCursor = new FLSqlCursor("lineaspedidosaut");
  curLineas.select("idpedidoaut = " + idPedidoAut);
  while (curLineas.next())
  {
    curLineas.setModeAccess(curLineas.Del);
    curLineas.refreshBuffer();
    if (!curLineas.commitBuffer())
      return false;
  }

  var xmlDatos: FLDomDocument = new FLDomDocument;
  if (!xmlDatos.setContent(datos))
  {
    return false;
  }
  var xmlArticulos: FLDomNodeList = xmlDatos.elementsByTagName("Articulo");
  if (xmlArticulos && xmlArticulos.count() > 0)
  {
    for (var i: Number = 0; i < xmlArticulos.count(); i++) {
      eArticulo = xmlArticulos.item(i).toElement();
      referencia = eArticulo.attribute("Referencia");

      if (!this.iface.insertarLinea(idPedidoAut, eArticulo, codProveedor)) {
        return false;
      }
    }
  }

  // check for different currencies
  var qryDivisaLineasSel: FLSqlQuery = new FLSqlQuery();
  with(qryDivisaLineasSel)
  {
    setTablesList("articulosprov,lineaspedidosaut");
    setSelect("ap.coddivisa");
    setFrom("lineaspedidosaut at INNER JOIN articulosprov ap ON (at.referencia = ap.referencia AND ap.codproveedor = '" + codProveedor + "')");
    setWhere("at.idpedidoaut = " + idPedidoAut + " GROUP BY ap.coddivisa");
    setForwardOnly(true);
  }
  if (!qryDivisaLineasSel.exec())
    return false;

  switch (qryDivisaLineasSel.size())
  {
    case 0: {
      break;
    }
    case 1: {
      qryDivisaLineasSel.first();
      var codDivisa: String = qryDivisaLineasSel.value("ap.coddivisa");
      if (codDivisa != curPedidoAut.valueBuffer("coddivisa")) {
        var res: Number = MessageBox.information(util.translate("scripts", "Die Währung für die ausgewählten Einkaufspreise weicht von der Auftragswährung ab.\nSoll diese Währung ins Hauptformular übernommen werden?"), MessageBox.Ok, MessageBox.No);
        if (res == MessageBox.Ok)
          cursor.setValueBuffer("coddivisa", codDivisa);
      }
      break;
    }
    default: {
      MessageBox.warning(util.translate("scripts", "Hinweis: Den Einkaufspreisen der ausgewählten Artikeln liegen verschiedene Währungen zugrunde!"), MessageBox.Ok, MessageBox.NoButton);
      break;
    }
  }

  return true;
}

function oficial_insertarLinea(idPedidoAut: Number, eArticulo: FLDomElement, codProveedor: String): Boolean {

  var util: FLUtil = new FLUtil;
  var referencia: String = eArticulo.attribute("Referencia");
  var descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");;
  var cantidad: Number = eArticulo.attribute("Pedir");

  var curLineasOrder: FLSqlCursor = new FLSqlCursor("lineaspedidosaut");
  with(curLineasOrder)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setActivatedCheckIntegrity(false);
    setValueBuffer("idpedidoaut", idPedidoAut);
    setValueBuffer("referencia", referencia);
    setValueBuffer("descripcion", descripcion);
    setValueBuffer("cantidad", cantidad);
  }

  if (!curLineasOrder.commitBuffer())
  {
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
