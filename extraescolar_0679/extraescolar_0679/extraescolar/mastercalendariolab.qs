
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends calendariolab
{
  function extraescolar(context)
  {
    calendariolab(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function marcarDesmarcarLectivo()
  {
    return this.ctx.extraescolar_marcarDesmarcarLectivo();
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_init()
{
  this.iface.__init();

  connect(this.child("tbnMarcarDesmarcarLectivo"), "clicked()", this, "iface.marcarDesmarcarLectivo");
}

function extraescolar_marcarDesmarcarLectivo()
{
  var util = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var codigoHorario;
  var codHorarioLab = flfactppal.iface.pub_valorDefecto("codhorariodl");
  var codHorarioDom = flfactppal.iface.pub_valorDefecto("codhorariodom");

  if (cursor.valueBuffer("codhorario") == codHorarioLab) {
    codigoHorario = codHorarioDom;
  } else {
    codigoHorario = codHorarioLab;
  }

  var curCal = new FLSqlCursor("calendariolab");
  curCal.select("fecha = '" + cursor.valueBuffer("fecha") + "'");
  if (!curCal.first()) {
    return false;
  }
  curCal.setModeAccess(curCal.Edit);
  curCal.refreshBuffer();
  curCal.setValueBuffer("codhorario", codigoHorario);
  curCal.setValueBuffer("horaentradamanana", util.sqlSelect("horarioslab", "horaentradamanana", "codhorario = '" + codigoHorario + "'"));
  curCal.setValueBuffer("horasalidamanana", util.sqlSelect("horarioslab", "horasalidamanana", "codhorario = '" + codigoHorario + "'"));
  curCal.setValueBuffer("horaentradatarde", util.sqlSelect("horarioslab", "horaentradatarde", "codhorario = '" + codigoHorario + "'"));
  curCal.setValueBuffer("horasalidatarde", util.sqlSelect("horarioslab", "horasalidatarde", "codhorario = '" + codigoHorario + "'"));
  curCal.setValueBuffer("totalhoras", util.sqlSelect("horarioslab", "totalhoras", "codhorario = '" + codigoHorario + "'"));
  if (!curCal.commitBuffer()) {
    return false;
  }

  this.child("tableDBRecords").refresh();
}

//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
