
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function validateForm()
  {
    return this.ctx.multi_validateForm();
  }
  function datosMulti()
  {
    return this.ctx.multi_datosMulti();
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
function multi_validateForm()
{
  var _i = this.iface;

  if (!_i.__validateForm()) {
    return false;
  }

  if (!_i.datosMulti()) {
    return false;
  }
  return true;
}

function multi_datosMulti()
{
  var _i = this.iface;
  var cursor = this.cursor();
  cursor.setValueBuffer("codtienda", cursor.cursorRelation().valueBuffer("codtienda"));
  return true;
}

//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
