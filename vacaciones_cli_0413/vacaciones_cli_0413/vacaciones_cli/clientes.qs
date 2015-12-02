
/** @class_declaration vacacionesCli */
/////////////////////////////////////////////////////////////////
//// VACACIONES CLIENTES ////////////////////////////////////////
class vacacionesCli extends oficial
{
  function vacacionesCli(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.vacacionesCli_validateForm();
  }
  function validarDiaMes(diaMes: String): Boolean {
    return this.ctx.vacacionesCli_validarDiaMes(diaMes);
  }
}
//// VACACIONES CLIENTES ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition vacacionesCli */
/////////////////////////////////////////////////////////////////
//// VACACIONES CLIENTE /////////////////////////////////////////
function vacacionesCli_validateForm(): Boolean {
  if (!this.iface.__validateForm())
  {
    return false;
  }

  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var vacDesde: String = cursor.valueBuffer("vacdesde");
  if (!vacDesde)
  {
    vacDesde = "";
  }
  if (!this.iface.validarDiaMes(vacDesde))
  {
    return false;
  }
  var vacHasta: String = cursor.valueBuffer("vachasta");
  if (!vacHasta)
  {
    vacHasta = "";
  }
  if (!this.iface.validarDiaMes(vacHasta))
  {
    return false;
  }
  if ((vacDesde != "" && vacHasta == "") || (vacDesde == "" && vacHasta != ""))
  {
    MessageBox.warning(util.translate("scripts", "Vacaciones: Debe establecer ambas fechas o ninguna"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function vacacionesCli_validarDiaMes(diaMes: String): Boolean {
  var util: FLUtil;
  if (!diaMes || diaMes == "")
  {
    return true;
  }
  var fecha: Date = new Date;
  var datosDiaMes: Array = diaMes.split("-");
  var ok: Boolean = true;

  if (datosDiaMes.length != 2)
  {
    ok = false;
  } else {
    fecha.setDate(1);
    fecha.setMonth(datosDiaMes[1]);
    if (!fecha)
    {
      ok = false;
    } else {
      fecha.setDate(datosDiaMes[0]);
      if (!fecha)
      {
        ok = false;
      }
    }
  }
  if (!ok)
  {
    MessageBox.warning(util.translate("scripts", "Vacaciones: El formato %1 no corresponde a una fecha real").arg(diaMes), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// VACACIONES CLIENTE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
