
/** @class_declaration rutas */
/////////////////////////////////////////////////////////////////
//// RUTAS //////////////////////////////////////////////////////
class rutas extends oficial
{
  function rutas(context)
  {
    oficial(context);
  }
  function beforeCommit_paradas(curParada: FLSqlCursor): Boolean {
    return this.ctx.rutas_beforeCommit_paradas(curParada);
  }
}
//// RUTAS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rutas */
/////////////////////////////////////////////////////////////////
//// RUTAS //////////////////////////////////////////////////////
function rutas_beforeCommit_paradas(curParada: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  switch (curParada.modeAccess())
  {
    case curParada.Insert: {
      var qry: FLSqlQuery = new FLSqlQuery();
      qry.setTablesList("paradas");
      qry.setSelect("coddir");
      qry.setFrom("paradas")
      qry.setWhere("codruta = '" + curParada.valueBuffer("codruta") + "'");
      qry.setForwardOnly(true);
      if (!qry.exec()) {
        return false;
      }
      while (qry.next()) {
        if (qry.value("coddir") == curParada.valueBuffer("coddir")) {
          MessageBox.information(util.translate("scripts", "Esta dirección ya es una parada de esta ruta"), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
      }
    }
  }
  return true;
}

//// RUTAS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
