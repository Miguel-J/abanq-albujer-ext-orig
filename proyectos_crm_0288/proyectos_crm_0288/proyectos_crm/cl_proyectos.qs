
/** @class_declaration proyectosCRM */
/////////////////////////////////////////////////////////////////
//// proyectosCRM //////////////////////////////////////////////
class proyectosCRM extends oficial
{
  function proyectosCRM(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.proyectosCRM_init();
  }
}
//// proyectosCRM //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition proyectosCRM */
/////////////////////////////////////////////////////////////////
//// proyectosCRM //////////////////////////////////////////////
function proyectosCRM_init()
{
  var cursor: FLSqlCursor = this.cursor();

  // Tareas
  if (sys.isLoadedModule("flcolaproc")) {
    var datosS: Array;
    datosS["tipoObjeto"] = "cl_proyectos";
    datosS["idObjeto"] = cursor.valueBuffer("codproyecto");
    flcolaproc.iface.pub_seguimientoOn(this, datosS);
  } else {
    this.child("twProyectos").setTabEnabled("tareas", false);
  }
}

//// proyectosCRM //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
