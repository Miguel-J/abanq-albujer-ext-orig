
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function afterCommit_fo_sesionesalumno(curSA: FLSqlCursor): Boolean {
    return this.ctx.gym_afterCommit_fo_sesionesalumno(curSA);
  }
  function actualizarSesionesBono(curSA: FLSqlCursor): Boolean {
    return this.ctx.gym_actualizarSesionesBono(curSA);
  }
  function datosSesionAlumno(curSesion: FLSqlCursor, curAlumno: FLSqlCursor, masDatos: Array): Boolean {
    return this.ctx.gym_datosSesionAlumno(curSesion, curAlumno, masDatos);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
function gym_afterCommit_fo_sesionesalumno(curSA: FLSqlCursor): Boolean {
  if (!this.iface.actualizarSesionesBono(curSA))
  {
    return false;
  }
  return true;
}

/** \D Actualiza los datos de sesiones consumidas y disponibles del bono asociado a la sesión
@param curSA: Cursor de la sesión por alumno
\end */
function gym_actualizarSesionesBono(curSA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curSA.cursorRelation();
  if (curRel && curRel.table() == "bonosgym")
  {
    return true;
  }
  var codBono: String = curSA.valueBuffer("codbono");
  var curBono: FLSqlCursor = new FLSqlCursor("bonosgym");
  curBono.select("codbono = '" + codBono + "'");
  if (!curBono.first())
  {
    MessageBox.warning(util.translate("scripts", "Error al actualizar los datos del bono %1").arg(codBono), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  curBono.setModeAccess(curBono.Edit);
  curBono.refreshBuffer();
  curBono.setValueBuffer("cansesionescon", formRecordbonosgym.iface.pub_commonCalculateField("cansesionescon", curBono));
  curBono.setValueBuffer("cansesionesdisp", formRecordbonosgym.iface.pub_commonCalculateField("cansesionesdisp", curBono));
  if (!curBono.commitBuffer())
  {
    return false;
  }

  return true;
}

/** \D Establece los datos de una sesión por alumno
@param curSesion: Cursor de la sesión
@param curAlumno: Cursor del alumno
@param masDatos: Array con datos auxiliares
\end */
function gym_datosSesionAlumno(curSesion: FLSqlCursor, curAlumno: FLSqlCursor, masDatos: Array): Boolean {
  if (!this.iface.__datosSesionAlumno(curSesion, curAlumno, masDatos))
  {
    return false;
  }
  this.iface.curSesionesAlumno_.setValueBuffer("codbono", masDatos["codbono"]);

  return true;
}
//// GIMNASIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
