
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
/** \D Calcula un nuevo código de proyecto
\end */
function proyectoscc_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  var codigo: String = "PR000001";
  var ultimoCodigo: String = util.sqlSelect("cl_proyectos", "codproyecto", "codproyecto LIKE 'PR%' ORDER BY codproyecto DESC");
  if (ultimoCodigo) {
    var numUltimo: Number = parseFloat(ultimoCodigo.right(6));
    codigo = "PR" + flfactppal.iface.pub_cerosIzquierda((++numUltimo).toString(), 6);
  }

  return codigo;
}
//// PROYECTOSCC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
