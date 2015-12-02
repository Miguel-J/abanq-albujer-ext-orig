
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
class lotesEnv extends envases
{
  function lotesEnv(context)
  {
    envases(context);
  }
  function copiarMoviLoteLineaRec(idLinea, idLineaOriginal, factor)
  {
    return this.ctx.lotesEnv_copiarMoviLoteLineaRec(idLinea, idLineaOriginal, factor);
  }
}
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
function lotesEnv_copiarMoviLoteLineaRec(idLinea, idLineaOriginal, factor)
{
  var util: FLUtil = new FLUtil;

  var curLinea = this.child("tdbLineasFacturasCli").cursor();
  curLinea.select("idlinea = " + idLinea);
  if (!curLinea.first()) {
    return false;
  }
  curLinea.setModeAccess(curLinea.Browse);
  curLinea.refreshBuffer();
  if (!flfacturac.iface.pub_lineaPorLotes(curLinea)) {
    return true;
  }

  var fecha: String = util.sqlSelect("lineasfacturascli lf INNER JOIN facturascli f ON lf.idfactura = f.idfactura", "f.fecha", "idlinea = " + idLinea, "facturascli,lineasfacturascli");

  var curMoviOriginal: FLSqlCursor = new FLSqlCursor("movilote");
  this.iface.curMoviLoteRec_ = new FLSqlCursor("movilote");

  var camposML = util.nombreCampos("movilote");
  var totalCampos: Number = camposML[0];
  curMoviOriginal.select("idlineafc = " + idLineaOriginal);
  var movimientos = curMoviOriginal.size();
  if (!movimientos) {
    return true;
  }
  var cantidad;
  while (curMoviOriginal.next()) {
    curMoviOriginal.setModeAccess(curMoviOriginal.Browse);
    curMoviOriginal.refresh();
    this.iface.curMoviLoteRec_.setModeAccess(this.iface.curMoviLoteRec_.Insert);
    this.iface.curMoviLoteRec_.refresh();
    this.iface.curMoviLoteRec_.setValueBuffer("idlineafc", idLinea);
    this.iface.curMoviLoteRec_.setValueBuffer("fecha", fecha);

    var campoInformado = [];
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[camposML[i]] = false;
    }
    if (movimientos == 1) {
      /// Solo se permite variar la cantidad en la rectificación si hay un único lote asociado a la línea
      cantidad = util.sqlSelect("lineasfacturascli", "canenvases", "idlinea = " + idLinea);
      cantidad *= -1;
    } else {
      cantidad = curMoviOriginal.valueBuffer("canenvases") * factor;
    }
    this.iface.curMoviLoteRec_.setValueBuffer("canenvases", cantidad);
    this.iface.curMoviLoteRec_.setValueBuffer("valormetrico", curMoviOriginal.valueBuffer("valormetrico"));
    this.iface.curMoviLoteRec_.setValueBuffer("cantidad", cantidad * curMoviOriginal.valueBuffer("valormetrico"));
    campoInformado["canenvases"] = true;
    campoInformado["valormetrico"] = true;
    campoInformado["cantidad"] = true;


    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoMoviRec(camposML[i], curMoviOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curMoviLoteRec_.commitBuffer()) {
      return false;
    }
  }

  return true;
}
//// TRAZABILIDAD + ENVASES /////////////////////////////////////
/////////////////////////////////////////////////////////////////
