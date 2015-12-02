
/** @class_declaration remesasAuto */
/////////////////////////////////////////////////////////////////
//// REMESAS AUTO ///////////////////////////////////////////////
class remesasAuto extends oficial
{
  function remesasAuto(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.remesasAuto_validateForm();
  }
}
//// REMESAS AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesasAuto */
/////////////////////////////////////////////////////////////////
//// REMESAS AUTO ///////////////////////////////////////////////
/** \C Las remesas activas pueden estar vacías (sin recibos asociados), pero sólo puede existir una remesa activa en el sistema
\end */
function remesasAuto_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("activa"))
  {
    if (util.sqlSelect("remesas", "idremesa", "activa = true and idremesa <> " + cursor.valueBuffer("idremesa"))) {
      MessageBox.warning(util.translate("scripts", "Ya existe una remesa activa.\nDebe desactivarla antes de activar la remesa actual"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    if (!this.iface.__validateForm())
      return false;
  }

  return true;
}
//// REMESAS AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
