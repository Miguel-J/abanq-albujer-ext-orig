
/** @class_declaration informeOdt */
/////////////////////////////////////////////////////////////////
//// INFORME ODT ////////////////////////////////////////////////
class informeOdt extends oficial
{
  function informeOdt(context)
  {
    oficial(context);
  }
  function lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, nombreReport: String, orderBy: String, groupBy: String, masWhere: String, idInforme: Number)
  {
    return this.ctx.informeOdt_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, idInforme);
  }
}
//// INFORME ODT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition informeOdt */
/////////////////////////////////////////////////////////////////
//// INFORME ODT ////////////////////////////////////////////////

function informeOdt_lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, nombreReport: String, orderBy: String, groupBy: String, masWhere: String, idInforme: Number)
{
  var util: FLUtil = new FLUtil();
  var prioridad: String = util.sqlSelect("i_plantillasodt", "prioridad", "informe = '" + nombreInforme + "'", "");

  switch (prioridad) {
    case "Siempre":
      return formi_plantillasodt.iface.pub_generarOdt(cursor, nombreInforme, orderBy, groupBy, false, false, masWhere, nombreReport);
      break;

    case "Preguntar":
      res = MessageBox.information(util.translate("scripts", "¿Imprimir en formato Open Document?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
      if (res == MessageBox.Yes)
        return formi_plantillasodt.iface.pub_generarOdt(cursor, nombreInforme, orderBy, groupBy, false, false, masWhere, nombreReport);
      else
        return this.iface.__lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, idInforme);
      break;

    default:
      return this.iface.__lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, idInforme);
  }
}
