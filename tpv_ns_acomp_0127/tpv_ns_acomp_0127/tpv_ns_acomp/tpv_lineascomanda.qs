
/** @class_declaration tpvNsAcomp */
//////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP /////////////////////////////////////////////////////

class tpvNsAcomp extends funNumSerie
{
  function tpvNsAcomp(context)
  {
    funNumSerie(context);
  }
  function init()
  {
    return this.ctx.tpvNsAcomp_init();
  }
  function validateForm(): Boolean { return this.ctx.tpvNsAcomp_validateForm(); }
  function bufferChanged(fN: String)
  {
    return this.ctx.tpvNsAcomp_bufferChanged(fN);
  }
  function regenerarNumSerieComp()
  {
    return this.ctx.tpvNsAcomp_regenerarNumSerieComp();
  }
  function controlNumSerieComp(regenerar: Boolean)
  {
    return this.ctx.tpvNsAcomp_controlNumSerieComp(regenerar);
  }
  function borrarNumSerieComp()
  {
    return this.ctx.tpvNsAcomp_borrarNumSerieComp();
  }
}

//// TPV_NS_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition tpvNsAcomp */
/////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP /////////////////////////////////////////////////

function tpvNsAcomp_init()
{
  this.iface.__init();
  this.iface.controlNumSerieComp();
}

/**
Se comprueba que el número de serie no existe en una línea de ns
*/
function tpvNsAcomp_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("tpv_lineascomandans", "idlinea",
  "numserie = '" + this.cursor().valueBuffer("numserie") + "'"))
  {
    MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return this.iface.__validateForm();
}

/**
Cuando la referencia es un artículo compuesto, se regeneran las líneas de
números de serie si alguno de los componentes se controla por ns
*/
function tpvNsAcomp_regenerarNumSerieComp()
{
  var util: FLUtil = new FLUtil();
  var referencia: String = this.cursor().valueBuffer("referencia");

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("articuloscomp,articulos");
  qry.setSelect("ac.refcomponente,ac.cantidad,a.controlnumserie");
  qry.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
  qry.setWhere("refcompuesto = '" + referencia + "'");

  if (!qry.exec())
    return;

  if (!qry.size())
    return;

  try {
    res = this.cursor().commitBuffer();
  } catch (e) {
    this.cursor().rollback();
    return;
  }

  if (!res)
    return;

  this.iface.borrarNumSerieComp();

  var curTab: FLSqlCursor = this.child("tdbLineasComandaNS").cursor();
  var refComp: String = "";
  var cantidad: Number = 0;

  while (qry.next()) {

    if (!qry.value(2))
      continue;

    refComp = qry.value(0);
    cantidad = parseFloat(qry.value(1));

    for (i = 0; i < cantidad; i++) {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("referencia", refComp);
      curTab.commitBuffer();
    }
  }

}

function tpvNsAcomp_bufferChanged(fN: String)
{
  this.iface.__bufferChanged(fN);

  switch (fN) {
      /** Si el artículo tiene componentes se habilita el cuadro de números de serie
      */
    case "referencia":
      this.iface.controlNumSerieComp(true);
      break;
  }
}

/** Si el artículo tiene componentes se habilita el cuadro de números de serie
*/
function tpvNsAcomp_controlNumSerieComp(regenerar: Boolean)
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("articuloscomp", "refcompuesto", "refcompuesto = '" + this.cursor().valueBuffer("referencia") + "'")) {

    if (regenerar)
      this.iface.regenerarNumSerieComp();

    this.child("gbxNumSerieComp").setDisabled(false);

    // Si hay componentes con NS hay que forzar a 1 la cantidad
    var curTab: FLSqlCursor = this.child("tdbLineasComandaNS").cursor();
    curTab.select();
    if (curTab.first()) {
      this.cursor().setValueBuffer("cantidad", 1);
      this.child("fdbCantidad").setDisabled(true);
    }
  } else {
    this.iface.borrarNumSerieComp();
    this.child("gbxNumSerieComp").setDisabled(true);
    this.child("fdbCantidad").setDisabled(false);
  }
}

/** Borra los registros de números de serie de componentes
*/
function tpvNsAcomp_borrarNumSerieComp()
{
  var curTab: FLSqlCursor = this.child("tdbLineasComandaNS").cursor();
  curTab.select();
  while (curTab.next()) {
    curTab.setModeAccess(curTab.Del)
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
  curTab.select();
  while (curTab.next()) {
    curTab.setModeAccess(curTab.Del)
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
}

//// TPV_NS_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
