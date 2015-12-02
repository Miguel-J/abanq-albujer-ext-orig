
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function iniciarCamposExtra()
  {
    return this.ctx.extraescolar_iniciarCamposExtra();
  }
  function controlCentroUsuario()
  {
    return this.ctx.extraescolar_controlCentroUsuario();
  }
  function centroInhabilitado()
  {
    return this.ctx.extraescolar_centroInhabilitado();
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_init()
{
  var _i = this.iface;

  _i.__init();
  _i.controlCentroUsuario();
  _i.iniciarCamposExtra();
}

function extraescolar_iniciarCamposExtra()
{
  var cursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      if (formRecordcontratos.cursor().isValid()) {
        curRelCon = formRecordcontratos.cursor();
        this.child("fdbCodCentro").setValue(curRelCon.valueBuffer("codcentroesc"));
        this.child("fdbCodCliente").setValue(curRelCon.valueBuffer("codcliente"));
        this.child("fdbCodCentro").setDisabled(true);
        this.child("fdbCodCliente").setDisabled(true);
      }
      break;
    }
  }
}

function extraescolar_controlCentroUsuario()
{
  var _i = this.iface;
  var util = new FLUtil;

  var codCentro = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + sys.nameUser() + "'");
  if (codCentro && codCentro != "") {
    var cursor = this.cursor();
    if (cursor.modeAccess() == cursor.Insert) {
      this.child("fdbCodCentro").setValue(codCentro);
    }
    this.child("fdbCodCentro").setDisabled(_i.centroInhabilitado());
  }
}

function extraescolar_centroInhabilitado()
{
  var _i = this.iface;
  var util = new FLUtil;

  var codCentro = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + sys.nameUser() + "'");
  if (codCentro && codCentro != "") {
    return true;
  } else {
    return _i.__centroInhabilitado();
  }
}

//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
