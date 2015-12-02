
/** @class_declaration venFacturasProv */
/////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ///////////////////////////////////////////////
class venFacturasProv extends proveed
{
  function venFacturasProv(context)
  {
    proveed(context);
  }
  function init()
  {
    return this.ctx.venFacturasProv_init();
  }
}
//// VENFACTURASPROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition venFacturasProv */
//////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ////////////////////////////////////////////////

function venFacturasProv_init()
{
  this.iface.__init();

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("recibosprov,facturasprov");
  q.setSelect("f.codcuenta");
  q.setFrom("facturasprov f INNER JOIN recibosprov r ON f.idfactura = r.idfactura");
  q.setWhere("r.idrecibo = " + this.cursor().valueBuffer("idrecibo"));

  if (!q.exec())
    return;

  if (q.first())
    this.child("fdbCodCuenta").setValue(q.value(0));
}

//// VENFACTURASPROV ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

