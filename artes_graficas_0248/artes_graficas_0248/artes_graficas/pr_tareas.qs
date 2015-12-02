
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
class artesG extends prod
{
  var xmlItinerario_: FLDomDocument;
  function artesG(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function mostrarPrecorte()
  {
    return this.ctx.artesG_mostrarPrecorte();
  }
  function mostrarTrabajosPliego()
  {
    return this.ctx.artesG_mostrarTrabajosPliego();
  }
  function tbnZoomPI_clicked()
  {
    return this.ctx.artesG_tbnZoomPI_clicked();
  }
  function tbwTarea_currentChanged(tabName: String)
  {
    return this.ctx.artesG_tbwTarea_currentChanged(tabName);
  }
}
//// ARTES GRAFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
function artesG_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenidoItinerario: String = util.sqlSelect("pr_procesos", "xmlparametros", "idproceso = " + cursor.valueBuffer("idproceso"));
  if (!contenidoItinerario) {
    return;
  }

  this.iface.xmlItinerario_ = new FLDomDocument;
  this.iface.xmlItinerario_.setContent(contenidoItinerario);


  this.iface.mostrarPrecorte();
  this.iface.mostrarTrabajosPliego()

  connect(this.child("tbnZoomPI"), "clicked()", this, "iface.tbnZoomPI_clicked");
  connect(this.child("tbwTarea"), "currentChanged(QString)", this, "iface.tbwTarea_currentChanged()");
}

function artesG_mostrarPrecorte()
{
  if (!this.iface.xmlItinerario_) {
    return false;
  }

  var dimPliego: String = flfacturac.iface.pub_dameAtributoXML(this.iface.xmlItinerario_.firstChild(), "Parametros/PliegoParam@AreaPliego");
  if (!dimPliego || dimPliego == "") {
    return false;
  }

  var xmlPliegoImpresionParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(this.iface.xmlItinerario_.firstChild(), "Parametros/PliegoImpresionParam");
  if (!xmlPliegoImpresionParam)
    return false;

  flfacturac.iface.pub_mostrarPrecorte(this.child("lblDiagPrecorte"), xmlPliegoImpresionParam, dimPliego);
}

function artesG_mostrarTrabajosPliego()
{
  var dimPI: String = flfacturac.iface.pub_dameAtributoXML(this.iface.xmlItinerario_.firstChild(), "Parametros/PliegoImpresionParam@Valor");
  if (!dimPI || dimPI == "") {
    return false;
  }

  flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagDistPlancha"), this.iface.xmlItinerario_.firstChild(), dimPI, false);

  return true;
}

function artesG_tbnZoomPI_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var dimPI: String = flfacturac.iface.pub_dameAtributoXML(this.iface.xmlItinerario_.firstChild(), "Parametros/PliegoImpresionParam@Valor");
  if (!dimPI || dimPI == "") {
    return false;
  }

  var arrayPI: Array = dimPI.split("x");

  var nodoParametros: FLDomNode = this.iface.xmlItinerario_.firstChild().namedItem("Parametros");
  if (!nodoParametros) {
    debug("!nodoParametros");
    return false;
  }
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  xmlDocAux.appendChild(nodoParametros.cloneNode());
  var parametros: String = xmlDocAux.toString(4);

  var idUsuario = sys.nameUser();
  if (!util.sqlDelete("parampliego", "idusuario = '" + idUsuario + "'")) {
    return false;
  }

  var f: Object = new FLFormSearchDB("parampliego");
  var curPP: FLSqlCursor = f.cursor();

  curPP.setModeAccess(curPP.Insert);
  curPP.refreshBuffer();
  curPP.setValueBuffer("idusuario", idUsuario);
  curPP.setValueBuffer("xml", parametros);
  curPP.setValueBuffer("altopi", arrayPI[1]);
  curPP.setValueBuffer("anchopi", arrayPI[0]);

  f.setMainWidget();
  var xml: String = f.exec("xml");

}

function artesG_tbwTarea_currentChanged(tabName: String)
{
  var util: FLUtil = new FLUtil;

  switch (tabName) {
    case "resumen": {
      var cursor: FLSqlCursor = this.cursor();
      var codLote: String = cursor.valueBuffer("idobjeto");
      var referencia: String = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");
      if (!referencia) {
        return false;
      }
      var resumen: String;
      switch (referencia) {
        case "IPTICO": {
          resumen = formRecorditinerarioslp.iface.pub_resumenIptico(this.iface.xmlItinerario_);
          break;
        }
        case "LIBRO": {
          resumen = formRecorditinerarioslp.iface.pub_resumenLibro(this.iface.xmlItinerario_);
          break;
        }
      }
      this.child("lblResumen").text = resumen;
      break;
    }
  }
}

//// ARTES GRAFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
