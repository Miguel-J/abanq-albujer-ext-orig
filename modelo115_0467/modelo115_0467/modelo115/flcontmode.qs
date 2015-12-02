
/** @class_declaration modelo115 */
/////////////////////////////////////////////////////////////////
//// MODELO 115 /////////////////////////////////////////////////
class modelo115 extends oficial
{
  function modelo115(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.modelo115_init();
  }
  function informarTiposDec115()
  {
    this.ctx.modelo115_informarTiposDec115();
  }
}

//// MODELO 115 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo115 */
/////////////////////////////////////////////////////////////////
//// MODELO 115 /////////////////////////////////////////////////
function modelo115_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;

  if (!util.sqlSelect("co_tipodec115", "idtipodec", "1 = 1")) {
    this.iface.informarTiposDec115();
  }
}

function modelo115_informarTiposDec115()
{
  var curTipoDec: FLSqlCursor = new FLSqlCursor("co_tipodec115");
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

//// MODELO 115 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
