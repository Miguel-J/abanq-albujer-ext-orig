
/** @class_declaration ccPGC2008 */
//////////////////////////////////////////////////////////////////
//// CC PGC 2008 ///////////////////////////////////////////
class ccPGC2008 extends pgc2008
{
  function ccPGC2008(context)
  {
    pgc2008(context);
  }
  function popularBuffer(ejercicio: String, posicion: String, idBalance: Number, fechaDesde: String, fechaHasta: String, tablaCB: String)
  {
    return this.ctx.ccPGC2008_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB);
  }
  function cabeceraInforme(nodo: FLDomNode, campo: String): String {
    return this.ctx.ccPGC2008_cabeceraInforme(nodo, campo);
  }
}
//// CC PGC 2008 ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ccPGC2008 */
/////////////////////////////////////////////////////////////////
//// CC PGC 2008 //////////////////////////////////////////

/** Si la cuenta es por centro/subcentro, se filtra la consulta
*/
function ccPGC2008_popularBuffer(ejercicio: String, posicion: String, idBalance: Number, fechaDesde: String, fechaHasta: String, tablaCB: String, masWhere: String)
{
  var util: FLUtil = new FLUtil();

  var datosCentro: Array = flfactppal.iface.ejecutarQry("co_i_cuentasanuales", "codcentro,codsubcentro", "id = " + idBalance);
  if (datosCentro.result < 1)
    return this.iface.__popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);

  var masWhere: String = "";

  if (datosCentro.codcentro)
    masWhere += " AND a.codcentro = '" + datosCentro.codcentro + "'";
  if (datosCentro.codsubcentro)
    masWhere += " AND a.codsubcentro = '" + datosCentro.codsubcentro + "'";

  debug(masWhere);

  return this.iface.__popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);
}

function ccPGC2008_cabeceraInforme(nodo: FLDomNode, campo: String): String {
  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var desc: String;
  var ejAct: String, ejAnt: String;

  var texto: String;
  var sep: String = "       ";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();

  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  var datosCentro: Array = flfactppal.iface.ejecutarQry("co_i_cuentasanuales", "codcentro,codsubcentro", "id = " + this.iface.idInformeActual);
  if (datosCentro.result < 1)
    return this.iface.__cabeceraInforme(nodo, campo);


  var masTit: String = "";

  if (datosCentro.codcentro)
    masTit += util.translate("scripts", "Centro ") + util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + datosCentro.codcentro + "'");
  if (datosCentro.codsubcentro)
    masTit += "   " + util.translate("scripts", "Subcentro ") + util.sqlSelect("subcentroscoste", "descripcion", "codsubcentro = '" + datosCentro.codsubcentro + "'");


  switch (texCampo)
  {

    case "balancepyg08":
    case "titSituacion":
    case "titSituacionAbr":
    case "titIG":
    case "titIGAbr":
      texto = this.iface.__cabeceraInforme(nodo, campo);
      texto += "   " + masTit;

      break;
      return this.iface.__cabeceraInforme(nodo, campo);
  }

  if (!texto)
    texto = "";

  return texto;
}

//// CC PGC 2008 //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
