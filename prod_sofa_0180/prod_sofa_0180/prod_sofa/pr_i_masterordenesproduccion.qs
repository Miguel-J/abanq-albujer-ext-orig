
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// SOFA /////////////////////////////////////////////////
class prodSofa extends oficial
{
  function prodSofa(context)
  {
    oficial(context);
  }
  function desTipoTarea(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_desTipoTarea(nodo, campo);
  }
  function codigoModuloConSufijo(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_codigoModuloConSufijo(nodo, campo);
  }
  function lanzar(cursor: FLSqlCursor)
  {
    return this.ctx.prodSofa_lanzar(cursor);
  }
}
//// SOFA ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSofa */
/////////////////////////////////////////////////////////////////
//// PUB SOFA ///////////////////////////////////////////////////
class pubSofa extends ifaceCtx
{
  function pubSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_desTipoTarea(nodo: FLDomNode, campo: String): String {
    return this.desTipoTarea(nodo, campo);
  }
  function pub_codigoModuloConSufijo(nodo: FLDomNode, campo: String): String {
    return this.codigoModuloConSufijo(nodo, campo);
  }
}

const iface = new pubSofa(this);
//// PUB SOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// SOFA ///////////////////////////////////////////////////////
function prodSofa_desTipoTarea(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var idTipoTreaPro: String = nodo.attributeValue("pr_tareas.idtipotareapro");
  debug("idTipoTreaPro = " + idTipoTreaPro);
  var desTarea: String = util.sqlSelect("pr_tipostareapro", "descripcion", "idtipotareapro = " + idTipoTreaPro);
  debug(desTarea);
  return desTarea;

}

function prodSofa_codigoModuloConSufijo(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var idTipoTarea: String = nodo.attributeValue("pr_tareas.idtipotarea");
  debug("idTipoTarea " + idTipoTarea);
  var codLote: String = nodo.attributeValue("modulos.codlote");
  debug("codLote " + codLote);
  var sufijo: String = idTipoTarea.right(1);
  debug("sufijo = " + sufijo);
  if (sufijo != "M" && sufijo != "F")
    sufijo = "";

  return codLote + sufijo;

}

function prodSofa_lanzar(cursor: FLSqlCursor)
{
  if (!cursor)
    cursor = this.cursor()

             var seleccion: String = cursor.valueBuffer("id");
  if (!seleccion)
    return;

  var dialog = new Dialog;
  dialog.caption = "Imprimir";
  dialog.okButtonText = "Aceptar"
                        dialog.cancelButtonText = "Cancelar";

  var produccion = new RadioButton;
  produccion.text = "O. Produccion";
  produccion.checked = false;
  dialog.add(produccion);

  var cosido = new RadioButton;
  cosido.text = "O. Cosido";
  cosido.checked = true;
  dialog.add(cosido);

  var whereFijo: String = "";
  if (dialog.exec()) {
    if (cosido.checked)
      whereFijo = "pr_tareas.idtipotarea IN ('COSIDO','COSIDOM','COSIDOF')";
    else
      whereFijo = "pr_tareas.idtipotarea NOT IN ('COSIDO','COSIDOM','COSIDOF')";
  }

  var nombreInforme: String = "pr_i_ordenesproduccion";
  flprodinfo.iface.pub_lanzarInforme(cursor, nombreInforme, "", "", false, false, whereFijo);
}
//// SOFA ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
