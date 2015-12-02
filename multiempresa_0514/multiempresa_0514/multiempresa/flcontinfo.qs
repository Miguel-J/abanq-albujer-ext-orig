
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends pgc2008
{
  function multi(context)
  {
    pgc2008(context);
  }
  function nombreEmpresa(nodo: FLDomNode, campo: String): String {
    return this.ctx.multi_nombreEmpresa(nodo, campo);
  }
  function cabeceraInforme(nodo: FLDomNode, campo: String): String {
    return this.ctx.multi_cabeceraInforme(nodo, campo);
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multi_nombreEmpresa(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;

  var nombre: String;
  debug("this.iface.nombreInformeActual = " + this.iface.nombreInformeActual);
  switch (this.iface.nombreInformeActual)
  {
    case "co_i_diario": {
      nombre = util.sqlSelect("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id INNER JOIN co_i_diario info ON ej.codejercicio = info.i_co__subcuentas_codejercicio", "em.nombre", "info.id = " + this.iface.idInformeActual, "empresa,ejercicios");
      break;
    }
    case "co_i_mayor": {
      nombre = util.sqlSelect("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id INNER JOIN co_i_mayor info ON ej.codejercicio = info.i_co__subcuentas_codejercicio", "em.nombre", "info.id = " + this.iface.idInformeActual, "empresa,ejercicios");
      break;
    }
    case "co_i_balancesis": {
      nombre = util.sqlSelect("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id INNER JOIN co_i_balancesis info ON ej.codejercicio = info.i_co__subcuentas_codejercicio", "em.nombre", "info.id = " + this.iface.idInformeActual, "empresa,ejercicios");
      break;
    }
    case "co_i_facturasrec": {
      nombre = util.sqlSelect("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id INNER JOIN co_i_facturasrec info ON ej.codejercicio = info.i_co__cuentas_codejercicio", "em.nombre", "info.id = " + this.iface.idInformeActual, "empresa,ejercicios");
      break;
    }
    case "co_i_facturasemi": {
      nombre = util.sqlSelect("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id INNER JOIN co_i_facturasemi info ON ej.codejercicio = info.i_co__cuentas_codejercicio", "em.nombre", "info.id = " + this.iface.idInformeActual, "empresa,ejercicios");
      break;
    }
  }
  return nombre;
}

function multi_cabeceraInforme(nodo: FLDomNode, campo: String): String {
  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var texto: String;
  var sep: String = "       ";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();

  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (texCampo)
  {
    case "datosEmpresa": {
      debug("this.iface.nombreInformeActual = " + this.iface.nombreInformeActual);
      var idEmpresa: String;
      switch (this.iface.nombreInformeActual) {
        case "co_i_cuentasanuales": {
          idEmpresa = util.sqlSelect("co_i_cuentasanuales ca INNER JOIN ejercicios ej ON ca.i_co__subcuentas_codejercicioact = ej.codejercicio", "ej.idempresa", "ca.id = " + this.iface.idInformeActual, "empresa,ejercicios");
          break;
        }
        default: {
          idEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("id");
          break;
        }
      }
      var dE: Array = flfactppal.iface.pub_ejecutarQry("empresa", "nombre,cifnif,direccion,codpostal,ciudad,provincia", "id = " + idEmpresa);

      texto = dE.nombre + "    CIF/NIF " + dE.cifnif;
      texto += "\n" + dE.direccion + "    " + dE.codpostal + "  " + dE.ciudad + ", " + dE.provincia;
      break;
    }
    default: {
      return this.iface.__cabeceraInforme(nodo, campo);
    }
  }

  if (!texto)
    texto = "";

  return texto;
}

//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
