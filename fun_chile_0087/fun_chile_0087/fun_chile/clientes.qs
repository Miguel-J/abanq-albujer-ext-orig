
/** @class_declaration funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

class funChile extends oficial
{
  var fdbRUT: FLFieldDB;
  var lblDV: Object;

  function funChile(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.funChile_init();
  }
  function imprimirBoleta()
  {
    this.ctx.funChile_imprimirBoleta();
  }
  function calcularDV(rut: String)
  {
    this.ctx.funChile_calcularDV(rut);
  }
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

function funChile_init()
{
  this.iface.__init();

  this.iface.fdbRUT = this.child("fdbCifNif");
  this.iface.lblDV = this.child("lblDV");

  this.child("tdbFacturas").cursor().setMainFilter("codserie<>'BO'");
  this.child("tdbBoletas").cursor().setMainFilter("codserie='BO'");

  connect(this.child("toolButtonPrintBol"), "clicked()", this, "iface.imprimirBoleta()");
  connect(this.iface.fdbRUT.editor(), "textChanged(QString)", this, "iface.calcularDV()");
}

/** \D Imprime la boleta seleccionada
\end */
function funChile_imprimirBoleta()
{
  var codBoleta: String = this.child("tdbBoletas").cursor().valueBuffer("codigo");
  if (!codBoleta)
    return;
  formboletas.iface.pub_imprimir(codBoleta);
}

function funChile_calcularDV(rut: String)
{
  this.iface.lblDV.text = flfactppal.iface.pub_obtenerDV(rut);
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
