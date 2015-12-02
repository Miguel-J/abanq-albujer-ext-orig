
/** @class_declaration modelo180 */
/////////////////////////////////////////////////////////////////
//// MODELO 180 /////////////////////////////////////////////////
class modelo180 extends oficial
{
  function modelo180(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.modelo180_init();
  }
  function informarTiposDec180()
  {
    this.ctx.modelo180_informarTiposDec180();
  }
}
//// MODELO 180 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo180 */
/////////////////////////////////////////////////////////////////
//// MODELO 180 /////////////////////////////////////////////////
function modelo180_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;

  if (!util.sqlSelect("co_tipodec180", "idtipodec", "1 = 1")) {
    this.iface.informarTiposDec180();
  }
}

function modelo180_informarTiposDec180()
{
  var curTipoDec: FLSqlCursor = new FLSqlCursor("co_tipodec180");
  var valores: Array = [["G", "Cuenta corriente tributaria-ingreso"], ["I", "Ingreso"], ["N", "Negativa"], ["U", "Domiciliación del ingreso en CCC"]];

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

//// MODELO 180 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
