
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial
{
  var aEnvase_; /// Array con los datos del envase actual
  function envases(context)
  {
    oficial(context);
  }
  function datosLineaVentaCantidad()
  {
    return this.ctx.envases_datosLineaVentaCantidad();
  }
  function bufferChanged(fN)
  {
    return this.ctx.envases_bufferChanged(fN);
  }
  function buscarEnvase(codEnvase)
  {
    return this.ctx.envases_buscarEnvase(codEnvase);
  }
  function datosLineaVentaArt()
  {
    return this.ctx.envases_datosLineaVentaArt();
  }
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_bufferChanged(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  switch (fN) {
    case "codbarras": {
      this.iface.aEnvase_ = false;
      this.child("lblCanEnvase").text = "x 1";
      var codBarras = cursor.valueBuffer("codbarras");
      if (!codBarras || codBarras == "") {
        break;
      }
      if (!this.iface.buscarEnvase(codBarras)) {
        this.iface.__bufferChanged(fN);
      }
      break;
    }
    case "referencia": {
      this.iface.aEnvase_ = false;
      this.child("lblCanEnvase").text = "x 1";
      this.iface.__bufferChanged(fN);
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function envases_buscarEnvase(codEnvase)
{
  var util = new FLUtil;
  var cursor = this.cursor();

  var qryEnvase = new FLSqlQuery;
  qryEnvase.setTablesList("envases");
  qryEnvase.setSelect("codenvase, cantidad, referencia");
  qryEnvase.setFrom("envases");
  qryEnvase.setWhere("codenvase = '" + codEnvase + "'");
  qryEnvase.setForwardOnly(true);
  if (!qryEnvase.exec()) {
    return false;
  }
  if (!qryEnvase.first()) {
    return false;
  }
  this.child("fdbReferencia").setValue(qryEnvase.value("referencia"));
  this.iface.aEnvase_ = [];
  this.iface.aEnvase_["codenvase"] = qryEnvase.value("codenvase");
  this.iface.aEnvase_["cantidad"] = qryEnvase.value("cantidad");
  this.child("lblCanEnvase").text = "x " + this.iface.aEnvase_["cantidad"];
  return true;
}

function envases_datosLineaVentaCantidad()
{
  if (!this.iface.aEnvase_) {
    return this.iface.__datosLineaVentaCantidad();
  }
  var util = new FLUtil;
  var cursor = this.cursor();

  this.iface.curLineas.setValueBuffer("valormetrico", this.iface.aEnvase_["cantidad"]);
  this.iface.curLineas.setValueBuffer("canenvases", util.roundFieldValue(this.iface.txtCanArticulo.text, "tpv_lineascomanda", "cantidad"));
  this.iface.curLineas.setValueBuffer("cantidad", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("cantidad", this.iface.curLineas));

  return true;
}

function envases_datosLineaVentaArt()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  if (this.iface.aEnvase_) {
    this.iface.curLineas.setValueBuffer("codenvase", this.iface.aEnvase_["codenvase"]);
  }
  if (!this.iface.__datosLineaVentaArt()) {
    return false;
  }
  return true;
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
