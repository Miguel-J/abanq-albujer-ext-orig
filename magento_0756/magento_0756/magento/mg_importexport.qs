/***************************************************************************
                 mg_importexport.qs  -  description
                             -------------------
    begin                : mar feb 26 2013
    copyright            : Por ahora (C) 2013 by InfoSiAL S.L.
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
  function main()
  {
    this.ctx.interna_main();
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
  var aFichero_, v_, cabecera_, f_, sep_;
  function oficial(context)
  {
    interna(context);
  }
  function pbRutaExport_clicked()
  {
    return this.ctx.oficial_pbRutaExport_clicked();
  }
  function cargaValores()
  {
    return this.ctx.oficial_cargaValores();
  }
  function pbExCatalogo_clicked()
  {
    return this.ctx.oficial_pbExCatalogo_clicked();
  }
  function pbExStock_clicked()
  {
    return this.ctx.oficial_pbExStock_clicked();
  }
  function fechaFichero()
  {
    return this.ctx.oficial_fechaFichero();
  }
  function pbExPrecios_clicked()
  {
    return this.ctx.oficial_pbExPrecios_clicked();
  }
  function formatoFecha(valor, formato)
  {
    return this.ctx.oficial_formatoFecha(valor, formato);
  }
  function parteFecha(d, parte)
  {
    return this.ctx.oficial_parteFecha(d, parte);
  }
  function cerosIzquierda(numero, totalCifras)
  {
    return this.ctx.oficial_cerosIzquierda(numero, totalCifras);
  }
  function esquemaCatalogo(oParam)
  {
    return this.ctx.oficial_esquemaCatalogo(oParam);
  }
  function esquemaStock(oParam)
  {
    return this.ctx.oficial_esquemaStock(oParam);
  }
  function queryStock(oParam)
  {
    return this.ctx.oficial_queryStock(oParam);
  }
  function esquemaPrecios(oParam)
  {
    return this.ctx.oficial_esquemaPrecios(oParam);
  }
  function queryPrecios(oParam)
  {
    return this.ctx.oficial_queryPrecios(oParam);
  }
  function arrayAFichero()
  {
    return this.ctx.oficial_arrayAFichero();
  }
  function queryCatalogo(oParam)
  {
    return this.ctx.oficial_queryCatalogo(oParam);
  }
  function cargaEsquema(esquema, oParam)
  {
    return this.ctx.oficial_cargaEsquema(esquema, oParam);
  }
  function iniciaExportacion(esquema, oParam)
  {
    return this.ctx.oficial_iniciaExportacion(esquema, oParam);
  }
  function prefijoEsquema(esquema)
  {
    return this.ctx.oficial_prefijoEsquema(esquema);
  }
  function lanzaExportacion(esquema, oParam)
  {
    return this.ctx.oficial_lanzaExportacion(esquema, oParam);
  }
  function lanzaEsquema(esquema, oParam)
  {
    return this.ctx.oficial_lanzaEsquema(esquema, oParam);
  }
  function saltaRegistro(esquema, q)
  {
    return this.ctx.oficial_saltaRegistro(esquema, q);
  }
  function calculaValor(c, q)
  {
    return this.ctx.oficial_calculaValor(c, q);
  }
  function guardaRegistro(e, q)
  {
    return this.ctx.oficial_guardaRegistro(e, q);
  }
  function cabeceraEsquema(e)
  {
    return this.ctx.oficial_cabeceraEsquema(e);
  }
  function colEsquema()
  {
    return this.ctx.oficial_colEsquema();
  }
  function descripcionTraducida(q)
  {
    return this.ctx.oficial_descripcionTraducida(q);
  }
  function ordenCols(esquema)
  {
    return this.ctx.oficial_ordenCols(esquema);
  }
  function pbRutaImport_clicked()
  {
    this.ctx.oficial_pbRutaImport_clicked();
  }
  function importCustomers()
  {
    this.ctx.oficial_importCustomers();
  }
  function importOrders()
  {
    this.ctx.oficial_importOrders();
  }
  function loadFile(path, fileName, sep, nocommas)
  {
    return this.ctx.oficial_loadFile(path, fileName, sep, nocommas);
  }
  function dumpFile(path, fileName, content)
  {
    return this.ctx.oficial_dumpFile(path, fileName, content);
  }
  function splitFileOrders(path, content)
  {
    return this.ctx.oficial_splitFileOrders(path, content);
  }
  function exportData(esquema, codWebsite)
  {
    return this.ctx.oficial_exportData(esquema, codWebsite);
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
  function pub_importCustomers()
  {
    this.importCustomers();
  }
  function pub_importOrders()
  {
    this.importOrders();
  }
  function pub_exportData(esquema, codWebsite)
  {
    this.exportData(esquema, codWebsite);
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
*/
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  connect(child("pbRutaExport"), "clicked()", _i, "pbRutaExport_clicked");
  connect(child("pbExCatalogo"), "clicked()", _i, "pbExCatalogo_clicked");
  connect(child("pbExStock"), "clicked()", _i, "pbExStock_clicked");
  connect(child("pbExPrecios"), "clicked()", _i, "pbExPrecios_clicked");

  connect(child("pbRutaImport"), "clicked()", _i, "pbRutaImport_clicked");
  connect(child("pbImportCustomers"), "clicked()", _i, "importCustomers");
  connect(child("pbImportOrders"), "clicked()", _i, "importOrders");

  _i.cargaValores();
}


function interna_main()
{
  var _i = this.iface;

  var f = new FLFormSearchDB("mg_importexport");
  var cursor = f.cursor();

  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  cursor.refreshBuffer();
  f.setMainWidget();
  var id = f.exec("id");
  if (!id) {
    return;
  }
  cursor.commitBuffer();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargaValores()
{
  var _i = this.iface;
  _i.sep_ = ";";
}

function oficial_pbRutaExport_clicked()
{
  var d = FileDialog.getExistingDirectory();
  if (!d) {
    return;
  }
  sys.setObjText(this, "fdbRutaExport", d);
}

function oficial_pbExCatalogo_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var oParam = new Object;
  if (!_i.lanzaExportacion("catalogo", oParam)) {
    return false;
  }
}

function oficial_pbExStock_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codWebsite = cursor.valueBuffer("codwebsite");
  if (!codWebsite || codWebsite == "") {
    sys.warnMsgBox(sys.translate("Debe indicar el website cuyo stock quiere exportar"));
    return;
  }
  var oParam = new Object;
  oParam.codWebsite = codWebsite;

  if (!_i.lanzaExportacion("Stock", oParam)) {
    return false;
  }
}

function oficial_pbExPrecios_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var oParam = new Object;
  if (!_i.lanzaExportacion("Precios", oParam)) {
    return false;
  }

}

function oficial_exportData(esquema, codWebsite)
{
  debug("oficial_exportData " + esquema + " " + codWebsite);
  var _i = this.iface;
  var oParam = new Object;
  oParam.codWebsite = codWebsite;
  if (!_i.lanzaExportacion(esquema, oParam)) {
    return false;
  }
}

function oficial_fechaFichero()
{
  var d = new Date;
  var s = "";
  var _cI = flfactppal.iface.pub_cerosIzquierda;
  s += _cI(d.getDate(), 2);
  s += _cI(d.getMonth(), 2);
  s += d.getYear();
  s += _cI(d.getHours(), 2);
  s += _cI(d.getMinutes(), 2);
  s += _cI(d.getSeconds(), 2);
  return s;
}

function oficial_arrayAFichero()
{
  var _i = this.iface;
  var nL = _i.v_.length;

  if (_i.cabecera_ && _i.cabecera_.length != 0) {
    _i.f_.writeLine(_i.cabecera_.join(_i.sep_));
  }

  for (var l = 0; l < nL; l++) {
    _i.f_.writeLine(_i.v_[l].join(_i.sep_));
  }
  return true;
}

function oficial_queryCatalogo()
{
  var q = new AQSqlQuery;
  q.setSelect("a.referencia, ws.codwebsite, sv.codstoreview, sv.codidioma, aw.activo, a.mgcategorias, a.descripcion, t.traduccion, a.aqpeso, a.mgnuevodesde, a.mgnuevohasta, a.pvp, s.cantidad, s.disponible, a.mgimagen1, a.mgimagen2, a.mgimagen3, a.mgimagen4");
  q.setFrom("articulos a INNER JOIN mg_artwebsite aw ON (a.referencia = aw.referencia AND aw.activo IS NOT NULL) INNER JOIN mg_websites ws ON aw.codwebsite = ws.codwebsite INNER JOIN mg_storeviews sv ON ws.codwebsite = sv.codwebsite LEFT OUTER JOIN traducciones t ON (a.referencia = t.idcampo AND tabla = 'articulos' AND campo = 'descripcion' AND t.codidioma = sv.codidioma) LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = ws.codalmacen)");
  q.setWhere("1 = 1 ORDER BY a.referencia, ws.codwebsite, sv.codstoreview");
  debug(q.sql());
  return q;
}

function oficial_ordenCols(esquema)
{
  var cols;
  switch (esquema) {
    case "catalogo": {
      cols = "sku, skupadre, website, storeview, borrar, categorias, nombre, descripcion, descripcioncorta, peso, newfrom, newto, baja, precio, precioespecial, especialdesde, especialhasta, qty, disponible, imagen1, imagen2, imagen3, imagen4";
      break;
    }
    case "Stock": {
      cols = "sku, stock";
      break;
    }
    case "Precios": {
      cols = "sku, website, precio, precioespecial, especialdesde, especialhasta";
      break;
    }
  }
  return cols;
}

function oficial_esquemaCatalogo(oParam)
{
  var _i = this.iface;
  var e = new Object;

  e.nombre = "catalogo";
  e.q = _i.queryCatalogo();

  e.col = new Object;
  e.indexCol = _i.ordenCols("catalogo").split(", ");

  var col = e.col;
  col["sku"] = _i.colEsquema();
  col["sku"].titulo = "SKU";
  col["sku"].valor = "a.referencia";

  col["skupadre"] = _i.colEsquema();
  col["skupadre"].titulo = "SKUPADRE";
  col["skupadre"].tipo = "valor";
  col["skupadre"].valor = "";

  col["website"] = _i.colEsquema();
  col["website"].titulo = "WEBSITE";
  col["website"].valor = "ws.codwebsite";

  col["storeview"] = _i.colEsquema();
  col["storeview"].titulo = "STOREVIEW";
  col["storeview"].valor = "sv.codstoreview";

  col["borrar"] = _i.colEsquema();
  col["borrar"].titulo = "BORRAR";
  col["borrar"].tipo = "funcion";
  col["borrar"].valor = new Function("q", "return q.value(\"aw.activo\") ? 0 : 1;");

  col["categorias"] = _i.colEsquema();
  col["categorias"].titulo = "CATEGORIAS";
  col["categorias"].valor = "a.mgcategorias";

  col["nombre"] = _i.colEsquema();
  col["nombre"].titulo = "NOMBRE";
  col["nombre"].tipo = "funcion";
  col["nombre"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");

  col["descripcion"] = _i.colEsquema();
  col["descripcion"].titulo = "DESCRIPCION";
  col["descripcion"].tipo = "funcion";
  col["descripcion"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");

  col["descripcioncorta"] = _i.colEsquema();
  col["descripcioncorta"].titulo = "DESCRIPCIONCORTA";
  col["descripcioncorta"].tipo = "funcion";
  col["descripcioncorta"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");

  col["peso"] = _i.colEsquema();
  col["peso"].titulo = "PESO";
  col["peso"].valor = "a.aqpeso";

  col["newfrom"] = _i.colEsquema();
  col["newfrom"].titulo = "NEWFROM";
  col["newfrom"].tipo = "funcion";
  col["newfrom"].valor = new Function("q", "return formmg_importexport.iface.formatoFecha(q.value(\"a.mgnuevodesde\"), \"dd-mm-aa\");");

  col["newto"] = _i.colEsquema();
  col["newto"].titulo = "NEWTO";
  col["newto"].tipo = "funcion";
  col["newto"].valor = new Function("q", "return formmg_importexport.iface.formatoFecha(q.value(\"a.mgnuevohasta\"), \"dd-mm-aa\");");

  col["baja"] = _i.colEsquema();
  col["baja"].titulo = "BAJA";
  col["baja"].tipo = "valor";
  col["baja"].valor = "0";

  col["precio"] = _i.colEsquema();
  col["precio"].titulo = "PRECIO";
  col["precio"].valor = "a.pvp";

  col["precioespecial"] = _i.colEsquema();
  col["precioespecial"].titulo = "PRECIO ESPECIAL";
  col["precioespecial"].tipo = "vacio";

  col["especialdesde"] = _i.colEsquema();
  col["especialdesde"].titulo = "ESPECIAL DESDE";
  col["especialdesde"].tipo = "vacio";

  col["especialhasta"] = _i.colEsquema();
  col["especialhasta"].titulo = "ESPECIAL HASTA";
  col["especialhasta"].tipo = "vacio";

  col["qty"] = _i.colEsquema();
  col["qty"].titulo = "Qty";
  col["qty"].valor = "s.cantidad";

  col["disponible"] = _i.colEsquema();
  col["disponible"].titulo = "Disponible";
  col["disponible"].valor = "s.disponible";

  col["imagen1"] = _i.colEsquema();
  col["imagen1"].titulo = "IMAGEN 1";
  col["imagen1"].valor = "a.mgimagen1";

  col["imagen2"] = _i.colEsquema();
  col["imagen2"].titulo = "IMAGEN 2";
  col["imagen2"].valor = "a.mgimagen2";

  col["imagen3"] = _i.colEsquema();
  col["imagen3"].titulo = "IMAGEN 3";
  col["imagen3"].valor = "a.mgimagen3";

  col["imagen4"] = _i.colEsquema();
  col["imagen4"].titulo = "IMAGEN 4";
  col["imagen4"].valor = "a.mgimagen4";

  return e;
}

function oficial_queryStock(oParam)
{
  if (!("codWebsite" in oParam)) {
    return false;
  }
  var codAlmacen = AQUtil.sqlSelect("mg_websites", "codalmacen", "codwebsite = '" + oParam.codWebsite + "'");
  if (!codAlmacen) {
    return false;
  }
  var cursor = this.cursor();
  var q = new AQSqlQuery;
  q.setSelect("a.referencia, s.cantidad");
  q.setFrom("articulos a LEFT OUTER JOIN stocks s ON a.referencia = s.referencia AND s.codalmacen = '" + codAlmacen + "'");
  q.setWhere("1 = 1 ORDER BY a.referencia");
  debug(q.sql());
  return q;
}

function oficial_esquemaStock(oParam)
{
  var _i = this.iface;
  var e = new Object;

  e.nombre = "Stock";
  e.q = _i.queryStock(oParam);

  e.col = new Object;
  e.indexCol = _i.ordenCols(e.nombre).split(", ");

  var col = e.col;
  col["sku"] = _i.colEsquema();
  col["sku"].titulo = "SKU";
  col["sku"].valor = "a.referencia";

  col["stock"] = _i.colEsquema();
  col["stock"].titulo = "STOCK";
  col["stock"].tipo = "funcion";
  col["stock"].valor = new Function("q", "v = q.value(\"s.cantidad\"); return ((!v || isNaN(v)) ? 0 : v);");

  return e;
}

function oficial_queryPrecios(oParam)
{
  var q = new AQSqlQuery;
  q.setSelect("a.referencia, ws.codwebsite, a.pvp");
  q.setFrom("articulos a INNER JOIN mg_artwebsite aw ON (a.referencia = aw.referencia AND aw.activo IS NOT NULL) INNER JOIN mg_websites ws ON aw.codwebsite = ws.codwebsite");
  q.setWhere("1 = 1 ORDER BY a.referencia, ws.codwebsite");
  debug(q.sql());
  return q;
}

function oficial_esquemaPrecios(oParam)
{
  var _i = this.iface;
  var e = new Object;

  e.nombre = "Precios";
  e.q = _i.queryPrecios(oParam);

  e.col = new Object;
  e.indexCol = _i.ordenCols(e.nombre).split(", ");

  var col = e.col;
  col["sku"] = _i.colEsquema();
  col["sku"].titulo = "SKU";
  col["sku"].valor = "a.referencia";

  col["website"] = _i.colEsquema();
  col["website"].titulo = "WEBSITE";
  col["website"].valor = "ws.codwebsite";

  col["precio"] = _i.colEsquema();
  col["precio"].titulo = "PRECIO";
  col["precio"].valor = "a.pvp";

  col["precioespecial"] = _i.colEsquema();
  col["precioespecial"].titulo = "PRECIOESPECIAL";
  col["precioespecial"].tipo = "vacio";

  col["especialdesde"] = _i.colEsquema();
  col["especialdesde"].titulo = "FECHAINICIO";
  col["especialdesde"].tipo = "vacio";

  col["especialhasta"] = _i.colEsquema();
  col["especialhasta"].titulo = "FECHAFIN";
  col["especialhasta"].tipo = "vacio";

  return e;
}

function oficial_formatoFecha(valor, formato)
{
  var _i = this.iface;
  if (!valor || valor == "") {
    return "";
  }
  var d = new Date(Date.parse(valor.toString()));
  if (!d) {
    return "";
  }
  var seps = "/-", sep;
  for (var s = 0; s < seps.length; s++) {
    sep = seps.charAt(s);
    if (formato.find(sep) >= 0) {
      break;
    }
  }
  var aF = formato.split(sep);
  var fecha = "";
  for (var i = 0; i < aF.length; i++) {
    fecha += fecha == "" ? "" : sep;
    fecha += _i.parteFecha(d, aF[i]);
  }
  return fecha;
}

function oficial_parteFecha(d, parte)
{
  var _i = this.iface;
  var valor;
  switch (parte.toUpperCase()) {
    case "DD": {
      valor = _i.cerosIzquierda(d.getDate(), 2);
      break;
    }
    case "MM": {
      valor = _i.cerosIzquierda(d.getMonth(), 2);
      break;
    }
    case "AA": {
      valor = d.getYear().toString().right(2);
      break;
    }
    case "AAAA": {
      valor = d.getYear();
      break;
    }
  }
  return valor;
}

function oficial_cerosIzquierda(numero, totalCifras)
{
  var ret = numero.toString();
  var numCeros = totalCifras - ret.length;
  for (; numCeros > 0 ; --numCeros)
    ret = "0" + ret;
  return ret;
}

function oficial_cargaEsquema(esquema, oParam)
{
  var _i = this.iface;
  var e;
  switch (esquema) {
    case "catalogo": {
      e = _i.esquemaCatalogo(oParam);
      break;
    }
    default: {
      e = eval("_i.esquema" + esquema + "(oParam)");
    }
  }
  return e;
}

function oficial_iniciaExportacion(esquema, oParam)
{
  var _i = this.iface;
  switch (esquema) {
    case "catalogo":
    case "Stock":
    case "Precios": {
      _i.aFichero_ = true;
      break;
    }
  }
  return true;
}

function oficial_prefijoEsquema(esquema)
{
  var p;
  switch (esquema) {
    case "catalogo": {
      p = "CATALOG_IMPORT_";
      break;
    }
    case "Stock": {
      p = "STOCK_IMPORT_";
      break;
    }
    case "Precios": {
      p = "PRICES_IMPORT_";
      break;
    }
  }
  return p;
}

function oficial_lanzaExportacion(esquema, oParam)
{
  var _i = this.iface;

  var prefijo = _i.prefijoEsquema(esquema);

  var nF =  prefijo + _i.fechaFichero() + ".CSV";

  var fdbRutaExport = sys.testObj(this, "fdbRutaExport");
  var rutaExp;
  if (fdbRutaExport) {
    rutaExp = fdbRutaExport.value();
  } else {
    rutaExp = AQUtil.sqlSelect("mg_importexport", "rutaexport", "");
  }
  var rutaF = rutaExp + "/" + nF;
  _i.f_ = new File(rutaF);
  _i.f_.open(File.WriteOnly);

  if (!_i.iniciaExportacion(esquema, oParam)) {
    return false;
  }

  if (!_i.lanzaEsquema(esquema, oParam)) {
    return false;
  }

  _i.f_.close();

  sys.infoMsgBox(sys.translate("Fichero generado correctamente en %1").arg(rutaF));
  return true;
}

function oficial_lanzaEsquema(esquema, oParam)
{
  var iG = sys.interactiveGUI();
  var _i = this.iface;
  var e = _i.cargaEsquema(esquema, oParam);
  if (!e) {
    return false;
  }
  var col = e.col;
  var q = e.q;
  if (!q.exec()) {
    return false;
  }
  if (!_i.cabeceraEsquema(e)) {
    return false;
  }
  if (iG) AQUtil.createProgressDialog(sys.translate("Exportando esquema %1...").arg(esquema), q.size());
  var p = 0;
  while (q.next()) {
    if (iG) AQUtil.setProgress(p++);
    if (_i.saltaRegistro(esquema, q)) {
      continue;
    }
    if (!_i.guardaRegistro(e, q)) {
      if (iG) sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }
  }
  if (iG) sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
  return true;
}

function oficial_saltaRegistro(esquema, q)
{
  var _i = this.iface;
  return false;
}

function oficial_calculaValor(c, q)
{
  var _i = this.iface;
  var valor;
  switch (c.tipo) {
    case "campo": {
      valor = q.value(c.valor);
      break;
    }
    case "valor": {
      valor = c.valor;
      break;
    }
    case "vacio": {
      valor = "";
      break;
    }
    case "funcion": {
      valor = c.valor(q)
              break;
    }
  }
  return valor;
}

function oficial_guardaRegistro(e, q)
{
  var _i = this.iface;
  var sep = ";"
            var iC = e.indexCol;
  var nC = iC.length;
  var linea = new Array(nC);
  var oCol, valor;
  for (var c = 0; c < nC; c++) {
    oCol = e.col[iC[c]];
    valor = _i.calculaValor(oCol, q);
    if (valor == "AQSaltar") {
      return true;
    }
    linea[c] = "\"" + valor + "\"";
  }
  if (_i.aFichero_) {
    var l = linea.join(sep);
    _i.f_.writeLine(l);
  } else {
    _i.v_[_i.v_.length] = linea;
  }
  return true;
}

function oficial_cabeceraEsquema(e)
{
  var _i = this.iface;
  var sep = ";"
            var iC = e.indexCol;
  var nC = iC.length;
  var linea = new Array(nC);
  var oCol;
  for (var c = 0; c < nC; c++) {
    oCol = e.col[iC[c]];
    linea[c] = "\"" + oCol.titulo + "\"";
  }
  if (_i.aFichero_) {
    var l = linea.join(sep);
    _i.f_.writeLine(l);
  } else {
    _i.cabecera_ = linea;
  }
  return true;
}

function oficial_colEsquema()
{
  var cE = new Object;
  cE.nombre = undefined;
  cE.titulo = undefined;
  cE.tipo = "campo"; /// campo, valor, funcion, vacio (columna sin titulo ni valor)
  cE.valor = undefined;
  return cE;
}

function oficial_descripcionTraducida(q)
{
  var _i = this.iface;
  var valor = q.value("a.descripcion");

  var codIdiomaWeb = q.value("sv.codidioma");
  var codIdiomaEmpresa = "ES";
  var traduccion = q.value("t.traduccion");

  if (codIdiomaWeb != codIdiomaEmpresa) {
    if (traduccion && traduccion != "") {
      valor = traduccion
    } else {
      valor = "AQSaltar";
    }
  }
  return valor;
}

function oficial_pbRutaImport_clicked()
{
  var d = FileDialog.getExistingDirectory();
  if (!d) {
    return;
  }
  sys.setObjText(this, "fdbRutaImport", d);
}

function oficial_importCustomers()
{
  var _i = this.iface;

  var rutaImp = "";
  var fdbRutaImport = sys.testObj(this, "fdbRutaImport");
  if (fdbRutaImport)
    rutaImp = fdbRutaImport.value();
  else
    rutaImp = AQUtil.sqlSelect("mg_importexport", "rutaimport", "");

  if (!rutaImp || rutaImp.isEmpty()) {
    sys.errorMsgBox(sys.translate("Se debe establecer el directorio de importación"));
    return;
  }

  rutaImp = Dir.cleanDirPath(rutaImp);
  rutaImp = Dir.convertSeparators(rutaImp);

  var impDir = new QDir(rutaImp, "c*.csv C*.csv c*.CSV C*.CSV");
  if (!impDir.exists() || !impDir.isReadable()) {
    sys.errorMsgBox(sys.translate("El directorio de importación no existe o no se puede leer"));
    return;
  }

  try {
    AQSql.del("dat_opciones");
    AQSql.insert("dat_opciones", ["rutadatos"], [rutaImp + "/"]);
  } catch (e) {
    sys.errorMsgBox("Error SQL: " + e);
    return;
  }

  var strLog = "";
  var tedLog = {
    append: function(txt)
    {
      strLog += txt + "\n";
    }
  }

  var list = impDir.entryList(AQS.Files);
  for (var i = 0; i < list.length; ++i) {
    var ret = _i.loadFile(impDir.absPath(), list[i], ";");
    if (ret == undefined)
      continue;
    if (ret[1] == "OK")
      continue;
    var sha = ret[0];
    ret = _i.dumpFile(impDir.absPath(), "aq_out_clientes.csv",
                      AQUtil.sqlSelect("mg_importfiles", "contenido",
                                       "sha='" + sha + "'"));
    if (ret == false)
      continue;

    var transCur = new FLSqlCursor("dat_procesos_lotes");
    transCur.transaction(false);

    strLog = "";
    formRecorddat_procesos_lotes.iface.pub_setTedLog(tedLog);
    formRecorddat_procesos_lotes.iface.pub_cmdRunLote("mg_custome");
    var state = "OK";
    if (strLog.indexOf("### ERROR") != -1 || strLog.indexOf("#error") != -1) {
      transCur.rollback();
      state = "ERROR";
    } else
      transCur.commit();

    try {
      AQSql.update("mg_importfiles", ["estado", "log"],
                   [state, strLog], "sha='" + sha + "'");
      if (sys.interactiveGUI()) {
        var tdbImportFiles = sys.testObj(this, "tdbImportFiles");
        if (tdbImportFiles)
          tdbImportFiles.refresh();
        if (state == "ERROR")
          sys.errorMsgBox(sys.translate("Ha habido un error importando, consulte el Log."));
      }
    } catch (e) {
      sys.errorMsgBox("Error SQL: " + e);
    }
  }
}

function oficial_importOrders()
{
  var _i = this.iface;

  if (!flfactppal.iface.pub_extension("tallcol_barcode")) {
    sys.errorMsgBox(
      sys.translate("La extensión 'tallcol_barcode' debe estar instalada para importar pedidos")
    );
    return;
  }

  var rutaImp = "";
  var fdbRutaImport = sys.testObj(this, "fdbRutaImport");
  if (fdbRutaImport)
    rutaImp = fdbRutaImport.value();
  else
    rutaImp = AQUtil.sqlSelect("mg_importexport", "rutaimport", "");

  if (!rutaImp || rutaImp.isEmpty()) {
    sys.errorMsgBox(sys.translate("Se debe establecer el directorio de importación"));
    return;
  }

  rutaImp = Dir.cleanDirPath(rutaImp);
  rutaImp = Dir.convertSeparators(rutaImp);

  var impDir = new QDir(rutaImp, "o*.txt O*.txt o*.TXT O*.TXT");
  if (!impDir.exists() || !impDir.isReadable()) {
    sys.errorMsgBox(sys.translate("El directorio de importación no existe o no se puede leer"));
    return;
  }

  try {
    AQSql.del("dat_opciones");
    AQSql.insert("dat_opciones", ["rutadatos"], [rutaImp + "/"]);
  } catch (e) {
    sys.errorMsgBox("Error SQL: " + e);
    return;
  }

  var strLog = "";
  var tedLog = {
    append: function(txt)
    {
      strLog += txt + "\n";
    }
  }

  var list = impDir.entryList(AQS.Files);
  for (var i = 0; i < list.length; ++i) {
    var ret = _i.loadFile(impDir.absPath(), list[i], "\\|", true);
    if (ret == undefined)
      continue;
    if (ret[1] == "OK")
      continue;
    var sha = ret[0];
    var content = AQUtil.sqlSelect("mg_importfiles", "contenido",
                                   "sha='" + sha + "'");
    ret = _i.dumpFile(impDir.absPath(), "aq_out_pedidos.csv", content);
    if (ret == false)
      continue;
    ret = _i.splitFileOrders(impDir.absPath(), content);
    if (ret == false)
      continue;

    var transCur = new FLSqlCursor("dat_procesos_lotes");
    transCur.transaction(false);

    strLog = "";
    formRecorddat_procesos_lotes.iface.pub_setTedLog(tedLog);
    formRecorddat_procesos_lotes.iface.pub_cmdRunLote("mg_orders");
    var state = "OK";
    if (strLog.indexOf("### ERROR") != -1 || strLog.indexOf("#error") != -1) {
      transCur.rollback();
      state = "ERROR";
    } else
      transCur.commit();

    try {
      AQSql.update("mg_importfiles", ["estado", "log"],
                   [state, strLog], "sha='" + sha + "'");
      if (sys.interactiveGUI()) {
        var tdbImportFiles = sys.testObj(this, "tdbImportFiles");
        if (tdbImportFiles)
          tdbImportFiles.refresh();
        if (state == "ERROR")
          sys.errorMsgBox(sys.translate("Ha habido un error importando, consulte el Log."));
      }
    } catch (e) {
      sys.errorMsgBox("Error SQL: " + e);
    }
  }
}

function oficial_loadFile(path, fileName, sep, nocommas)
{
  var fname = fileName;
  fileName = path + "/" + fileName;
  fileName = Dir.cleanDirPath(fileName);
  fileName = Dir.convertSeparators(fileName);
  var file = new QFile(fileName);
  if (!file.open(File.ReadOnly)) {
    sys.errorMsgBox(file.errorString());
    return undefined;
  }

  var ts = new QTextStream;
  ts.setCodec(AQS.TextCodec_codecForName("utf8"));
  ts.setDevice(file.ioDevice());
  var sha = AQUtil.sha1(ts.read());
  ts.unsetDevice();
  file.close();

  var stFile = AQUtil.sqlSelect("mg_importfiles", "estado", "sha='" + sha + "'");
  if (stFile != false)
    return [sha, stFile];

  file.open(File.ReadOnly)
  ts.setDevice(file.ioDevice());

  if (sys.interactiveGUI()) {
    AQUtil.createProgressDialog("Leyendo...", 100);
    AQUtil.setProgress(50);
  }
  var content = ts.read();
  var regExp = new RegExp(sep);
  regExp.global = true;
  content = content.replace(regExp, "ð");
  if (nocommas) {
    regExp = new RegExp("\"");
    regExp.global = true;
    content = content.replace(regExp, "");
  }
  if (sys.interactiveGUI())
    AQUtil.destroyProgressDialog();
  ts.unsetDevice();
  file.close();

  try {
    AQSql.insert("mg_importfiles",
                 ["nombre", "estado", "log", "contenido", "sha"],
                 [fname, "LOADED", "LOADED OK", content, sha]);
  } catch (e) {
    sys.errorMsgBox("Error SQL: " + e);
    return undefined;
  }

  return [sha, "LOADED"];
}

function oficial_dumpFile(path, fileName, content)
{
  if (!content)
    return false;

  fileName = path + "/" + fileName;
  fileName = Dir.cleanDirPath(fileName);
  fileName = Dir.convertSeparators(fileName);
  var file = new QFile(fileName);
  if (!file.open(File.WriteOnly)) {
    sys.errorMsgBox(file.errorString());
    return false;
  }

  var ts = new QTextStream;
  ts.setCodec(AQS.TextCodec_codecForName("ISO8859-15"));
  ts.setDevice(file.ioDevice());
  ts.opIn(content);
  ts.unsetDevice();
  file.close();

  return true;
}

function oficial_splitFileOrders(path, content)
{
  var _i = this.iface;

  if (content == false)
    return false;

  var cabs = "TIPOðNUM_PEDIDOðFECHAðTIPO_TRANSACCIONðSOLICITA_FACTURAðMETODO_DE_PAGOðN_CLIENTEðEMAILðNOMBRE_FACTURACIONðAPELLIDO_FACTURACIONðTIPO_DE_VIA__FACTURACIONðCOD._POSTAL__FACTURACIONðCIUDAD__FACTURACIONðPROVINCIA__FACTURACIONðPAIS_FACTURACIONðTELEFONO__FACTURACIONðNIFðPESO_TOTALðSUBTOTALðIMPUESTOSðDESCUENTOSðTOTALðLIBRE1ðLIBRE2\n";
  var lins = "TIPOðNUM PEDIDOðSKUðPESOðUNIDADESðPRECIO CON IVAðPRECIO SIN IVAðTIPOS DE IVAðDESCUENTOðPRECIO CON IVAxQTYðPRECIO SIN IVAxQTYðLIBRE1ðLIBRE2\n";
  var envs = "TIPOðNUM PEDIDOðMETODO ENVIOðUNIDADESðNUM SEGUIMIENTOðNOMBRE ENVIOðAPELLIDOS ENVIOðTIPO DE VIA ENVIOðCOD. POSTAL ENVIOðCIUDAD ENVIOðPROVINCIA ENVIOðPAIS ENVIOðTELEFONO ENVIOðGASTOS DE ENVIOðTIPO DE IVAðCOMENTARIOSðLIBRE1ðLIBRE2\n";
  var lines = content.split('\n');
  for (var i = 0; i < lines.length; ++i) {
    var line = lines[i];
    if (!line || line.isEmpty())
      continue;
    if (line.startsWith("C"))
      cabs += line + "\n";
    else if (line.startsWith("L"))
      lins += line + "\n";
    else if (line.startsWith("E"))
      envs += line + "\n";
  }

  var ret = true;
  ret = _i.dumpFile(path, "aq_out_ped_cab.csv", cabs);
  ret = _i.dumpFile(path, "aq_out_ped_lin.csv", lins);
  ret = _i.dumpFile(path, "aq_out_ped_env.csv", envs);
  return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////