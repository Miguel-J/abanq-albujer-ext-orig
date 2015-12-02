
/** @class_declaration camposArticulos */
/////////////////////////////////////////////////////////////////
//// CAMPOS ARTICULOS ////////////////////////////////////////////////
class camposArticulos extends oficial
{
  var tbnBlockDesBlock: Object;
  function camposArticulos(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.camposArticulos_init();
  }
}
//// CAMPOS ARTICULOS ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition camposArticulos */
/////////////////////////////////////////////////////////////////
//// CAMPOS ARTICULOS ////////////////////////////////////////////////

function camposArticulos_init()
{
  this.iface.__init();
  connect(this.child("toolButtonEditMultiple"), "clicked()", this, "iface.editMultiple");
}

function camposArticulos_editMultiple()
{
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("camposarticulos");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;
  var codCliente: String;
  var codAlmacen: String;

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt: String = f.exec("descripcion");

  if (acpt) {
    debug(cursor.valueBuffer("descripcion"));
    f.close();
    this.iface.tdbRecords.refresh();
  }
}
//// CAMPOS ARTICULOS ////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
