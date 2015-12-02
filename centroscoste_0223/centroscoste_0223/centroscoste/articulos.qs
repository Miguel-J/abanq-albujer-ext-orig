
/** @class_declaration cCoste */
/////////////////////////////////////////////////////////////////////
//// FUNDACUIONMF ///////////////////////////////////////////
class cCoste extends oficial
{
  function cCoste(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.cCoste_init();
  }
  function actualizaFactorAcceso()
  {
    return this.ctx.cCoste_actualizaFactorAcceso();
  }
  function calculateField(fN)
  {
    return this.ctx.cCoste_calculateField(fN);
  }
}
//// FUNDACUIONMF ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////

/** @class_definition cCoste */
/////////////////////////////////////////////////////////////////////
//// CENTROS DE COSTE ///////////////////////////////////////////////
function cCoste_init()
{
  this.iface.__init();
  connect(this.child("fdbArticulosCC").cursor(), "bufferCommited()", this, "iface.actualizaFactorAcceso");
}

function cCoste_actualizaFactorAcceso()
{
  this.child("fdbFactorAcceso").setValue(this.iface.calculateField("factoracceso"));
}

function cCoste_calculateField(fN)
{
  var valor;
  var cursor = this.cursor();
  switch (fN) {
    case "factoracceso": {
      var qryFA = new FLSqlQuery;
      qryFA.setTablesList("articuloscc,centroscoste");
      qryFA.setSelect("cc.factoracceso");
      qryFA.setFrom("articuloscc ac INNER JOIN centroscoste cc ON ac.codcentro = cc.codcentro");
      qryFA.setWhere("ac.referencia = '" + cursor.valueBuffer("referencia") + "'");
      qryFA.setForwardOnly(true);
      if (!qryFA.exec()) {
        return false;
      }
      valor = 0;
      var factorCC;
      while (qryFA.next()) {
        factorCC = qryFA.value("cc.factoracceso");
        debug("factorCC " + factorCC);
        if (!isNaN(factorCC)) {
          valor += Math.pow(2, factorCC);
        }
        debug("valor " + valor);
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}
//// CENTROS DE COSTE ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
