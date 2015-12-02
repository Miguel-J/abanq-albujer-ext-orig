
/** @class_declaration clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////
class clientesPot extends oficial
{
  function clientesPot(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.clientesPot_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.clientesPot_bufferChanged(fN);
  }
  function cargarDatosClientePot()
  {
    return this.ctx.clientesPot_cargarDatosClientePot();
  }
  function estadoClientePot(borrarDatos: Boolean)
  {
    return this.ctx.clientesPot_estadoClientePot(borrarDatos);
  }
}
//// CLIENTESPOT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////

function clientesPot_init()
{
  this.iface.__init();

  this.iface.estadoClientePot(false);
}

function clientesPot_bufferChanged(fN: String)
{
  switch (fN) {
    case "clientepot":
      this.iface.estadoClientePot(true);
      break;
    case "codclientepot":
      this.child("fdbCodDir").setValue("");
      this.iface.cargarDatosClientePot();
      break;
    default:
      return this.iface.__bufferChanged(fN);
  }
}

/** \D Carga los datos de nombre, nif y dirección cuando se selecciona un cliente
potencial
*/
function clientesPot_cargarDatosClientePot()
{
  var codigo: String = this.child("fdbCodClientePot").value();

  if (!codigo)
    return;

  var datos: Array = flfactppal.iface.pub_ejecutarQry("clientespot", "nombre,cifnif,direccion,ciudad,provincia,codpostal,codpais", "codigo = '" + codigo + "'");

  if (datos.result > 0) {
    this.child("fdbCodDir").setValue("");
    this.child("fdbNombreCliente").setValue(datos.nombre);
    this.child("fdbCifNif").setValue(datos.cifnif);
    this.child("fdbDireccion").setValue(datos.direccion);
    this.child("fdbCiudad").setValue(datos.ciudad);
    this.child("fdbProvincia").setValue(datos.provincia);
    this.child("fdbCodPostal").setValue(datos.codpostal);
    this.child("fdbCodPais").setValue(datos.codpais);
  }
}

/** \D Habilida o deshabilita los campos de código de cliente real y potencial
en base al valor de --clientepot--
*/
function clientesPot_estadoClientePot(borrarDatos: Boolean)
{
  if (this.cursor().modeAccess() == this.cursor().Browse)
    return;

  if (this.child("fdbClientePot").value()) {
    this.child("fdbCodClientePot").setDisabled(false);
    this.child("fdbCodCliente").setDisabled(true);
    this.child("fdbCodCliente").setValue("");
  } else {
    this.child("fdbCodClientePot").setDisabled(true);
    this.child("fdbCodCliente").setDisabled(false);
    this.child("fdbCodClientePot").setValue("");
  }

  if (borrarDatos) {
    this.child("fdbCifNif").setValue("");
    this.child("fdbNombreCliente").setValue("");
    this.child("fdbDireccion").setValue("");
    this.child("fdbCiudad").setValue("");
    this.child("fdbProvincia").setValue("");
    this.child("fdbCodPostal").setValue("");
    this.child("fdbCodPais").setValue("");
  }
}

//// CLIENTESPOT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

