/***************************************************************************
                 masterlineastallacolcli.qs  -  description
                             -------------------
    begin                : jue sep 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
  var tablaLineasTC;
  var arrayLineasTC;
  var bloqueoCantidad;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function arrayTallas(codGrupoTalla, referencia)
  {
    return this.ctx.oficial_arrayTallas(codGrupoTalla, referencia);
  }
  function arrayColores(referencia)
  {
    return this.ctx.oficial_arrayColores(referencia);
  }
  function actualizarTabla()
  {
    return this.ctx.oficial_actualizarTabla();
  }
  function insertar()
  {
    return this.ctx.oficial_insertar();
  }
  function preguntarPrecios()
  {
    return this.ctx.oficial_preguntarPrecios();
  }
  function nuevaFila()
  {
    return this.ctx.oficial_nuevaFila();
  }
  function refrescarTablaTC(tblTallaColor, arrayTC, cursor)
  {
    return this.ctx.oficial_refrescarTablaTC(tblTallaColor, arrayTC, cursor);
  }
  function calcularCantidad()
  {
    return this.ctx.oficial_calcularCantidad();
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
/** \C lineaspedidoscli
\end */
function interna_init()
{
  var _i = this.iface;

  _i.tablaLineasTC = this.child("tblAtributos");
  _i.arrayLineasTC = [];
  var cursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("pbnInsertar"), "clicked()", this, "iface.insertar");
  connect(this.child("tbnNuevaFila"), "clicked()", this, "iface.nuevaFila");
  connect(_i.tablaLineasTC, "valueChanged(int, int)", this, "iface.calcularCantidad");

  this.child("pushButtonAccept").setEnabled(false);
  var referencia = cursor.valueBuffer("referencia")
  if (referencia && referencia != "") {
    this.child("fdbReferencia").setValue("");
    this.child("fdbReferencia").setValue(referencia);
  }

  switch (cursor.modeAccess()) {
    case cursor.Browse: {
      this.child("pbnInsertar").enabled = false;
      break;
    }
  }

  var tablaPadre = cursor.valueBuffer("tabla").right(cursor.valueBuffer("tabla").length - 6);

  var campoPadre  = cursor.valueBuffer("campopadre");
  var valorCampoPadre = cursor.valueBuffer("valorcampopadre");

  var codSerie = AQUtil.sqlSelect(tablaPadre, "codserie", campoPadre + " = " + valorCampoPadre);
  var codCliente = AQUtil.sqlSelect(tablaPadre, "codcliente", campoPadre + " = " + valorCampoPadre);

  var irpf = 0;
  if (codSerie && codSerie != "")
    irpf = AQUtil.sqlSelect("series", "irpf", "codserie = '" + codSerie + "'");
  if (!irpf)
    irpf = 0;

  if (!cursor.valueBuffer("referencia") || cursor.valueBuffer("referencia") == "") {
    this.child("fdbIRPF").setValue(irpf);
    this.child("fdbDtoPor").setValue(formRecordlineaspedidoscli.iface.pub_commonCalculateField("dtopor", cursor));
    this.child("fdbPorComision").setValue(formRecordlineaspedidoscli.iface.pub_commonCalculateField("porcomision", cursor));
  }

  var opcionIvaRec = flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente);

  switch (opcionIvaRec) {
    case 0:
      this.child("fdbCodImpuesto").setDisabled(true);
      this.child("fdbIva").setDisabled(true);
    case 1:
      this.child("fdbRecargo").setDisabled(true);
      break;
    default:
      break;
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "referencia": {
      _i.actualizarTabla(true);
      this.child("fdbPvpUnitario").setValue(formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", cursor));
      this.child("fdbCodImpuesto").setValue(formRecordlineaspedidoscli.iface.pub_commonCalculateField("codimpuesto", cursor));
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
        this.child("fdbDescripcion").setValue("");
        this.child("fdbCodeBar").setFilter("");
        this.child("fdbCodeBar").setValue("");
      } else {
        this.child("fdbCodeBar").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
      }
      break;
    }
    case "codebar": {
      var referencia = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("codebar") + "'");
      if (!referencia) {
        referencia = "";
      }
      this.child("fdbReferencia").setValue(referencia);
      break;
    }
    //    default: {
    //      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, this);
    //      break;
    //    }
  }
}

/** \D Si el almacén y la referencia son válidos, carga los datos de stock actuales
@param inicio: Indica si la tabla debe cargarse con los datos de líneas ya introducidas
\end */
function oficial_actualizarTabla(inicio)
{
  var _i = this.iface;

  var cursor = this.cursor();
  var referencia = cursor.valueBuffer("referencia");
  if (!referencia || referencia == "")
    return false;

  if (!AQUtil.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'"))
    return false;

  var arrayTCPrevio = _i.arrayLineasTC;

  _i.bloqueoCantidad = true;
  _i.arrayLineasTC = _i.refrescarTablaTC(_i.tablaLineasTC, _i.arrayLineasTC, cursor);
  _i.bloqueoCantidad = false;
  _i.calcularCantidad();

  if (inicio) {

  }
}

function oficial_arrayTallas(codGrupoTalla, referencia)
{
  var _i = this.iface;

  var tallas = [];
  var qryTallas: FLSqlQuery = new FLSqlQuery;
  if (codGrupoTalla && codGrupoTalla != "") {
    qryTallas.setTablesList("tallas");
    qryTallas.setSelect("codtalla");
    qryTallas.setFrom("tallas");
    qryTallas.setWhere("codgrupotalla = '" + codGrupoTalla + "'");
  } else {
    qryTallas.setTablesList("atributosarticulos");
    qryTallas.setSelect("talla");
    qryTallas.setFrom("atributosarticulos");
    qryTallas.setWhere("referencia = '" + referencia + "' GROUP BY talla ORDER BY talla");
  }
  qryTallas.setForwardOnly(true);
  if (!qryTallas.exec()) {
    return false;
  }
  var c = 0;
  while (qryTallas.next()) {
    tallas[c++] = qryTallas.value(0);
  }
  return tallas;
}

function oficial_arrayColores(referencia)
{
  var _i = this.iface;

  var colores = [];
  var qryColores: FLSqlQuery = new FLSqlQuery;
  qryColores.setTablesList("coloresarticulo");
  qryColores.setSelect("codcolor");
  qryColores.setFrom("coloresarticulo");
  qryColores.setWhere("referencia = '" + referencia + "' ORDER BY codcolor");
  if (!qryColores.exec()) {
    return;
  }
  var f = 0;
  while (qryColores.next()) {
    colores[f++] = qryColores.value("codcolor");
  }
  return colores;
}

/** \D Compone una tabla de tantas filas como tallas y tantas columnas como colores hay definidos para el artículo seleccionado, indicando en cada celda la cantidad existente para la combinación talla / color en el almacén seleccionado */
function oficial_refrescarTablaTC(tblTallaColor, arrayTC, cursor)
{
  var _i = this.iface;
  var referencia = cursor.valueBuffer("referencia");

  if (!referencia || referencia == "") {
    return;
  }

  var numFilas = tblTallaColor.numRows();

  for (var i = (numFilas - 1); i >= 0; i--) {
    tblTallaColor.removeRow(i);
  }

  var codGrupoTalla = AQUtil.sqlSelect("articulos", "codgrupotalla", "referencia = '" + referencia + "'");
  var tallas = _i.arrayTallas(codGrupoTalla, referencia);
  if (!tallas) {
    return;
  }

  var numColumnas = tallas.length;
  var listaTallas = tallas.join("/");

  tblTallaColor.setNumCols(numColumnas);
  tblTallaColor.setColumnLabels("/", listaTallas);

  var colores = _i.arrayColores(referencia);
  if (!colores) {
    return;
  }

  var listaColores = colores.join("/");
  var numFilas = colores.length;

  tblTallaColor.insertRows(0, numFilas);
  tblTallaColor.setRowLabels("/", listaColores);

  if (arrayTC)
    delete arrayTC;
  arrayTC = new Array(numFilas);
  for (var i = 0; i < numFilas; i++) {
    arrayTC[i] = new Array(numColumnas);
    for (var k = 0; k < numColumnas; k++) {
      arrayTC[i][k] = new Array(3);
      arrayTC[i][k]["cantidad"] = 0;
      arrayTC[i][k]["barcode"] = AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + tallas[k] + "' AND color = '" + colores[i] + "'");;
      arrayTC[i][k]["talla"] = tallas[k];
      arrayTC[i][k]["color"] = colores[i];
      arrayTC[i][k]["idlineapedido"] = 0;
      arrayTC[i][k]["idpedido"] = 0;
    }
  }

  var qryLineas: FLSqlQuery = new FLSqlQuery;
  qryLineas.setTablesList(cursor.valueBuffer("tabla"));
  qryLineas.setSelect("talla, color, SUM(cantidad), COUNT(idlinea)");
  qryLineas.setFrom(cursor.valueBuffer("tabla"));
  qryLineas.setWhere(cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre") + " AND referencia = '" + referencia + "' GROUP BY referencia, talla, color");
  if (!qryLineas.exec()) {
    return false;
  }

  while (qryLineas.next()) {
    for (numFilas = 0; numFilas < colores.length; numFilas++) {
      if (colores[numFilas] == qryLineas.value("color")) {
        break;
      }
    }
    if (numFilas == colores.length) {
      continue;
    }

    for (numColumnas = 0; numColumnas < tallas.length; numColumnas++) {
      if (tallas[numColumnas ] == qryLineas.value("talla")) {
        break;
      }
    }
    if (numColumnas == tallas.length) {
      continue;
    }

    tblTallaColor.setText(numFilas, numColumnas, qryLineas.value("SUM(cantidad)"));
    arrayTC[numFilas][numColumnas]["barcode"] = AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + qryLineas.value("talla") + "' AND color = '" + qryLineas.value("color") + "'");
    arrayTC[numFilas][numColumnas]["talla"] = qryLineas.value("talla");
    arrayTC[numFilas][numColumnas]["color"] = qryLineas.value("color");

    // Gestión de albaranes que provienen de pedidos (posible generación de pedidos parciales)
    if (cursor.valueBuffer("tabla") == "lineasalbaranescli") {
      if (qryLineas.value("COUNT(idlinea)") > 1) {
        if (AQUtil.sqlSelect("lineasalbaranescli", "idlinea", "idalbaran = " + cursor.valueBuffer("valorcampopadre") + " AND barcode = '" + arrayTC[numFilas][numColumnas]["barcode"] + "' AND idlineapedido <> 0 AND idlineapedido IS NOT NULL")) {
          MessageBox.warning(sys.translate("Existe más de una línea con artículos de la combinación %1 + %2.\nAl menos una de estas línea procede de un pedido de cliente.\nNo es posible editar las cantidades de prendas desde este formulario, hágalo desde cada línea individual para evitar ambigüedades.").arg(qryLineas.value("talla")).arg(qryLineas.value("color")), MessageBox.Ok, MessageBox.NoButton);
          this.child("pbnInsertar").enabled = false;
          return false;
        }
      } else {
        var qryLineaPedido: FLSqlQuery = new FLSqlQuery;
        with(qryLineaPedido) {
          setTablesList("lineasalbaranescli");
          setSelect("idlineapedido, idpedido");
          setFrom("lineasalbaranescli");
          setWhere("idalbaran = " + cursor.valueBuffer("valorcampopadre") + " AND barcode = '" + arrayTC[numFilas][numColumnas]["barcode"] + "'");
          setForwardOnly(true);
        }
        if (!qryLineaPedido.exec())
          return false;

        if (!qryLineaPedido.first())
          return false;

        var idLineaPedido = qryLineaPedido.value("idlineapedido");
        if (!idLineaPedido)
          idLineaPedido = 0;
        arrayTC[numFilas][numColumnas]["idlineapedido"] = idLineaPedido;

        var idPedido = qryLineaPedido.value("idpedido");
        if (!idPedido)
          idPedido = 0;
        arrayTC[numFilas][numColumnas]["idpedido"] = idPedido;
      }
    }
  }
  return arrayTC;
}

function oficial_preguntarPrecios()
{
  return true;
}

function oficial_insertar()
{
  var cursor = this.cursor();
  var _i = this.iface;

  var datos = "";
  var nuevaCantidad;
  var referencia = cursor.valueBuffer("referencia");
  var pvpInicial = parseFloat(cursor.valueBuffer("pvpunitario"));
  pvpInicial = AQUtil.roundFieldValue(pvpInicial, "lineastallacolcli", "pvpunitario");
  var texto;
  var codTalla;
  var codColor;
  var barCode;
  var pvp;
  var preguntar = _i.preguntarPrecios();
  var usarPvpArt = false;

  for (var fila = 0; fila < _i.tablaLineasTC.numRows(); fila++) {
    for (var columna = 0; columna < _i.arrayLineasTC[fila].length; columna++) {
      texto = parseFloat(_i.tablaLineasTC.text(fila, columna))
              if (!texto || texto == "")
                continue;
      nuevaCantidad = parseFloat(texto);
      if (isNaN(nuevaCantidad))
        continue;
      if (nuevaCantidad == 0)
        continue;

      barCode = false;
      viejaCantidad = 0;
      barCode = _i.arrayLineasTC[fila][columna]["barcode"];
      codTalla = _i.arrayLineasTC[fila][columna]["talla"];
      codColor = _i.arrayLineasTC[fila][columna]["color"];
      if (!barCode) {
        barCode = flfactalma.iface.pub_construirBarcode(referencia, codTalla, codColor);
      }

      cursor.setValueBuffer("barcode", barCode);
      pvp = parseFloat(formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", cursor));
      pvp = AQUtil.roundFieldValue(pvp, "lineastallacolcli", "pvpunitario");
      if (preguntar && pvp != pvpInicial) {
        var dialog = new Dialog;
        dialog.caption = sys.translate("Aviso");
        dialog.okButtonText = sys.translate("Aceptar");
        dialog.cancelButtonText = sys.translate("Cancelar");

        var texto = new TextEdit;
        texto.text = sys.translate("El precio del barcode %1 (talla %2, color %3) %4 es distinto del precio del artículo %5\n¿Qué desea hacer?").arg(barCode).arg(codTalla).arg(codColor).arg(pvpInicial).arg(pvp);
        dialog.add(texto);

        var gbxOpciones = new GroupBox;
        var rbnOp1 = new RadioButton;
        rbnOp1.text = sys.translate("Usar el coste indicado (%1)").arg(pvpInicial);
        rbnOp1.checked = true;
        gbxOpciones.add(rbnOp1);

        var rbnOp2 = new RadioButton;
        rbnOp2.text = sys.translate("Usar el precio del artículo (%1)").arg(pvp);
        gbxOpciones.add(rbnOp2);
        dialog.add(gbxOpciones);

        var chkTodos = new CheckBox;
        chkTodos.text = sys.translate("Aplicar respuesta a los demás barcodes");
        chkTodos.checked = true;
        dialog.add(chkTodos);

        if (!dialog.exec()) {
          return;
        }
        if (chkTodos.checked) {
          preguntar = false;
        }
        if (rbnOp1.checked) {
          usarPvpArt = false;
        } else {
          usarPvpArt = true;
        }
      }
      if (!usarPvpArt) {
        pvp = pvpInicial;
      }
      if (datos != "") {
        datos += ";"
      }
               datos += barCode + "," + codTalla + "," + codColor + "," + nuevaCantidad + "," + pvp;
      if (cursor.valueBuffer("tabla") == "lineasalbaranescli") {
        datos += "," + _i.arrayLineasTC[fila][columna]["idlineapedido"];
        datos += "," + _i.arrayLineasTC[fila][columna]["idpedido"];
      }
    }
  }

  cursor.setValueBuffer("datos", datos);
  this.child("pushButtonAccept").setEnabled(true);
  this.child("pushButtonAccept").animateClick();
}

/** \D Construye el barcode componiendo el código como referencia + codTalla + codColor
@param  referencia: Referencia del artículo
@param  codTalla: Código de talla
@param  codColor: Código de color
@retrun barCode
\end */
function oficial_construirBarcode(referencia: Sring, codTalla, codColor)
{
  return referencia + codTalla + codColor;
}

function oficial_nuevaFila()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var referencia = cursor.valueBuffer("referencia");
  if (!referencia || referencia == "")
    return;

  var res = MessageBox.information(sys.translate("Si modifica la tabla de tallas y colores perderá los datos que haya modificado en la misma. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return false;

  if (!flfactalma.iface.pub_pedirColor(referencia))
    return false;

  _i.bloqueoCantidad = true;
  _i.arrayLineasTC = _i.refrescarTablaTC(_i.tablaLineasTC, _i.arrayLineasTC, cursor);
  _i.bloqueoCantidad = false;
  _i.calcularCantidad();
}

/** \D Calcula y modifica el valor del campo cantidad como suma de las cantidades introducidas en la tabla
\end */
function oficial_calcularCantidad()
{
  var _i = this.iface;

  if (_i.bloqueoCantidad)
    return;

  if (!_i.arrayLineasTC || _i.arrayLineasTC.length == 0) {
    this.child("fdbCantidad").setValue(0);
    return;
  }

  var numCols = _i.arrayLineasTC[0].length;
  var valor = 0;
  var temp;
  for (var fila = 0; fila < _i.tablaLineasTC.numRows(); fila++) {
    for (var col = 0; col < numCols; col++) {
      temp = parseFloat(_i.tablaLineasTC.text(fila, col));
      if (!isNaN(temp))
        valor += temp;
    }
  }
  this.child("fdbCantidad").setValue(valor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
