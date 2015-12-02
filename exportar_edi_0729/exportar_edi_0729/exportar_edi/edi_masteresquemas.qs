/***************************************************************************
                            edi_masteresquemas.qs
                             -------------------
    begin                : mar 22 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  var ctx;
  function interna(context)
  {
    this.ctx = context;
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var cur_;
  var mw_;
  var pbExportXml_;
  var pbImportXml_;
  var pbGenEdi_;
  var pbChangeWorkdir_;
  var ledWorkdir_;
  var curSet_;

  function oficial(context)
  {
    interna(context);
  }
  function init()
  {
    this.ctx.oficial_init();
  }

  function updateGuiWorkdir()
  {
    return this.ctx.oficial_updateGuiWorkdir();
  }
  function exportToXml()
  {
    return this.ctx.oficial_exportToXml();
  }
  function importFromXml()
  {
    return this.ctx.oficial_importFromXml();
  }
  function genEdiFile()
  {
    return this.ctx.oficial_genEdiFile();
  }
  function changeWorkdir()
  {
    return this.ctx.oficial_changeWorkdir();
  }

  function objEdiFromRec(curEsquema)
  {
    return this.ctx.oficial_objEdiFromRec(curEsquema);
  }
  function funsEdiFromRec(curEsquema)
  {
    return this.ctx.oficial_funsEdiFromRec(curEsquema);
  }
  function fieldsEdiFromRec(curEsquema)
  {
    return this.ctx.oficial_fieldsEdiFromRec(curEsquema);
  }

  function domDocEdi(objEdi)
  {
    return this.ctx.oficial_domDocEdi(objEdi);
  }
  function domNodeEdiFuns(domDocEdi, funs)
  {
    return this.ctx.oficial_domNodeEdiFuns(domDocEdi, funs);
  }
  function domNodeEdiFields(domDocEdi, fields)
  {
    return this.ctx.oficial_domNodeEdiFields(domDocEdi, fields);
  }

  function genDomDocEdi(objEdi, funs, fields)
  {
    return this.ctx.oficial_genDomDocEdi(objEdi, funs, fields);
  }

  function objEdiFromDom(domDocEdi)
  {
    return this.ctx.oficial_objEdiFromDom(domDocEdi);
  }
  function funsEdiFromDom(domDocEdi)
  {
    return this.ctx.oficial_funsEdiFromDom(domDocEdi);
  }
  function fieldsEdiFromDom(domDocEdi)
  {
    return this.ctx.oficial_fieldsEdiFromDom(domDocEdi);
  }

  function objEdiToRec(curEsquema, objEdi)
  {
    return this.ctx.oficial_objEdiToRec(curEsquema, objEdi);
  }
  function funsEdiToRec(objEdi, funs)
  {
    return this.ctx.oficial_funsEdiToRec(objEdi, funs);
  }
  function fieldsEdiToRec(objEdi, fields)
  {
    return this.ctx.oficial_fieldsEdiToRec(objEdi, fields);
  }

  function formatValueEdi(val, field, objEdi)
  {
    return this.ctx.oficial_formatValueEdi(val, field, objEdi);
  }
  function genEdiText(objEdi, funs, fields)
  {
    return this.ctx.oficial_genEdiText(objEdi, funs, fields);
  }

  function espaciosIzquierda(texto, totalLongitud)
  {
    return this.ctx.oficial_espaciosIzquierda(texto, totalLongitud);
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

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_init()
{
  var _i = this.iface;

  _i.cur_ = this.cursor();
  _i.mw_ = this.mainWidget();
  _i.pbExportXml_ = _i.mw_.child("pbExportXml");
  _i.pbImportXml_ = _i.mw_.child("pbImportXml");
  _i.pbGenEdi_ = _i.mw_.child("pbGenEdi");
  _i.pbChangeWorkdir_ = _i.mw_.child("pbChangeWorkdir");
  _i.ledWorkdir_ = _i.mw_.child("ledWorkdir");
  _i.curSet_ = new AQSqlCursor("edi_settings");

  connect(_i.pbExportXml_, "clicked()", _i, "exportToXml()");
  connect(_i.pbImportXml_, "clicked()", _i, "importFromXml()");
  connect(_i.pbGenEdi_, "clicked()", _i, "genEdiFile()");
  connect(_i.pbChangeWorkdir_, "clicked()", _i, "changeWorkdir()");

  _i.updateGuiWorkdir();
}

function oficial_updateGuiWorkdir()
{
  var _i = this.iface;

  _i.curSet_.select("");
  if (_i.curSet_.size() == 0) {
    try {
      AQSql.insert(_i.curSet_, ["workdir"], [aqApp.applicationDirPath()]);
      _i.curSet_.select("");
    } catch (e) {
      sys.errorMsgBox("Error SQL: " + e);
      return false;
    }
  }
  _i.curSet_.first();
  _i.ledWorkdir_.text = _i.curSet_.valueBuffer("workdir");

  return true;
}

function oficial_exportToXml()
{
  var _i = this.iface;

  if (!_i.cur_.isValid()) {
    sys.errorMsgBox(sys.translate("No hay ningún registro seleccionado"));
    return false;
  }

  var objEdi = _i.objEdiFromRec(_i.cur_);
  var funs = _i.funsEdiFromRec(_i.cur_);
  var fields = _i.fieldsEdiFromRec(_i.cur_);

  var docEdi = _i.genDomDocEdi(objEdi, funs, fields);
  var fileName = _i.curSet_.valueBuffer("workdir") + "/" +
                 objEdi.cod + ".xml";

  var file = new QFile(fileName);
  if (!file.open(File.WriteOnly)) {
    sys.errorMsgBox(file.errorString());
    return false;
  }

  var ts = new QTextStream(file.ioDevice());
  ts.setEncoding(AQS.UnicodeUTF8);
  docEdi.save(ts, 2);
  file.close();

  sys.infoMsgBox(
    sys.translate("Esquema EDI correctamente exportado en:\n") +
    fileName
  );

  return true;
}

function oficial_importFromXml()
{
  var _i = this.iface;

  var fileName = FileDialog.getOpenFileName(
                   "XML Files (*.xml)",
                   sys.translate("Seleccionar Fichero")
                 );
  if (!fileName)
    return true;

  var file = new QFile(fileName);
  if (!file.open(File.ReadOnly)) {
    sys.errorMsgBox(file.errorString());
    return false;
  }

  var ts = new QTextStream(file.ioDevice());
  ts.setEncoding(AQS.UnicodeUTF8);
  var docEdi = new QDomDocument;
  if (!docEdi.setContent(ts.read())) {
    sys.errorMsgBox(sys.translate(
                      "Error XML al intentar cargar la definición del esquema EDI."
                    ));
    return false;
  }
  file.close();

  var objEdi = _i.objEdiFromDom(docEdi);
  var funs = _i.funsEdiFromDom(docEdi);
  var fields = _i.fieldsEdiFromDom(docEdi);

  _i.cur_.transaction(false);
  var res = _i.objEdiToRec(_i.cur_, objEdi) &&
            _i.funsEdiToRec(objEdi, funs) &&
            _i.fieldsEdiToRec(objEdi, fields);
  if (res) {
    _i.cur_.commit();
    if (_i.cur_.valueBuffer("codesquema") == objEdi.cod)
      _i.cur_.editRecord();
  } else
    _i.cur_.rollback();
  return res;
}

function oficial_genEdiFile()
{
  var _i = this.iface;

  if (!_i.cur_.isValid()) {
    sys.errorMsgBox(sys.translate("No hay ningún registro seleccionado"));
    return false;
  }

  var objEdi = _i.objEdiFromRec(_i.cur_);
  var funs = _i.funsEdiFromRec(_i.cur_);
  var fields = _i.fieldsEdiFromRec(_i.cur_);

  var txt = _i.genEdiText(objEdi, funs, fields);
  var fileName = _i.curSet_.valueBuffer("workdir") + "/" +
                 objEdi.cod + ".txt";

  var file = new QFile(fileName);
  if (!file.open(File.WriteOnly)) {
    sys.errorMsgBox(file.errorString());
    return false;
  }

  var ts = new QTextStream(file.ioDevice());
  ts.opIn(txt);
  file.close();

  sys.infoMsgBox(
    sys.translate("Fichero EDI generado en:\n") +
    fileName
  );

  return true;
}

function oficial_changeWorkdir()
{
  var _i = this.iface;

  if (!_i.updateGuiWorkdir())
    return false;

  var wDir = FileDialog.getExistingDirectory(
               Dir.home,
               sys.translate("Seleccionar directorio de trabajo EDI")
             );
  if (!wDir)
    return true;

  wDir = Dir.cleanDirPath(wDir);
  wDir = Dir.convertSeparators(wDir);
  Dir.current = wDir;

  _i.curSet_.setModeAccess(AQSql.Edit);
  if (!_i.curSet_.refreshBuffer())
    return false;
  _i.curSet_.setValueBuffer("workdir", wDir);

  return _i.curSet_.commitBuffer() && _i.updateGuiWorkdir();
}

function oficial_objEdiFromRec(curEsquema)
{
  if (!curEsquema.isValid())
    return undefined;

  var objEdi = {
    separator: curEsquema.valueBuffer("separator"),
    decimal: curEsquema.valueBuffer("decimal"),
    partdecimal: curEsquema.valueBuffer("partdecimal"),
    plus: curEsquema.valueBuffer("plus"),
    select: curEsquema.valueBuffer("sqlselect"),
    from: curEsquema.valueBuffer("sqlfrom"),
    where: curEsquema.valueBuffer("sqlwhere"),
    orderby: curEsquema.valueBuffer("sqlorderby"),
    numfields: curEsquema.valueBuffer("numfields"),
    cod: curEsquema.valueBuffer("codesquema"),
    descripcion: curEsquema.valueBuffer("descripcion")
  }
  return objEdi;
}

function oficial_funsEdiFromRec(curEsquema)
{
  if (!curEsquema.isValid())
    return undefined;

  var curFuns = new AQSqlCursor("edi_funciones");
  if (!curFuns.select("codesquema='" + curEsquema.valueBuffer("codesquema") + "'"))
    return undefined;

  var funs = [];
  while (curFuns.next()) {
    var fun = {
      name: curFuns.valueBuffer("name"),
      brief: curFuns.valueBuffer("brief"),
      script: curFuns.valueBuffer("script")
    }
    funs[fun.name] = fun;
  }
  return funs;
}

function oficial_fieldsEdiFromRec(curEsquema)
{
  if (!curEsquema.isValid())
    return undefined;

  var curFields = new AQSqlCursor("edi_campos");
  if (!curFields.select("codesquema='" + curEsquema.valueBuffer("codesquema") + "' order by pos"))
    return undefined;

  var fields = [];
  while (curFields.next()) {
    var field = {
      pos: curFields.valueBuffer("pos"),
      campo: curFields.valueBuffer("campo"),
      tipo: curFields.valueBuffer("tipo"),
      longi: curFields.valueBuffer("longi"),
      ini: curFields.valueBuffer("ini"),
      fin: curFields.valueBuffer("fin"),
      sitedifact: curFields.valueBuffer("sitedifact"),
      condedifact: curFields.valueBuffer("condedifact"),
      tipovalor: curFields.valueBuffer("tipovalor"),
      valor: curFields.valueBuffer("valor"),
      descripcion: curFields.valueBuffer("descripcion")
    }
    if (field.ini > field.fin)
      debug("ERROR fieldsEdiFromRec: La columna de inicio del campo no debe ser mayor que la columna de fin");
    if (parseInt(field.longi) != (field.fin - field.ini + 1))
      debug("ERROR fieldsEdiFromRec: Longitud del campo incoherente");
    var indentPos = flfactppal.iface.pub_cerosIzquierda(field.pos, 9);
    fields[indentPos] = field;
  }
  return fields;
}

function oficial_domDocEdi(objEdi)
{
  var doc = new QDomDocument;
  var instr = doc.createProcessingInstruction("xml",
                                              "version=\"1.0\" encoding=\"utf-8\"");
  var root = doc.createElement("aqedi");

  var tag = doc.createElement("separator");
  var tagElem = tag.toElement();
  tagElem.setAttribute("char", objEdi.separator);
  root.appendChild(tag);

  tag = doc.createElement("decimal");
  tagElem = tag.toElement();
  tagElem.setAttribute("char", objEdi.decimal);
  root.appendChild(tag);

  tag = doc.createElement("partdecimal");
  tagElem = tag.toElement();
  tagElem.setAttribute("digits", objEdi.partdecimal);
  root.appendChild(tag);

  tag = doc.createElement("plus");
  tagElem = tag.toElement();
  tagElem.setAttribute("char", objEdi.plus);
  root.appendChild(tag);

  tag = doc.createElement("select");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.select);
  root.appendChild(tag);

  tag = doc.createElement("from");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.from);
  root.appendChild(tag);

  tag = doc.createElement("where");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.where);
  root.appendChild(tag);

  tag = doc.createElement("orderby");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.orderby);
  root.appendChild(tag);

  tag = doc.createElement("numfields");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.numfields);
  root.appendChild(tag);

  tag = doc.createElement("cod");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.cod);
  root.appendChild(tag);

  tag = doc.createElement("descripcion");
  tagElem = tag.toElement();
  tagElem.setAttribute("args", objEdi.descripcion);
  root.appendChild(tag);

  doc.appendChild(instr);
  doc.appendChild(root);
  return doc;
}

function oficial_domNodeEdiFuns(domDocEdi, funs)
{
  var tagRet = domDocEdi.createElement("functions");
  for (var key in funs) {
    var tag = domDocEdi.createElement("function");
    var tagElem = tag.toElement();
    var fun = funs[key];
    tagElem.setAttribute("name", fun.name);
    tagElem.setAttribute("brief", fun.brief);
    tagElem.appendChild(domDocEdi.createTextNode(fun.script));
    tagRet.appendChild(tag);
  }
  return tagRet;
}

function oficial_domNodeEdiFields(domDocEdi, fields)
{
  var tagRet = domDocEdi.createElement("fields");
  for (var key in fields) {
    var tag = domDocEdi.createElement("field");
    var tagElem = tag.toElement();
    var field = fields[key];
    tagElem.setAttribute("pos", field.pos);
    tagElem.setAttribute("campo", field.campo);
    tagElem.setAttribute("tipo", field.tipo);
    tagElem.setAttribute("longi", field.longi);
    tagElem.setAttribute("ini", field.ini);
    tagElem.setAttribute("fin", field.fin);
    tagElem.setAttribute("sitedifact", field.sitedifact);
    tagElem.setAttribute("condedifact", field.condedifact);
    tagElem.setAttribute("tipovalor", field.tipovalor);
    tagElem.setAttribute("valor", field.valor);
    tagElem.appendChild(domDocEdi.createTextNode(field.descripcion));
    tagRet.appendChild(tag);
  }
  return tagRet;
}

function oficial_genDomDocEdi(objEdi, funs, fields)
{
  var _i = this.iface;

  var docEdi = _i.domDocEdi(objEdi);
  var root = docEdi.namedItem("aqedi");

  var tagFuns = _i.domNodeEdiFuns(docEdi, funs);
  root.appendChild(tagFuns);

  var tagFields = _i.domNodeEdiFields(docEdi, fields);
  root.appendChild(tagFields);

  return docEdi;
}

function oficial_objEdiFromDom(domDocEdi)
{
  var root = domDocEdi.namedItem("aqedi");

  var objEdi = {
    separator: undefined,
    decimal: undefined,
    partdecimal: undefined,
    plus: undefined,
    select: undefined,
    from: undefined,
    where: undefined,
    orderby: undefined,
    numfields: undefined,
    cod: undefined,
    descripcion: undefined
  }

  var tagElem = root.namedItem("separator").toElement();
  objEdi.separator = tagElem.attribute("char");

  tagElem = root.namedItem("decimal").toElement();
  objEdi.decimal = tagElem.attribute("char");

  tagElem = root.namedItem("partdecimal").toElement();
  objEdi.partdecimal = parseInt(tagElem.attribute("digits"));

  tagElem = root.namedItem("plus").toElement();
  objEdi.plus = tagElem.attribute("char");

  tagElem = root.namedItem("select").toElement();
  objEdi.select = tagElem.attribute("args");

  tagElem = root.namedItem("from").toElement();
  objEdi.from = tagElem.attribute("args");

  tagElem = root.namedItem("where").toElement();
  objEdi.where = tagElem.attribute("args");

  tagElem = root.namedItem("orderby").toElement();
  objEdi.orderby = tagElem.attribute("args");

  tagElem = root.namedItem("numfields").toElement();
  objEdi.numfields = parseInt(tagElem.attribute("args"));

  tagElem = root.namedItem("cod").toElement();
  objEdi.cod = tagElem.attribute("args");

  tagElem = root.namedItem("descripcion").toElement();
  objEdi.descripcion = tagElem.attribute("args");

  return objEdi;
}

function oficial_funsEdiFromDom(domDocEdi)
{
  var root = domDocEdi.namedItem("aqedi");
  var tagFuns = root.namedItem("functions").toElement();
  var list = tagFuns.elementsByTagName("function");
  var funs = [];
  for (var i = 0; i < list.length(); ++i) {
    var it = list.item(i).toElement();
    var fun = {
      name: it.attribute("name"),
      brief: it.attribute("brief"),
      script: it.text()
    }
    funs[fun.name] = fun;
  }
  return funs;
}

function oficial_fieldsEdiFromDom(domDocEdi)
{
  var _i = this;

  var root = domDocEdi.namedItem("aqedi");
  var tagFields = root.namedItem("fields").toElement();
  var list = tagFields.elementsByTagName("field");
  var fields = [];
  for (var i = 0; i < list.length(); ++i) {
    var it = list.item(i).toElement();
    var field = {
      pos: parseInt(it.attribute("pos")),
      campo: it.attribute("campo"),
      tipo: it.attribute("tipo"),
      longi: it.attribute("longi"),
      ini: parseInt(it.attribute("ini")),
      fin: parseInt(it.attribute("fin")),
      sitedifact: it.attribute("sitedifact"),
      condedifact: it.attribute("condedifact"),
      tipovalor: it.attribute("tipovalor"),
      valor: it.attribute("valor"),
      descripcion: it.text()
    }
    if (field.ini > field.fin)
      debug("ERROR fieldsEdiFromDom: La columna de inicio del campo no debe ser mayor que la columna de fin");
    if (parseInt(field.longi) != (field.fin - field.ini + 1))
      debug("ERROR fieldsEdiFromDom: Longitud del campo incoherente");
    fields[field.pos] = field;
  }
  return fields;
}

function oficial_objEdiToRec(curEsquema, objEdi)
{
  curEsquema.setModeAccess(AQSql.Insert);
  if (!curEsquema.refreshBuffer())
    return false;

  curEsquema.setValueBuffer("codesquema", objEdi.cod);
  curEsquema.setValueBuffer("descripcion", objEdi.descripcion);
  curEsquema.setValueBuffer("numfields", objEdi.numfields);
  curEsquema.setValueBuffer("separator", objEdi.separator);
  curEsquema.setValueBuffer("decimal", objEdi.decimal);
  curEsquema.setValueBuffer("partdecimal", objEdi.partdecimal);
  curEsquema.setValueBuffer("plus", objEdi.plus);
  curEsquema.setValueBuffer("sqlselect", objEdi.select);
  curEsquema.setValueBuffer("sqlfrom", objEdi.from);
  curEsquema.setValueBuffer("sqlwhere", objEdi.where);
  curEsquema.setValueBuffer("sqlorderby", objEdi.orderby);

  var msg = curEsquema.msgCheckIntegrity();
  if (!msg.isEmpty()) {
    msg = sys.translate("Error al intentar crear esquema EDI:") + msg;
    //sys.errorPopup(msg);
    debug(msg);
    return false;
  }

  return curEsquema.commitBuffer();
}

function oficial_funsEdiToRec(objEdi, funs)
{
  for (var key in funs) {
    var fun = funs[key];
    try {
      AQSql.insert("edi_funciones",
                   ["name", "brief", "script", "codesquema"],
                   [fun.name, fun.brief, fun.script, objEdi.cod]);
    } catch (e) {
      //sys.errorPopup("" + e);
      debug("" + e);
      return false;
    }
  }
  return true;
}

function oficial_fieldsEdiToRec(objEdi, fields)
{
  for (var key in fields) {
    var field = fields[key];
    try {
      AQSql.insert(
        "edi_campos",
        ["pos", "campo", "tipo", "longi", "ini", "fin", "sitedifact",
         "condedifact", "tipovalor", "valor", "descripcion", "codesquema"],
        [field.pos, field.campo, field.tipo, field.longi, field.ini,
         field.fin, field.sitedifact, field.condedifact, field.tipovalor,
         field.valor, field.descripcion, objEdi.cod]
      );
    } catch (e) {
      //sys.errorPopup("" + e);
      debug("" + e);
      return false;
    }
  }
  return true;
}

function oficial_formatValueEdi(val, field, objEdi)
{
  var _i = this.iface;

  if (val == undefined)
    return field.campo + ":undefined";

  var formatVal = val;

  if (field.tipo == "N") {
    if ((typeof formatVal) != "number" || !formatVal)
      formatVal = 0;
    var longs = field.longi.split(',');
    var len = longs[0];
    if (longs.length == 2) {
      var lenDec = longs[1] ? longs[1] : objEdi.partdecimal;
      formatVal = AQUtil.buildNumber(val, 'f', lenDec);
      formatVal = formatVal.left(formatVal.length - lenDec - 1) +
                  objEdi.decimal +
                  formatVal.right(lenDec);
      var signPlus = objEdi.plus;
      if ((typeof field.condedifact) == "string" &&
          field.condedifact.startsWith("sign")) {
        signPlus = field.condedifact.right(1);
      }
      var sign = formatVal.charAt(0);
      if (sign == '-')
        formatVal = formatVal.mid(1);
      else
        sign = signPlus;
      formatVal = flfactppal.iface.pub_cerosIzquierda(formatVal, len - 1);
      formatVal = sign + formatVal;
    } else if (longs.length == 1) {
      formatVal = Math.round(formatVal).toString();
      if (formatVal.length < len) {
        var sign = formatVal.charAt(0);
        if (sign == '-') {
          formatVal = formatVal.mid(1);
          --len;
        }
        formatVal = flfactppal.iface.pub_cerosIzquierda(formatVal, len);
        if (sign == '-')
          formatVal = sign + formatVal;
      } else
        formatVal = formatVal.left(len);
    }
  } else if (field.tipo == "P") {
    if ((typeof formatVal) != "number" || !formatVal)
      formatVal = 0;
    var longs = field.longi.split(',');
    var len = longs[0];
    if (longs.length == 2) {
      var lenDec = longs[1] ? longs[1] : objEdi.partdecimal;
      formatVal = AQUtil.buildNumber(val, 'f', lenDec);
      formatVal = formatVal.left(formatVal.length - lenDec - 1) +
                  '.' +
                  formatVal.right(lenDec);
      var sign = formatVal.charAt(0);
      if (sign == '-')
        formatVal = formatVal.mid(1);
      else
        sign = ' ';
      formatVal = _i.espaciosIzquierda(formatVal, len - 1);
      formatVal = sign + formatVal;
    } else if (longs.length == 1) {
      formatVal = Math.round(formatVal).toString();
      if (formatVal.length < len) {
        var sign = formatVal.charAt(0);
        if (sign == '-') {
          formatVal = formatVal.mid(1);
          --len;
        }
        formatVal = _i.espaciosIzquierda(formatVal, len);
        if (sign == '-')
          formatVal = sign + formatVal;
      } else
        formatVal = formatVal.left(len);
    }
  } else if (field.tipo == "X") {
    if ((typeof formatVal) != "string" && !formatVal)
      formatVal = "";
    formatVal = flfactppal.iface.pub_espaciosDerecha(formatVal, field.longi);
    formatVal = formatVal.left(field.longi);
  }

  return formatVal;
}

function oficial_genEdiText(objEdi, funs, fields)
{
  var _i = this.iface;

  var cacheFunsEdi = [];
  for (var k in funs)
    cacheFunsEdi[k] = new Function("q", funs[k].script);

  var qry = new AQSqlQuery;
  qry.setSelect(objEdi.select);
  qry.setFrom(objEdi.from);
  qry.setWhere(objEdi.where);
  qry.setOrderBy(objEdi.orderby);
  qry.setForwardOnly(true);

  if (!qry.exec()) {
    var msg = "genEdiText: ";
    msg += sys.translate("Falló la consulta");
    msg += '\n' + qry.sql();
    //sys.errorPopup(msg);
    debug(msg);
    return msg;
  }

  var p = 0;
  var txt = "";

  AQUtil.createProgressDialog(sys.translate("Procesando..."), qry.size());
  AQUtil.setProgress(1);

  while (qry.next()) {
    var lastFin = 0;
    var line = new Array(objEdi.numfields + 1);
    for (var k in fields) {
      var field = fields[k];
      if (field.ini <= lastFin) {
        var msg = sys.translate(
                    "ERROR: La columna de inicio (%1) del campo (%2) es menor que la columna final (%3) del campo anterior"
                  );
        //sys.errorPopup(msg.arg(field.ini).arg(field.campo).arg(lastFin));
        debug(msg.arg(field.ini).arg(field.campo).arg(lastFin));
        return msg.arg(field.ini).arg(field.campo).arg(lastFin) + '\n' + line.join(objEdi.separator) + '\n' + txt;
      }

      var gap = field.ini - lastFin - 1;
      var spaces = "";
      if (gap > 0)
        spaces = flfactppal.iface.pub_espaciosDerecha("", gap);
      lastFin = field.fin;

      var val = "";
      switch (field.tipovalor) {
        case "fijo": {
          val = field.valor;
        }
        break;

        case "campo": {
          val = qry.value(field.valor);
        }
        break;

        case "funcion": {
          try {
            val = (cacheFunsEdi[field.valor](qry));
          } catch (e) {
            //sys.errorPopup("Function " + field.valor + " : " + e);
            debug("Function " + field.valor + " : " + e);
          }
        }
        break;
      }

      line[field.pos] = spaces + _i.formatValueEdi(val, field, objEdi);
    }
    txt += line.join(objEdi.separator) + '\r\n';
    AQUtil.setProgress(++p);
  }

  AQUtil.destroyProgressDialog();

  return txt;
}

function oficial_espaciosIzquierda(texto, totalLongitud)
{
  var ret = texto.toString();
  var numEspacios = totalLongitud - ret.length;
  for (; numEspacios > 0 ; --numEspacios)
    ret = " " + ret;
  return ret;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
