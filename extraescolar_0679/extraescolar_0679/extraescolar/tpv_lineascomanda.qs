
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends ivaIncluido
{
  function extraescolar(context)
  {
    ivaIncluido(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function validateForm()
  {
    return this.ctx.extraescolar_validateForm();
  }
  function validarReferencia()
  {
    return this.ctx.extraescolar_validarReferencia();
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_init()
{
  this.iface.__init();

  var cursor = this.cursor();
  var codCentro = cursor.cursorRelation().valueBuffer("codcentroesc");
  if (codCentro && codCentro != "") {
    this.child("fdbReferencia").setFilter("referencia IN (SELECT at.referencia FROM articulostarifas at INNER JOIN tarifas f ON at.codtarifa = f.codtarifa WHERE f.codcentroesc = '" + codCentro + "')");
  }
}

function extraescolar_validateForm()
{
  //  if (!this.iface.__validateForm()) {
  //    return false;
  //  }
  if (!this.iface.validarReferencia()) {
    return false;
  }
  return true;
}

function extraescolar_validarReferencia()
{
  var util = new FLUtil;
  var cursor = this.cursor();

  var codTarifa = cursor.cursorRelation().valueBuffer("codtarifa");
  if (codTarifa && codTarifa != "") {
    var referencia = cursor.valueBuffer("referencia");
    if (!util.sqlSelect("articulostarifas", "referencia", "codtarifa = '" + codTarifa + "' AND referencia = '" + referencia + "'")) {
      MessageBox.warning(util.translate("scripts", "La referencia indicada no está asociada a la tarifa %1").arg(codTarifa), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
