
/** @class_declaration maquinas */
/////////////////////////////////////////////////////////////////
//// MAQUINAS ///////////////////////////////////////////////////
class maquinas extends oficial
{
  function maquinas(context)
  {
    oficial(context);
  }
  function globalInit()
  {
    return this.ctx.maquinas_globalInit();
  }
  function avisaRevisionesPtes(): Boolean {
    return this.ctx.maquinas_avisaRevisionesPtes();
  }
  function revisionesPendientes(): String {
    return this.ctx.maquinas_revisionesPendientes();
  }
}
//// MAQUINAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition maquinas */
/////////////////////////////////////////////////////////////////
//// MAQUINAS ///////////////////////////////////////////////////
function maquinas_globalInit()
{
  debug("maquinas_globalInit");
  this.iface.__globalInit();

  this.iface.avisaRevisionesPtes();
}

function maquinas_avisaRevisionesPtes(): Boolean {
  var util: FLUtil = new FLUtil;
  var idUsuario: String = sys.nameUser();
  if (!util.sqlSelect("usuarios", "avisorevisiones", "idusuario = '" + idUsuario + "'"))
  {
    return true;
  }

  var revisiones: String = this.iface.revisionesPendientes();
  if (revisiones == "")
  {
    return true;
  }
  if (!revisiones)
  {
    return false;
  }
  var usuario: String = sys.nameUser();
  var mensaje: String = util.translate("scripts", "Hola %1.\nLas siguientes máquinas están pendientes de revisión:").arg(usuario) + revisiones;
  MessageBox.information(mensaje, MessageBox.Ok, MessageBox.NoButton);

  return true;
}

function maquinas_revisionesPendientes(): String {
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date;

  var qryRevisiones: FLSqlQuery = new FLSqlQuery;
  qryRevisiones.setTablesList("cl_maquinas,cl_tiposrevisionmaquina");
  qryRevisiones.setSelect("m.codmaquina, m.descripcion, r.codtipo, tr.descripcion, r.fechaproxima, tr.diasinteraviso");
  qryRevisiones.setFrom("cl_maquinas m INNER JOIN cl_tiposrevisionmaquina r ON m.codmaquina = r.codmaquina INNER JOIN cl_tiposaveriasrevision tr ON r.codtipo = tr.codtipo");
  qryRevisiones.setWhere("m.estado = 'En funcionamiento' AND CURRENT_DATE + tr.diasinteraviso::integer >= r.fechaproxima ORDER BY r.fechaproxima, m.codmaquina, r.codtipo");
  qryRevisiones.setForwardOnly(true);
  debug(qryRevisiones.sql());
  if (!qryRevisiones.exec())
  {
    return false;
  }
  var listaRevisiones: String = "";
  //  var codContrato:String;
  //  var hoy:Date = new Date;
  //  var fechaHoy:String = hoy.toString().left(10);
  var fechaRev: String;
  while (qryRevisiones.next())
  {
    fechaRev = util.dateAMDtoDMA(qryRevisiones.value("r.fechaproxima"));
    //    codContrato = qryContratos.value("codigo");
    //    if (util.sqlSelect("periodoscontratos", "id", "codcontrato = '" + codContrato + "' AND fechafin > '" + fechaHoy + "' AND facturado = true")) {
    //      continue;
    //    }
    listaRevisiones += "\n";
    listaRevisiones += util.translate("scripts", "Fecha: %1. Máquina %2 - %3. Revisión %4 - %5.").arg(fechaRev).arg(qryRevisiones.value("m.codmaquina")).arg(qryRevisiones.value("m.descripcion")).arg(qryRevisiones.value("r.codtipo")).arg(qryRevisiones.value("tr.descripcion"));
  }
  return listaRevisiones;
}
//// MAQUINAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
