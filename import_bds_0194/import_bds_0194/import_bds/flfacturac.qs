
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends oficial
{
  var ultimoPwd_;
  function importDatosFC(context)
  {
    oficial(context);
  }
  function beforeCommit_importdatosfc(curD: FLSqlCursor): Boolean {
    return this.ctx.importDatosFC_beforeCommit_importdatosfc(curD);
  }
  function afterCommit_importdatosfc(curD: FLSqlCursor): Boolean {
    return this.ctx.importDatosFC_afterCommit_importdatosfc(curD);
  }
  function ponUltimoPwd(p)
  {
    return this.ctx.importDatosFC_ponUltimoPwd(p);
  }
  function dameUltimoPwd()
  {
    return this.ctx.importDatosFC_dameUltimoPwd();
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubImportDatosFC */
/////////////////////////////////////////////////////////////////
//// PUB IMPORT DATOS ///////////////////////////////////////////
class pubImportDatosFC extends ifaceCtx
{
  function pubImportDatosFC(context)
  {
    ifaceCtx(context);
  }
  function pub_ponUltimoPwd(p)
  {
    return this.ponUltimoPwd(p);
  }
}
//// PUB IMPORT DATOS ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////

/** Se marcan los registros efectivamente exportados
*/
function importDatosFC_beforeCommit_importdatosfc(curD: FLSqlCursor): Boolean {
  var _i = this.iface;
  var util: FLUtil = new FLUtil();

  //  if(!AQUtil.sqlSelect("registrosexportados","id","1=1"))
  //    return true;

  var pwd = _i.dameUltimoPwd();
  if (!sys.addDatabase(curD.valueBuffer("driver"), curD.valueBuffer("nombrebd"), curD.valueBuffer("usuario"), pwd, curD.valueBuffer("host"), curD.valueBuffer("puerto"), "remota"))
    return false;

  // Registros modificados
  var curLoc: FLSqlCursor = new FLSqlCursor("registrosexportados");
  var curRem: FLSqlCursor = new FLSqlCursor("registrosexportados", "remota");

  curLoc.select();

  util.createProgressDialog(util.translate("scripts", "Registrando la importación. Paso 1 de 2") , curLoc.size());
  util.setProgress(1);
  var paso: Number = 0;

  while (curLoc.next())
  {

    util.setProgress(paso++);

    curRem.select("tabla = '" + curLoc.valueBuffer("tabla") + "' AND clave = '" + curLoc.valueBuffer("clave") + "'");
    if (curRem.first())
      continue;

    curRem.setModeAccess(curRem.Insert);
    curRem.refreshBuffer();
    curRem.setValueBuffer("tabla", curLoc.valueBuffer("tabla"));
    curRem.setValueBuffer("clave", curLoc.valueBuffer("clave"));
    if (!curRem.commitBuffer())
      debug(util.translate("scripts", "Error al registrar el registro exportado de la tabla local %0 el código/id ").arg(curLoc.valueBuffer("tabla")));
  }

  util.destroyProgressDialog();

  sys.removeDatabase("remota");

  util.sqlDelete("registrosexportados", "1=1");

  return true;
}

/** Se liberan los registros efectivamente importados
*/
function importDatosFC_afterCommit_importdatosfc(curD: FLSqlCursor): Boolean {
  var _i = this.iface;
  var util: FLUtil = new FLUtil();

  /*  if(!AQUtil.sqlSelect("registrosimportados","id","1=1"))
      return true*/;

  var pwd = _i.dameUltimoPwd();
  if (!sys.addDatabase(curD.valueBuffer("driver"), curD.valueBuffer("nombrebd"), curD.valueBuffer("usuario"), pwd, curD.valueBuffer("host"), curD.valueBuffer("puerto"), "remota"))
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor("registrosimportados");
  var curRem: FLSqlCursor = new FLSqlCursor("registrosmodificados", "remota");

  curLoc.select();

  util.createProgressDialog(util.translate("scripts", "Registrando la importación. Paso 2 de 2") , curLoc.size());
  util.setProgress(1);
  var paso: Number = 0;

  while (curLoc.next())
  {

    util.setProgress(paso++);

    curRem.select("id = " + curLoc.valueBuffer("idmodificados"));
    if (!curRem.first())
      continue;

    curRem.setModeAccess(curRem.Del);
    curRem.refreshBuffer();
    if (!curRem.commitBuffer())
      debug(util.translate("scripts", "Error al eliminar el registro modificado de la tabla local %0 el código/id ").arg(curLoc.valueBuffer("idmodificados")));
  }

  util.destroyProgressDialog();

  sys.removeDatabase("remota");

  util.sqlDelete("registrosimportados", "1=1");
}

function importDatosFC_ponUltimoPwd(p)
{
  var _i = this.iface;
  _i.ultimoPwd_ = p;
}

function importDatosFC_dameUltimoPwd()
{
  var _i = this.iface;
  return _i.ultimoPwd_;
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
