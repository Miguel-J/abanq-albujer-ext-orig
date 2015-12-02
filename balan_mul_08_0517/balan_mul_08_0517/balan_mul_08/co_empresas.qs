
/** @class_declaration balanMul08 */
/////////////////////////////////////////////////////////////////
//// BALANMUL08 //////////////////////////////////////////////////
class balanMul08 extends oficial
{
  function balanMul08(context)
  {
    oficial(context);
  }
  function actualizarEjercicios(): Boolean { return this.ctx.balanMul08_actualizarEjercicios(); }
}
//// BALANMUL08 //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition balanMul08 */
/////////////////////////////////////////////////////////////////
//// BALANMUL08 /////////////////////////////////////////////////

function balanMul08_actualizarEjercicios()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.valueBuffer("nombrebd")) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar una empresa"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var nombreBD: String = cursor.valueBuffer("nombrebd");
  var conexion: String = nombreBD + "_conn";

  // Conectamos
  if (!flcontinfo.iface.pub_conectar(nombreBD))
    return;

  var curLoc: FLSqlCursor = new FLSqlCursor("co_ejerciciosempresas");
  var curRem: FLSqlCursor = new FLSqlCursor("ejercicios", conexion);

  curRem.select();
  while (curRem.next()) {
    curLoc.select("nombrebd = '" + nombreBD + "' AND codejercicio = '" + curRem.valueBuffer("codejercicio") + "'");
    if (curLoc.first())
      continue;
    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();
    curLoc.setValueBuffer("nombrebd", nombreBD);
    curLoc.setValueBuffer("codejercicio", curRem.valueBuffer("codejercicio"));
    curLoc.setValueBuffer("fechadesde", curRem.valueBuffer("fechainicio"));
    curLoc.setValueBuffer("fechahasta", curRem.valueBuffer("fechafin"));
    curLoc.setValueBuffer("nomejercicio", curRem.valueBuffer("nombre"));
    curLoc.commitBuffer();
  }

  flcontinfo.iface.pub_desconectar(conexion);
  this.child("tdbEjerciciosEmpresa").refresh();
}

//// BALANMUL08 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

