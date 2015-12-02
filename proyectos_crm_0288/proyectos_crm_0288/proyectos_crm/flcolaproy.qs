
/** @class_declaration proyectosCRM */
/////////////////////////////////////////////////////////////////
//// proyectosCRM/////////////////////////////////////////////////
class proyectosCRM extends oficial
{
  function proyectosCRM(context)
  {
    oficial(context);
  }
  function actualizarTiempoTotal(tipoObjeto: String, idObjeto: String)
  {
    return this.ctx.proyectosCRM_actualizarTiempoTotal(tipoObjeto, idObjeto);
  }
  function calcularTiempo(tipoObjeto: String, idObjeto: String): Number {
    return this.ctx.proyectosCRM_calcularTiempo(tipoObjeto, idObjeto);
  }
  function afterCommit_cl_subproyectos(curSubProyecto: FLSqlCursor): Boolean {
    return this.ctx.proyectosCRM_afterCommit_cl_subproyectos(curSubProyecto);
  }
}
//// proyectosCRM ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proyectosCRM */
/////////////////////////////////////////////////////////////////
//// proyectosCRM ///////////////////////////////////////////////

function proyectosCRM_afterCommit_cl_subproyectos(curSubProyecto: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var codProyecto: String = util.sqlSelect("cl_subproyectos", "codproyecto", "codsubproyecto = '" + curSubProyecto.valueBuffer("codsubproyecto") + "'");

  if (!this.iface.actualizarTiempoTotal("cl_proyectos", codProyecto))
    return false;

  return true;
}

function proyectosCRM_actualizarTiempoTotal(tipoObjeto: String, idObjeto: String)
{
  var util: FLUtil = new FLUtil();
  var tiempo: Number = this.iface.calcularTiempo(tipoObjeto, idObjeto);
  if (isNaN(tiempo))
    return false;

  switch (tipoObjeto) {
    case "cl_subproyectos": {
      if (formRecordcl_subproyectos.child("fdbCodSubproyecto"))
        formRecordcl_subproyectos.child("fdbTiempoTotal").setValue(tiempo);
      else
        util.sqlUpdate("cl_subproyectos", "tiempototal", tiempo, "codsubproyecto = '" + idObjeto + "'");
      break;
    }
    case "cl_proyectos": {
      if (formRecordcl_proyectos.child("fdbCodProyecto"))
        formRecordcl_proyectos.child("fdbTiempoTotal").setValue(tiempo);
      else
        util.sqlUpdate("cl_proyectos", "tiempototal", tiempo, "codproyecto = '" + idObjeto + "'");
      break;
    }
  }
  return true;
}

function proyectosCRM_calcularTiempo(tipoObjeto: String, idObjeto: String): Number {
  var util: FLUtil = new FLUtil();
  var total: Number;
  switch (tipoObjeto)
  {
    case "cl_subproyectos": {
      total = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");

      if (isNaN(total))
        return false;
      break;
    }
    case "cl_proyectos": {
      var tiempoTareas: Number = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
      if (isNaN(tiempoTareas))
        return false;

      var tiempoSubp: Number = util.sqlSelect("cl_subproyectos", "SUM(tiempototal)", "codproyecto = '" + idObjeto + "'");
      if (isNaN(tiempoSubp))
        return false;

      total = parseFloat(tiempoTareas + tiempoSubp);
      break;
    }
  }
  return total;
}

//// proyectosCRM ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
