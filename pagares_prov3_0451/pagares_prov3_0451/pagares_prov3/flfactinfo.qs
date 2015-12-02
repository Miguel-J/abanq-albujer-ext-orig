
/** @class_declaration pagaresProv3 */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV3 //////////////////////////////////////////////
class pagaresProv3 extends recibosProv
{
  function pagaresProv3(context)
  {
    recibosProv(context);
  }
  function fechaVencimiento(nodo: FLDomNode, campo: String): String {
    return this.ctx.pagaresProv3_fechaVencimiento(nodo, campo);
  }
  function mesEnLetra(mes: String): String {
    return this.ctx.pagaresProv3_mesEnLetra(mes);
  }
  function fechaEnTexto(nodo: FLDomNode, campo: String): String {
    return this.ctx.pagaresProv3_fechaEnTexto(nodo, campo);
  }
}
//// PAGARES_PROV3 //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPagaresProv3 */
/////////////////////////////////////////////////////////////////
//// PUB_PAGARES_PROV3 //////////////////////////////////////////
class pubPagaresProv3 extends head
{
  function pubPagaresProv3(context)
  {
    head(context);
  }
  function pub_fechaVencimiento(nodo: FLDomNode, campo: String): String {
    return this.fechaVencimiento(nodo, campo);
  }
  function pub_fechaEnTexto(nodo: FLDomNode, campo: String): String {
    return this.fechaEnTexto(nodo, campo);
  }
}
//// PUB_PAGARES_PROV3 //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresProv3 */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV3 //////////////////////////////////////////////
function pagaresProv3_fechaVencimiento(nodo: FLDomNode, campo: String): String {
  var valor: String;
  var fechaV: String = nodo.attributeValue("pagaresprov.fechav");
  switch (campo)
  {
    case "dia": {
      valor = fechaV.right(2);
      break;
    }
    case "mes": {
      fechaV = fechaV.right(5);
      var mes: String = fechaV.left(2);
      valor = this.iface.mesEnLetra(mes);
      break;
    }
    case "ano": {
      valor = fechaV.left(4);
      break;
    }
  }
  return valor;
}

function pagaresProv3_mesEnLetra(mes: String): String {
  var valor: String;
  switch (mes)
  {
    case "01": {
      valor = "Enero";
      break;
    }
    case "02": {
      valor = "Febrero";
      break;
    }
    case "03": {
      valor = "Marzo";
      break;
    }
    case "04": {
      valor = "Abril";
      break;
    }
    case "05": {
      valor = "Mayo";
      break;
    }
    case "06": {
      valor = "Junio";
      break;
    }
    case "07": {
      valor = "Julio";
      break;
    }
    case "08": {
      valor = "Agosto";
      break;
    }
    case "09": {
      valor = "Septiembre";
      break;
    }
    case "10": {
      valor = "Octubre";
      break;
    }
    case "11": {
      valor = "Noviembre";
      break;
    }
    case "12": {
      valor = "Diciembre";
      break;
    }
  }
  return valor;
}

function pagaresProv3_fechaEnTexto(nodo: FLDomNode, campo: String): String {
  var valor: String;
  var f: Date = nodo.attributeValue("pagaresprov.fecha");
  var fecha: Date = new Date(Date.parse(f.toString()));
  var indexToMonth = [ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" ];
  var indexToDay = [ "Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis", "Siete", "Ocho", "Nueve", "Diez", "Once", "Doce", "Trece", "Catorce", "Quince", "Dieciseis", "Diecisiete", "Dieciocho", "Diecinueve", "Veinte", "Veintiuno", "Veintidos", "Veintitres", "Veinticuatro", "Veinticinco", "Veintiseis", "Veintisiete", "Veintiocho", "Veintinueve", "Treinta", "Treinta y uno" ];
  switch (campo)
  {
    case "dia": {
      valor = indexToDay[fecha.getDate(fecha) - 1];
      break;
    }
    case "mes": {
      valor = indexToMonth[fecha.getMonth() - 1];
      break;
    }
    case "ano": {
      valor = fecha.getYear();
      break;
    }
  }
  return valor;
}

//// PAGARES_PROV3 //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
