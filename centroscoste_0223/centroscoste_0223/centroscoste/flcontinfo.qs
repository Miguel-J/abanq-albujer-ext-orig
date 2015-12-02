
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends pgc2008
{
  var listaCentros: String;
  var listaSubcentros: String;
  var totalFacturasRecCCBase: Number;
  var totalFacturasRecCCIVA: Number;
  var totalFacturasRecCCTotal: Number;

  function centrosCoste(context)
  {
    pgc2008(context);
  }

  function lanzarBalance(cursor: FLSqlCursor)
  {
    return this.ctx.centrosCoste_lanzarBalance(cursor);
  }
  function agregarCentro(curInforme: FLSqlCursor, nomSubTabla: String): Boolean {
    return this.ctx.centrosCoste_agregarCentro(curInforme, nomSubTabla);
  }
  function eliminarCentro(curInforme: FLSqlCursor, codCentro: String, nomSubTabla: String): Boolean {
    return this.ctx.centrosCoste_eliminarCentro(curInforme, codCentro, nomSubTabla);
  }
  function agregarSubcentro(curInforme: FLSqlCursor, nomSubTabla: String): Boolean {
    return this.ctx.centrosCoste_agregarSubcentro(curInforme, nomSubTabla);
  }
  function eliminarSubcentro(curInforme: FLSqlCursor, codSubcentro: String, nomSubTabla: String): Boolean {
    return this.ctx.centrosCoste_eliminarSubcentro(curInforme, codSubcentro, nomSubTabla);
  }
  function datoFacturasRecCC(nodo: FLDomNode, campo: String): String {
    return this.ctx.centrosCoste_datoFacturasRecCC(nodo, campo);
  }
  function datoTotalFacturasRecCC(nodo: FLDomNode, campo: String): String {
    return this.ctx.centrosCoste_datoTotalFacturasRecCC(nodo, campo);
  }
  function popularBuffer(ejercicio: String, posicion: String, idBalance: Number, fechaDesde: String, fechaHasta: String, tablaCB: String, masWhere: String)
  {
    return this.ctx.centrosCoste_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);
  }
  function populaBuffer(oDatos)
  {
    return this.ctx.centrosCoste_populaBuffer(oDatos);
  }
  function establecerListasCentros(listaCentros: String, listaSubcentros: String)
  {
    return this.ctx.centrosCoste_establecerListasCentros(listaCentros, listaSubcentros);
  }
  function cabeceraInforme(nodo: FLDomNode, campo: String): String {
    return this.ctx.centrosCoste_cabeceraInforme(nodo, campo);
  }
  function datosMayorCC(nodo: FLDomNode, campo: String): String {
    return this.ctx.centrosCoste_datosMayorCC(nodo, campo);
  }
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////

function centrosCoste_agregarCentro(curInforme: FLSqlCursor, nomSubTabla: String): Boolean {
  var util: FLUtil = new FLUtil();
  var idInforme: Number = curInforme.valueBuffer("id");

  var listaCentros: String = "";
  var filtro: String = "";
  var curTab: FLSqlCursor = new FLSqlCursor("co_i_centros" + nomSubTabla);
  curTab.select("idinforme = " + idInforme);
  while (curTab.next())
  {
    if (listaCentros)
      listaCentros += ",";
    listaCentros += "'" + curTab.valueBuffer("codcentro") + "'";
  }

  if (listaCentros)
    filtro = "codcentro NOT IN (" + listaCentros + ")";


  var f: Object = new FLFormSearchDB("co_i_seleccioncentroscoste");
  var curCentros: FLSqlCursor = f.cursor();

  if (curInforme.modeAccess() != curInforme.Browse)
    if (!curInforme.checkIntegrity())
      return;

  curCentros.select();
  if (!curCentros.first())
    curCentros.setModeAccess(curCentros.Insert);
  else
    curCentros.setModeAccess(curCentros.Edit);

  f.setMainWidget();
  curCentros.refreshBuffer();
  curCentros.setValueBuffer("datos", "");
  curCentros.setValueBuffer("filtro", filtro);

  var ret = f.exec("datos");

  if (!f.accepted())
    return false;

  var datos: String = new String(ret);

  if (datos.isEmpty())
    return false;

  var regExp: RegExp = new RegExp("'");
  regExp.global = true;
  datos = datos.replace(regExp, "");

  var centros: Array = datos.split(",");

  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Agregando centros"), centros.length);

  for (var i: Number = 0; i < centros.length; i++)
  {
    codCentro = centros[i];
    util.setProgress(paso++);

    curTab.select("codcentro = '" + codCentro + "' AND idinforme = " + idInforme);
    if (!curTab.first()) {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idinforme", idInforme);
      curTab.setValueBuffer("codcentro", codCentro);
      curTab.setValueBuffer("descripcion", util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + codCentro + "'"));
      curTab.commitBuffer();
    }
  }

  util.destroyProgressDialog();
}

function centrosCoste_eliminarCentro(curInforme: FLSqlCursor, codCentro: String, nomSubTabla: String): Boolean {
  var util: FLUtil = new FLUtil();
  var idInforme: Number = curInforme.valueBuffer("id");
  var curTab: FLSqlCursor = new FLSqlCursor("co_i_centros" + nomSubTabla);
  var paso: Number = 0;

  // Un centro
  if (codCentro)
    curTab.select("codcentro = '" + codCentro + "' AND idinforme = " + idInforme);
  // Todos
  else
    curTab.select("idinforme = " + idInforme);

  util.createProgressDialog(util.translate("scripts", "Quitando centros"), curTab.size());
  while (curTab.next())
  {
    util.setProgress(paso++);
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
  util.destroyProgressDialog();


  // Subcentros asociados
  var curTab = new FLSqlCursor("co_i_subcentros" + nomSubTabla);

  // Un centro
  if (codCentro)
    curTab.select("codsubcentro IN (select codsubcentro from subcentroscoste where codcentro = '" + codCentro + "') AND idinforme = " + idInforme);
  // Todos
  else
    curTab.select("idinforme = " + idInforme);

  paso = 0;
  util.createProgressDialog(util.translate("scripts", "Quitando subcentros"), curTab.size());
  while (curTab.next())
  {
    util.setProgress(paso++);
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
  util.destroyProgressDialog();
}

function centrosCoste_agregarSubcentro(curInforme: FLSqlCursor, nomSubTabla: String): Boolean {
  var util: FLUtil = new FLUtil();
  var idInforme: Number = curInforme.valueBuffer("id");

  var filtro: String = "";

  var listaCentros: String = "";
  var curCentros: FLSqlCursor = new FLSqlCursor("co_i_centros" + nomSubTabla);
  curCentros.select("idinforme = " + idInforme);
  while (curCentros.next())
  {
    if (listaCentros)
      listaCentros += ",";
    listaCentros += "'" + curCentros.valueBuffer("codcentro") + "'";
  }
  if (listaCentros)
    filtro = "codcentro IN (" + listaCentros + ")";
  else {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar al menos un centro de coste"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var listaSubcentros: String = "";
  var curTab: FLSqlCursor = new FLSqlCursor("co_i_subcentros" + nomSubTabla);
  curTab.select("idinforme = " + idInforme);
  while (curTab.next())
  {
    if (listaSubcentros)
      listaSubcentros += ",";
    listaSubcentros += "'" + curTab.valueBuffer("codsubcentro") + "'";
  }

  if (listaSubcentros)
    filtro += " AND codsubcentro NOT IN (" + listaSubcentros + ")";

  var f: Object = new FLFormSearchDB("co_i_seleccionsubcentroscoste");
  var curSubcentros: FLSqlCursor = f.cursor();

  if (curInforme.modeAccess() != curInforme.Browse)
    if (!curInforme.checkIntegrity())
      return;

  curSubcentros.select();
  if (!curSubcentros.first())
    curSubcentros.setModeAccess(curSubcentros.Insert);
  else
    curSubcentros.setModeAccess(curSubcentros.Edit);

  f.setMainWidget();
  curSubcentros.refreshBuffer();
  curSubcentros.setValueBuffer("datos", "");
  curSubcentros.setValueBuffer("filtro", filtro);

  var ret = f.exec("datos");

  if (!f.accepted())
    return false;

  var datos: String = new String(ret);

  if (datos.isEmpty())
    return false;

  var regExp: RegExp = new RegExp("'");
  regExp.global = true;
  datos = datos.replace(regExp, "");

  var subcentros: Array = datos.split(",");
  var curTab: FLSqlCursor = new FLSqlCursor("co_i_subcentros" + nomSubTabla);

  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Agregando subcentros"), subcentros.length);

  for (var i: Number = 0; i < subcentros.length; i++)
  {
    codSubcentro = subcentros[i];
    util.setProgress(paso++);

    curTab.select("codsubcentro = '" + codSubcentro + "' AND idinforme = " + idInforme);
    if (!curTab.first()) {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idinforme", idInforme);
      curTab.setValueBuffer("codsubcentro", codSubcentro);
      curTab.setValueBuffer("descripcion", util.sqlSelect("subcentroscoste", "descripcion", "codsubcentro = '" + codSubcentro + "'"));
      curTab.commitBuffer();
    }
  }

  util.destroyProgressDialog();
}

function centrosCoste_eliminarSubcentro(curInforme: FLSqlCursor, codSubcentro: String, nomSubTabla: String): Boolean {
  var util: FLUtil = new FLUtil();

  var idInforme: Number = curInforme.valueBuffer("id");
  var paso: Number = 0;

  var curTab: FLSqlCursor = new FLSqlCursor("co_i_subcentros" + nomSubTabla);

  // Un subcentro
  if (codSubcentro)
    curTab.select("codsubcentro = '" + codSubcentro + "' AND idinforme = " + idInforme);
  // Todos
  else
    curTab.select("idinforme = " + idInforme);

  util.createProgressDialog(util.translate("scripts", "Quitando subcentros"), curTab.size());
  while (curTab.next())
  {
    util.setProgress(paso++);
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
  util.destroyProgressDialog();
}

function centrosCoste_datoFacturasRecCC(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var idAsiento: Number = nodo.attributeValue("co_asientos.idasiento");
  var iva: Number = nodo.attributeValue("co_partidas.iva");
  var valor: Number;
  var where: String = "f.idasiento = " + idAsiento + " AND l.iva = " + iva;
  if (this.iface.listaCentros)
    where += " AND l.codcentro IN (" + this.iface.listaCentros + ")";
  if (this.iface.listaSubcentros)
    where += " AND l.codsubcentro IN (" + this.iface.listaSubcentros + ")";

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("facturasprov,lineasfacturasprov");
  q.setFrom("facturasprov f INNER JOIN lineasfacturasprov l ON f.idfactura = l.idfactura");
  q.setSelect("sum(l.pvptotal)");
  q.setWhere(where);
  q.exec();

  // de factura
  if (q.first())
    valor = q.value(0);

  // de asiento manual
  else
    valor = nodo.attributeValue("co_partidascc.importe");

  switch (campo)
  {
    case "bi":
      this.iface.totalFacturasRecCCBase += parseFloat(valor);
      break;
    case "iva":
      valor = parseFloat(valor * iva / 100);
      this.iface.totalFacturasRecCCIVA += parseFloat(valor);
      break;
    case "total":
      valor = parseFloat(valor + valor * iva / 100);
      this.iface.totalFacturasRecCCTotal += parseFloat(valor);
      break;
  }

  return valor;
}

function centrosCoste_datoTotalFacturasRecCC(nodo: FLDomNode, campo: String): String {
  switch (campo)
  {
    case "bi":
      return this.iface.totalFacturasRecCCBase;
      break;
    case "iva":
      return this.iface.totalFacturasRecCCIVA;
      break;
    case "total":
      return this.iface.totalFacturasRecCCTotal;
      break;
  }
}

function centrosCoste_lanzarBalance(cursor: FLSqlCursor)
{
  var util: FLUtil = new FLUtil;
  var idBalance = cursor.valueBuffer("id");

  // Por centros de coste, sólo PyG
  if (cursor.valueBuffer("tipo") == "Perdidas y ganancias")
    return pgc2008_lanzarBalance(cursor);

  if (util.sqlSelect("co_i_centroscuentasanuales", "idinforme", "idinforme = " + cursor.valueBuffer("id"))) {
    MessageBox.information(util.translate("scripts", "Esta cuenta tiene asociados centros y/o subcentros de coste.\nSólo es posible obtener la cuenta de Pérdidas y Ganancias por centros de coste.\nCambie el tipo de cuenta, o elimile los centros/subcentros de esta cuenta."),  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  return pgc2008_lanzarBalance(cursor);
}


function centrosCoste_popularBuffer(ejercicio: String, posicion: String, idBalance: Number, fechaDesde: String, fechaHasta: String, tablaCB: String, masWhere: String)
{
  var _i = this.iface;
  var oDatos = _i.dameDatosBuffer();
  oDatos.ejercicio = ejercicio;
  oDatos.posicion = posicion;
  oDatos.idBalance = idBalance;
  oDatos.fechaDesde = fechaDesde;
  oDatos.fechaHasta = fechaHasta;
  oDatos.tablaCB = tablaCB;
  oDatos.masWhere = masWhere;
  return _i.populaBuffer(oDatos);
}

function centrosCoste_populaBuffer(oDatos)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();

  var ejercicio = oDatos.ejercicio;
  var posicion = oDatos.posicion;
  var idBalance = oDatos.idBalance;
  var fechaDesde = oDatos.fechaDesde;
  var fechaHasta = oDatos.fechaHasta;
  var tablaCB = oDatos.tablaCB;
  var masWhere = oDatos.masWhere;
  var tablaCBPlan = oDatos.tablaCBPlan;
  var nombreBD = oDatos.nombreBD;

  if (!tablaCBPlan) {
    tablaCBPlan = "co_codbalances08";
  }

  var conexion;
  if (nombreBD != sys.nameBD()) {
    conexion = nombreBD + "_conn";
    if (!flcontinfo.iface.pub_conectar(nombreBD)) {
      return;
    }
    q = new FLSqlQuery("", conexion);
  } else {
    conexion = "default";
    q = new FLSqlQuery();
  }

  var qCC = new FLSqlQuery;
  qCC.setTablesList("co_i_centroscuentasanuales");
  qCC.setFrom("co_i_centroscuentasanuales");
  qCC.setSelect("codcentro");
  qCC.setWhere("idinforme = " + idBalance);
  if (!qCC.exec()) {
    return;
  }
  if (!qCC.size()) {
    /// Cambiado porque es lo suyo y además falla para Sinergia (fun_fundacionmf)
    return _i.__populaBuffer(oDatos);
  }

  var listaCentros: String = "";
  while (qCC.next()) {
    if (listaCentros) {
      listaCentros += ",";
    }
    listaCentros += "'" + qCC.value(0) + "'";
  }

  qCC.setTablesList("co_i_subcentroscuentasanuales");
  qCC.setFrom("co_i_subcentroscuentasanuales");
  qCC.setSelect("codsubcentro");
  qCC.setWhere("idinforme = " + idBalance);
  if (!qCC.exec()) {
    return;
  }
  var listaSubcentros: String = "";
  while (qCC.next()) {
    if (listaSubcentros) {
      listaSubcentros += ",";
    }
    listaSubcentros += "'" + qCC.value(0) + "'";
  }

  if (!masWhere) {
    masWhere = "";
  }
  if (listaSubcentros) {
    masWhere += " AND co_partidascc.codsubcentro IN (" + listaSubcentros + ")";
  } else {
    masWhere += " AND co_partidascc.codcentro IN (" + listaCentros + ")";
  }

  var from: String = "";
  var where: String = "";
  var codBalance: String;
  var codCuentaCB: String;

  var curTab: FLSqlCursor = new FLSqlCursor("co_i_balances08_datos")

  // Todas las naturalezas, se filtra más tarde
  where = "s.codejercicio = '" + ejercicio + "'";

  var idAsientoCierre: Number = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicio + "'");
  if (idAsientoCierre)
    where += " AND a.idasiento <> " + idAsientoCierre;

  var idAsientoPyG: Number = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + ejercicio + "'");
  if (idAsientoPyG)
    where += " AND a.idasiento <> " + idAsientoPyG;

  if (masWhere)
    where += masWhere;

  from = "co_subcuentas s INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta " +
         "INNER JOIN co_asientos a ON p.idasiento = a.idasiento " +
         "INNER JOIN co_partidascc ON p.idpartida = co_partidascc.idpartida";

  if (fechaDesde) where += " AND a.fecha >= '" + fechaDesde + "'";
  if (fechaHasta) where += " AND a.fecha <= '" + fechaHasta + "'";

  q.setTablesList("co_subcuentas,co_asientos,co_partidas");
  q.setFrom(from);
  q.setSelect("co_partidascc.importe,p.debe");


  // Bucle principal
  var qCB: FLSqlQuery = new FLSqlQuery();
  qCB.setTablesList(tablaCB + "," + tablaCBPlan);
  qCB.setFrom(tablaCB + " ccb INNER JOIN " + tablaCBPlan + " cb ON ccb.codbalance = cb.codbalance");
  qCB.setSelect("cb.codbalance,cb.naturaleza,ccb.codcuenta");
  qCB.setWhere("1=1 ORDER BY cb.naturaleza, cb.nivel1, cb.nivel2, cb.orden3, cb.nivel4");

  if (!qCB.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de códigos por cuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var paso: Number = 0;
  var suma: Number, sumaActual: Number;

  util.createProgressDialog(util.translate("scripts", "Recabando datos..."), qCB.size());

  var codCentro: String;

  while (qCB.next()) {

    debug(codBalance + " " + codCuentaCB);

    codBalance = qCB.value(0);
    naturaleza = qCB.value(1);
    codCuentaCB = qCB.value(2);

    util.setProgress(paso++);
    util.setLabelText(util.translate("scripts", "Recabando datos del ejercicio %0\n\nAnalizando código de balance\n").arg(ejercicio) + codBalance);

    q.setWhere(where + " and s.codcuenta like '" + codCuentaCB + "%'");

    if (!q.exec()) {
      debug(util.translate("scripts", "Error buscando cuentas ") + codCuentaCB, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      continue;
    }

    suma = 0;
    while (q.next()) {
      // Partida de debe?
      if (parseFloat(q.value(1)) > 0)
        suma += parseFloat(q.value(0));
      else
        suma -= parseFloat(q.value(0));
    }

    if (naturaleza == "P" || naturaleza == "PG")
      suma = 0 - suma;

    curTab.select("codbalance = '" + codBalance + "' and idbalance = " + idBalance);
    if (curTab.first()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
      sumaActual = parseFloat(curTab.valueBuffer(posicion));
    } else {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("codbalance", codBalance);
      curTab.setValueBuffer("idbalance", idBalance);
      sumaActual = 0;
    }

    suma += sumaActual;

    curTab.setValueBuffer(posicion, suma);
    curTab.commitBuffer();
  }

  util.destroyProgressDialog();

  return true;
}


function centrosCoste_establecerListasCentros(listaCentros: String, listaSubcentros: String)
{
  this.iface.listaCentros = listaCentros;
  this.iface.listaSubcentros = listaSubcentros;

  this.iface.totalFacturasRecCCBase = 0;
  this.iface.totalFacturasRecCCIVA = 0;
  this.iface.totalFacturasRecCCTotal = 0;

  debug(this.iface.listaCentros + " - " + this.iface.listaSubcentros)
}

function centrosCoste_cabeceraInforme(nodo: FLDomNode, campo: String): String {
  if (this.iface.nombreInformeActual != "co_i_facturasemi_cc" && this.iface.nombreInformeActual != "co_i_facturasrec_cc")
    return this.iface.__cabeceraInforme(nodo, campo);

  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var desc: String;
  var ejAct: String, ejAnt: String;
  var fchDesde: String, fchHasta: String;
  var fchDesdeAnt: String, fchHastaAnt: String;
  var sctDesde: String, sctHasta: String;
  var asiDesde: Number, asiHasta: Number;

  var texto: String;
  var sep: String = "       ";

  var tabla: String = "";
  if (this.iface.nombreInformeActual == "co_i_facturasemi_cc")
    tabla = "co_i_facturasemi";
  if (this.iface.nombreInformeActual == "co_i_facturasrec_cc")
    tabla = "co_i_facturasrec";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();

  qCondiciones.setTablesList(tabla);
  qCondiciones.setFrom(tabla);
  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (texCampo)
  {
    case "facturasemi":
    case "facturasrec":

      qCondiciones.
      setSelect
      ("descripcion,i_co__cuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);
      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      texto = "[ " + desc + " ]" + sep +
      "Ejercicio " + ejAct + sep +
      "Periodo  " + fchDesde + " - " + fchHasta;

      break;


    default:
      texto = this.iface.__cabeceraInforme(nodo, campo);
      break;

  }

  return texto;
}

function centrosCoste_datosMayorCC(nodo: FLDomNode, campo: String): String {
  var valor: Number = 0;
  switch (campo)
  {
    case "debe": {
      var debe = nodo.attributeValue("co_partidas.debe");
      if (debe && debe != 0) {
        valor = nodo.attributeValue("SUM(co_partidascc.importe)");
      } else {
        valor = 0;
        debe = 0;
      }
      /// Comprobación redundante de signo
      valor = Math.abs(valor) * ((debe > 0) ? 1 : -1)
              break;
    }
    case "haber": {
      var haber = nodo.attributeValue("co_partidas.haber");
      if (haber && haber != 0) {
        valor = nodo.attributeValue("SUM(co_partidascc.importe)");
      } else {
        valor = 0;
        haber = 0;
      }
      /// Comprobación redundante de signo
      valor = Math.abs(valor) * ((haber > 0) ? 1 : -1)
              break;
    }
  }

  return valor;
}
//// CENTROS COSTE /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
