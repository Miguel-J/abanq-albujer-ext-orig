
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class prodSofa extends oficial
{
  function prodSofa(context)
  {
    oficial(context);
  }
  function elegirOpcion(opciones: Array): Number {
    return this.ctx.prodSofa_elegirOpcion(opciones);
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubProdSofa */
/////////////////////////////////////////////////////////////////
//// PUB_PROD_SOFA //////////////////////////////////////////////

class pubProdSofa extends ifaceCtx
{
  function pubProdSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_elegirOpcion(opciones: Array): Number {
    return this.elegirOpcion(opciones);
  }
}

//// PUB_PROD_SOFA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////

/** \D
Da a elegir al usuario entre una serie de opciones
@param  opciones: Array con las n opciones a elegir
@return El índice de la opción elegida si se pulsa Aceptar
    -1 si se pulsa Cancelar
    -2 si hay error
*/
function prodSofa_elegirOpcion(opciones: Array): Number {
  var util: FLUtil = new FLUtil();
  var dialog: Dialog = new Dialog;
  dialog.okButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");
  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);
  var rB: Array = [];
  for (var i: Number = 0; i < opciones.length; i++)
  {
    rB[i] = new RadioButton;
    bgroup.add(rB[i]);
    rB[i].text = opciones[i];
    if (i == 0)
      rB[i].checked = true;
    else
      rB[i].checked = false;
  }

  if (dialog.exec())
  {
    for (var i: Number = 0; i < opciones.length; i++)
      if (rB[i].checked == true)
        return i;
  } else
    return -1;
}

//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
