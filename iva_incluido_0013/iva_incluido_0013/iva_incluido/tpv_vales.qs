
/** @class_declaration ivaincluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////
class ivaincluido extends oficial
{
  function ivaincluido(context)
  {
    oficial(context);
  }
  function incluirDatosLinea(curLinea, curLineaPadre)
  {
    return this.ctx.ivaincluido_incluirDatosLinea(curLinea, curLineaPadre);
  }
}
//// IVA INCLUIDO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaincluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////
function ivaincluido_incluirDatosLinea(curLinea, curLineaPadre)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__incluirDatosLinea(curLinea, curLineaPadre))
    return false;

  curLinea.setValueBuffer("ivaincluido", curLineaPadre.valueBuffer("ivaincluido"));
  curLinea.setValueBuffer("pvpunitarioiva", curLineaPadre.valueBuffer("pvpunitarioiva"));

  if (curLineaPadre.valueBuffer("ivaincluido")) {
    curLinea.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", curLinea));
    curLinea.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva2", curLinea));
    curLinea.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto2", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva2", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal2", curLinea));
  } else {
    curLinea.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", curLinea));
    curLinea.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLinea));
    curLinea.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva", curLinea));
    curLinea.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLinea));
    curLinea.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva", curLinea));
  }

  //  curLinea.setValueBuffer("pvpunitarioiva",curLineaPadre.valueBuffer("pvpunitarioiva"));
  //  curLinea.setValueBuffer("pvptotaliva",parseFloat(curLineaPadre.valueBuffer("pvptotaliva"))*-1);
  //  curLinea.setValueBuffer("pvpsindtoiva",parseFloat(curLineaPadre.valueBuffer("pvpsindtoiva"))*-1);

  return true;
}
//// IVA INCLUIDO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
