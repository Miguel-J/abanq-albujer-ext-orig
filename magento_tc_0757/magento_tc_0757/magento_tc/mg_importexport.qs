
/** @class_declaration tallCol */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////
class tallCol extends oficial
{
  function tallCol(context)
  {
    oficial(context);
  }
  function lanzaEsquema(esquema, oParam)
  {
    return this.ctx.tallCol_lanzaEsquema(esquema, oParam);
  }
  function cargaEsquema(esquema, oParam)
  {
    return this.ctx.tallCol_cargaEsquema(esquema, oParam);
  }
  function esquemaCatalogoTC(oParam)
  {
    return this.ctx.tallCol_esquemaCatalogoTC(oParam);
  }
  function temporada(q)
  {
    return this.ctx.tallCol_temporada(q);
  }
  function esquemaCatalogo(oParam)
  {
    return this.ctx.tallCol_esquemaCatalogo(oParam);
  }
  function iniciaExportacion(esquema, oParam)
  {
    return this.ctx.tallCol_iniciaExportacion(esquema, oParam);
  }
  function queryCatalogo(oParam)
  {
    return this.ctx.tallCol_queryCatalogo(oParam);
  }
  function queryCatalogoTC(oParam)
  {
    return this.ctx.tallCol_queryCatalogoTC(oParam);
  }
  function ordenaCatalogoTC(a, b)
  {
    return this.ctx.tallCol_ordenaCatalogoTC(a, b);
  }
  function ordenCols(esquema)
  {
    return this.ctx.tallCol_ordenCols(esquema);
  }
  function cabeceraEsquema(e)
  {
    return this.ctx.tallCol_cabeceraEsquema(e);
  }
  function esquemaStockTC(oParam)
  {
    return this.ctx.tallCol_esquemaStockTC(oParam);
  }
  function queryStockTC(oParam)
  {
    return this.ctx.tallCol_queryStockTC(oParam);
  }
  function queryStock(oParam)
  {
    return this.ctx.tallCol_queryStock(oParam);
  }
}
//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallCol */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////


// function tallCol_esquemaCatalogo()
// {
//  var _i = this.iface;
//  var e = new Object;
//
//  e.q = _i.queryCatalogo();
//
//  e.col = new Object;
//  e.indexCol = _i.ordenCols("catalogo").split(", ");
//
//  var col = e.col;
//  col["sku"] = _i.colEsquema();
//  col["sku"].titulo = "SKU";
//  col["sku"].valor = "a.referencia";
//
//  col["skupadre"] = _i.colEsquema();
//  col["skupadre"].titulo = "SKUPADRE";
//  col["skupadre"].tipo = "valor";
//  col["skupadre"].valor = "";
//
//  col["website"] = _i.colEsquema();
//  col["website"].titulo = "WEBSITE";
//  col["website"].valor = "ws.codwebsite";
//
//  col["storeview"] = _i.colEsquema();
//  col["storeview"].titulo = "STOREVIEW";
//  col["storeview"].valor = "sv.codstoreview";
//
//  col["borrar"] = _i.colEsquema();
//  col["borrar"].titulo = "BORRAR";
//  col["borrar"].tipo = "funcion";
//  col["borrar"].valor = new Function("q", "return q.value(\"aw.activo\") ? 0 : 1;");
//
//  col["categorias"] = _i.colEsquema();
//  col["categorias"].titulo = "CATEGORIAS";
//  col["categorias"].valor = "a.mgcategorias";
//
//  col["nombre"] = _i.colEsquema();
//  col["nombre"].titulo = "NOMBRE";
//  col["nombre"].tipo = "funcion";
//  col["nombre"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");
//
//  col["descripcion"] = _i.colEsquema();
//  col["descripcion"].titulo = "DESCRIPCION";
//  col["descripcion"].tipo = "funcion";
//  col["descripcion"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");
//
//  col["descripcioncorta"] = _i.colEsquema();
//  col["descripcioncorta"].titulo = "DESCRIPCIONCORTA";
//  col["descripcioncorta"].tipo = "funcion";
//  col["descripcioncorta"].valor = new Function("q", "return formmg_importexport.iface.descripcionTraducida(q);");
//
// //   col[c] = _i.colEsquema();
// //   col[c].nombre = "guiadetallas";
// //   col[c].titulo = "GUIADETALLAS";
// //   col[c].valor = "";
// //   c++;
// //
// //   col[c] = _i.colEsquema();
// //   col[c].nombre = "guiadetallas";
// //   col[c].titulo = "GUIADETALLAS";
// //   col[c].valor = "";
// //   c++;
//
//  col["peso"] = _i.colEsquema();
//  col["peso"].titulo = "PESO";
//  col["peso"].valor = "a.aqpeso";
//
//  col["newfrom"] = _i.colEsquema();
//  col["newfrom"].titulo = "NEWFROM";
//  col["newfrom"].valor = "a.mgnuevodesde";
//
//  col["newto"] = _i.colEsquema();
//  col["newto"].titulo = "NEWTO";
//  col["newto"].valor = "a.mgnuevohasta";
//
//  col["baja"] = _i.colEsquema();
//  col["baja"].titulo = "BAJA";
//  col["baja"].tipo = "valor";
//  col["baja"].valor = "0";
//
// //   col[c] = _i.colEsquema();
// //   col[c].nombre = "talla";
// //   col[c].titulo = "TALLA";
// //   col[c].valor = "";
// //   c++;
//
// //   col[c] = _i.colEsquema();
// //   col[c].nombre = "composicion";
// //   col[c].titulo = "COMPOSICION";
// //   col[c].valor = "";
// //   c++;
//
//  return e;
// }

function tallCol_queryCatalogo(oParam)
{
  var q = new AQSqlQuery;
  q.setSelect("a.referencia, ws.codwebsite, sv.codstoreview, sv.codidioma, aw.activo, a.mgcategorias, a.descripcion, a.mgcomposicion, a.mgcuidado, t.traduccion, a.mgguiatallas, a.aqpeso, a.mgnuevodesde, a.mgnuevohasta, a.anno, tm.descripcion, a.pvp, s.cantidad, s.disponible, a.mgimagen1, a.mgimagen2, a.mgimagen3, a.mgimagen4");
  q.setFrom("articulos a INNER JOIN mg_artwebsite aw ON (a.referencia = aw.referencia AND aw.activo IS NOT NULL) INNER JOIN mg_websites ws ON aw.codwebsite = ws.codwebsite INNER JOIN mg_storeviews sv ON ws.codwebsite = sv.codwebsite LEFT OUTER JOIN traducciones t ON (a.referencia = t.idcampo AND tabla = 'articulos' AND campo = 'descripcion' AND t.codidioma = sv.codidioma) LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND s.barcode IS NULL AND s.codalmacen = ws.codalmacen) LEFT OUTER JOIN temporadas tm ON a.codtemporada = tm.codtemporada");
  q.setWhere("1 = 1 ORDER BY a.referencia, ws.codwebsite, sv.codstoreview");
  debug(q.sql());
  return q;
}


function tallCol_queryCatalogoTC(oParam)
{
  var q = new AQSqlQuery;
  q.setSelect("a.referencia, aa.barcode, aa.talla, aa.color, ws.codwebsite, sv.codstoreview, sv.codidioma, aw.activo, a.mgcategorias, a.descripcion, t.traduccion, a.mgguiatallas, a.aqpeso, a.mgnuevodesde, a.mgnuevohasta, a.mgcomposicion, a.mgcuidado, a.anno, tm.descripcion, a.pvp, s.cantidad, s.disponible, a.mgimagen1, a.mgimagen2, a.mgimagen3, a.mgimagen4");
  q.setFrom("articulos a INNER JOIN atributosarticulos aa ON a.referencia = aa.referencia INNER JOIN mg_artwebsite aw ON (a.referencia = aw.referencia AND aw.activo IS NOT NULL) INNER JOIN mg_websites ws ON aw.codwebsite = ws.codwebsite INNER JOIN mg_storeviews sv ON ws.codwebsite = sv.codwebsite LEFT OUTER JOIN traducciones t ON (a.referencia = t.idcampo AND tabla = 'articulos' AND campo = 'descripcion' AND t.codidioma = sv.codidioma) LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND s.barcode = aa.barcode AND s.codalmacen = ws.codalmacen) LEFT OUTER JOIN temporadas tm ON a.codtemporada = tm.codtemporada");
  q.setWhere("1 = 1 ORDER BY a.referencia, ws.codwebsite, sv.codstoreview");
  debug(q.sql());
  return q;
}

function tallCol_ordenCols(esquema)
{
  var _i = this.iface;
  var cols;
  switch (esquema) {
    case "catalogo": {
      cols = "sku, skupadre, website, storeview, borrar, categorias, nombre, descripcion, descripcioncorta, guiadetallas, peso, newfrom, newto, baja, talla, composicion, cuidado, temporada, vacio19, vacio20, precio, precioespecial, especialdesde, especialhasta, vacio25, qty, disponible, vacio28, imagen1, imagen2, imagen3, imagen4, vacio33, vacio34";
      break;
    }
    default: {
      cols = _i.__ordenCols(esquema);
    }
  }
  return cols;
}

function tallCol_esquemaCatalogo(oParam)
{
  var _i = this.iface;
  var e = _i.__esquemaCatalogo(oParam);

  var col = e.col;

  col["guiadetallas"] = _i.colEsquema();
  col["guiadetallas"].titulo = "GUIADETALLAS";
  col["guiadetallas"].valor = "a.mgguiatallas";

  col["talla"] = _i.colEsquema();
  col["talla"].titulo = "TALLA";
  col["talla"].tipo = "vacio";

  col["composicion"] = _i.colEsquema();
  col["composicion"].titulo = "COMPOSICION";
  col["composicion"].valor = "a.mgcomposicion";

  col["cuidado"] = _i.colEsquema();
  col["cuidado"].titulo = "CUIDADO";
  col["cuidado"].valor = "a.mgcuidado";

  col["temporada"] = _i.colEsquema();
  col["temporada"].titulo = "TEMPORADA";
  col["temporada"].tipo = "funcion";
  col["temporada"].valor = new Function("q", "return formmg_importexport.iface.temporada(q);");

  col["vacio19"] = _i.colEsquema();
  col["vacio19"].titulo = "";
  col["vacio19"].tipo = "vacio";

  col["vacio20"] = _i.colEsquema();
  col["vacio20"].titulo = "";
  col["vacio20"].tipo = "vacio";

  col["vacio25"] = _i.colEsquema();
  col["vacio25"].titulo = "";
  col["vacio25"].tipo = "vacio";

  col["vacio28"] = _i.colEsquema();
  col["vacio28"].titulo = "";
  col["vacio28"].tipo = "vacio";

  col["vacio33"] = _i.colEsquema();
  col["vacio33"].titulo = "";
  col["vacio33"].tipo = "vacio";

  col["vacio34"] = _i.colEsquema();
  col["vacio34"].titulo = "";
  col["vacio34"].tipo = "vacio";

  return e;
}

/// Valores para El Ganso. Si se cambia, llevar esta función a la extensión fun_ganso
function tallCol_temporada(q)
{
  var temp = q.value("tm.descripcion");
  if (!temp || temp == "") {
    return "";
  }
  if (temp == "ATEMP") {
    return "";
  }
  temp = temp.toUpperCase() == "W" ? "OI" : "PV"
         var ano = q.value("a.anno");
  if (!ano || ano == "") {
    return "";
  }
  if (ano.length == 2) {
    ano = "20" + ano;
  }
  return ano + "-" + temp;
}

function tallCol_esquemaCatalogoTC(oParam)
{
  var _i = this.iface;
  var e = _i.esquemaCatalogo();

  e.nombre = "catalogo_tc";

  e.q = _i.queryCatalogoTC(oParam);
  var q = e.q;

  var col = e.col;

  col["sku"].valor = "aa.barcode";

  col["skupadre"].tipo = "campo";
  col["skupadre"].valor = "a.referencia";

  col["talla"].tipo = "campo";
  col["talla"].valor = "aa.talla";

  return e;
}


function tallCol_lanzaEsquema(esquema, oParam)
{
  var _i = this.iface;
  switch (esquema) {
    case "catalogo": {
      if (!_i.__lanzaEsquema("catalogo", oParam)) {
        return false;
      }
      if (!_i.__lanzaEsquema("catalogo_tc", oParam)) {
        return false;
      }
      /// Ordenar array
      /// Volcar a fichero
      _i.v_.sort(_i.ordenaCatalogoTC);
      if (!_i.arrayAFichero()) {
        return false;
      }
      break;
    }
    case "Stock": {
      if (!_i.__lanzaEsquema("Stock", oParam)) {
        return false;
      }
      if (!_i.__lanzaEsquema("StockTC", oParam)) {
        return false;
      }
      break;
    }
    default: {
      if (!_i.__lanzaEsquema(esquema, oParam)) {
        return false;
      }
    }
  }
  debug("lanzaEsquema OK");
  return true;
}

function tallCol_ordenaCatalogoTC(a, b)
{
  var rA = a[1] != "" ? a[1] : a[0];
  var rB = b[1] != "" ? b[1] : b[0];
  if (rA > rB) {
    return 1;
  }
  if (rA < rB) {
    return -1;
  }
  if (a[1] != "" && b[1] == "") {
    return 1;
  }
  if (a[1] == "" && b[1] != "") {
    return -1;
  }
  if (a[1] == b[1]) {
    if (a[0] > b[0]) {
      return 1;
    }
    if (a[0] < b[0]) {
      return -1;
    }
  }
  if (a[2] > b[2]) {
    return 1;
  }
  if (a[2] < b[2]) {
    return -1;
  }
  if (a[3] > b[3]) {
    return 1;
  }
  if (a[3] < b[3]) {
    return -1;
  }
  return 0;
}

function tallCol_cargaEsquema(esquema, oParam)
{
  var _i = this.iface;
  var e;
  switch (esquema) {
    case "catalogo_tc": {
      e = _i.esquemaCatalogoTC(oParam);
      break;
    }
    default: {
      e = _i.__cargaEsquema(esquema, oParam);
    }
  }
  return e;
}

function tallCol_iniciaExportacion(esquema, oParam)
{
  var _i = this.iface;
  switch (esquema) {
    case "catalogo": {
      _i.aFichero_ = false;
      _i.v_ = [];
      _i.cabecera_ = [];
      break;
    }
    default: {
      if (!_i.__iniciaExportacion(esquema, oParam)) {
        return false;
      }
    }
  }
  return true;
}

function tallCol_cabeceraEsquema(e)
{
  var _i = this.iface;

  switch (e.nombre) {
    case "StockTC":
    case "catalogo_tc": {
      break;
    }
    default: {
      if (!_i.__cabeceraEsquema(e)) {
        return false;
      }
    }
  }
  return true;
}

function tallCol_queryStock(oParam)
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
  q.setFrom("articulos a LEFT OUTER JOIN stocks s ON a.referencia = s.referencia AND s.codalmacen = '" + codAlmacen + "' AND s.barcode IS NULL");
  q.setWhere("1 = 1 ORDER BY a.referencia");
  debug(q.sql());
  return q;
}


function tallCol_queryStockTC(oParam)
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
  q.setSelect("aa.referencia, aa.talla, aa.barcode, s.cantidad");
  q.setFrom("atributosarticulos aa LEFT OUTER JOIN stocks s ON aa.barcode = s.barcode AND s.codalmacen = '" + codAlmacen + "'");
  q.setWhere("1 = 1 ORDER BY aa.referencia");
  debug(q.sql());
  return q;
}

function tallCol_esquemaStockTC(oParam)
{
  var _i = this.iface;
  var e = new Object;

  e.nombre = "StockTC";
  e.q = _i.queryStockTC(oParam);

  e.col = new Object;
  e.indexCol = _i.ordenCols("Stock").split(", ");

  var col = e.col;
  col["sku"] = _i.colEsquema();
  col["sku"].titulo = "SKU";
  col["sku"].valor = "aa.barcode";

  col["stock"] = _i.colEsquema();
  col["stock"].titulo = "STOCK";
  col["stock"].tipo = "funcion";
  col["stock"].valor = new Function("q", "v = q.value(\"s.cantidad\"); return ((!v || isNaN(v)) ? 0 : v);");

  return e;
}

//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
