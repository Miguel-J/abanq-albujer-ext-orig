
/** @class_declaration modelo349 */
/////////////////////////////////////////////////////////////////
//// MODELO 349 /////////////////////////////////////////////////
class modelo349 extends oficial
{
  var numOperador349: Number;

  function modelo349(context)
  {
    oficial(context);
  }
  function iniciarOP349(nodo: FLDomNode, campo: String): String {
    return this.ctx.modelo349_iniciarOP349(nodo, campo);
  }
  function siguienteOP349(nodo: FLDomNode, campo: String): String {
    return this.ctx.modelo349_siguienteOP349(nodo, campo);
  }
  function formatoAlfabetico349(texto: String): String {
    return this.ctx.modelo349_formatoAlfabetico349(texto);
  }
  function formatoAlfanumerico349(texto: String): String {
    return this.ctx.modelo349_formatoAlfanumerico349(texto);
  }
}
//// MODELO 349 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo349 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO349 /////////////////////////////////////////////
class pubModelo349 extends head
{
  function pubModelo349(context)
  {
    head(context);
  }
  function pub_iniciarOP349(nodo: FLDomNode, campo: String): String {
    return this.iniciarOP349(nodo, campo);
  }
  function pub_siguienteOP349(nodo: FLDomNode, campo: String): String {
    return this.siguienteOP349(nodo, campo);
  }
  function pub_formatoAlfabetico349(texto: String): String {
    return this.formatoAlfabetico349(texto);
  }
  function pub_formatoAlfanumerico349(texto: String): String {
    return this.formatoAlfanumerico349(texto);
  }
}
//// PUB_MODELO349 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo349 */
/////////////////////////////////////////////////////////////////
//// MODELO 349 /////////////////////////////////////////////////
/** \D Inicia a cero el contador de operadores del modelo 349
\end */
function modelo349_iniciarOP349(nodo: FLDomNode, campo: String): String {
  this.iface.numOperador349 = 0;
}

/** \D Devuelve la cadena "Operador" + número del contador de operadores, e incrementa el contador
\end */
function modelo349_siguienteOP349(nodo: FLDomNode, campo: String): String {
  this.iface.numOperador349++;
  return "Operador " + this.iface.numOperador349;
}

function modelo349_formatoAlfabetico349(texto: String): String {
  var validos: String = " ,-.ABCDEFGHIJKLMNOPQRSTUVWXYZÇÑ"; /// Se quita la comilla \' por error en mayton

  if (!texto || texto == "")
  {
    return texto;
  }
  var textoMay: String = this.iface.formatearTexto(texto);
  var resultado: String;
  var iPos: Number;
  var caracter: String;
  var carAnterior: String = "";
  for (var i: Number = 0; i < textoMay.length; i++)
  {
    caracter = textoMay.charAt(i);
    iPos = validos.find(caracter);
    if (iPos >= 0) {
      if (!(caracter == " " && (carAnterior == " " || carAnterior == ""))) { /// Evita dos espacios seguidos
        resultado += caracter;
        carAnterior = caracter;
      }
    }
  }
  return resultado;
}

function modelo349_formatoAlfanumerico349(texto: String): String {
  var validos: String = " &,-./0123456789:;ABCDEFGHIJKLMNOPQRSTUVWXYZ_ÇÑ"; /// Se quita la comilla \' por error en mayton

  if (!texto || texto == "")
  {
    return texto;
  }
  var textoMay: String = this.iface.formatearTexto(texto);
  var resultado: String;
  var iPos: Number;
  var caracter: String;
  var carAnterior: String = "";
  for (var i: Number = 0; i < textoMay.length; i++)
  {
    caracter = textoMay.charAt(i);
    iPos = validos.find(caracter);
    if (iPos >= 0) {
      if (!(caracter == " " && (carAnterior == " " || carAnterior == ""))) { /// Evita dos espacios seguidos
        resultado += caracter;
        carAnterior = caracter;
      }
    }
  }
  return resultado;
}

//// MODELO 349 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
