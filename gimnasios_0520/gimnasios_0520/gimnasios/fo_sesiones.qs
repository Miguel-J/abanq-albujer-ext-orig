
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function datosAccesoSesionAlumno(curSesion: FLSqlCursor, curAlumno: FLSqlCursor): Array {
    return this.ctx.gym_datosAccesoSesionAlumno(curSesion, curAlumno);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
/** \D Comprueba si el alumno tiene acceso a la sesión y genera un array con otros datos necesarios para el alta de la sesión por alumno.
@param curSesion: Cursor de la sesión
@param curAlumno: Cursor del alumno
\end */
function gym_datosAccesoSesionAlumno(curSesion: FLSqlCursor, curAlumno: FLSqlCursor): Array {
  var util: FLUtil = new FLUtil;

  var datos: Array = [];
  var fecha: String = curSesion.valueBuffer("fecha");
  var codCliente: String = curAlumno.valueBuffer("codcliente");
  var codAlumno: String = curAlumno.valueBuffer("codalumno");
  var nombre: String = curAlumno.valueBuffer("nombre");

  var qryBonos: FLSqlQuery = new FLSqlQuery;
  qryBonos.setTablesList("bonosgym,clientes");
  qryBonos.setSelect("b.codbono, b.cansesionesdisp, b.referencia, b.fechacaducidad, b.cansesiones");
  qryBonos.setFrom("bonosgym b INNER JOIN clientes c ON b.codcliente = c.codcliente");
  qryBonos.setWhere("c.codcliente = '" + codCliente + "' AND (b.fechainicio <= '" + fecha + "' AND (b.fechacaducidad IS NULL OR b.fechacaducidad >= '" + fecha + "')) AND (b.cansesionesdisp > 0 OR (b.cansesiones = 0 OR b.cansesiones IS NULL)) ORDER BY b.fechacompra");
  qryBonos.setForwardOnly(true);
  if (!qryBonos.exec())
  {
    return false;
  }
  if (qryBonos.size() == 0)
  {
    MessageBox.warning(util.translate("scripts", "El alumno %1 - %2 no tiene bonos ni suscripciones disponibles").arg(codAlumno).arg(nombre), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var aOpciones: Array = new Array(qryBonos.size());
  var aBonos: Array = new Array(qryBonos.size());
  var i: Number = 0, porSesiones: Boolean;
  while (qryBonos.next())
  {
    porSesiones = (qryBonos.value("b.cansesiones") > 0);
    aBonos[i] = qryBonos.value("b.codbono");
    if (porSesiones) {
      aOpciones[i] = util.translate("scripts", "Bono %1 tipo %2 con %3 sesiones disponibles.").arg(qryBonos.value("b.codbono")).arg(qryBonos.value("b.referencia")).arg(qryBonos.value("b.cansesionesdisp"));
    } else  {
      aOpciones[i] = util.translate("scripts", "Bono %1 tipo %2. Caduca el %3").arg(qryBonos.value("b.codbono")).arg(qryBonos.value("b.referencia")).arg(util.dateAMDtoDMA(qryBonos.value("b.fechacaducidad")));
    }
    i++;
  }
  if (i == 1)
  {
    datos["codbono"] = aBonos[0];
  } else {
    var iBono: Number = flfactppal.iface.pub_elegirOpcion(aOpciones, util.translate("scripts", "Seleccione bono"));
    if (iBono < 0)
    {
      return false;
    }
    datos["codbono"] = aBonos[iBono];
  }

  //  var codBono:String = util.sqlSelect("bonosgym b INNER JOIN clientes c ON b.codcliente = c.codcliente", "b.codbono", "c.codcliente = '" + codCliente + "' AND (b.fechainicio <= '" + fecha + "' AND (b.fechacaducidad IS NULL OR b.fechacaducidad >= '" + fecha + "')) AND (b.cansesionesdisp > 0 OR (b.cansesiones = 0 OR b.cansesiones IS NULL)) ORDER BY b.fechacompra", "bonosgym,clientes");
  //  if (!codBono) {
  //    MessageBox.warning(util.translate("scripts", "El alumno %1 - %2 no tiene bonos ni suscripciones disponibles").arg(codAlumno).arg(nombre), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  //  datos["codbono"] = codBono;

  if (!util.sqlSelect("bonosgym b INNER JOIN clientes c ON b.codcliente = c.codcliente", "b.codbono", "c.codcliente = '" + codCliente + "' AND (b.fechainicio <= '" + fecha + "' AND (b.fechacaducidad IS NULL OR b.fechacaducidad >= '" + fecha + "')) AND (b.cansesiones = 0 OR b.cansesiones IS NULL) ORDER BY b.fechacompra", "bonosgym,clientes"))
  {
    /// No hay un bono vigente de cantidad ilimitada
    var canSesionesDisp: Number = parseInt(util.sqlSelect("clientes", "cansesionesdisp", "codcliente = '" + codCliente + "'"));
    canSesionesDisp = (isNaN(canSesionesDisp) ? 0 : canSesionesDisp);
    var canSesionesAviso: Number = parseInt(flfactppal.iface.pub_valorDefectoEmpresa("cansesionesaviso"));
    canSesionesAviso = (isNaN(canSesionesAviso) ? 0 : canSesionesAviso);
    if (canSesionesDisp  <= canSesionesAviso) {
      MessageBox.information(util.translate("scripts", "Al alumno %1 - %2 le quedan sólo %3 sesiones disponibles").arg(codAlumno).arg(nombre).arg(canSesionesDisp), MessageBox.Ok, MessageBox.NoButton);
    }
  }

  if (!util.sqlSelect("bonosgym b INNER JOIN clientes c ON b.codcliente = c.codcliente", "b.codbono", "c.codcliente = '" + codCliente + "' AND (b.fechainicio <= '" + fecha + "' AND (b.fechacaducidad IS NULL)) AND (b.cansesionesdisp > 0 OR (b.cansesiones = 0 OR b.cansesiones IS NULL)) ORDER BY b.fechacompra", "bonosgym,clientes"))
  {
    /// No hay un bono vigente sin fecha de caducidad
    var fechaCaducidad: String = util.sqlSelect("bonosgym b INNER JOIN clientes c ON b.codcliente = c.codcliente", "b.fechacaducidad", "c.codcliente = '" + codCliente + "' AND (b.fechainicio <= '" + fecha + "' AND (b.fechacaducidad >= '" + fecha + "')) AND (b.cansesionesdisp > 0 OR (b.cansesiones = 0 OR b.cansesiones IS NULL)) ORDER BY b.fechacaducidad DESC", "bonosgym,clientes");

    var canDiasAviso: Number = parseInt(flfactppal.iface.pub_valorDefectoEmpresa("candiasaviso"));
    canDiasAviso = (isNaN(canDiasAviso) ? 0 : canDiasAviso);
    if (canDiasAviso > 0) {
      var diasHastaCad: Number = util.daysTo(fecha, fechaCaducidad);
      if (diasHastaCad <= canDiasAviso) {
        MessageBox.information(util.translate("scripts", "El bono del alumno %1 - %2 caduca dentro de %3 días").arg(codAlumno).arg(nombre).arg(diasHastaCad), MessageBox.Ok, MessageBox.NoButton);
      }
    }
  }
  return datos;
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
