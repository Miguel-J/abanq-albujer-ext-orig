
/** @class_declaration tpvMultiTC */
/////////////////////////////////////////////////////////////////
//// TPV MULTI TC ///////////////////////////////////////////////
class tpvMultiTC extends oficial
{
  function tpvMultiTC(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.tpvMultiTC_init();
  }
  function actualizaFiltro()
  {
    return this.ctx.tpvMultiTC_actualizaFiltro();
  }
  //  function ocultaSubfamilias() {
  //    return this.ctx.tpvMultiTC_ocultaSubfamilias();
  //  }
}
//// TPV MULTI TC ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvMultiTC */
/////////////////////////////////////////////////////////////////
//// TPV MULTI TC ///////////////////////////////////////////////
function tpvMultiTC_init()
{
  var _i = this.iface;
  _i.__init();

  connect(this.child("tdbFamilias"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbSubfamilias"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbGruposTC"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbTiposPrenda"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbAnnosTC"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbTemporadas"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");
  connect(this.child("tdbGruposModa"), "primaryKeyToggled(QVariant, bool)", _i, "actualizaFiltro");

  flfactalma.iface.pub_iniciaFiltroArt(this);
  //  _i.ocultaSubfamilias();
}

// function tpvMultiTC_ocultaSubfamilias()
// {
//  var manager = aqApp.db().manager();
//  mtd = manager.metadata("subfamilias")
//  if (!mtd) {
//    this.child("gbxSubfamilias").close();
//  }
// }

function tpvMultiTC_actualizaFiltro()
{
  var f = flfactalma.iface.pub_dameFiltroArt(this, "articulos");

  debug("Filtro " + f);
  this.child("tableDBRecords").setFilter(f);
  this.child("tableDBRecords").refresh();
}
//// TPV MULTI TC ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
