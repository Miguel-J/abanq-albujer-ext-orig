
/** @class_declaration extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extra extends ivaIncluido
{
  function extra(context)
  {
    ivaIncluido(context);
  }
  var codCentroEscUsuario_;
  var bloqueoCa_;
  function init()
  {
    return this.ctx.extra_init();
  }
  function validateForm()
  {
    return this.ctx.extra_validateForm();
  }
  function validarClienteAlumnoCentro()
  {
    return this.ctx.extra_validarClienteAlumnoCentro();
  }
  function validarTarifa()
  {
    return this.ctx.extra_validarTarifa();
  }
  function cursorAPosicionInicial()
  {
    return this.ctx.extra_cursorAPosicionInicial();
  }
  function bufferChanged(fN)
  {
    return this.ctx.extra_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.extra_calculateField(fN);
  }
  function filtrosExtra()
  {
    return this.ctx.extra_filtrosExtra();
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extra_validateForm()
{
  if (!this.iface.__validateForm()) {
    return false;
  }
  if (!this.iface.validarClienteAlumnoCentro()) {
    return false;
  }
  if (!this.iface.validarTarifa()) {
    return false;
  }
  return true;
}

function extra_init()
{
  var _i = this.iface;
  _i.__init();

  var util = new FLUtil;
  var cursor = this.cursor();
  var idUsuario = sys.nameUser();
  _i.codCentroEscUsuario_ = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + idUsuario + "'");
  _i.bloqueoCa_ = false;

  this.child("fdbCodTpvPuntoventa").setDisabled(true);

  if (_i.codCentroEscUsuario_) {
    this.child("fdbCodCentroEsc").setDisabled(true);
  }
  this.child("lblNombreAlumno").text = _i.calculateField("nombrealumno");
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbCodCentroEsc").setValue(_i.calculateField("codcentroesc"));

      var idUsuario = sys.nameUser();
      if (idUsuario && idUsuario != "") {

        var puntoVenta = this.child("fdbCodTpvPuntoventa").value();
        if (!util.sqlSelect("usuariospuntoventa", "id", "idusuario = '" + idUsuario + "' AND codtpv_puntoventa = '" + puntoVenta + "'")) {
          MessageBox.warning(util.translate("scripts", "No es posible crear la venta. El usuario %1 no tiene acceso al punto de venta %2.").arg(idUsuario).arg(puntoVenta), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
          this.close();
        }
      }
      break;
    }
  }
}

function extra_filtrosExtra()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codCentroEsc = cursor.valueBuffer("codcentroesc");
  codCentroEsc = codCentroEsc == "" ? false : codCentroEsc;
  var fEsc = codCentroEsc ? "codcentroesc = '" + codCentroEsc + "'" : "";
  var f = codCentroEsc ? "codcentro = '" + codCentroEsc + "'" : "";
  this.child("fdbCodCliente").setFilter(fEsc);
  this.child("fdbCodCliente2").setFilter(fEsc);
  this.child("fdbCodAlumno").setFilter(f);
  this.child("fdbTarifa").setFilter(fEsc);
  if (codCentroEsc) {
    this.child("fdbReferencia").setFilter("referencia IN (SELECT at.referencia FROM articulostarifas at INNER JOIN tarifas f ON at.codtarifa = f.codtarifa WHERE f.codcentroesc = '" + codCentroEsc  + "')");
  } else {
    this.child("fdbReferencia").setFilter("");
  }
}

function extra_validarClienteAlumnoCentro()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var codAlumno = cursor.valueBuffer("codalumno");
  var codCliente = cursor.valueBuffer("codcliente");
  if (codAlumno && codAlumno != "") {
    if (!util.sqlSelect("fo_alumnos", "codalumno", "codalumno = '" + codAlumno + "' AND codcliente = '" + codCliente + "'")) {
      MessageBox.warning(util.translate("scripts", "El alumno %1 no está asociado al cliente %2").arg(codAlumno).arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  var codCentroCli = util.sqlSelect("clientes", "codcentroesc", "codcliente = '" + codCliente + "'");
  var codCentroEsc = cursor.valueBuffer("codcentroesc");
  codCentroEsc = codCentroEsc == "" ? false : codCentroEsc;
  if (codCentroEsc && codCentroCli != codCentroEsc) {
    MessageBox.warning(util.translate("scripts", "El cliente indicado no pertenece al centro %1").arg(codCentroEsc), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function extra_cursorAPosicionInicial()
{
  this.child("fdbCodCliente2").setFocus();
}

function extra_bufferChanged(fN)
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var codCentroEsc = cursor.valueBuffer("codcentroesc");
  codCentroEsc = codCentroEsc == "" ? false : codCentroEsc;

  switch (fN) {
    case "codalumno": {
      var codAlumno = cursor.valueBuffer("codalumno");
      var masWhere = codCentroEsc ? " AND codcentro = '" + codCentroEsc + "'" : "";
      if (!_i.bloqueoCa_) {
        if (codAlumno && util.sqlSelect("fo_alumnos", "codalumno", "codalumno = '" + codAlumno + "'" + masWhere)) {
          _i.bloqueoCa_ = true;
          this.child("fdbCodCliente2").setValue(_i.calculateField("codcliente"));
          _i.bloqueoCa_ = false;

        }
      }
      this.child("lblNombreAlumno").text = _i.calculateField("nombrealumno");
      break;
    }
    case "codcliente": {
      if (!_i.bloqueoCa_) {
        _i.bloqueoCa_ = true;
        this.child("fdbCodAlumno").setValue(_i.calculateField("codalumno"));
        _i.bloqueoCa_ = false;
      }
      if (!codCentroEsc) {
        this.child("fdbCodCentroEsc").setValue(_i.calculateField("codcentroesc"));
      }
      this.child("fdbNombreCliente2").setValue(_i.calculateField("nombrecliente"));
      break;
    }
    case "codcentroesc": {
      this.child("fdbTarifa").setValue(_i.calculateField("codtarifa"));
      _i.filtrosExtra();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function extra_calculateField(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var codCentroEsc = cursor.valueBuffer("codcentroesc");
  codCentroEsc = codCentroEsc == "" ? false : codCentroEsc;
  var valor;
  switch (fN) {
    case "codcliente": {
      valor = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + cursor.valueBuffer("codalumno") + "'");
      break;
    }
    case "nombrecliente": {
      var masWhere = codCentroEsc ? " AND codcentroesc = '" + codCentroEsc + "'" : "";
      valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codcliente") + "'" + masWhere);
      valor = !valor ? "" : valor;
      break;
    }
    case "codalumno": {
      var masWhere = codCentroEsc ? " AND codcentro = '" + codCentroEsc + "'" : "";
      var qryAlumno = new FLSqlQuery();
      qryAlumno.setTablesList("fo_alumnos");
      qryAlumno.setSelect("codalumno");
      qryAlumno.setFrom("fo_alumnos");
      qryAlumno.setWhere("codcliente = '" + cursor.valueBuffer("codcliente") + "'" + masWhere)
      qryAlumno.setForwardOnly(true);
      if (!qryAlumno.exec()) {
        return false;
      }
      if (qryAlumno.size() != 1) {
        return "";
      }
      qryAlumno.first();
      valor = qryAlumno.value("codalumno");
      break;
    }
    case "nombrealumno": {
      var masWhere = codCentroEsc ? " AND codcentro = '" + codCentroEsc + "'" : "";
      valor = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + cursor.valueBuffer("codalumno") + "'" + masWhere);
      valor = !valor ? "" : valor;
      break;
    }
    case "codtarifa": {
      valor = util.sqlSelect("fo_centros", "codtarifatpv", "codcentro = '" + cursor.valueBuffer("codcentro") + "'");
      valor = !valor ? "" : valor;
      break;
    }
    case "codcentroesc": {
      if (this.iface.codCentroEscUsuario_) {
        valor = this.iface.codCentroEscUsuario_;
      } else {
        valor = util.sqlSelect("clientes", "codcentroesc", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      }
      valor = !valor ? "" : valor;
      break;
    }
    case "desarticulo":
    case "pvparticulo":
    case "ivaarticulo": {
      var referencia = cursor.valueBuffer("referencia");
      var codTarifa = cursor.valueBuffer("codtarifa");
      if (util.sqlSelect("articulostarifas", "referencia", "codtarifa = '" + codTarifa + "' AND referencia = '" + referencia + "'")) {
        valor = this.iface.__calculateField(fN);
      } else {
        valor = "";
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}


function extra_validarTarifa()
{
  var util = new FLUtil;
  var cursor = this.cursor();

  var codTarifa = cursor.valueBuffer("codtarifa");
  var codCentro = cursor.valueBuffer("codcentroesc");
  if (!util.sqlSelect("tarifas", "codtarifa", "codtarifa = '" + codTarifa + "' AND codcentroesc = '" + codCentro + "'")) {
    MessageBox.warning(util.translate("scripts", "La tarifa %1 no está asociado al centro %2").arg(codTarifa).arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
