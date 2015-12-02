
/** @class_declaration bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
class bMultiempresa extends oficial
{
  function bMultiempresa(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.bMultiempresa_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.bMultiempresa_bufferChanged(fN);
  }
  function controlConsolidacion()
  {
    return this.ctx.bMultiempresa_controlConsolidacion();
  }
}
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////

function bMultiempresa_init()
{
  this.iface.__init();
  this.iface.controlConsolidacion()
}

function bMultiempresa_bufferChanged(fN)
{
  var util: FLUtil = new FLUtil();

  switch (fN) {

    case "ejercicioanterior":
      this.iface.controlConsolidacion();
      break;

    default:
      return this.iface.__bufferChanged(fN);
  }
}

function bMultiempresa_controlConsolidacion()
{
  if (this.cursor().valueBuffer("ejercicioanterior"))  {
    this.child("tbwEmpresas").setTabEnabled("tbwotras", false);
    this.child("fdbEjercicioAnt").setDisabled(false);
    this.child("fdbFechaDesdeAnt").setDisabled(false);
    this.child("fdbFechaHastaAnt").setDisabled(false);
  } else {
    this.child("tbwEmpresas").setTabEnabled("tbwotras", true);
    this.child("fdbEjercicioAnt").setDisabled(true);
    this.child("fdbFechaDesdeAnt").setDisabled(true);
    this.child("fdbFechaHastaAnt").setDisabled(true);
  }
}

//// FUN_BMULTIEMPRESA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
