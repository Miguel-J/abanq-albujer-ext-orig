
/** @class_declaration tablaEditable */
/////////////////////////////////////////////////////////////////
//// TABLA EDITABLE /////////////////////////////////////////////
class tablaEditable extends oficial
{
  var tablasEditables_;
  function tablaEditable(context)
  {
    oficial(context);
  }
  function cargaTablaEditable(parent, name, oParam)
  {
    return this.ctx.tablaEditable_cargaTablaEditable(parent, name, oParam);
  }
  function cargaDatosTE(oParam)
  {
    return this.ctx.tablaEditable_cargaDatosTE(oParam);
  }
  function tabla_valueChanged(f, c, t)
  {
    return this.ctx.tablaEditable_tabla_valueChanged(f, c, t);
  }
  function tblDirecciones_valueChanged(f, c)
  {
    return this.ctx.tablaEditable_tblDirecciones_valueChanged(f, c);
  }
  function dameColTE()
  {
    return this.ctx.tablaEditable_dameColTE();
  }
}
//// TABLA EDITABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubTablaEditable */
/////////////////////////////////////////////////////////////////
//// PUB TABLA EDITABLE /////////////////////////////////////////
class pubTablaEditable extends ifaceCtx
{
  function pubTablaEditable(context)
  {
    ifaceCtx(context);
  }
  function pub_cargaTablaEditable(parent, name, oParam)
  {
    return this.cargaTablaEditable(parent, name, oParam);
  }
  function pub_dameColTE()
  {
    return this.dameColTE();
  }
}
//// PUB TABLA EDITABLE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tablaEditable */
/////////////////////////////////////////////////////////////////
//// TABLA EDITABLE /////////////////////////////////////////////
function tablaEditable_cargaTablaEditable(parent, name, oParam)
{

  //  var _i = this.iface;

  //  var con = oParam.container;

  var t = new AQSTable(parent, name, oParam);
  return t;

  var nombreT = oParam.controlTabla;

  if (!_i.tablasEditables_) {
    _i.tablasEditables_ = new Object;
  }
  if (!(nombreT in _i.tablasEditables_)) {
    _i.tablasEditables_[nombreT] = new Object;
  }
  _i.tablasEditables_[nombreT] = oParam;

  _i.tablasEditables_[nombreT]["cursor"] = new FLSqlCursor(oParam.tabla);

  _i.tablasEditables_[nombreT]["fltable"] = con.child(nombreT);
  var t = _i.tablasEditables_[nombreT]["fltable"];
  if (!t) {
    return;
  }
  var campos = oParam.campos;
  t.setNumCols(campos.length);
  var cabecera = "";
  for (var c = 0; c < campos.length; c++) {
    cabecera += AQUtil.fieldNameToAlias(campos[c], oParam.tabla) + "*";
  }
  t.setColumnLabels("*", cabecera);

  connect(t, "valueChanged(int, int)", _i, nombreT + "_valueChanged");
  _i.cargaDatosTE(nombreT);
}

function tablaEditable_tblDirecciones_valueChanged(f, c)
{
  var _i = this.iface;
  /// XXXXXXXXXXXXXXXXXXXXXXXXXXX
  _i.tabla_valueChanged(f, c, "tblDirecciones");
  //  debug("sender " + sender);
}

function tablaEditable_tabla_valueChanged(f, c)
{
  //  debug("sender " + sender);
}

function tablaEditable_cargaDatosTE(nombreT)
{
  var _i = this.iface;
  var oParam = _i.tablasEditables_[nombreT];
  var t = oParam["fltable"];
  if (!t) {
    return;
  }
  var cursor = oParam.container.cursor();
  var codClave = cursor.valueBuffer(oParam.fF);

  var q = new AQSqlQuery;
  q.setSelect(oParam.campos.join(","));
  q.setFrom(oParam.tabla);
  q.setWhere(oParam.fR + " = '" + codClave + "'");
  if (!q.exec()) {
    return false;
  }
  var campos = oParam.campos;
  var f = 0;
  while (q.next()) {
    t.insertRows(f);
    for (var c = 0; c < campos.length; c++) {
      t.setText(f, c, q.value(c));
    }
    f++;
  }
  for (var c = 0; c < campos.length; c++) {
    t.adjustColumn(c);
  }
}

function tablaEditable_dameColTE()
{
  var c = new Object;
  c["fN"] = undefined;
  c["editable"] = true;
  c["visible"] = true;
  return c;
}


class AQSTable
{
  var t_;
  var p_, c_, f_;
  var cursorAbierto_, fBufferChanged_, fBufferCommited_, fValidateCursor_;
  var mtd_;
  const tSTRING_ = 3, tDECIMAL_ = 19;

  function AQSTable(parent, name, oParam)
  {
    p_ = oParam;
    t_ = new QTable(parent, name);
    c_ = new FLSqlCursor(p_.tabla);

    fBufferChanged_ = oParam.fBufferChanged ? new Function("fN", "cursor", "return " + oParam.fBufferChanged + "(fN, cursor)") : undefined;
    fBufferCommited_ = oParam.fBufferCommited ? new Function("return " + oParam.fBufferCommited + "()") : undefined;
    fValidateCursor_ = oParam.fValidateCursor ? new Function("cursor", "return " + oParam.fValidateCursor + "(cursor)") : undefined;

    var manager = aqApp.db().manager();
    mtd_ = manager.metadata(p_.tabla)

           cursorAbierto_ = false;

    var vLay = new QVBoxLayout(parent);
    vLay.addWidget(t_);

    iniciaTabla();
    cargaTabla();
  }

  function iniciaTabla(f)
  {

    var cols = p_.cols;
    t_.setNumCols(cols.length);
    var cabecera = [];

    f_ = new Object;
    for (var c = 0; c < cols.length; c++) {
      cabecera.push(AQUtil.fieldNameToAlias(cols[c]["fN"], p_.tabla));
      f_[cols[c]["fN"]] = c;
      if (!cols[c].visible) {
        t_.hideColumn(c);
      }
      if (!cols[c].editable) {
        t_.setColumnReadOnly(c, true);
      }

    }
    t_.setColumnLabels(cabecera);

    connect(t_, "valueChanged(int, int)", this, "valueChanged");
    connect(c_, "bufferChanged(QString)", this, "bufferChanged");
    connect(c_, "bufferCommited()", this, "bufferCommited");
  }

  function posicionaCursorFilaActual()
  {
    var f = t_.currentRow();
    if (f < 0) {
      return false;
    }
    var id = t_.text(f, 0);
    c_.select(c_.primaryKey() + " = '" + id + "'");
    if (!c_.first()) {
      return false;
    }
    return true;
  }

  function editRecord()
  {
    if (!posicionaCursorFilaActual()) {
      return;
    }
    c_.editRecord();
  }

  function deleteRecord()
  {
    if (!posicionaCursorFilaActual()) {
      return false;
    }
    var res = MessageBox.warning(sys.translate("El registro seleccionado se eliminará.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Yes) {
      return false;
    }
    c_.setModeAccess(c_.Del);
    c_.refreshBuffer();
    if (!c_.commitBuffer()) {
      return false;
    }
    var f = t_.currentRow();
    t_.removeRow(f);
  }

  function browseRecord()
  {
    if (!posicionaCursorFilaActual()) {
      return;
    }
    c_.browseRecord();
  }

  function refrescar()
  {
    cargaTabla();
  }

  function cargaTabla()
  {
    t_.setNumRows(0);
    var codClave = p_.cR.valueBuffer(p_.fF);

    var miSelect = "";
    for (var c = 0; c < p_.cols.length; c++) {
      miSelect += miSelect != "" ? ", " : "";
      miSelect += p_.cols[c]["fN"];
    }

    var q = new AQSqlQuery;
    q.setSelect(miSelect);
    q.setFrom(p_.tabla);
    q.setWhere(p_.fR + " = '" + codClave + "'");
    if (!q.exec()) {
      return false;
    }
    var cols = p_.cols;
    var f = 0, v;
    while (q.next()) {
      t_.insertRows(f);
      for (var c = 0; c < cols.length; c++) {
        v = formateaValor(q.value(c), p_.tabla, cols[c]["fN"]);
        t_.setText(f, c, v);
      }
      f++;
    }
    for (var c = 0; c < cols.length; c++) {
      t_.adjustColumn(c);
    }
  }

  function bufferChanged(fN)
  {
    if (!fBufferChanged_) {
      return;
    }
    if (!fBufferChanged_(fN, c_)) {
      MessageBox.warning(sys.translate("Error al procesar el cambio en el campo %1").arg(fN), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }

  function bufferCommited()
  {
    var f = t_.currentRow();
    if (f < 0) {
      return;
    }
    refrescaFila(f);
    if (!fBufferCommited_) {
      return;
    }
    fBufferCommited_();
  }

  function validateCursor()
  {
    if (!fValidateCursor_) {
      return true;
    }
    return fValidateCursor_(c_);
  }

  function validaValor(v, t, f)
  {
    var mtdCampo = mtd_.field(f);
    var tipo = mtdCampo.type();
    debug("Campo " + f + " Tipo " + tipo);

    switch (tipo) {
      case tSTRING_: {
        if (v && v != "") {
          if (v.length > mtdCampo.length()) {
            MessageBox.warning(sys.translate("Valor demasiado largo (límite de %1)").arg(mtdCampo.length()), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
            return false;
          }
        }
        break;
      }
      case tDECIMAL_: {
        if (isNaN(v)) {
          if (v && v != "") {
            v.replace(",", ".");
            if (isNaN(v)) {
              MessageBox.warning(sys.translate("Valor no numérico"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
              return false;
            }
          }
        }
        break;
      }
    }
    return true;
  }

  function formateaValor(v, t, f)
  {
    var mtdCampo = mtd_.field(f);
    var tipo = mtdCampo.type();

    var vF;
    switch (tipo) {
      case tDECIMAL_: {
        vF = AQUtil.roundFieldValue(v, t, f);
        break;
      }
      default: {
        vF = v;
      }
    }
    return vF;
  }

  function valueChanged(f, c)
  {
    var fN = p_.cols[c]["fN"];
    var valor = t_.text(f, c);
    if (!validaValor(valor, p_.tabla, fN)) {
      t_.setText(f, c, c_.valueBuffer(fN));
      return;
    }
    valor = formateaValor(valor, p_.tabla, fN);
    if (!cursorAbierto_) {
      if (!abreCursor(f, c)) {
        return false;
      }
    }
    cursorAbierto_ = false;
    c_.setValueBuffer(fN, valor);

    if (!validateCursor()) {
      recargaFila(f);
      return false;
    }
    if (!c_.commitBuffer()) {
      return false;
    }
    //    bufferCommited();
    //    refrescaFila(f);
  }

  function recargaFila(f)
  {
    abreCursor(f);
    refrescaFila(f);
  }

  function refrescaFila(f)
  {
    /// Supone el cursor situado correctamente
    var cols = p_.cols;
    var v;
    for (var c = 0; c < cols.length; c++) {
      v = formateaValor(c_.valueBuffer(cols[c]["fN"]), p_.tabla, cols[c]["fN"]);
      t_.setText(f, c, v);
    }
  }

  function abreCursor(f, c)
  {
    var id = t_.text(f, 0);
    c_.select(c_.primaryKey() + " = '" + id + "'");
    if (!c_.first()) {
      return false;
    }
    c_.setModeAccess(c_.Edit);
    c_.refreshBuffer();
    cursorAbierto_ = true;
    return true;
  }

}

//// TABLA EDITABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
