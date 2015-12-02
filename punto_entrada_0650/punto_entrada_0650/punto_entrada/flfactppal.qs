
/** @class_declaration puntoE */
/////////////////////////////////////////////////////////////////
//// PUNTO DE ENTRADA ///////////////////////////////////////////
class puntoE extends oficial
{
  function puntoE(context)
  {
    oficial(context);
  }
  function dameElementosT1()
  {
    return this.ctx.puntoE_dameElementosT1();
  }
  function dameRelacionesT1()
  {
    return this.ctx.puntoE_dameRelacionesT1();
  }
}
//// PUNTO DE ENTRADA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPuntoE */
/////////////////////////////////////////////////////////////////
//// PUB PUNTO ENTRADA //////////////////////////////////////////
class pubPuntoE extends ifaceCtx
{
  function pubPuntoE(context)
  {
    ifaceCtx(context);
  }
  function pub_dameElementosT1()
  {
    return this.dameElementosT1();
  }
  function pub_dameRelacionesT1()
  {
    return this.dameRelacionesT1();
  }
}
//// PUB PUNTO ENTRADA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition puntoE */
/////////////////////////////////////////////////////////////////
//// PUNTO DE ENTRADA ///////////////////////////////////////////
function puntoE_dameElementosT1()
{
  var aElementos = [["t1_home"], ["clientes"], ["facturascli"], ["albaranescli"], ["pedidoscli"], ["presupuestoscli"], ["reciboscli"], ["agentes"], ["usuarios"], ["pr_tareas"], ["crm_oportunidadventa"], ["crm_contactos"], ["crm_clientes", "clientes"]];
  return aElementos;
}

function puntoE_dameRelacionesT1()
{
  var aRelaciones = [["clientes", "presupuestoscli"],
                     ["clientes", "pedidoscli"],
                     ["clientes", "albaranescli"],
                     ["clientes", "facturascli"],
                     ["clientes", "crm_contactos"],
                     ["agentes", "clientes"],
                     ["agentes", "facturascli"],
                     ["facturascli", "reciboscli"],
                     ["presupuestoscli", "pedidoscli", "11"],
                     ["pedidoscli", "albaranescli", "MM"],
                     ["facturascli", "albaranescli"],
                     ["usuarios", "pr_tareas"],
                     ["usuarios", "crm_oportunidadventa"]];
  return aRelaciones;
}
//// PUNTO DE ENTRADA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
