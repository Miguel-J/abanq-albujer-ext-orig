
/** @class_declaration backups */
/////////////////////////////////////////////////////////////////
//// BACKUPS //////////////////////////////////////////////////////
class backups extends oficial
{
  var valoresTradActual: Array;
  function backups(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.backups_init();
  }
  function introducirComandos()
  {
    return this.ctx.backups_introducirComandos();
  }
  function introducirOpciones()
  {
    return this.ctx.backups_introducirOpciones();
  }
}
//// BACKUPS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition backups */
/////////////////////////////////////////////////////////////////
//// BACKUPS //////////////////////////////////////////////////////

function backups_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = new FLSqlCursor("mt_comandos");
  cursor.select();
  if (!cursor.first()) {
    var util: FLUtil = new FLUtil();
    MessageBox.information(util.translate("scripts",
                                          "Se insertarán algunos datos para empezar a trabajar."),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

    this.iface.introducirComandos();
    this.iface.introducirOpciones();
  }

}


function backups_introducirComandos()
{
  var util: FLUtil = new FLUtil();
  var datos = [
                ["LI", "Linux",
                 "pg_dump %base_datos% -U %usuario% -f %fichero%",
                 "psql %base_datos% -U %usuario% -f %fichero%",
                 "createdb %base_datos% -E UNICODE -U %usuario%",
                 "dropdb %base_datos% -U %usuario%"]];

  var cursor: FLSqlCursor = new FLSqlCursor("mt_comandos");

  for (i = 0; i < datos.length; i++) {

    cursor.select("codigo = '" + datos[i][0] + "'");
    if (cursor.first())
      continue;

    cursor.setModeAccess(cursor.Insert);
    cursor.refreshBuffer();
    cursor.setValueBuffer("codigo", datos[i][0]);
    cursor.setValueBuffer("so", datos[i][1]);
    cursor.setValueBuffer("comandobackup", datos[i][2]);
    cursor.setValueBuffer("comandorestore", datos[i][3]);
    cursor.setValueBuffer("comandocreate", datos[i][4]);
    cursor.setValueBuffer("comandodel", datos[i][5]);
    cursor.commitBuffer();
  }

}

function backups_introducirOpciones()
{
  var util: FLUtil = new FLUtil();

  var cursor: FLSqlCursor = new FLSqlCursor("mt_opciones");

  cursor.select();
  if (cursor.first())
    return;

  cursor.setModeAccess(cursor.Insert);
  cursor.refreshBuffer();
  cursor.setValueBuffer("backupokpg", "-- PostgreSQL database dump complete");
  cursor.setValueBuffer("delokpg", "DROP DATABASE");
  cursor.setValueBuffer("createokpg", "CREATE DATABASE");
  cursor.commitBuffer();

  MessageBox.information(util.translate("scripts", "Verifique que los valores de configuración son los correctos."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  this.execMainScript("mt_opciones");
}

//// BACKUPS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
