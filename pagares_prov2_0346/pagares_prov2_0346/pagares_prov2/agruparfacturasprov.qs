/**************************************************************************
                 agruparfacturasprov.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var estado: String;
  var currentRow: Number;
  function oficial(context)
  {
    interna(context);
  }
  function tblFacturas_currentChanged(row: Number, col: Number)
  {
    return this.ctx.oficial_tblFacturas_currentChanged(row, col);
  }
  function pbnAddDel_clicked()
  {
    return this.ctx.oficial_pbnAddDel_clicked();
  }
  function incluirFila(fila: Number, col: Number)
  {
    return this.ctx.oficial_incluirFila(fila, col);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function gestionEstado()
  {
    return this.ctx.oficial_gestionEstado();
  }
  function actualizar()
  {
    return this.ctx.oficial_actualizar();
  }
  function descontarExcepciones(): Boolean {
    return this.ctx.oficial_descontarExcepciones();
  }
  function whereAgrupacion(): String {
    return this.ctx.oficial_whereAgrupacion();
  }
  function tienePagos(idFactura: Number): Boolean {
    return this.ctx.oficial_tienePagos(idFactura);
  }
  function listaFacturas(): Boolean {
    return this.ctx.oficial_listaFacturas();
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
Este formulario agrupa distintas facturas del mismo proveedor uno único recibo (pagaré). Es posible especificar los criterios que deben cumplir las facturas a incluir.
\end */
function interna_init()
{
  this.iface.estado = "Buscando";
  this.iface.gestionEstado();
  var tblFacturas: QTable = this.child("tblFacturas");
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("pbnRefresh"), "clicked()", this, "iface.actualizar");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(tblFacturas, "doubleClicked(int, int)", this, "iface.incluirFila");
  connect(tblFacturas, "currentChanged(int, int)", this, "iface.tblFacturas_currentChanged");
  connect(this.child("pushButtonAccept"), "clicked()", this, "iface.listaFacturas");
  connect(this.child("pbnAddDel"), "clicked()", this, "iface.pbnAddDel_clicked");

  this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());

  var util: FLUtil = new FLUtil();
  var hoy: Date = new Date();
  this.child("fdbFecha").setValue(hoy);
  this.child("fdbFechaHasta").setValue(hoy);
  this.child("fdbFechaDesde").setValue(util.addDays(hoy, -1));

  tblFacturas.setNumCols(7);
  tblFacturas.setColumnWidth(0, 60);
  tblFacturas.setColumnWidth(1, 130);
  tblFacturas.setColumnWidth(2, 100);
  tblFacturas.setColumnWidth(3, 100);
  tblFacturas.setColumnWidth(4, 80);
  tblFacturas.setColumnWidth(5, 220);
  tblFacturas.setColumnLabels("/", "Incluir/Código/Fecha/Total/Proveedor/Nombre/idfactura");
  tblFacturas.hideColumn(6);

  cursor.setValueBuffer("excepciones", "");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tblFacturas_currentChanged(row: Number, col: Number)
{
  this.iface.currentRow = row;
}

function oficial_pbnAddDel_clicked()
{
  this.iface.incluirFila(this.iface.currentRow, 0);
}

function oficial_incluirFila(fila: Number, col: Number)
{
  var tblFacturas: QTable = this.child("tblFacturas");

  if (tblFacturas.numRows() == 0) return;

  if (tblFacturas.text(fila, 0) == "Si")
    tblFacturas.setText(fila, 0, "No");
  else
    tblFacturas.setText(fila, 0, "Si");
}

function oficial_bufferChanged(fN: String)
{
  switch (fN) {
      /** \C
      La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
      \end */
    case "codproveedor":
    case "nombreproveedor":
    case "cifnif":
    case "codalmacen":
    case "fechadesde":
    case "fechahasta":
    case "coddivisa":
    case "codserie":
    case "codejercicio": {
      if (this.iface.estado == "Seleccionando") {
        this.iface.estado = "Buscando";
        this.iface.gestionEstado();
      }
      break;
    }
  }
}

/** \D
El estado 'Buscando' define la situación en la que el usuario está especificando los criterios de búsqueda.
El estado 'Seleccionando' define la situación en la que el usuario ya ha buscado y puede generar la factura o facturas
\end */
function oficial_gestionEstado()
{
  switch (this.iface.estado) {
    case "Buscando": {
      this.child("pbnRefresh").enabled = true;
      this.child("pushButtonAccept").enabled = false;
      break;
    }
    case "Seleccionando": {
      this.child("pbnRefresh").enabled = false;
      this.child("pushButtonAccept").enabled = true;
      break;
    }
  }
}

/** \D
Actualiza la lista de facturas en función de los criterios de búsqueda especificados
\end */
function oficial_actualizar()
{
  var util: FLUtil = new FLUtil();

  if (!this.cursor().valueBuffer("codserie")) {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar una serie de facturación"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (!this.cursor().valueBuffer("codproveedor")) {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar un proveedor"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (!this.cursor().valueBuffer("coddivisa")) {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar una divisa"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (!this.cursor().valueBuffer("codpago")) {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar una forma de pago"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var curFacturas: FLSqlCursor = new FLSqlCursor("facturasprov");
  var tblFacturas: QTable = this.child("tblFacturas");
  var util: FLUtil = new FLUtil;
  var fila: Number;
  var numFilas: Number = tblFacturas.numRows();

  for (fila = 0; fila < numFilas; fila++)
    tblFacturas.removeRow(0);

  var where: String = formrecibosprov.iface.pub_whereAgrupacion(this.cursor());
  where += " AND (idpagare IS NULL OR idpagare = 0) ORDER BY codproveedor DESC";
  curFacturas.select(where);
  while (curFacturas.next()) {
    curFacturas.setModeAccess(curFacturas.Browse);
    curFacturas.refreshBuffer();

    if (this.iface.tienePagos(curFacturas.valueBuffer("idfactura")))
      continue;

    with(tblFacturas) {
      insertRows(0);
      setText(0, 0, "Si");
      setText(0, 1, curFacturas.valueBuffer("codigo"));
      setText(0, 2, util.dateAMDtoDMA(curFacturas.valueBuffer("fecha")));
      setText(0, 3, util.roundFieldValue(curFacturas.valueBuffer("total"), "facturasprov", "total"));
      setText(0, 4, curFacturas.valueBuffer("codproveedor"));
      setText(0, 5, curFacturas.valueBuffer("nombre"));
      setText(0, 6, curFacturas.valueBuffer("idfactura"));
    }
  }
  this.iface.estado = "Seleccionando";
  this.iface.gestionEstado();

  if (tblFacturas.numRows() == 0)
    this.child("pushButtonAccept").enabled = false;
}

/** \D
Elabora un string en el que figuran, separados por comas, los identificadores de aquellas facturas que el usuario haya marcado como 'Si' (incluir en el pagaré). Este string se usará para ser incluido en una sentencia IN en el select de los facturas.

@return String con la lista de facturas
\end */
function oficial_listaFacturas(): Boolean {
  var valor: Boolean = true;
  var cursor: FLSqlCursor = this.cursor();
  var tblFacturas: QTable = this.child("tblFacturas");
  var lista: String = "";
  var fila: Number;
  for (fila = 0; fila < tblFacturas.numRows(); fila++)
  {
    if (tblFacturas.text(fila, 0) == "Si") {
      if (lista != "")
        lista += ", ";
      lista += tblFacturas.text(fila, 6);
    }
  }
  cursor.setValueBuffer("lista", lista);
  debug("Facturas " + lista);
  return valor;
}

function oficial_tienePagos(idFactura: Number): Boolean {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("facturasprov,recibosprov,pagosdevolprov");
  q.setFrom("pagosdevolprov INNER JOIN recibosprov on pagosdevolprov.idrecibo = recibosprov.idrecibo INNER JOIN facturasprov ON recibosprov.idfactura = facturasprov.idfactura");
  q.setSelect("pagosdevolprov.idrecibo");
  q.setWhere("facturasprov.idfactura = " + idFactura);

  if (!q.exec())
    return false;
  if (!q.first())
    return false;

  if (q.value(0))
    return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
