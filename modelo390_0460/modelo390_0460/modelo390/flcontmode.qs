
/** @class_declaration modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
class modelo390 extends oficial
{
  function modelo390(context)
  {
    oficial(context);
  }
  function calcularCampoBooleano(nodo: FLDomNode, campo: String): String {
    this.ctx.modelo390_calcularCampoBooleano(nodo, campo);
  }
  function lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, masWhere: String)
  {
    return this.ctx.modelo390_lanzarInforme(cursor, nombreInforme, masWhere);
  }
}
//// MODELO 390 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo390 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO 390 /////////////////////////////////////////////
class pubModelo390 extends head
{
  function pubModelo390(context)
  {
    head(context);
  }
  function pub_calcularCampoBooleano(nodo: FLDomNode, campo: String): String {
    return this.calcularCampoBooleano(nodo, campo);
  }
  function pub_lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, masWhere: String)
  {
    return this.lanzarInforme(cursor, nombreInforme, masWhere);
  }
}

//// PUB_MODELO390 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
/** \D Devuelve una X si el valor del campo es verdadero. Esta función se usa desde los scripts para cumplimentas correctamente los campos de tipo casilla de verificación

@param  nodo: Nodo con los valores de la fila actual del informe
@param  campo: Nombre del campo (no se usa en esta función)
@return X si el valor del campo es verdadero, cadena vacía si es falso
\end */
function modelo390_calcularCampoBooleano(nodo: FLDomNode, campo: String): String {
  var decpterceros: String = nodo.attributeValue("co_modelo390.declaracionopterceros3");

  if (decpterceros)
    return "X"
    else
      return ""
    }

function modelo390_lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, masWhere: String)
{
  var util: FLUtil = new FLUtil;
  var dialog: Object = new Dialog;
  dialog.caption = util.translate("scripts", "Elegir página a imprimir");
  dialog.okButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var text: Object = new Label;
  text.text = util.translate("scripts", "Ha seleccionado un informe de varias páginas,\nelija la página/s a imprimir:");
  dialog.add(text);

  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);

  var imprimirtodas: CheckBox = new CheckBox;
  imprimirtodas.text = util.translate("scripts", "Todas");
  imprimirtodas.checked = true;
  bgroup.add(imprimirtodas);

  var imprimiruna: CheckBox = new CheckBox;
  imprimiruna.text = util.translate("scripts", "Página 1");
  imprimiruna.checked = false;
  bgroup.add(imprimiruna);

  var imprimirdos: CheckBox = new CheckBox;
  imprimirdos.text = util.translate("scripts", "Página 2");
  imprimirdos.checked = false;
  bgroup.add(imprimirdos);

  var imprimirtres: CheckBox = new CheckBox;
  imprimirtres.text = util.translate("scripts", "Página 3");
  imprimirtres.checked = false;
  bgroup.add(imprimirtres);

  var imprimircuatro: CheckBox = new CheckBox;
  imprimircuatro.text = util.translate("scripts", "Página 4");
  imprimircuatro.checked = false;
  bgroup.add(imprimircuatro);

  var imprimircinco: CheckBox = new CheckBox;
  imprimircinco.text = util.translate("scripts", "Página 5");
  imprimircinco.checked = false;
  bgroup.add(imprimircinco);

  if (!dialog.exec())
    return;

  var imprimir = new Array(5);

  for (var i: Number = 0; i < 5; i++)
    imprimir[i] = true;

  if (imprimirtodas.checked == false) {
    if (imprimiruna.checked == false)
      imprimir[0] = false;
    if (imprimirdos.checked == false)
      imprimir[1] = false;
    if (imprimirtres.checked == false)
      imprimir[2] = false;
    if (imprimircuatro.checked == false)
      imprimir[3] = false;
    if (imprimircinco.checked == false)
      imprimir[4] = false;
  }

  nombreInforme = "co_modelo390_0";
  for (var i: Number = 1; i < 6; i++) {
    if (imprimir[i - 1] == true) {
      this.iface.lanzar(cursor, nombreInforme + i.toString(), masWhere);
    }
  }
}

//// MODELO 390 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
