
/** @class_declaration proyectoscc */
//////////////////////////////////////////////////////////////////
//// PROYECTOSCC /////////////////////////////////////////////////
class proyectoscc extends oficial
{
  function proyectoscc(context)
  {
    oficial(context);
  }
  function calculateCounter(): String {
    return this.ctx.proyectoscc_calculateCounter();
  }
}
//// PROYECTOSCC /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition proyectoscc */
//////////////////////////////////////////////////////////////////
//// PROYECTOSCC /////////////////////////////////////////////////
/** \D Calcula un nuevo código de subproyecto
\end */
function proyectoscc_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  var codigo: String = "SP000001";
  var ultimoCodigo: String = util.sqlSelect("cl_subproyectos", "codsubproyecto", "codsubproyecto LIKE 'SP%' ORDER BY codsubproyecto DESC");
  if (ultimoCodigo) {
    var numUltimo: Number = parseFloat(ultimoCodigo.right(6));
    codigo = "SP" + flfactppal.iface.pub_cerosIzquierda((++numUltimo).toString(), 6);
  }

  return codigo;
}
//// PROYECTOSCC ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
