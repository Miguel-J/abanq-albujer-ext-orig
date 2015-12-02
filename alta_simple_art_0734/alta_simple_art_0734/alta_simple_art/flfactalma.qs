
/** @class_declaration altaSimple */
/////////////////////////////////////////////////////////////////
//// ALTA SIMPLE /////////////////////////////////////////////
class altaSimple extends oficial
{
  var datosAltaSimple;
  var altaSimpleActiva;
  function altaSimple(context)
  {
    oficial(context);
  }
  function inicializarDatosAltaSimple()
  {
    return this.ctx.altaSimple_inicializarDatosAltaSimple();
  }
}
//// ALTA SIMPLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubAltaSimple */
/////////////////////////////////////////////////////////////////
//// PUB ALTA SIMPLE ////////////////////////////////////////
class pubAltaSimple extends ifaceCtx
{
  function pubAltaSimple(context)
  {
    ifaceCtx(context);
  }
  function pub_inicializarDatosAltaSimple()
  {
    return this.inicializarDatosAltaSimple();
  }
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition altaSimple */
/////////////////////////////////////////////////////////////////
//// ALTA SIMPLE /////////////////////////////////////////////
function altaSimple_inicializarDatosAltaSimple()
{
  var _i = this.iface;

  //  _i.altaSimpleActiva = false;
  if (_i.datosAltaSimple)
    delete _i.datosAltaSimple;

  _i.datosAltaSimple = new Array();

  _i.datosAltaSimple["descripcion"] = "";
  _i.datosAltaSimple["pvp"] = 0;
  _i.datosAltaSimple["codimpuesto"] = "";
  _i.datosAltaSimple["codfamilia"] = "";
  _i.datosAltaSimple["secompra"] = true;
  _i.datosAltaSimple["sevende"] = true;
  _i.datosAltaSimple["imagen"] = "";
  _i.datosAltaSimple["stockmax"] = 0;
  _i.datosAltaSimple["stockmin"] = 0;
  _i.datosAltaSimple["controlstock"] = true;
  _i.datosAltaSimple["nostock"] = false;
}
//// ALTA SIMPLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
