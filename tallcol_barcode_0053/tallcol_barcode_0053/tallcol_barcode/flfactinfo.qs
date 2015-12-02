
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////
class barCode extends oficial
{
  var labelTallas_;
  var indiceTallas_;
  var cantidadesTallas_;
  function barCode(context)
  {
    oficial(context);
  }
  function labelTallas(nodo, campo)
  {
    return this.ctx.barCode_labelTallas(nodo, campo);
  }
  function inicializarTallas(nodo, campo)
  {
    return this.ctx.barCode_inicializarTallas(nodo, campo);
  }
  function cantidadTallaColor(nodo, campo)
  {
    return this.ctx.barCode_cantidadTallaColor(nodo, campo);
  }
  function valoresLineaTC(nodo, campo)
  {
    return this.ctx.barCode_valoresLineaTC(nodo, campo);
  }
  function mostrarLabelDto(nodo, campo)
  {
    return this.ctx.barCode_mostrarLabelDto(nodo, campo);
  }
  function formatoTallasColores(idDoc, tipoDoc)
  {
    return this.ctx.barCode_formatoTallasColores(idDoc, tipoDoc);
  }
  function referenciaProveedor(nodo, campo)
  {
    return this.ctx.barCode_referenciaProveedor(nodo, campo);
  }
  function labelNetoSinDto(nodo, campo)
  {
    return this.ctx.barCode_labelNetoSinDto(nodo, campo);
  }
  function labelDto(nodo, campo)
  {
    return this.ctx.barCode_labelDto(nodo, campo);
  }
  function valorNetoSinDto(nodo, campo)
  {
    return this.ctx.barCode_valorNetoSinDto(nodo, campo);
  }
  function valorDto(nodo, campo)
  {
    return this.ctx.barCode_valorDto(nodo, campo);
  }
}
//// BARCODE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarcode */
/////////////////////////////////////////////////////////////////
//// PUB BARCODE /////////////////////////////////////////////
class pubBarcode extends ifaceCtx
{
  function pubBarcode(context)
  {
    ifaceCtx(context);
  }
  function pub_labelTallas(nodo, campo)
  {
    return this.labelTallas(nodo, campo);
  }
  function pub_inicializarTallas(nodo, campo)
  {
    return this.inicializarTallas(nodo, campo);
  }
  function pub_guardaTallaArray(nodo, campo)
  {
    return this.guardaTallaArray(nodo, campo);
  }
  function pub_cantidadTallaColor(nodo, campo)
  {
    return this.cantidadTallaColor(nodo, campo);
  }
  function pub_valoresLineaTC(nodo, campo)
  {
    return this.valoresLineaTC(nodo, campo);
  }
  function pub_mostrarLabelDto(nodo, campo)
  {
    return this.mostrarLabelDto(nodo, campo);
  }
  function pub_formatoTallasColores(idDoc, tipoDoc)
  {
    return this.formatoTallasColores(idDoc, tipoDoc);
  }
  function pub_referenciaProveedor(nodo, campo)
  {
    return this.referenciaProveedor(nodo, campo);
  }
}
//// PUB BARCODE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////
function barCode_labelTallas(nodo, campo)
{
  var _i = this.iface;
  var valores = campo.split("/");
  debug("valor " + valores[1]);
  debug("total tallas " + _i.labelTallas_.length);
  if (_i.labelTallas_.length > valores[1]) {
    debug("return " + _i.labelTallas_[valores[1]]);
    return _i.labelTallas_[valores[1]];
  } else {
    debug("else");
    return "";
  }
}

function barCode_inicializarTallas(nodo, campo)
{
  var _i = this.iface;

  var valores = campo.split("/");
  var tabla = valores[0];
  var clave = valores[1];
  _i.labelTallas_ = [];
  _i.indiceTallas_ = [];
  _i.cantidadesTallas_ = [];

  var idDoc = nodo.attributeValue(tabla + "." + clave);
  if (!idDoc)
    return "";
  var referencia = nodo.attributeValue(tabla + ".referencia");
  var pvp = parseFloat(nodo.attributeValue(tabla + ".pvpunitario"));
  var dto = parseFloat(nodo.attributeValue(tabla + ".dtopor"));

  var qryTallas = new FLSqlQuery();
  with(qryTallas) {
    setTablesList("atributosarticulos,tallas");
    setSelect("tallas.codtalla, tallas.orden");
    setFrom("atributosarticulos INNER JOIN tallas ON atributosarticulos.talla = tallas.codtalla");
    setWhere("atributosarticulos.referencia = '" + referencia +  "' group by tallas.codtalla, tallas.orden order by tallas.orden");
  }
  if (!qryTallas.exec())
    return "";

  var tam = 0;
  while (qryTallas.next()) {
    _i.labelTallas_[tam] = qryTallas.value("tallas.codtalla");
    _i.indiceTallas_[qryTallas.value("tallas.codtalla")] = tam++;
  }

  var qryColores = new FLSqlQuery();
  with(qryColores) {
    setTablesList(tabla);
    setSelect("color,cantidad,talla");
    setFrom(tabla);
    setWhere(clave + " = " + idDoc +  " AND referencia = '" + referencia +  "' AND pvpunitario  = " + pvp + "  AND dtopor = " + dto + " AND barcode <> '' and barcode is not null order by color");
  }
  if (!qryColores.exec())
    return "";

  var totalColor = 0;
  var colorAnt = "";
  while (qryColores.next()) {
    var cant = parseFloat(qryColores.value("cantidad"));

    if (!(qryColores.value("color") in _i.cantidadesTallas_)) {
      if (colorAnt != "") {
        _i.cantidadesTallas_[colorAnt]["total"] = totalColor;
        totalColor = 0;
      }
      _i.cantidadesTallas_[qryColores.value("color")] = [];
      for (var i = 0; i < tam; i++) {
        debug("i " + i);
        _i.cantidadesTallas_[qryColores.value("color")][i] = 0;
      }
    }
    colorAnt = qryColores.value("color");
    totalColor += cant;
    _i.cantidadesTallas_[qryColores.value("color")][_i.indiceTallas_[qryColores.value("talla")]] += cant;
  }

  if (colorAnt != "") {
    _i.cantidadesTallas_[colorAnt]["total"] = totalColor;
  }

  return "";
}

function barCode_cantidadTallaColor(nodo, campo)
{
  var _i = this.iface;
  var valores = campo.split("/");
  var tabla = valores[0];
  var pos = valores[1];
  var color = nodo.attributeValue(tabla + ".color");
  if (!color || color == "")
    return "";

  var cant = 0;
  if (color in _i.cantidadesTallas_) {
    if (pos in _i.cantidadesTallas_[color]) {
      cant = _i.cantidadesTallas_[color][pos];
      if (!cant || cant == 0)
        return  "";
    } else {
      return "";
    }
  } else {
    return "";
  }

  if (!cant || cant == 0)
    return "";

  //  cant = AQUtil.partInteger(cant);
  return cant;
}

function barCode_valoresLineaTC(nodo, campo)
{
  var valores = campo.split("/");
  var tabla = valores[0];
  var clave = valores[1];
  var campo = valores[2];

  var idDoc = nodo.attributeValue(tabla + "." + clave);
  if (!idDoc)
    return "";

  var referencia = nodo.attributeValue(tabla + ".referencia");
  var pvp = nodo.attributeValue(tabla + ".pvpunitario");
  var dto = nodo.attributeValue(tabla + ".dtopor");

  var valor = AQUtil.sqlSelect(tabla, "sum(" + campo + ")", clave + " = " + idDoc + " AND referencia = '" + referencia + "' AND pvpunitario = " + pvp + " AND dtopor = " + dto);

  if (!valor)
    valor = 0;

  if (campo == "pvpsindto-pvptotal")
    campo = "pvptotal";

  valor = AQUtil.roundFieldValue(valor, tabla, campo);
  return valor;
}

function barCode_mostrarLabelDto(nodo, campo)
{
  if (nodo.attributeValue(campo + ".dtopor") && nodo.attributeValue(campo + ".dtopor") != 0)
    return "%";
  else
    return "";
}

function barCode_formatoTallasColores(idDoc, tipoDoc)
{
  if (AQUtil.sqlSelect("facturac_general", "imptallcol", "1=1"))
    return true;

  return false;
}

function barCode_referenciaProveedor(nodo, campo)
{
  var referencia = nodo.attributeValue("articulosprov.refproveedor");

  if (referencia && referencia != "") {
    return referencia;
  } else {
    return nodo.attributeValue(campo + ".referencia");
  }
}

function barCode_labelNetoSinDto(nodo, campo)
{
  if (!flfactppal.iface.pub_extension("dto_especial"))
    return "";

  if (!campo || campo == "")
    return "";

  var idDoc = nodo.attributeValue(campo);
  if (!idDoc)
    return "";

  var datosTabla = campo.split(".");

  var dto = AQUtil.sqlSelect(datosTabla[0], "pordtoesp", datosTabla[1] + " = " + idDoc);
  if (!dto || dto == 0)
    return "";

  return "NETO SIN DTO";
}

function barCode_labelDto(nodo, campo)
{
  if (!flfactppal.iface.pub_extension("dto_especial"))
    return "";

  if (!campo || campo == "")
    return "";

  var idDoc = nodo.attributeValue(campo);
  if (!idDoc)
    return "";

  var datosTabla = campo.split(".");

  var dto = AQUtil.sqlSelect(datosTabla[0], "pordtoesp", datosTabla[1] + " = " + idDoc);
  if (!dto || dto == 0)
    return "";

  return dto + "% DTO";
}

function barCode_valorNetoSinDto(nodo, campo)
{
  if (!flfactppal.iface.pub_extension("dto_especial"))
    return "";

  if (!campo || campo == "")
    return "";

  var idDoc = nodo.attributeValue(campo);
  if (!idDoc)
    return "";

  var datosTabla = campo.split(".");

  var dto = AQUtil.sqlSelect(datosTabla[0], "pordtoesp", datosTabla[1] + " = " + idDoc);
  if (!dto || dto == 0)
    return "";

  var netoSinDtoEsp = AQUtil.sqlSelect(datosTabla[0], "netosindtoesp", datosTabla[1] + " = " + idDoc);

  return netoSinDtoEsp;
}

function barCode_valorDto(nodo, campo)
{
  if (!flfactppal.iface.pub_extension("dto_especial"))
    return "";

  if (!campo || campo == "")
    return "";

  var idDoc = nodo.attributeValue(campo);
  if (!idDoc)
    return "";

  var datosTabla = campo.split(".");

  var dto = AQUtil.sqlSelect(datosTabla[0], "pordtoesp", datosTabla[1] + " = " + idDoc);
  if (!dto || dto == 0)
    return "";

  var dtoEsp = AQUtil.sqlSelect(datosTabla[0], "dtoesp", datosTabla[1] + " = " + idDoc);

  return dtoEsp;
}
//// BARCODE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
