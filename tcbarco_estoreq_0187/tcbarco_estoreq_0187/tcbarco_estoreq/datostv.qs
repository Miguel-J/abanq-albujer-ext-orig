
/** @class_declaration tcEstoreQ */
/////////////////////////////////////////////////////////////////
//// TC_ESTOREQ /////////////////////////////////////////////////
class tcEstoreQ extends oficial
{
  function tcEstoreQ(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.tcEstoreQ_init();
  }
  function obtenerListaCampos(tabla)
  {
    return this.ctx.tcEstoreQ_obtenerListaCampos(tabla);
  }
}
//// TC_ESTOREQ //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tcEstoreQ */
/////////////////////////////////////////////////////////////////
//// TC_ESTOREQ /////////////////////////////////////////////////

/** Nuevas tablas
*/
function tcEstoreQ_init()
{
  this.iface.__init();

  this.iface.tablas = new Array(
    "idiomas",
    "infogeneral",
    "modulosweb",
    "noticias",
    "traducciones",
    "fabricantes",
    "faqs",

    "grupostalla",
    "tallas",
    "setstallas",
    "tallasset",
    "colores",
    "setscolores",
    "coloresset",

    "paises",
    "provincias",
    "tarifas",
    "almacenes",
    "gruposatributos",
    "familias",
    "plazosenvio",
    "articulos",
    "atributos",
    "atributosart",
    "accesoriosart",

    "atributosarticulos",
    "codigosdescuento",
    "stocks",

    "formasenvio",
    "formaspago",
    "opcionestv",
    "empresa"
  );
}

function tcEstoreQ_obtenerListaCampos(tabla)
{
  var _i = this.iface;

  if (tabla != "articulos")
    return _i.__obtenerListaCampos(tabla);

  var contenido: String = AQUtil.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");

  var xmlContenido = new FLDomDocument();
  xmlContenido.setContent(contenido);

  var listaCampos: FLDomNodeList;
  listaCampos = xmlContenido.elementsByTagName("field");

  var arrayCampos: Array = [];
  var paso: Number = 0;
  var nombreCampo = "";
  var camposOmiir = "codgrupomoda,codgrupotc,codtipoprenda,codtemporada,anno";
  for (var i = 0; i < listaCampos.length(); i++) {
    if (!listaCampos.item(i).namedItem("name"))
      continue;

    nombreCampo = listaCampos.item(i).namedItem("name").toElement().text();
    if (camposOmiir.find(nombreCampo) > -1)
      continue;

    arrayCampos[paso] = nombreCampo;
    paso++;
  }
  return arrayCampos;
}
//// TC_ESTOREQ /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////