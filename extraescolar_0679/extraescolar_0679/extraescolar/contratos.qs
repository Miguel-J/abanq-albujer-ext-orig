
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends oficial
{
  //  var curAlumnoAct_;
  function extraescolar(context)
  {
    oficial(context);
  }
  function validateForm()
  {
    return this.ctx.extraescolar_validateForm();
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function comprobarBecador()
  {
    return this.ctx.extraescolar_comprobarBecador();
  }
  //  function toolButtomInAlumnAct_clicked() {
  //    return this.ctx.extraescolar_toolButtomInAlumnAct_clicked();
  //  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_validateForm()
{
  if (!this.iface.comprobarBecador()) {
    return false;
  }
}

function extraescolar_init()
{
  this.iface.__init();
  this.child("tdbAlumnosActividadOculto").close();
  connect(this.child("tdbAlumnosActividadOculto").cursor(), "bufferCommited()", this.child("tdbAlumnosActividadOculto"), "refresh()");
}

function extraescolar_comprobarBecador()
{
  var cursor = this.cursor();
  var util = new FLUtil();
  var organismoBec = util.sqlSelect("clientes", "becador", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
  var tipoContrato = cursor.valueBuffer("tipocontrato");
  var tipoContratoBecador = flfacturac.iface.pub_valorDefecto("tipocontratobec");
  if (organismoBec && tipoContrato != tipoContratoBecador) {
    MessageBox.information(util.translate("scripts", "El cliente es un organismo becador y el tipo de contrato no coincide \ncon el tipo establecido en los datos generales."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!organismoBec && tipoContrato == tipoContratoBecador) {
    MessageBox.information(util.translate("scripts", "El cliente no es un organismo becador y el tipo de contrato coincide \ncon el tipo establecido en los datos generales para un organismo becador."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

// function extraescolar_toolButtomInAlumnAct_clicked()
// {
//  if (this.iface.curAlumnoAct_) {
//    delete this.iface.curAlumnoAct_;
//    disconnect(this.iface.curAlumnoAct_, "bufferCommited()", this.child("tdbAlumnosActividad"), "refresh()");
//  }
//  connect(this.iface.curAlumnoAct_, "bufferCommited()", this.child("tdbAlumnosActividad"), "refresh()");
//  this.iface.curAlumnoAct_ = new FLSqlCursor("fo_alumnosactividad");
//  this.iface.curAlumnoAct_.insertRecord();
// }
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
