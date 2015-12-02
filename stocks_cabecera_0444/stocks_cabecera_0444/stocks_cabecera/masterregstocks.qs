
/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
class scab extends oficial
{
  var tbnRevisarStock: Object;
  function scab(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.scab_init();
  }
  function tbnRevisarStock_clicked()
  {
    return this.ctx.scab_tbnRevisarStock_clicked();
  }
  function revisarStock(where: String): Boolean {
    return this.ctx.scab_revisarStock(where);
  }
  function comprobarStock(where)
  {
    return this.ctx.scab_comprobarStock(where);
  }
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
function scab_init()
{
  this.iface.__init();
  this.iface.tbnRevisarStock = this.child("tbnRevisarStock");

  connect(this.iface.tbnRevisarStock, "clicked()", this, "iface.tbnRevisarStock_clicked");
}

function scab_tbnRevisarStock_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codAlmacen: String = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    return false;
  }


  var arrayOps: Array = [];
  arrayOps[0] = util.translate("scripts", "Actualizar el stock seleccionado");
  arrayOps[1] = util.translate("scripts", "Actualizar los stocks de %1").arg(codAlmacen);
  arrayOps[2] = util.translate("scripts", "Actualizar todos los stocks");

  var dialogo = new Dialog;
  dialogo.okButtonText = util.translate("scripts", "Aceptar");
  dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

  var chkComprobar = new CheckBox;
  chkComprobar.text = util.translate("scripts", "Sólo comprobar y emitir informe");
  dialogo.add(chkComprobar);

  var gbxDialogo = new GroupBox;
  gbxDialogo.title = util.translate("scripts", "Seleccione opción");

  var rButton: Array = new Array(arrayOps.length);
  for (var i: Number = 0; i < rButton.length; i++) {
    rButton[i] = new RadioButton;
    rButton[i].text = arrayOps[i];
    rButton[i].checked = false;
    gbxDialogo.add(rButton[i]);
  }

  dialogo.add(gbxDialogo);
  if (!dialogo.exec()) {
    return false;
  }
  var seleccion: Number = -1;
  for (var i: Number = 0; i < rButton.length; i++) {
    if (rButton[i].checked) {
      seleccion = i;
      break;
    }
  }
  if (seleccion == -1) {
    return false;
  }
  var where: String;
  switch (seleccion) {
    case 0: {
      where = "idstock = " + cursor.valueBuffer("idstock");
      break;
    }
    case 1: {
      where = "codalmacen = '" + codAlmacen + "'";
      break;
    }
    case 2: {
      where = "1 = 1";
      break;
    }
  }
  if (chkComprobar.checked) {
    var numErrores = this.iface.comprobarStock(where);
    if (numErrores >= 0) {
      MessageBox.information(util.translate("scripts", "Comprobación completa. Se han encontrado %1 errores").arg(numErrores), MessageBox.Ok, MessageBox.NoButton);
    }
  } else {
    var curTransaccion: FLSqlCursor = new FLSqlCursor("empresa");
    curTransaccion.transaction(false);
    try {
      if (this.iface.revisarStock(where)) {
        curTransaccion.commit();
      } else {
        curTransaccion.rollback();
        MessageBox.warning(util.translate("scripts", "Error al revisar el stock"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    } catch (e) {
      curTransaccion.rollback();
      MessageBox.warning(util.translate("scripts", "Error al revisar el stock:") + e, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    this.child("tdbRegStocks").refresh();
    MessageBox.information(util.translate("scripts", "Revisión completada"), MessageBox.Ok, MessageBox.NoButton);
  }
}

function scab_revisarStock(where: String): Boolean {
  var util: FLUtil = new FLUtil;

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select(where);
  util.createProgressDialog(util.translate("scripts", "Revisando stocks..."), curStock.size());
  var paso: Number = 0;
  var canUltReg: Number;
  while (curStock.next())
  {
    util.setProgress(++paso);
    curStock.setModeAccess(curStock.Edit);
    curStock.refreshBuffer();
    curStock.setValueBuffer("fechaultreg", formRecordregstocks.iface.pub_commonCalculateField("fechaultreg", curStock));
    curStock.setValueBuffer("horaultreg", formRecordregstocks.iface.pub_commonCalculateField("horaultreg", curStock));
    canUltReg = formRecordregstocks.iface.pub_commonCalculateField("cantidadultreg", curStock);
    if (!canUltReg || isNaN(canUltReg)) {
      canUltReg = 0;
    }
    curStock.setValueBuffer("cantidadultreg", canUltReg);
    curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock));
    curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock));
    curStock.setValueBuffer("cantidadac", formRecordregstocks.iface.pub_commonCalculateField("cantidadac", curStock));
    curStock.setValueBuffer("cantidadap", formRecordregstocks.iface.pub_commonCalculateField("cantidadap", curStock));
    curStock.setValueBuffer("cantidadfc", formRecordregstocks.iface.pub_commonCalculateField("cantidadfc", curStock));
    curStock.setValueBuffer("cantidadfp", formRecordregstocks.iface.pub_commonCalculateField("cantidadfp", curStock));
    curStock.setValueBuffer("cantidadts", formRecordregstocks.iface.pub_commonCalculateField("cantidadts", curStock));
    if (sys.isLoadedModule("flfact_tpv")) {
      curStock.setValueBuffer("cantidadtpv", formRecordregstocks.iface.pub_commonCalculateField("cantidadtpv", curStock));
      curStock.setValueBuffer("cantidadval", formRecordregstocks.iface.pub_commonCalculateField("cantidadval", curStock));
    }
    curStock.setValueBuffer("cantidad", formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
    curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
    if (!curStock.commitBuffer()) {
      util.destroyProgressDialog();
      return false;
    }
  }
  util.destroyProgressDialog();
  return true;
}

/** \D Compara los datos de la tabla con los calculados y emite un fichero de errores
@param  where: Sentencia where para la consulta
@return Número de errores encontrados. -1 si hay error en la función.
\end */
function scab_comprobarStock(where)
{
  var util: FLUtil = new FLUtil;

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select(where);
  util.createProgressDialog(util.translate("scripts", "Comprobando stocks..."), curStock.size());
  var paso: Number = 0;
  var canUltReg: Number;
  var ruta = FileDialog.getSaveFileName("*.csv", util.translate("scripts", "Fichero de errores"));
  if (!ruta) {
    return -1
  }
         var fErrores = new File(ruta);
  fErrores.open(File.WriteOnly);
  var cErrores = "Stock;Referencia;Almacen;" +
                 "Ult.Reg. Dif =BD-Cal;" +
                 "Reservada;" +
                 "Pte.Recibir;" +
                 "Alb.Cli.;" +
                 "Alb.Pro.;" +
                 "Fac.Cli.;" +
                 "Fac.Pro.;" +
                 "Transfer;" +
                 "Vent.TPV;" +
                 "Vale TPV;" +
                 "Cantidad;";
  fErrores.write(cErrores + "\n");

  var linea, canBD, canCal, canDif;
  var canUR, canAC, canAP, canFC, canFP, canTPV, canVal, canTS;
  var hayDif;
  var errores = 0;
  while (curStock.next()) {
    util.setProgress(++paso);
    hayDif = false;
    curStock.setModeAccess(curStock.Browse);
    curStock.refreshBuffer();
    linea = curStock.valueBuffer("idstock") + ";" + curStock.valueBuffer("referencia") + ";" + curStock.valueBuffer("codalmacen") + ";";

    curStock.setValueBuffer("fechaultreg", formRecordregstocks.iface.pub_commonCalculateField("fechaultreg", curStock));
    curStock.setValueBuffer("horaultreg", formRecordregstocks.iface.pub_commonCalculateField("horaultreg", curStock));
    canBD = curStock.valueBuffer("cantidadultreg");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadultreg", curStock);
    canCal = !canCal || isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canUR = canCal;

    canBD = curStock.valueBuffer("reservada");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";

    canBD = curStock.valueBuffer("pterecibir");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";

    canBD = curStock.valueBuffer("cantidadac");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadac", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canAC = canCal;

    canBD = curStock.valueBuffer("cantidadap");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadap", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canAP = canCal;

    canBD = curStock.valueBuffer("cantidadfc");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadfc", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canFC = canCal;

    canBD = curStock.valueBuffer("cantidadfp");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadfp", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canFP = canCal;

    canBD = curStock.valueBuffer("cantidadts");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadts", curStock);
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    canTS = canCal;
    if (sys.isLoadedModule("flfact_tpv")) {
      canBD = curStock.valueBuffer("cantidadtpv");
      canBD = isNaN(canBD) ? 0 : canBD;
      canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadtpv", curStock);
      canCal = isNaN(canCal) ? 0 : canCal;
      canDif = canBD - canCal;
      if (!hayDif && canDif != 0) hayDif = true;
      linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
      canTPV = canCal;

      canBD = curStock.valueBuffer("cantidadval");
      canBD = isNaN(canBD) ? 0 : canBD;
      canCal = formRecordregstocks.iface.pub_commonCalculateField("cantidadval", curStock);
      canCal = isNaN(canCal) ? 0 : canCal;
      canDif = canBD - canCal;
      if (!hayDif && canDif != 0) hayDif = true;
      linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
      canVal = canCal;
    } else {
      linea += "0;0;0;0;0;0;"
               canTPV = 0;
      canVal = 0;
    }
    canBD = curStock.valueBuffer("cantidad");
    canBD = isNaN(canBD) ? 0 : canBD;
    canCal = canUR - canAC + canAP - canFC + canFP + canTS - canTPV + canVal;
    canCal = isNaN(canCal) ? 0 : canCal;
    canDif = canBD - canCal;
    if (!hayDif && canDif != 0) hayDif = true;
    linea += canDif.toString() + " =" + canBD.toString() + "-" + canCal.toString() + ";";
    if (!hayDif) {
      continue;
    }
    fErrores.write(linea + "\n");
    //    cErrores += linea + "\n";
    errores++;
  }
  fErrores.close();
  util.destroyProgressDialog();
  return errores;
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
