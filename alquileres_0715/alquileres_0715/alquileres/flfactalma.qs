
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILERES ////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function beforeCommit_alquilerarticulos(curAA)
  {
    return this.ctx.alquiler_beforeCommit_alquilerarticulos(curAA);
  }
  function compruebaSolapeAlquiler(curAA)
  {
    return this.ctx.alquiler_compruebaSolapeAlquiler(curAA);
  }
  function haySolapeAlquiler(curAA)
  {
    return this.ctx.alquiler_haySolapeAlquiler(curAA);
  }
}
//// ALQUILERES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubAlquiler */
/////////////////////////////////////////////////////////////////
//// PUB ALQUILER ///////////////////////////////////////////////
class pubAlquiler extends ifaceCtx
{
  function pubAlquiler(context)
  {
    ifaceCtx(context);
  }
  function pub_haySolapeAlquiler(curAA)
  {
    return this.haySolapeAlquiler(curAA);
  }
}
//// PUB ALQUILER ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILERES /////////////////////////////////////////////////
function alquiler_beforeCommit_alquilerarticulos(curAA)
{
  var _i = this.iface;
  if (!_i.compruebaSolapeAlquiler(curAA)) {
    return false;
  }
  return true;
}

function alquiler_compruebaSolapeAlquiler(curAA)
{
  var util = new FLUtil;
  var _i = this.iface;
  if (curAA.valueBuffer("reservado")) {
    if (_i.haySolapeAlquiler(curAA) == 2) {
      MessageBox.warning(util.translate("scripts", "El período de alquiler indicado se solapa con otros períodos ya existentes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return true;
}

/** \D Indica si el cursor con datos de alquiler se solapa con uno ya existente
@return false: No hay solapamiento. 1. Solapamiento con un período no reservado. 2. Solapamiento con un período reservado
\end */
function alquiler_haySolapeAlquiler(curAA)
{
  var util = new FLUtil;
  var fD = curAA.valueBuffer("fechadesde");
  var fH = curAA.valueBuffer("fechahasta");
  var hD = curAA.valueBuffer("horadesde");
  if (hD) {
    hD = hD.toString().right(8);
  }
  var hH = curAA.valueBuffer("horahasta");
  if (hH) {
    hH = hH.toString().right(8);
  }
  var referencia = curAA.valueBuffer("referencia");
  var idPeriodo = curAA.valueBuffer("idperiodoalq");
  var where = "referencia = '" + referencia + "' AND (fechadesde < '" + fH + "' OR (fechadesde = '" + fH + "' AND horadesde < '" + hH + "')) AND (fechahasta > '" + fD + "' OR (fechahasta = '" + fD + "' AND horahasta > '" + hD + "')) AND idperiodoalq <> " + idPeriodo;

  var q = new FLSqlQuery;
  q.setSelect("idperiodoalq, reservado");
  q.setFrom("alquilerarticulos");
  q.setWhere(where + " ORDER BY reservado DESC");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  if (!q.first()) {
    return false;
  }
  if (q.value("reservado")) {
    return 2;
  } else {
    return 1;
  }
}
//// ALQUILERES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


