
/** @class_declaration modelo300 */
/////////////////////////////////////////////////////////////////
//// MODELO 300 /////////////////////////////////////////////////
class modelo300 extends oficial
{
  function modelo300(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.modelo300_init();
  }
  function informarTiposDec300()
  {
    this.ctx.modelo300_informarTiposDec300();
  }
}
//// MODELO 300 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo300 */
/////////////////////////////////////////////////////////////////
//// MODELO 300 /////////////////////////////////////////////////
function modelo300_init()
{
  this.iface.__init();
  var util: FLUtil = new FLUtil();
  if (!util.sqlSelect("co_tipodec300", "idtipodec", "1 = 1"))
    this.iface.informarTiposDec300();
}

function modelo300_informarTiposDec300()
{
  var curTipoDec: FLSqlCursor = new FLSqlCursor("co_tipodec300");
  var valores: Array = [["C", "Solicitud de compensación"],
                        ["D", "Devolución"],
                        ["G", "Cuenta corriente tributaria - ingreso"],
                        ["N", "Sin actividad / resultado 0"],
                        ["V", "Cuenta corriente tributaria - devolución"]];

  for (var i: Number = 0; i < valores.length; i++) {
    with(curTipoDec) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("idtipodec", valores[i][0]);
      setValueBuffer("descripcion", valores[i][1]);
      commitBuffer();
    }
  }
}

//// MODELO 300 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
