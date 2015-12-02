
/** @class_declaration etiquetas */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS //////////////////////////////////////////////////
class etiquetas extends oficial
{
  function etiquetas(context)
  {
    oficial(context);
  }
  function datosEtiCliente(nodo: FLDomNode, campo: String): String {
    return this.ctx.etiquetas_datosEtiCliente(nodo, campo);
  }
  function datosEtiProv(nodo: FLDomNode, campo: String): String {
    return this.ctx.etiquetas_datosEtiProv(nodo, campo);
  }
}
//// ETIQUETAS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiquetas */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS //////////////////////////////////////////////////
function etiquetas_datosEtiCliente(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var nombre: String = nodo.toElement().attribute("clientes.nombre");
  var direccion: String = nodo.toElement().attribute("dirclientes.direccion");
  var apartado: String = nodo.toElement().attribute("dirclientes.apartado");
  var codPostal: String = nodo.toElement().attribute("dirclientes.codpostal");
  var ciudad: String = nodo.toElement().attribute("dirclientes.ciudad");
  var provincia: String = nodo.toElement().attribute("dirclientes.provincia");
  var pais: String = nodo.toElement().attribute("paises.nombre");

  var datos: String = "";
  switch (campo)   /// Contiene el modelo Apli
  {
    case "01276":
    default: {
      datos += nombre;
      datos += "\n";
      datos += direccion;
      datos += "\n";
      if (apartado && apartado != "") {
        datos += util.translate("scripts", "Apdo.") + apartado + " ";
      }
      if (codPostal && codPostal != "") {
        datos += codPostal + " ";
      }
      datos += ciudad;
      datos += "\n";
      if (provincia && provincia != "") {
        datos += provincia;
        if (pais && pais != "") {
          datos += " - ";
        }
      }
      if (pais && pais != "") {
        datos += pais;
      }
    }
  }
  return datos;
}

function etiquetas_datosEtiProv(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var nombre: String = nodo.toElement().attribute("proveedores.nombre");
  var direccion: String = nodo.toElement().attribute("dirproveedores.direccion");
  var apartado: String = nodo.toElement().attribute("dirproveedores.apartado");
  var codPostal: String = nodo.toElement().attribute("dirproveedores.codpostal");
  var ciudad: String = nodo.toElement().attribute("dirproveedores.ciudad");
  var provincia: String = nodo.toElement().attribute("dirproveedores.provincia");
  var pais: String = nodo.toElement().attribute("paises.nombre");

  var datos: String = "";
  switch (campo)   /// Contiene el modelo Apli
  {
    case "01276":
    default: {
      datos += nombre;
      datos += "\n";
      datos += direccion;
      datos += "\n";
      if (apartado && apartado != "") {
        datos += util.translate("scripts", "Apdo.") + apartado + " ";
      }
      if (codPostal && codPostal != "") {
        datos += codPostal + " ";
      }
      datos += ciudad;
      datos += "\n";
      if (provincia && provincia != "") {
        datos += provincia;
        if (pais && pais != "") {
          datos += " - ";
        }
      }
      if (pais && pais != "") {
        datos += pais;
      }
    }
  }
  return datos;
}
//// ETIQUETAS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
