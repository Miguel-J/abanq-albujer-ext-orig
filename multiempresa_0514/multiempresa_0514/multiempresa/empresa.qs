
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multi_init();
  }
  function main()
  {
    return this.ctx.multi_main();
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multi_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      var codEjercicio: String = util.sqlSelect("ejercicios", "codejercicio", "1 = 1");
      cursor.setValueBuffer("codejercicio", codEjercicio);
      break;
    }
    default: {
      this.child("tlbIDEmpresa").text = cursor.valueBuffer("id");
      break;
    }
  }
}

function multi_main()
{
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
