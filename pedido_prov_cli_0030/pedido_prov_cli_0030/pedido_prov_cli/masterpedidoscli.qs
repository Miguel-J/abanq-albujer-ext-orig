
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends oficial
{
  function pedProvCli(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.pedProvCli_init();
  }
  function ponAnchoColumnas()
  {
    return this.ctx.pedProvCli_ponAnchoColumnas();
  }
  function anchoColumnas()
  {
    return this.ctx.pedProvCli_anchoColumnas();
  }
  function colorEstado(fN, fV, cursor, fT, sel)
  {
    return this.ctx.pedProvCli_colorEstado(fN, fV, cursor, fT, sel);
  }
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////

function pedProvCli_init()
{
  var _i = this.iface;
  _i.__init();
  _i.ponAnchoColumnas();

}

function pedProvCli_ponAnchoColumnas()
{
  var _i = this.iface;
  var t = this.child("tableDBRecords");
  var aC = _i.anchoColumnas()
  for (var i = 0; i < aC.length; i++) {
    t.setColumnWidth(aC[i][0], aC[i][1]);
  }
}

function pedProvCli_anchoColumnas()
{
  var aColumnas = [["pedido", 55], ["recibido", 55], ["editable", 55], ["servido", 55]];

  if (flfactppal.iface.pub_extension("marca_impresion")) {
    aColumnas.push(["impreso", 55]);
  }
  return aColumnas;
}

function pedProvCli_colorEstado(fN, fV, cursor, fT, sel)
{
  var _i = this.iface;
  if (fN != "pedido" && fN != "recibido" && fN != "servido") {
    return;
  }
  var color = "";
  switch (fV) {
    case "Sí": {
      color = flfactppal.iface.pub_dameColor("fondo_verde");
      break;
    }
    case "Parcial": {
      color = flfactppal.iface.pub_dameColor("fondo_amarillo");
      break;
    }
    case "No": {
      color = flfactppal.iface.pub_dameColor("fondo_rojo");
      break;
    }
    default: {
      color = flfactppal.iface.pub_dameColor("fondo_blanco");
    }
  }
  if (color != "") {
    var a = [color, "#000000", "SolidPattern", "SolidPattern"];
    return a;
  }
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
