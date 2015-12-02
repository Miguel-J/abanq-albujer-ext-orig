
/** @class_declaration cambioEjerAlb */
/////////////////////////////////////////////////////////////////
//// CAMBIO_EJER_ALB ////////////////////////////////////////////
class cambioEjerAlb extends oficial
{
  var tbnCambiarEjercicio: Object;
  function cambioEjerAlb(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.cambioEjerAlb_init()
  }
         function tbnCambiarEjercicio_clicked()
  {
    return this.ctx.cambioEjerAlb_tbnCambiarEjercicio_clicked();
  }
  function cambiarEjercicio(codEjercicio: String, codSerie: String): String {
    return this.ctx.cambioEjerAlb_cambiarEjercicio(codEjercicio, codSerie);
  }
  function cambiarDatosLinea(curLineas: FLSqlCursor, tieneIva: Number): Boolean {
    return this.ctx.cambioEjerAlb_cambiarDatosLinea(curLineas, tieneIva);
  }
}
//// CAMBIO_EJER_ALB ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cambioEjerAlb */
/////////////////////////////////////////////////////////////////
//// CAMBIO_EJER_ALB /////////////////////////////////////////////
function cambioEjerAlb_init()
{
  this.iface.__init();

  this.iface.tbnCambiarEjercicio = this.child("tbnCambiarEjercicio");
  connect(this.iface.tbnCambiarEjercicio, "clicked()", this, "iface.tbnCambiarEjercicio_clicked");
}

function cambioEjerAlb_tbnCambiarEjercicio_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var idAlbaran: String = cursor.valueBuffer("idalbaran");
  if (!idAlbaran)
    return;

  var f: Object = new FLFormSearchDB("cambioejercicio");
  var curCambioEjercicio: FLSqlCursor = f.cursor();
  curCambioEjercicio.setActivatedCheckIntegrity(false);
  curCambioEjercicio.select();
  if (!curCambioEjercicio.first()) {
    curCambioEjercicio.setModeAccess(cursor.Insert);
  } else {
    curCambioEjercicio.setModeAccess(cursor.Edit);
  }

  f.setMainWidget();
  curCambioEjercicio.refreshBuffer();

  var id: String = f.exec("id");
  if (!id) {
    return;
  }

  var codEjercicio: String = curCambioEjercicio.valueBuffer("codejercicio");
  if (!util.sqlSelect("secuenciasejercicios", "id", "codejercicio = '" + codEjercicio + "' AND codserie = '" + curCambioEjercicio.valueBuffer("codserie") + "'")) {
    MessageBox.warning(util.translate("scripts", "La serie no pertenece al ejercicio"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  if (!codEjercicio || codEjercicio == "") {
    return;
  }

  var codNuevo: String;
  cursor.transaction(false);
  try {
    codNuevo = this.iface.cambiarEjercicio(codEjercicio, curCambioEjercicio.valueBuffer("codserie"));
    if (codNuevo) {
      cursor.commit();
      MessageBox.information(util.translate("scripts", "El nuevo código del albarán seleccionado es %1").arg(codNuevo), MessageBox.Ok, MessageBox.NoButton);
    } else
      cursor.rollback();
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en el cambio de ejercicio:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }

  this.iface.tdbRecords.refresh();
}

function cambioEjerAlb_cambiarEjercicio(codEjercicio: String, codSerie: String): String {
  var util: FLUtil = new FLUtil();
  var curAlbaran: FLSqlCursor = new FLSqlCursor("albaranesprov");
  var cursor: FLSqlCursor = this.cursor();
  var idAlbaran: String = cursor.valueBuffer("idalbaran");
  var codAlbaran: String = cursor.valueBuffer("codigo");
  var codProveedor: String = cursor.valueBuffer("codProveedor");

  var numero: String = flfacturac.iface.pub_siguienteNumero(codSerie, codEjercicio, "nalbaranprov");
  if (!numero)
  {
    return false;
  }

  curAlbaran.setActivatedCommitActions(false);
  curAlbaran.select("idalbaran = " + idAlbaran);
  if (!curAlbaran.first())
  {
    return false;
  }
  curAlbaran.setModeAccess(curAlbaran.Edit);
  curAlbaran.refreshBuffer();
  curAlbaran.setValueBuffer("codejercicio", codEjercicio);
  curAlbaran.setValueBuffer("codserie", codSerie);
  curAlbaran.setValueBuffer("numero", numero);
  var codigo: String = formalbaranesprov.iface.pub_commonCalculateField("codigo", curAlbaran);
  curAlbaran.setValueBuffer("codigo", codigo);
  if (!curAlbaran.commitBuffer())
    return false;

  var tieneIva: Number = flfacturac.iface.pub_tieneIvaDocProveedor(codSerie, codProveedor, codEjercicio);
  debug("tieneIva " + tieneIva);
  //  Devuelve 3 posibles valores:
  //    0: Si no debe tener ni IVA ni recargo de equivalencia,
  //    1: Si debe tener IVA pero no recargo de equivalencia,
  //    2: Si debe tener IVA y recargo de equivalencia

  var curLineas: FLSqlCursor = new FLSqlCursor("lineasalbaranesprov");
  curLineas.setActivatedCommitActions(false);
  curLineas.select("idalbaran = " + idAlbaran);
  var codImpuesto: String;

  while (curLineas.next())
  {
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer();
    if (!this.iface.cambiarDatosLinea(curLineas, tieneIva))
      return false;
    if (!curLineas.commitBuffer())
      return false;
  }

  curAlbaran.select("idalbaran = " + idAlbaran);
  if (!curAlbaran.first())
    return false;

  curAlbaran.setModeAccess(curAlbaran.Edit);
  curAlbaran.refreshBuffer();
  curAlbaran.setValueBuffer("totaliva", this.iface.commonCalculateField("totaliva", curAlbaran));
  curAlbaran.setValueBuffer("totalrecargo", this.iface.commonCalculateField("totalrecargo", curAlbaran));
  curAlbaran.setValueBuffer("total", this.iface.commonCalculateField("total", curAlbaran));
  curAlbaran.setValueBuffer("totaleuros", this.iface.commonCalculateField("totaleuros", curAlbaran));
  if (!curAlbaran.commitBuffer())
    return false;

  return codigo;
}

function cambioEjerAlb_cambiarDatosLinea(curLineas: FLSqlCursor, tieneIva: Number): Boolean {
  var util: FLUtil;
  var codImpuesto: String;
  var cursor: FLSqlCursor = this.cursor();

  if (tieneIva == 0)
  {
    curLineas.setValueBuffer("codimpuesto", "");
    curLineas.setValueBuffer("iva", 0);
    curLineas.setValueBuffer("recargo", 0);
  } else {
    codImpuesto = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + curLineas.valueBuffer("referencia") + "'");
    if (!codImpuesto)
      codImpuesto = "IVA16";

    curLineas.setValueBuffer("codimpuesto", codImpuesto);
    curLineas.setValueBuffer("iva", flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, cursor.valueBuffer("fecha")));

    if (tieneIva == 1)
      curLineas.setValueBuffer("recargo", 0);
    else
      curLineas.setValueBuffer("recargo", flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, cursor.valueBuffer("fecha")));
  }

  return true;
}
//// CAMBIO_EJER_ALB /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
