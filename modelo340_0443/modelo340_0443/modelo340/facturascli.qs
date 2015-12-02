
/** @class_declaration modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
class modelo340 extends oficial
{
  function modelo340(context)
  {
    oficial(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.modelo340_bufferChanged(fN);
  }
  function calcularTotales()
  {
    return this.ctx.modelo340_calcularTotales();
  }
  function actualizarLineasIva(curFactura)
  {
    return this.ctx.modelo340_actualizarLineasIva(curFactura);
  }
  function validateForm()
  {
    return this.ctx.modelo340_validateForm();
  }
  function validaClaveModelo340()
  {
    return this.ctx.modelo340_validaClaveModelo340();
  }
  function init()
  {
    return this.ctx.modelo340_init();
  }
  function habilita340()
  {
    return this.ctx.modelo340_habilita340();
  }
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
function modelo340_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "deabono":
    case "idfacturarect": {
      sys.setObjText(this, "fdbClaveOperacion340", formfacturascli.iface.pub_commonCalculateField("claveoperacion340", cursor));
      _i.__bufferChanged(fN);
      break;
    }
    case "claveoperacion340": {
      sys.setObjText(this, "fdbDesglose340", formfacturascli.iface.pub_commonCalculateField("desglose340", cursor));
      _i.__bufferChanged(fN);
      _i.habilita340();
      break;
    }
    case "manual340": {
      _i.habilita340();
      if (!cursor.valueBuffer("manual340")) {
        sys.setObjText(this, "fdbClaveOperacion340", formfacturascli.iface.pub_commonCalculateField("claveoperacion340", cursor));
      }
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function modelo340_actualizarLineasIva(curFactura)
{
  var _i = this.iface;
  if (!_i.__actualizarLineasIva(curFactura)) {
    return false;
  }
  curFactura.setValueBuffer("claveoperacion340", formfacturascli.iface.pub_commonCalculateField("claveoperacion340", curFactura));
  curFactura.setValueBuffer("desglose340", formfacturascli.iface.pub_commonCalculateField("desglose340", curFactura));
  return true;
}

function modelo340_calcularTotales()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__calcularTotales();
  sys.setObjText(this, "fdbClaveOperacion340", formfacturascli.iface.pub_commonCalculateField("claveoperacion340", cursor));
}

function modelo340_validateForm()
{
  var _i = this.iface;
  if (!_i.__validateForm()) {
    return false;
  }
  if (!_i.validaClaveModelo340()) {
    return false;
  }
  return true;
}

function modelo340_validaClaveModelo340()
{
  var _i = this.iface;
  var cursor = this.cursor();
  /// Arrendamientos
  if (cursor.valueBuffer("claveoperacion340") == "R" && cursor.isNull("codinmueble340")) {
    MessageBox.warning(sys.translate("Si la clave de operación del modelo 340 es R (Arrendamiento) debe establecer el código de inmueble asociado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  /// Varios IVA
  if (cursor.valueBuffer("claveoperacion340") == "C" && cursor.valueBuffer("desglose340") < 2) {
    MessageBox.warning(sys.translate("Si la clave de operación del modelo 340 es C (Varios registros de IVA) el valor de desglose debe ser mayor que 1"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function modelo340_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();
  _i.habilita340();
}

function modelo340_habilita340()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("manual340")) {
    this.child("fdbClaveOperacion340").setDisabled(false);
    this.child("fdbDesglose340").setDisabled(cursor.valueBuffer("claveoperacion340") != "C");
  } else {
    this.child("fdbClaveOperacion340").setDisabled(true);
    this.child("fdbDesglose340").setDisabled(true);
  }
  this.child("fdbCodInmueble340").setDisabled(cursor.valueBuffer("claveoperacion340") != "R");
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
