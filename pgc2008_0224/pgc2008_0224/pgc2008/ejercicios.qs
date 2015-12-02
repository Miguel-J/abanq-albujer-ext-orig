
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial
{
  var curSubcuenta_: FLSqlCursor;
  var curGruposEpigrafe_: FLSqlCursor;
  var curEpigrafe_: FLSqlCursor;
  var curCuenta_: FLSqlCursor;
  function pgc2008(context)
  {
    oficial(context);
  }

  function init()
  {
    this.ctx.pgc2008_init();
  }

  function validateForm(): Boolean {
    return this.ctx.pgc2008_validateForm();
  }
  function buscarPlanContable(cursor: FLSqlCursor): Boolean {
    return this.ctx.pgc2008_buscarPlanContable(cursor);
  }
  function copiarPGC_old(ejercicioAnt: String, ejercicioAct: String, longSubcuenta: Number): Boolean {
    return this.ctx.pgc2008_copiarPGC_old(ejercicioAnt, ejercicioAct, longSubcuenta);
  }
  function comprobarEjercicioCopiado(ejercicioAnt: String, ejercicioAct: String): Boolean {
    return this.ctx.pgc2008_comprobarEjercicioCopiado(ejercicioAnt, ejercicioAct);
  }
  function comprobarDependenciasTablas(codEjercicio: String): Boolean {
    return this.ctx.pgc2008_comprobarDependenciasTablas(codEjercicio);
  }
  function copiarPGC(ejercicioAnt: String, ejercicioAct: String, longSubcuenta: Number): Boolean {
    return this.ctx.pgc2008_copiarPGC(ejercicioAnt, ejercicioAct, longSubcuenta);
  }
  function buscarPlanContable90(cursor: FLSqlCursor): Boolean {
    return this.ctx.pgc2008_buscarPlanContable90(cursor);
  }
  function datosSubcuenta(curSubcuentaAnt: FLSqlCursor): Boolean {
    return this.ctx.pgc2008_datosSubcuenta(curSubcuentaAnt);
  }
  function comprobarSubcuentasCopia(ejercicioAnt: String, ejercicioAct: String): Boolean {
    return this.ctx.pgc2008_comprobarSubcuentasCopia(ejercicioAnt, ejercicioAct);
  }
  function copiarGruposEpigrafes(ejercicioAnt: String, ejercicioAct: String): Boolean {
    return this.ctx.pgc2008_copiarGruposEpigrafes(ejercicioAnt, ejercicioAct);
  }
  function copiarEpigrafes(ejercicioAnt: String, ejercicioAct: String, idGrupoOrigen: String, idGrupoDestino: String): Boolean {
    return this.ctx.pgc2008_copiarEpigrafes(ejercicioAnt, ejercicioAct, idGrupoOrigen, idGrupoDestino);
  }
  function copiarCuentas(ejercicioAnt: String, ejercicioAct: String, idEpigrafeOrigen: String, idEpigrafeDestino: String): Boolean {
    return this.ctx.pgc2008_copiarCuentas(ejercicioAnt, ejercicioAct, idEpigrafeOrigen, idEpigrafeDestino);
  }
  function copiarSubcuentas(ejercicioAnt: String, ejercicioAct: String, idCuentaOrigen: String, idCuentaDestino: String): Boolean {
    return this.ctx.pgc2008_copiarSubcuentas(ejercicioAnt, ejercicioAct, idCuentaOrigen, idCuentaDestino);
  }
  function copiaDatosGrupoEpigrafe(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.pgc2008_copiaDatosGrupoEpigrafe(cursor, campo);
  }
  function copiaDatosEpigrafe(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.pgc2008_copiaDatosEpigrafe(cursor, campo);
  }
  function copiaDatosCuenta(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.pgc2008_copiaDatosCuenta(cursor, campo);
  }
  function copiaDatosSubcuenta(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.pgc2008_copiaDatosSubcuenta(cursor, campo);
  }
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Edit) {
    if (util.sqlSelect("co_epigrafes", "idepigrafe", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'"))
      this.child("fdbPlanContable").setDisabled(true);
  }
}

function pgc2008_comprobarSubcuentasCopia(ejercicioAnt: String, ejercicioAct: String): Boolean {
  var util: FLUtil = new FLUtil;
  var paso: Number = 0;

  var qrySubCuentas: FLSqlQuery = new FLSqlQuery;
  qrySubCuentas.setTablesList("co_subcuentas");
  qrySubCuentas.setSelect("codsubcuenta,codcuenta,saldo");
  qrySubCuentas.setFrom("co_subcuentas");
  qrySubCuentas.setWhere("codejercicio = '" + ejercicioAnt + "' order by codsubcuenta");

  if (!qrySubCuentas.exec())
    return;

  util.createProgressDialog(util.translate("scripts", "Comprobando Subcuentas"), qrySubCuentas.size());

  var curSubCuentas: FLSqlCursor = new FLSqlCursor("co_subcuentas");

  var cuentasPerdidas: String = "";

  while (qrySubCuentas.next())
  {

    util.setProgress(paso++);

    codCuenta08 = flcontppal.iface.convertirCodCuenta(qrySubCuentas.value(1));

    //Si no existe y no hay saldo, se ignora
    if (!codCuenta08 && parseFloat(qrySubCuentas.value(2)))
      cuentasPerdidas += "\n" + qrySubCuentas.value(1) + " " + qrySubCuentas.value(0);
  }

  if (cuentasPerdidas)
  {
    MessageBox.information(util.translate("scripts", "Las siguientes cuentas/subcuentas con saldo no tienen correspondencia en el nuevo PGC\nDebe establecer su correspondencia en:\nMódulo principal de financiera / Configuración / Correspondencias 90-08:") + "\n" + cuentasPerdidas, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    util.destroyProgressDialog();
    return false;
  }

  util.destroyProgressDialog();
  return true;
}


function pgc2008_buscarPlanContable(cursor: FLSqlCursor): Boolean {
  if (cursor.valueBuffer("plancontable") != "08")
    return this.iface.buscarPlanContable90(cursor);

  var ejercicio: String = cursor.valueBuffer("codejercicio");
  var logdigitos: Number = cursor.valueBuffer("longsubcuenta");
  var util: FLUtil = new FLUtil;

  //si el ejercicio no tiene ningun plan contable asignado
  if (util.sqlSelect("co_epigrafes", "codejercicio", "codejercicio = '" + ejercicio + "'"))
    return;

  // Si sólo hay un ejercicio
  if (util.sqlSelect("ejercicios", "count(codejercicio)", "longsubcuenta = " + logdigitos) == 1)
  {

    res = MessageBox.warning(util.translate("scripts", "Sólo existe este ejercicio con el mismo número de dígitos por subcuenta. Se creará un nuevo plan contable.\n¿Continuar?"),
    MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return;

    flcontppal.iface.pub_generarPGC(ejercicio);
    return true;
  }

  var dialog: Object = new Dialog(util.translate("scripts", "Generar Plan Contable"), 0, "generarPGC");

  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: Object = new GroupBox;
  dialog.add(bgroup);

  var nuevoPlan: Object = new RadioButton;
  nuevoPlan.text = util.translate("scripts", "Crear nuevo Cuadro de cuentas");
  nuevoPlan.checked = true;
  bgroup.add(nuevoPlan);

  var anteriorPlan: Object = new RadioButton;
  anteriorPlan.text = util.translate("scripts", "Seleccionar un ejercicio anterior y copiar su Cuadro de cuentas");
  anteriorPlan.checked = false;
  bgroup.add(anteriorPlan);

  if (!dialog.exec())
    return true;

  if (nuevoPlan.checked == true)
  {
    flcontppal.iface.pub_generarPGC(ejercicio);
    return true;
  }


  var dialog: Object = new Dialog(util.translate("scripts", "Seleccionar ejercicio"), 0, "");

  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: Object = new GroupBox;
  dialog.add(bgroup);

  var curTab: FLSqlCursor = new FLSqlCursor("ejercicios");
  curTab.select("codejercicio <> '" + ejercicio + "'");
  var botonesEj: Array = [];
  var paso: Number = 0;

  while (curTab.next())
  {

    if (curTab.valueBuffer("longsubcuenta") != logdigitos)
      continue;

    botonesEj[paso] = new Array(2);
    botonesEj[paso]["codEjercicio"] = curTab.valueBuffer("codejercicio");
    botonEj = new RadioButton;
    botonEj.text = curTab.valueBuffer("codejercicio") + " - " + curTab.valueBuffer("nombre");
    if (!paso)
      botonEj.checked = true;
    bgroup.add(botonEj);

    botonesEj[paso]["boton"] = botonEj;
    paso++;
  }

  if (!dialog.exec())
    return true;

  var ejeranterior: String;
  for (i = 0; i < botonesEj.length; i++)
  {
    botonEj = botonesEj[i]["boton"];
    if (botonEj.checked) {
      ejeranterior = botonesEj[i]["codEjercicio"];
      break;
    }
  }

  if (!ejeranterior)
    return false;

  cursor.setValueBuffer("longsubcuenta", util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + ejeranterior + "'"));

  var curTransaccion: FLSqlCursor = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    if (this.iface.copiarPGC(ejeranterior, ejercicio, logdigitos))
    {
      curTransaccion.commit();
    } else {
      curTransaccion.rollback();
      return false;
    }
  } catch (e)
  {
    curTransaccion.rollback();
    MessageBox.warning(util.translate("scripts", "Error al copiar el PGC: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function pgc2008_copiarPGC_old(ejercicioAnt: String, ejercicioAct: String, longSubcuenta: Number): Boolean {
  var util: FLUtil = new FLUtil;

  var planContableAnt = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejercicioAnt + "'");
  if (planContableAnt != "08")
    if (!this.iface.comprobarSubcuentasCopia(ejercicioAnt, ejercicioAct))
      return false;

  // Se genera el cuadro de cuentas como si fuera un ejercicio estándar pero las subcuentas se copian
  flcontppal.iface.generarCuadroCuentas(ejercicioAct);
  flcontppal.iface.generarCodigosBalance2008(); // Sólo si no existen
  flcontppal.iface.actualizarCuentas2008(ejercicioAct);
  flcontppal.iface.actualizarCuentas2008ba(ejercicioAct);
  flcontppal.iface.generarCorrespondenciasCC(ejercicioAct);
  flcontppal.iface.actualizarCuentasEspeciales(ejercicioAct);

  var paso: Number = 0;

  //  var qrySubCuentas:FLSqlQuery = new FLSqlQuery;
  //  qrySubCuentas.setTablesList ("co_subcuentas");
  //  qrySubCuentas.setSelect("codsubcuenta,codcuenta,descripcion,coddivisa,codimpuesto,iva,recargo,saldo,idcuentaesp");
  //  qrySubCuentas.setFrom("co_subcuentas");
  //  qrySubCuentas.setWhere("codejercicio = '" + ejercicioAnt + "'");
  //
  //  if (!qrySubCuentas.exec())
  //    return;
  //
  //  util.createProgressDialog(util.translate("scripts", "Copiando Subcuentas"), qrySubCuentas.size());

  var curSubcuentaAnt: FLSqlQuery = new FLSqlCursor("co_subcuentas");
  curSubcuentaAnt.select("codejercicio = '" + ejercicioAnt + "'");
  util.createProgressDialog(util.translate("scripts", "Copiando Subcuentas"), curSubcuentaAnt.size());

  //  var curSubCuentas:FLSqlCursor = new FLSqlCursor ("co_subcuentas");
  this.iface.curSubcuenta_ = new FLSqlCursor("co_subcuentas");
  this.iface.curSubcuenta_.setActivatedCommitActions(false);

  var cuentasPerdidas: String = "";
  var descripcion: String;
  while (curSubcuentaAnt.next())
  {

    util.setProgress(paso++);

    // Caso 1: de 90 a 08
    if (planContableAnt != "08") {
      // A qué cuenta 08 corresponde esta cuenta 90?
      codCuenta08 = flcontppal.iface.convertirCodCuenta(curSubcuentaAnt.valueBuffer("codcuenta"));
      idCuenta08 = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuenta08 + "' and codejercicio = '" + ejercicioAct + "'");

      if (!idCuenta08) {
        //Si no hay saldo, se ignora
        if (parseFloat(curSubcuentaAnt.valueBuffer("saldo"))) {
          cuentasPerdidas += "\n" + curSubcuentaAnt.valueBuffer("codcuenta") + " " + curSubcuentaAnt.valueBuffer("codsubcuenta");
        }
        continue;
      }

      codSubcuenta08 = flcontppal.iface.convertirCodSubcuenta(ejercicioAnt, curSubcuentaAnt.valueBuffer("codsubcuenta"));
      descripcion = curSubcuentaAnt.valueBuffer("descripcion");
    } else {
      // Caso 2: de 08 a 08
      codCuenta08 = curSubcuentaAnt.valueBuffer("codcuenta");
      idCuenta08 = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuenta08 + "' and codejercicio = '" + ejercicioAct + "'");
      codSubcuenta08 = curSubcuentaAnt.valueBuffer("codsubcuenta");
      if (!idCuenta08) {
        idCuenta08 = flcontppal.iface.pub_copiarCuenta(codCuenta08, ejercicioAnt, ejercicioAct);
        if (!idCuenta08) {
          continue;
        }
      }
      descripcion = curSubcuentaAnt.valueBuffer("descripcion");
    }

    // Existe ya?
    this.iface.curSubcuenta_.select("codsubcuenta = '" + codSubcuenta08 + "' AND codejercicio = '" + ejercicioAct + "'");
    if (this.iface.curSubcuenta_.first()) {
      continue;
    }


    // La descripcion no debe tener ya el código antes. "225. Otras instalaciones" -> "Otras instalaciones"
    /*    descripcion = qrySubCuentas.value(2);
        if (descripcion.search(".") > -1) {
          partesDescripcion = descripcion.split(". ");
          if (partesDescripcion.length == 2)
            descripcion = partesDescripcion[1];
        }*/

    this.iface.curSubcuenta_.setModeAccess(this.iface.curSubcuenta_.Insert);
    this.iface.curSubcuenta_.refreshBuffer();
    this.iface.curSubcuenta_.setValueBuffer("codejercicio", ejercicioAct);
    this.iface.curSubcuenta_.setValueBuffer("codsubcuenta", codSubcuenta08);
    this.iface.curSubcuenta_.setValueBuffer("idcuenta", idCuenta08);
    this.iface.curSubcuenta_.setValueBuffer("codcuenta", codCuenta08);
    this.iface.curSubcuenta_.setValueBuffer("descripcion", descripcion);
    if (!this.iface.datosSubcuenta(curSubcuentaAnt)) {
      return false;
    }
    if (!this.iface.curSubcuenta_.commitBuffer()) {
      return;
    }
  }

  util.destroyProgressDialog();

  // Genera las subcuentas del nuevo PGC que no existen en el ejercicio anterior
  flcontppal.iface.generarSubcuentas(ejercicioAct, longSubcuenta);

  if (!this.iface.copiarSubcuentasCliProv(ejercicioAnt, ejercicioAct))
    return false;

  if (cuentasPerdidas)
    MessageBox.information(util.translate("scripts", "Las siguientes cuentas/subcuentas con saldo no se pudieron copiar\nporque no existe una correspondencia con el nuevo plan contable\nDeberá migrar su saldo a otras cuentas antes de cerrar el ejercicio:") + "\n" + cuentasPerdidas,
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  MessageBox.information(util.translate("scripts", "Se copió el cuadro de cuentas"),
                         MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  return true;
}

function pgc2008_comprobarDependenciasTablas(codEjercicio: String): Boolean {
  var util: FLUtil;

  if (!codEjercicio || codEjercicio   == "")
    return false;

  var codEpigrafe: String = util.sqlSelect("co_epigrafes e left outer join co_gruposepigrafes g on e.idgrupo = g.idgrupo", "e.codepigrafe", "g.idgrupo is null AND e.codejercicio = '" + codEjercicio + "'", "co_epigrafes,co_gruposepigrafes");
  if (codEpigrafe && codEpigrafe != "")
  {
    MessageBox.warning(util.translate("scripts", "No se puede copiar el plan contable del ejerciclio %1.\nEl epígrafe %2 no tiene un grupo asociado.").arg(codEjercicio).arg(codEpigrafe),  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var codCuenta: String = util.sqlSelect("co_cuentas c left outer join co_epigrafes e on c.idepigrafe = e.idepigrafe", "c.codcuenta", "e.idepigrafe is null AND c.codejercicio = '" + codEjercicio + "'", "co_cuentas,co_epigrafes");
  if (codCuenta && codCuenta != "")
  {
    MessageBox.warning(util.translate("scripts", "No se puede copiar el plan contable del ejerciclio %1.\nLa cuenta %2 no tiene un epígrafe asociado.").arg(codEjercicio).arg(codCuenta),  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var codSubcuenta: String = util.sqlSelect("co_subcuentas s left outer join co_cuentas c on s.idcuenta = c.idcuenta", "s.codsubcuenta", "c.idcuenta is null AND s.codejercicio = '" + codEjercicio + "'", "co_subcuentas,co_cuentas");
  if (codSubcuenta && codSubcuenta != "")
  {
    MessageBox.warning(util.translate("scripts", "No se puede copiar el plan contable del ejerciclio %1.\nLa subcuenta %2 no tiene una cuenta asociada.").arg(codEjercicio).arg(codSubcuenta),  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function pgc2008_copiarPGC(ejercicioAnt: String, ejercicioAct: String, longSubcuenta: Number): Boolean {
  var util: FLUtil = new FLUtil;

  var planContableAnt = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejercicioAnt + "'");
  var planContableAct = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejercicioAct + "'");
  if (planContableAnt != "08" || planContableAct != "08")
  {
    if (!this.iface.copiarPGC_old(ejercicioAnt, ejercicioAct, longSubcuenta))
      return false;
    return true;
  }

  if (!this.iface.comprobarDependenciasTablas(ejercicioAnt))
    return false;

  if (!this.iface.copiarGruposEpigrafes(ejercicioAnt, ejercicioAct))
    return false;

  //  if(!this.iface.copiarEpigrafes(ejercicioAnt, ejercicioAct))
  //    return false;
  //
  //  if(!this.iface.copiarCuentas(ejercicioAnt, ejercicioAct))
  //    return false;
  //
  //  if(!this.iface.copiarSubcuentas(ejercicioAnt, ejercicioAct))
  //    return false;

  if (!this.iface.copiarSubcuentasCliProv(ejercicioAnt, ejercicioAct))
    return false;

  if (!this.iface.comprobarEjercicioCopiado(ejercicioAnt, ejercicioAct))
    return false;

  MessageBox.information(util.translate("scripts", "Se copió correctamente el cuadro de cuentas"),
  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  return true;
}

function pgc2008_comprobarEjercicioCopiado(ejercicioAnt: String, ejercicioAct: String): Boolean {
  var util: FLUtil;

  if (!ejercicioAnt || ejercicioAnt == "" || !ejercicioAct || ejercicioAct == "")
    return false;

  var numSctaAnt: Number = parseFloat(util.sqlSelect("co_subcuentas", "COUNT(idsubcuenta)", "codejercicio = '" + ejercicioAnt + "'"));
  var numSctaAct: Number = parseFloat(util.sqlSelect("co_subcuentas", "COUNT(idsubcuenta)", "codejercicio = '" + ejercicioAct + "'"));
  if (numSctaAnt != numSctaAct)
  {
    var qSub = new FLSqlQuery;
    qSub.setSelect("s1.codsubcuenta, s1.descripcion");
    qSub.setFrom("co_subcuentas s1 LEFT OUTER JOIN co_subcuentas s2 ON (s1.codsubcuenta = s2.codsubcuenta AND s1.codejercicio = '" + ejercicioAnt  + "' AND s2.codejercicio = '" + ejercicioAct + "')");
    qSub.setWhere("s1.codejercicio = '" + ejercicioAnt + "' AND s2.idsubcuenta IS NULL");
    qSub.setForwardOnly(true);
    if (qSub.exec()) {
      if (qSub.size() <= 20) {
        var listaSub = "";
        while (qSub.next()) {
          listaSub += qSub.value("s1.codsubcuenta") + " - " + qSub.value("s1.descripcion");
          listaSub += listaSub != "" ? "\n" : "";
        }
        MessageBox.warning(util.translate("scripts", "Error. Las siguientes subcuentas no se han copiado al nuevo ejercicio:\n%1").arg(listaSub), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      } else {
        MessageBox.warning(util.translate("scripts", "Error. Más de 20 subcuentas no se han copiado al nuevo ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      }
    } else {
      MessageBox.warning(util.translate("scripts", "Las subcuentas no se copiaron correctamente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    }
    return false;
  }

  var numCtaAnt: Number = parseFloat(util.sqlSelect("co_cuentas", "COUNT(idcuenta)", "codejercicio = '" + ejercicioAnt + "'"));
  var numCtaAct: Number = parseFloat(util.sqlSelect("co_cuentas", "COUNT(idcuenta)", "codejercicio = '" + ejercicioAct + "'"));
  if (numCtaAnt != numCtaAct)
  {
    MessageBox.warning(util.translate("scripts", "Las cuentas no se copiaron correctamente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var numEpiAnt: Number = parseFloat(util.sqlSelect("co_epigrafes", "COUNT(idepigrafe)", "codejercicio = '" + ejercicioAnt + "'"));
  var numEpiAct: Number = parseFloat(util.sqlSelect("co_epigrafes", "COUNT(idepigrafe)", "codejercicio = '" + ejercicioAct + "'"));
  if (numEpiAnt != numEpiAct)
  {
    MessageBox.warning(util.translate("scripts", "Los epígrafes no se copiaron correctamente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var numGEpiAnt: Number = parseFloat(util.sqlSelect("co_gruposepigrafes", "COUNT(idgrupo)", "codejercicio = '" + ejercicioAnt + "'"));
  var numGEpiAct: Number = parseFloat(util.sqlSelect("co_gruposepigrafes", "COUNT(idgrupo)", "codejercicio = '" + ejercicioAct + "'"));
  if (numGEpiAnt != numGEpiAct)
  {
    MessageBox.warning(util.translate("scripts", "Los grupos de epígrafes no se copiaron correctamente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function pgc2008_copiarGruposEpigrafes(ejercicioAnt: String, ejercicioAct: String): Boolean {
  var util: FLUtil;

  var curGrupoOrigen: FLSqlCursor = new FLSqlCursor("co_gruposepigrafes");
  curGrupoOrigen.select("codejercicio = '" + ejercicioAnt + "'");

  util.createProgressDialog(util.translate("scripts", "Copiando Cuadro de cuentas ..."), curGrupoOrigen.size());
  var progres: Number = 0;
  var idGrupoOrigen: String, idGrupoDestino: String;
  while (curGrupoOrigen.next())
  {
    util.setProgress(++progres);

    curGrupoOrigen.setModeAccess(curGrupoOrigen.Browse);
    curGrupoOrigen.refreshBuffer();

    idGrupoOrigen = curGrupoOrigen.valueBuffer("idgrupo");
    if (!this.iface.curGruposEpigrafe_) {
      this.iface.curGruposEpigrafe_ = new FLSqlCursor("co_gruposepigrafes");
    }
    this.iface.curGruposEpigrafe_.setModeAccess(this.iface.curGruposEpigrafe_.Insert);
    this.iface.curGruposEpigrafe_.refreshBuffer();
    this.iface.curGruposEpigrafe_.setValueBuffer("codejercicio", ejercicioAct);
    var campos: Array = util.nombreCampos("co_gruposepigrafes");
    var totalCampos: Number = campos[0];
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiaDatosGrupoEpigrafe(curGrupoOrigen, campos[i])) {
        util.destroyProgressDialog();
        return false;
      }
    }

    if (!this.iface.curGruposEpigrafe_.commitBuffer()) {
      util.destroyProgressDialog();
      return false;
    }

    idGrupoDestino = this.iface.curGruposEpigrafe_.valueBuffer("idgrupo");
    if (!this.iface.copiarEpigrafes(ejercicioAnt, ejercicioAct, idGrupoOrigen, idGrupoDestino)) {
      return false;
    }
  }

  util.destroyProgressDialog();
  return true;
}

function pgc2008_copiarEpigrafes(ejercicioAnt: String, ejercicioAct: String, idGrupoOrigen: String, idGrupoDestino: String): Boolean {
  var util: FLUtil;

  var curEpigrafeOrigen: FLSqlCursor = new FLSqlCursor("co_epigrafes");
  if (!idGrupoOrigen)
    return false;

  curEpigrafeOrigen.select("codejercicio = '" + ejercicioAnt + "' AND idgrupo = " + idGrupoOrigen);
  var idEpigrafeOrigen: String, idEpigrafeDestino: String;
  while (curEpigrafeOrigen.next())
  {
    curEpigrafeOrigen.setModeAccess(curEpigrafeOrigen.Browse);
    curEpigrafeOrigen.refreshBuffer();

    idEpigrafeOrigen = curEpigrafeOrigen.valueBuffer("idepigrafe");
    if (!this.iface.curEpigrafe_) {
      this.iface.curEpigrafe_ = new FLSqlCursor("co_epigrafes");
    }
    this.iface.curEpigrafe_.setModeAccess(this.iface.curEpigrafe_.Insert);
    this.iface.curEpigrafe_.refreshBuffer();
    this.iface.curEpigrafe_.setValueBuffer("codejercicio", ejercicioAct);
    this.iface.curEpigrafe_.setValueBuffer("idgrupo", idGrupoDestino);
    var campos: Array = util.nombreCampos("co_epigrafes");
    var totalCampos: Number = campos[0];
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiaDatosEpigrafe(curEpigrafeOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curEpigrafe_.commitBuffer()) {
      return false;
    }
    idEpigrafeDestino = this.iface.curEpigrafe_.valueBuffer("idepigrafe");
    if (!this.iface.copiarCuentas(ejercicioAnt, ejercicioAct, idEpigrafeOrigen, idEpigrafeDestino)) {
      return false;
    }
  }
  return true;
}

function pgc2008_copiarCuentas(ejercicioAnt: String, ejercicioAct: String, idEpigrafeOrigen: String, idEpigrafeDestino: String): Boolean {
  var util: FLUtil;

  var curCuentaOrigen: FLSqlCursor = new FLSqlCursor("co_cuentas");
  if (!idEpigrafeOrigen)
    return false;

  curCuentaOrigen.select("codejercicio = '" + ejercicioAnt + "' AND idepigrafe = " + idEpigrafeOrigen);
  var idCuentaOrigen: String, idCuentaDestino: String;

  while (curCuentaOrigen.next())
  {
    curCuentaOrigen.setModeAccess(curCuentaOrigen.Browse);
    curCuentaOrigen.refreshBuffer();

    idCuentaOrigen = curCuentaOrigen.valueBuffer("idcuenta");

    if (!this.iface.curCuenta_) {
      this.iface.curCuenta_ = new FLSqlCursor("co_cuentas");
    }
    this.iface.curCuenta_.setModeAccess(this.iface.curCuenta_.Insert);
    this.iface.curCuenta_.refreshBuffer();
    this.iface.curCuenta_.setValueBuffer("codejercicio", ejercicioAct);
    this.iface.curCuenta_.setValueBuffer("idepigrafe", idEpigrafeDestino);
    var campos: Array = util.nombreCampos("co_cuentas");
    var totalCampos: Number = campos[0];
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiaDatosCuenta(curCuentaOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curCuenta_.commitBuffer()) {
      return false;
    }
    idCuentaDestino = this.iface.curCuenta_.valueBuffer("idcuenta");
    if (!this.iface.copiarSubcuentas(ejercicioAnt, ejercicioAct, idCuentaOrigen, idCuentaDestino))
      return false;
  }

  return true;
}

function pgc2008_copiarSubcuentas(ejercicioAnt: String, ejercicioAct: String, idCuentaOrigen: String, idCuentaDestino: String): Boolean {
  var util: FLUtil;

  var curSubcuentaOrigen: FLSqlCursor = new FLSqlCursor("co_subcuentas");
  if (!idCuentaOrigen)
    return false;

  curSubcuentaOrigen.select("codejercicio = '" + ejercicioAnt + "' AND idcuenta = " + idCuentaOrigen);
  while (curSubcuentaOrigen.next())
  {
    curSubcuentaOrigen.setModeAccess(curSubcuentaOrigen.Browse);
    curSubcuentaOrigen.refreshBuffer();

    if (!this.iface.curSubcuenta_) {
      this.iface.curSubcuenta_ = new FLSqlCursor("co_subcuentas");
    }
    this.iface.curSubcuenta_.setModeAccess(this.iface.curSubcuenta_.Insert);
    this.iface.curSubcuenta_.refreshBuffer();
    this.iface.curSubcuenta_.setValueBuffer("codejercicio", ejercicioAct);
    this.iface.curSubcuenta_.setValueBuffer("idcuenta", idCuentaDestino);
    var campos: Array = util.nombreCampos("co_subcuentas");
    var totalCampos: Number = campos[0];
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiaDatosSubcuenta(curSubcuentaOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curSubcuenta_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function pgc2008_copiaDatosGrupoEpigrafe(cursor: FLSqlCursor, campo: String): Boolean {
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idgrupo":
    case "codejercicio": {
      return true;
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        this.iface.curGruposEpigrafe_.setNull(campo);
      } else {
        this.iface.curGruposEpigrafe_.setValueBuffer(campo, cursor.valueBuffer(campo));
      }
    }
  }
  return true;
}

function pgc2008_copiaDatosEpigrafe(cursor: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil;

  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idepigrafe":
    case "codejercicio":
    case "idpadre":
    case "idgrupo": {
      return true;
      break;
    }
    //    case "idpadre": {
    //      var codPadre:String = util.sqlSelect("co_epigrafes","codepigrafe","idepigrafe = " + cursor.valueBuffer("idpadre") + "AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
    //      if(codPadre && codPadre != "") {
    //        var idEpigrafe:Number = util.sqlSelect("co_epigrafes","idepigrafe","codepigrafe = '" + codPadre + "' AND codejercicio = '" + this.iface.curEpigrafe_.valueBuffer("codejercicio") + "'");
    //        if(idEpigrafe && idEpigrafe != 0)
    //          this.iface.curEpigrafe_.setValueBuffer(campo, idEpigrafe);
    //      }
    //      break;
    //    }
    //    case "idgrupo": {
    //      var codGrupo:String = util.sqlSelect("co_gruposepigrafes","codgrupo","idgrupo = " + cursor.valueBuffer("idgrupo") + "AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
    //      if(codGrupo && codGrupo != "") {
    //        var idGrupo:Number = util.sqlSelect("co_gruposepigrafes","idgrupo","codgrupo = '" + codGrupo + "' AND codejercicio = '" + this.iface.curEpigrafe_.valueBuffer("codejercicio") + "'");
    //        if(idGrupo && idGrupo != 0)
    //          this.iface.curEpigrafe_.setValueBuffer(campo, idGrupo);
    //      }
    //      break;
    //    }
    default: {
      if (cursor.isNull(campo)) {
        this.iface.curEpigrafe_.setNull(campo);
      } else {
        this.iface.curEpigrafe_.setValueBuffer(campo, cursor.valueBuffer(campo));
      }
    }
  }
  return true;
}

function pgc2008_copiaDatosCuenta(cursor: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil;

  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idcuenta":
    case "codejercicio":
    case "idepigrafe": {
      return true;
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        this.iface.curCuenta_.setNull(campo);
      } else {
        this.iface.curCuenta_.setValueBuffer(campo, cursor.valueBuffer(campo));
      }
    }
  }
  return true;
}

function pgc2008_copiaDatosSubcuenta(cursor: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil;

  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idsubcuenta":
    case "codejercicio":
    case "idcuenta": {
      return true;
      break;
    }
    case "debe":
    case "haber":
    case "saldo": {
      this.iface.curSubcuenta_.setValueBuffer(campo, 0);
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        this.iface.curSubcuenta_.setNull(campo);
      } else {
        this.iface.curSubcuenta_.setValueBuffer(campo, cursor.valueBuffer(campo));
      }
    }
  }
  return true;
}

function pgc2008_datosSubcuenta(curSubcuentaAnt: FLSqlCursor): Boolean {
  this.iface.curSubcuenta_.setValueBuffer("coddivisa", curSubcuentaAnt.valueBuffer("coddivisa"));
  this.iface.curSubcuenta_.setValueBuffer("codimpuesto", curSubcuentaAnt.valueBuffer("codimpuesto"));
  this.iface.curSubcuenta_.setValueBuffer("iva", curSubcuentaAnt.valueBuffer("iva"));
  this.iface.curSubcuenta_.setValueBuffer("idcuentaesp", curSubcuentaAnt.valueBuffer("idcuentaesp"));

  return true;
}

/** \D Es el mismo que oficial pero no deja copiar de 08 a 90
\end */
function pgc2008_buscarPlanContable90(cursor: FLSqlCursor): Boolean {
  var ejercicio: String = cursor.valueBuffer("codejercicio");
  var logdigitos: Number = cursor.valueBuffer("longsubcuenta");
  var util: FLUtil = new FLUtil;
  //si el ejercicio no tiene ningun plan contable asignado
  if (!util.sqlSelect("co_epigrafes", "codejercicio", "codejercicio = '" + ejercicio + "'"))
  {
    if (util.sqlSelect("ejercicios", "count(codejercicio)", "1 = 1") == 1) {
      flcontppal.iface.pub_generarPGC(ejercicio);
      flcontppal.iface.pub_generarSubcuentas(ejercicio, logdigitos);
      return true;
    }

    var dialog: Object = new Dialog(util.translate("scripts", "Generar Plan Contable"), 0, "gerenarPGC");

    dialog.OKButtonText = util.translate("scripts", "Aceptar");
    dialog.cancelButtonText = util.translate("scripts", "Cancelar");

    var bgroup: Object = new GroupBox;
    dialog.add(bgroup);

    var nuevoPlan: Object = new RadioButton;
    nuevoPlan.text = util.translate("scripts", "Crear nuevo Cuadro de cuentas");
    nuevoPlan.checked = true;
    bgroup.add(nuevoPlan);

    var anteriorPlan: Object = new RadioButton;
    anteriorPlan.text = util.translate("scripts", "Seleccionar un ejercicio anterior y copiar su Cuadro de cuentas");
    anteriorPlan.checked = false;
    bgroup.add(anteriorPlan);

    if (!dialog.exec())
      return true;

    if (nuevoPlan.checked == true) {
      /** \D Si se selecciona crear un nuevo plan, se llama a flcontppal.generarPGC, que cargará el plan por defecto y lo asociará al ejercicio
      \end */
      flcontppal.iface.pub_generarPGC(ejercicio);
      flcontppal.iface.pub_generarSubcuentas(ejercicio, logdigitos);
    } else {
      /** \D Si se selecciona copiar un plan anterior, se abre la ventana de ejercicios para escoger el ejercicio del cual se copiará el plan. Los pasos seguidos son los siguientes:
      \end */
      var idEpigrafe: Number;
      var idEpigrafeNuevo: Number;
      var idPadre: Number;
      var idPadreNuevo: Number;
      var idCuenta: Number;
      var idCuentaNueva: Number;
      var codEpigrafe: String;
      var codPadre: String;
      var f: Object = new FLFormSearchDB("ejercicios");
      f.setMainWidget();

      // CAMBIO respecto de oficial
      f.cursor().setMainFilter("codejercicio <> '" + ejercicio + "' AND plancontable <> '08'");

      var ejeranterior: String = f.exec("codejercicio");

      if (!ejeranterior)
        return false;
      cursor.setValueBuffer("longsubcuenta", util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + ejeranterior + "'"));
      /** \D Se buscan los datos de la tabla epigrafes del ejercicio anterior y se insertan en el nuevo ejercicio
      \end */
      var qryEpigrafe: FLSqlQuery = new FLSqlQuery;
      with(qryEpigrafe) {
        setTablesList("co_epigrafes,co_epigrafes");
        setSelect("e.idpadre,e.idepigrafe,e.codepigrafe,e.descripcion,p.codepigrafe");
        setFrom("co_epigrafes e LEFT OUTER JOIN co_epigrafes p ON e.idpadre = p.idepigrafe");
        setWhere("e.codejercicio = '" + ejeranterior + "'");
      }
      if (!qryEpigrafe.exec())
        return;

      var i: Number = 0;
      var j: Number = 0;

      var totalEpigrafes: Number = util.sqlSelect("co_epigrafes e LEFT OUTER JOIN co_epigrafes p ON e.idpadre = p.idepigrafe", "COUNT(e.idepigrafe)", "e.codejercicio = '" + ejeranterior + "'", "co_epigrafes");

      util.createProgressDialog(util.translate("scripts", "Copiando Cuadro de cuentas"), totalEpigrafes);

      while (qryEpigrafe.next()) {
        idPadre = qryEpigrafe.value(0);
        idEpigrafe = qryEpigrafe.value(1);
        codEpigrafe = qryEpigrafe.value(2);
        var curEpigrafe: FLSqlCursor = new FLSqlCursor("co_epigrafes");
        curEpigrafe.setModeAccess(curEpigrafe.Insert);
        curEpigrafe.refreshBuffer();
        curEpigrafe.setValueBuffer("codejercicio", ejercicio);
        curEpigrafe.setValueBuffer("codepigrafe", codEpigrafe);
        curEpigrafe.setValueBuffer("descripcion", qryEpigrafe.value(3));
        if (idPadre) {
          idPadreNuevo = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + qryEpigrafe.value(4) + "'" + " AND codejercicio = '" + ejercicio + "'");
          curEpigrafe.setValueBuffer("idpadre", idPadreNuevo);
        }
        if (!curEpigrafe.commitBuffer())
          return false;
        idEpigrafeNuevo  = curEpigrafe.valueBuffer("idepigrafe");

        /** \D  Para las cuentas existentes para cada epigrafe, el idepigrafe, el idpadre y el codepigrafe son el mismo que el de el epigrafe al que pertenecen
        \end */
        var qryCuentas: FLSqlQuery = new FLSqlQuery;
        with(qryCuentas) {
          setTablesList("co_cuentas");
          setSelect("codcuenta,descripcion,idcuentaesp,codepigrafe,codbalance,idcuenta");
          setFrom("co_cuentas");
          setWhere("idepigrafe = " + idEpigrafe);
        }
        if (!qryCuentas.exec())
          return;
        while (qryCuentas.next()) {
          idCuenta = qryCuentas.value(5);
          var curCuentas: FLSqlCursor = new FLSqlCursor("co_cuentas");
          curCuentas.setModeAccess(curCuentas.Insert);
          curCuentas.refreshBuffer();
          curCuentas.setValueBuffer("codejercicio", ejercicio);
          curCuentas.setValueBuffer("codcuenta", qryCuentas.value(0));
          curCuentas.setValueBuffer("idepigrafe", idEpigrafeNuevo);
          curCuentas.setValueBuffer("codepigrafe", qryCuentas.value(3));
          curCuentas.setValueBuffer("descripcion", qryCuentas.value(1));
          curCuentas.setValueBuffer("idcuentaesp", qryCuentas.value(2));
          curCuentas.setValueBuffer("codbalance", qryCuentas.value(4));
          curCuentas.commitBuffer();
          codigocuenta = qryCuentas.value(0);
          /** \D Se busca el idcuenta que se genera para cada cuenta para posteriormente poderlo enlazar con las subcuentas
          \end */
          idCuentaNueva = curCuentas.valueBuffer("idcuenta");
          var qrySubCuentas: FLSqlQuery = new FLSqlQuery;
          /** \D Se busca la subcuenta para cada cuenta encontrada con el mismo ejercicio e idcuenta
          \end */
          with(qrySubCuentas) {
            setTablesList("co_subcuentas");
            setSelect("codsubcuenta,codcuenta,descripcion,coddivisa,codimpuesto,iva,recargo");
            setFrom("co_subcuentas");
            setWhere("idcuenta = " + idCuenta);
          }
          if (!qrySubCuentas.exec())
            return;
          while (qrySubCuentas.next()) {
            var curSubCuentas: FLSqlCursor = new FLSqlCursor("co_subcuentas");
            curSubCuentas.setModeAccess(curSubCuentas.Insert);
            curSubCuentas.refreshBuffer();
            curSubCuentas.setValueBuffer("codejercicio", ejercicio);
            curSubCuentas.setValueBuffer("codsubcuenta", qrySubCuentas.value(0));
            curSubCuentas.setValueBuffer("idcuenta", idCuentaNueva);
            curSubCuentas.setValueBuffer("codcuenta", qrySubCuentas.value(1));
            curSubCuentas.setValueBuffer("descripcion", qrySubCuentas.value(2));
            curSubCuentas.setValueBuffer("coddivisa", qrySubCuentas.value(3));
            curSubCuentas.setValueBuffer("codimpuesto", qrySubCuentas.value(4));
            curSubCuentas.setValueBuffer("iva", qrySubCuentas.value(5));
            if (!curSubCuentas.commitBuffer())
              return;
          }
        }
        i++
        if (j++ > totalEpigrafes / 10) {
          j = 0;
          util.setProgress(i);
        }
      }
      util.setProgress(totalEpigrafes);
      util.destroyProgressDialog();

      if (!this.iface.copiarSubcuentasCliProv(ejeranterior, ejercicio))
        return false;
    }
  }
  return true;
}

function pgc2008_validateForm(): Boolean {
  var fechaInicio: String = this.child("fdbFechaInicio").value();
  var fechaFin: String = this.child("fdbFechaFin").value();
  var util: FLUtil = new FLUtil;

  /** \C
  La fecha de inicio del ejercicio debe ser menor que la de fin
  \end */
  if (fechaInicio > fechaFin)
  {
    MessageBox.warning(util.translate("scripts", "La fecha de inicio del ejercicio debe ser menor que la de fin"),
    MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  Al menos una secuencia por serie debe añadirse al ejercicio
  \end */
  var cursor: FLSqlCursor = new FLSqlCursor("secuenciasejercicios");
  cursor.select("upper(codejercicio) = '" +
  this.cursor().valueBuffer("codejercicio").upper() + "';");
  if (!cursor.first())
  {
    MessageBox.warning(util.translate("scripts", "Debe añadir al menos una secuencia para el ejercicio\nen \"Secuencias por serie\""), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  La longitud de la subcuenta debe estar entre 5 y 15 caracteres
  \end */
  var longSubcuenta: Number = parseFloat(this.cursor().valueBuffer("longsubcuenta"));
  if (longSubcuenta < 5 || longSubcuenta > 15)
  {
    MessageBox.warning(util.translate("scripts", "La longitud de la subcuenta debe estar entre 5 y 15 caracteres"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (sys.isLoadedModule("flcontppal"))
  {
    if (!util.sqlSelect("co_epigrafes", "codejercicio", "codejercicio = '" + this.cursor().valueBuffer("codejercicio") + "'")) {
      MessageBox.information(util.translate("scripts", "Para generar el cuadro de cuentas asociado a este ejercicio,\nuse el botón 'Cuadro de cuentas' del formulario maestro de ejercicios"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    }
  }
  return true;
}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

