
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial
{
  function envases(context)
  {
    oficial(context);
  }
  function copiarLineasRec(idFacturaOriginal, aLineas, factor)
  {
    return this.ctx.envases_copiarLineasRec(idFacturaOriginal, aLineas, factor);
  }
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_copiarLineasRec(idFacturaOriginal, aLineas, factor)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    var curLineas: FLSqlCursor = this.child("tdbLineasFacturasCli").cursor();
    if (!curLineas.commitBufferCursorRelation()) {
      return false;
    }
  }

  var curLineaOriginal: FLSqlCursor = new FLSqlCursor("lineasfacturascli");
  this.iface.curLineaRectificacion_ = new FLSqlCursor("lineasfacturascli");

  var camposLinea: Array = util.nombreCampos("lineasfacturascli");
  var totalCampos: Number = camposLinea[0];
  var idLinea, cantidad, codEnvase;
  for (var i = 0; i < aLineas.length; i++) {
    curLineaOriginal.select("idlinea = " + aLineas[i]["idlinea"]);
    if (!curLineaOriginal.first()) {
      return false;
    }
    var campoInformado = [];
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[camposLinea[i]] = false;
    }

    curLineaOriginal.setModeAccess(curLineaOriginal.Browse);
    curLineaOriginal.refresh();
    this.iface.curLineaRectificacion_.setModeAccess(this.iface.curLineaRectificacion_.Insert);
    this.iface.curLineaRectificacion_.refresh();

    this.iface.curLineaRectificacion_.setValueBuffer("canenvases", aLineas[i]["cantidad"]);
    this.iface.curLineaRectificacion_.setValueBuffer("valormetrico", curLineaOriginal.valueBuffer("valormetrico"));
    this.iface.curLineaRectificacion_.setValueBuffer("cantidad", aLineas[i]["cantidad"] * curLineaOriginal.valueBuffer("valormetrico"));
    campoInformado["canenvases"] = true;
    campoInformado["valormetrico"] = true;
    campoInformado["cantidad"] = true;

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoLineaRec(camposLinea[i], curLineaOriginal, factor, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curLineaRectificacion_.commitBuffer()) {
      return false;
    }
    idLinea = this.iface.curLineaRectificacion_.valueBuffer("idlinea");
    if (!this.iface.copiarDatosLineaRec(idLinea, curLineaOriginal.valueBuffer("idlinea"), factor)) {
      return false;
    }
  }

  this.iface.calcularTotales();
  this.child("tdbLineasFacturasCli").refresh();

  return true;
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
