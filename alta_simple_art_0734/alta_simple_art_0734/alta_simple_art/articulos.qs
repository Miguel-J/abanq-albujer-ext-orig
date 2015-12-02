
/** @class_declaration altaSimple */
/////////////////////////////////////////////////////////////////
//// ALTA SIMPLE //////////////////////////////////////////////
class altaSimple extends oficial
{
  var tbnAltaSimple;
  var aCamposAS;
  function altaSimple(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.altaSimple_init();
  }
  function inicializarAltaSimple()
  {
    return this.ctx.altaSimple_inicializarAltaSimple();
  }
  function cambiarTipoAlta()
  {
    return this.ctx.altaSimple_cambiarTipoAlta();
  }
  function guardaCamposAltaSimple()
  {
    return this.ctx.altaSimple_guardaCamposAltaSimple();
  }
  function validateForm()
  {
    return this.ctx.altaSimple_validateForm();
  }
  function informaCamposAltaSimple()
  {
    return this.ctx.altaSimple_informaCamposAltaSimple();
  }
  function camposAS()
  {
    return this.ctx.altaSimple_camposAS();
  }
}
//// ALTA SIMPLE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition altaSimple */
/////////////////////////////////////////////////////////////////
//// ALTA SIMPLE //////////////////////////////////////////////
function altaSimple_init()
{

  var _i = this.iface;
  _i.__init();
  _i.inicializarAltaSimple();
}

function altaSimple_inicializarAltaSimple()
{
  var _i = this.iface;

  _i.tbnAltaSimple = this.child("tbnAltaSimple");

  connect(_i.tbnAltaSimple, "clicked()", _i, "cambiarTipoAlta()");

  if (!flfactalma.iface.altaSimpleActiva)
    return;

  _i.camposAS();
  _i.tbnAltaSimple.setOn(true);
  _i.informaCamposAltaSimple();
}

function altaSimple_informaCamposAltaSimple()
{

  var _f = flfactalma.iface;
  var _i = this.iface;
  var cursor = this.cursor();

  for (var i = 0; i < _i.aCamposAS.length; i++) {
    cursor.setValueBuffer(_i.aCamposAS[i], _f.datosAltaSimple[_i.aCamposAS[i]]);
  }
}

function altaSimple_cambiarTipoAlta()
{
  var _i = this.iface;

  if (_i.tbnAltaSimple.on) {
    flfactalma.iface.altaSimpleActiva = true;
  } else {
    flfactalma.iface.altaSimpleActiva = false;
  }
}

function altaSimple_validateForm()
{
  var _i = this.iface;

  if (!_i.__validateForm())
    return false;


  flfactalma.iface.inicializarDatosAltaSimple();
  if (flfactalma.iface.altaSimpleActiva == true) {
    _i.guardaCamposAltaSimple();
  }

  return true;
}

function altaSimple_guardaCamposAltaSimple()
{
  var _f = flfactalma.iface;
  var _i = this.iface;
  var cursor = this.cursor();

  _i.camposAS();
  for (var i = 0; i < _i.aCamposAS.length; i++) {
    _f.datosAltaSimple[_i.aCamposAS[i]] = cursor.valueBuffer(_i.aCamposAS[i]);
  }
}

function altaSimple_camposAS()
{
  var _i = this.iface;

  _i.aCamposAS = ["descripcion", "pvp", "codimpuesto", "codfamilia", "secompra", "sevende", "imagen", "stockmax", "stockmin", "controlstock", "nostock"];

}
//// ALTA SIMPLE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
