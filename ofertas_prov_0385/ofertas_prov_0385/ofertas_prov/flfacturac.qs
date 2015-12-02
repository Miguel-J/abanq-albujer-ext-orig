
/** @class_declaration ofertasProv */
/////////////////////////////////////////////////////////////////
//// OFERTAS_PROV //////////////////////////////////////////////
class ofertasProv extends oficial
{
  function ofertasProv(context)
  {
    oficial(context);
  }
  function aceptarOferta(curLineaOferta: FLSqlCursor): Boolean {
    return this.ctx.ofertasProv_aceptarOferta(curLineaOferta);
  }
  function cargarDatosSolOferta(curSolOferta: FLSqlCursor): Boolean {
    return this.ctx.ofertasProv_cargarDatosSolOferta(curSolOferta);
  }
  function beforeCommit_presupuestosprov(curPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.ofertasProv_beforeCommit_presupuestosprov(curPresupuesto);
  }
}
//// OFERTAS_PROV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pub_ofertas_prov */
/////////////////////////////////////////////////////////////////
//// PUB_OFERTAS_PROV //////////////////////////////////////////
class pub_ofertas_prov extends head
{
  function pub_ofertas_prov(context)
  {
    head(context);
  }
  function pub_aceptarOferta(curLineaOferta: FLSqlCursor): Boolean {
    return this.aceptarOferta(curLineaOferta);
  }
  function pub_cargarDatosSolOferta(curSolOferta: FLSqlCursor): Boolean {
    return this.cargarDatosSolOferta(curSolOferta);
  }
}

//// PUB_OFERTAS_PROV //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ofertasProv */
/////////////////////////////////////////////////////////////////
//// OFERTAS_PROV ///////////////////////////////////////////////
function ofertasProv_aceptarOferta(curLineaOferta: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var referencia: String = curLineaOferta.valueBuffer("referencia");
  if (!referencia || referencia == "")
  {
    MessageBox.information(util.translate("scripts", "No está informado el artículo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codProveedor: String = curLineaOferta.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
  {
    MessageBox.information(util.translate("scripts", "No está informado el código del proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var precio: Number = curLineaOferta.valueBuffer("pvpunitario");
  if (!precio || precio == "")
  {
    MessageBox.information(util.translate("scripts", "No está informado el precio del artículo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var dto: Number = curLineaOferta.valueBuffer("dto");

  if (!util.sqlUpdate("lineaspresupuestosprov", "aprobado", false, "codsolicitud = '" +  curLineaOferta.valueBuffer("codsolicitud") + "' AND referencia = '" + referencia + "'"))
    return false;

  if (!util.sqlUpdate("lineaspresupuestosprov", "aprobado", true, "codsolicitud = '" +  curLineaOferta.valueBuffer("codsolicitud") + "' AND referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'"))
    return false;

  var curLineaSolic: FLSqlCursor = new FLSqlCursor("lineassolpresupuestosprov");
  curLineaSolic.select("referencia = '" + referencia + "' AND codsolicitud = '" + curLineaOferta.valueBuffer("codsolicitud") + "'");
  if (!curLineaSolic.first())
    return false;

  curLineaSolic.setModeAccess(curLineaSolic.Edit);
  curLineaSolic.refreshBuffer();

  curLineaSolic.setValueBuffer("codproveedor", codProveedor);
  curLineaSolic.setValueBuffer("nombre", util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'"));
  curLineaSolic.setValueBuffer("coste", precio);
  curLineaSolic.setValueBuffer("pordtocoste", dto);
  curLineaSolic.setValueBuffer("margen", formRecordlineassolpresupuestosprov.iface.pub_commonCalculateField("margen", curLineaSolic));
  curLineaSolic.setValueBuffer("beneficio", formRecordlineassolpresupuestosprov.iface.pub_commonCalculateField("beneficio", curLineaSolic));
  curLineaSolic.setValueBuffer("confirmado", true);

  if (!curLineaSolic.commitBuffer())
    return false;

  return true;
}

function ofertasProv_cargarDatosSolOferta(curSolOferta: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var idPresupuesto: String = curSolOferta.valueBuffer("idpresupuestocli");
  if (!idPresupuesto)
  {
    return false;
  }

  var qryLinea: FLSqlQuery = new FLSqlQuery();
  qryLinea.setTablesList("lineassolpresupuestosprov");
  qryLinea.setSelect("idlinea");
  qryLinea.setFrom("lineassolpresupuestosprov");
  qryLinea.setWhere("codsolicitud = '" + curSolOferta.valueBuffer("codsolicitud") + "'");
  if (!qryLinea.exec())
    return false;
  if (qryLinea.first())
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "Se borraran los datos existentes antes de cargar los nuevos.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res == MessageBox.Yes) {
      util.sqlDelete("lineassolpresupuestosprov", "codsolicitud = '" + curSolOferta.valueBuffer("codsolicitud") + "'");
    } else {
      return;
    }
  }

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("lineaspresupuestoscli");
  qry.setSelect("referencia, SUM(cantidad)");
  qry.setFrom("lineaspresupuestoscli");
  qry.setWhere("idpresupuesto = " + idPresupuesto + " GROUP BY referencia");
  if (!qry.exec())
    return false;
  var curLineasSolPresupuestosProv: FLSqlCursor = new FLSqlCursor("lineassolpresupuestosprov");

  var datosArticulo: Array;
  var descripcion: String;
  var precioVta: Number;
  var coste: Number;
  var dto: Number;
  var margen: Number;
  var beneficio: Number;
  var fecha: String;
  var oferta: String;
  var proveedores: Number;

  while (qry.next())
  {
    referencia = qry.value("referencia");
    datosArticulo = flfactppal.iface.ejecutarQry("articulos a INNER JOIN articulosprov ap ON a.referencia = ap.referencia", "a.descripcion,ap.coste,ap.codproveedor,ap.dto,ap.nombre", "a.referencia = '" + referencia + "' AND ap.pordefecto = true", "articulos,articulosprov");
    if (datosArticulo.result != 1) {
      MessageBox.warning(util.translate("scripts", "Error al obtener los datos del artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    curLineasSolPresupuestosProv.setModeAccess(curLineasSolPresupuestosProv.Insert);
    curLineasSolPresupuestosProv.refreshBuffer();
    curLineasSolPresupuestosProv.setValueBuffer("codsolicitud", curSolOferta.valueBuffer("codsolicitud"));
    curLineasSolPresupuestosProv.setValueBuffer("referencia", qry.value("referencia"));

    descripcion = datosArticulo["a.descripcion"];
    curLineasSolPresupuestosProv.setValueBuffer("descripcion", descripcion);
    curLineasSolPresupuestosProv.setValueBuffer("canpresupuesto", qry.value("SUM(cantidad)"));
    curLineasSolPresupuestosProv.setValueBuffer("cansolicitada", qry.value("SUM(cantidad)"));

    precioVta = util.sqlSelect("lineaspresupuestoscli", "pvpunitario", "referencia = '" + qry.value("referencia") + "' AND idpresupuesto = " + idPresupuesto);
    if (precioVta)
      curLineasSolPresupuestosProv.setValueBuffer("pvpunitario", precioVta);
    else
      curLineasSolPresupuestosProv.setValueBuffer("pvpunitario", 0);

    coste = datosArticulo["ap.coste"];
    if (coste)
      curLineasSolPresupuestosProv.setValueBuffer("coste", coste);
    else
      curLineasSolPresupuestosProv.setValueBuffer("coste", 0);

    dto = datosArticulo["ap.dto"];
    var dtoTotal: Number;
    if (dto) {
      curLineasSolPresupuestosProv.setValueBuffer("pordtocoste", dto);
      dtoTotal = (coste * dto) / 100;
    } else {
      curLineasSolPresupuestosProv.setValueBuffer("pordtocoste", 0);
      dtoTotal = 0;
    }

    if (precioVta != 0) {
      margen = (precioVta - (coste - dtoTotal)) * 100 / precioVta;
    } else {
      margen = 0;
    }
    curLineasSolPresupuestosProv.setValueBuffer("margen", margen);

    beneficio = precioVta - coste * (100 - dto) / 100;
    curLineasSolPresupuestosProv.setValueBuffer("beneficio", beneficio);

    curLineasSolPresupuestosProv.setValueBuffer("codproveedorant", datosArticulo["ap.codproveedor"]);
    curLineasSolPresupuestosProv.setValueBuffer("nombreant", datosArticulo["ap.nombre"]);

    var hoy: Date = new Date();
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("presupuestosprov,lineaspresupuestosprov");
    q.setSelect("p.femision, p.idpresupuesto");
    q.setFrom("presupuestosprov p INNER JOIN lineaspresupuestosprov l ON p.idpresupuesto = l.idpresupuesto");
    q.setWhere("l.referencia = '" + qry.value("referencia") + "' ORDER BY p.femision DESC");
    if (!q.exec())
      return false;
    if (q.first()) {
      fecha = q.value("p.femision");
      oferta = q.value("p.idpresupuesto");
    } else {
      fecha = hoy;
      oferta = "";
    }
    curLineasSolPresupuestosProv.setValueBuffer("fecha", fecha);
    curLineasSolPresupuestosProv.setValueBuffer("codoferta", oferta);

    proveedores = util.sqlSelect("articulosprov", "COUNT(codproveedor)", "referencia = '" + qry.value("referencia") + "'");
    curLineasSolPresupuestosProv.setValueBuffer("proveedores", proveedores);
    curLineasSolPresupuestosProv.setValueBuffer("confirmado", false);

    if (!curLineasSolPresupuestosProv.commitBuffer())
      return false;
  }

  return true;
}

/* \C Se calcula el número del presupuesto como el siguiente de la secuencia asociada a su ejercicio y serie.
\end */
function ofertasProv_beforeCommit_presupuestosprov(curPresupuesto: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var numero: String;

  switch (curPresupuesto.modeAccess())
  {
    case curPresupuesto.Insert: {
      if (curPresupuesto.valueBuffer("numero") == 0) {
        numero = this.iface.siguienteNumero(curPresupuesto.valueBuffer("codserie"), curPresupuesto.valueBuffer("codejercicio"), "npresupuestoprov");
        if (!numero)
          return false;
        curPresupuesto.setValueBuffer("numero", numero);
        curPresupuesto.setValueBuffer("codigo", formpresupuestosprov.iface.pub_commonCalculateField("codigo", curPresupuesto));
      }
      break;
    }
  }

  return true;
}

//// OFERTAS_PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
