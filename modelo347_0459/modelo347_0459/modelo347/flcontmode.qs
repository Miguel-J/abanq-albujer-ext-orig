
/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends oficial
{
  var numOperador347: Number;
  var parcialHoja347: Number;
  var cuentaPagoEfectivo347_;

  function modelo347(context)
  {
    oficial(context);
  }
  function iniciarDE347(nodo: FLDomNode, campo: String)
  {
    return this.ctx.modelo347_iniciarDE347(nodo, campo);
  }
  function siguienteDE347(nodo: FLDomNode, campo: String)
  {
    return this.ctx.modelo347_siguienteDE347(nodo, campo);
  }
  function iniciarParcial347(nodo: FLDomNode, campo: String)
  {
    return this.ctx.modelo347_iniciarParcial347(nodo, campo);
  }
  function incrementarParcial347(nodo: FLDomNode, campo: String)
  {
    return this.ctx.modelo347_incrementarParcial347(nodo, campo);
  }
  function valorParcial347(nodo: FLDomNode, campo: String)
  {
    return this.ctx.modelo347_valorParcial347(nodo, campo);
  }
  function formatoAlfabetico347(cadena: String)
  {
    return this.ctx.modelo347_formatoAlfabetico347(cadena);
  }
  function formatoAlfanumerico347(texto: String)
  {
    return this.ctx.modelo347_formatoAlfanumerico347(texto);
  }
  function importeMetalicoCli347(cursor, codCliente, fechaInicio, fechaFin)
  {
    return this.ctx.modelo347_importeMetalicoCli347(cursor, codCliente, fechaInicio, fechaFin);
  }
  function importeMetalicoProv347(cursor, codProveedor, fechaInicio, fechaFin)
  {
    return this.ctx.modelo347_importeMetalicoProv347(cursor, codProveedor, fechaInicio, fechaFin);
  }
  function cargarCuentaPagoEfectivo()
  {
    return this.ctx.modelo347_cargarCuentaPagoEfectivo();
  }
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo347 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO347 /////////////////////////////////////////////
class pubModelo347 extends ifaceCtx
{
  function pubModelo347(context)
  {
    ifaceCtx(context);
  }
  function pub_iniciarDE347(nodo: FLDomNode, campo: String)
  {
    return this.iniciarDE347(nodo, campo);
  }
  function pub_siguienteDE347(nodo: FLDomNode, campo: String)
  {
    return this.siguienteDE347(nodo, campo);
  }
  function pub_iniciarParcial347(nodo: FLDomNode, campo: String)
  {
    return this.iniciarParcial347(nodo, campo);
  }
  function pub_incrementarParcial347(nodo: FLDomNode, campo: String)
  {
    return this.incrementarParcial347(nodo, campo);
  }
  function pub_valorParcial347(nodo: FLDomNode, campo: String)
  {
    return this.valorParcial347(nodo, campo);
  }
  function pub_formatoAlfabetico347(cadena: String)
  {
    return this.formatoAlfabetico347(cadena);
  }
  function pub_formatoAlfanumerico347(cadena: String)
  {
    return this.formatoAlfanumerico347(cadena);
  }
  function pub_importeMetalicoCli347(cursor, codCliente, fechaInicio, fechaFin)
  {
    return this.importeMetalicoCli347(cursor, codCliente, fechaInicio, fechaFin);
  }
  function pub_importeMetalicoProv347(cursor, codProveedor, fechaInicio, fechaFin)
  {
    return this.importeMetalicoProv347(cursor, codProveedor, fechaInicio, fechaFin);
  }
  function pub_cargarCuentaPagoEfectivo()
  {
    return this.cargarCuentaPagoEfectivo();
  }
}

//// PUB_MODELO347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
/** \D Inicia a cero el contador de declarados del modelo 347
\end */
function modelo347_iniciarDE347(nodo: FLDomNode, campo: String)
{
  this.iface.numOperador347 = 0;
}

/** \D Devuelve la cadena "Declarado" + número del contador de declarados, e incrementa el contador
\end */
function modelo347_siguienteDE347(nodo: FLDomNode, campo: String)
{
  this.iface.numOperador347++;
  return "Declarado " + this.iface.numOperador347;
}

/** \D Inicia a cero la variable que suma el importe total de cada hoja en el modelo 347
\end */
function modelo347_iniciarParcial347(nodo: FLDomNode, campo: String)
{
  this.iface.parcialHoja347 = 0;
  debug("iniciando parcial");
}

/** \D Suma a la variable la cantidad correspondiente de cada declarado en el modelo 347
\end */
function modelo347_incrementarParcial347(nodo: FLDomNode, campo: String)
{
  var importe =  nodo.attributeValue("co_modelo347_tipo2d.importe");
  this.iface.parcialHoja347 += parseFloat(importe);
  debug("incrementando parcial a " + this.iface.parcialHoja347);
}

/** \D Devuelve el valor del importe total de la hoja
\end */
function modelo347_valorParcial347(nodo: FLDomNode, campo: String)
{
  debug("obteniendo parcial a " + this.iface.parcialHoja347);
  return this.iface.parcialHoja347;
}

function modelo347_formatoAlfabetico347(texto: String)
{
  var validos = " ,-.ABCDEFGHIJKLMNOPQRSTUVWXYZ"; /// Se quita la comilla \' por error en mayton

  if (!texto || texto == "") {
    return texto;
  }
  var textoMay = this.iface.formatearTexto(texto);
  var resultado: String;
  var iPos: Number;
  var caracter: String;
  var carAnterior = "";
  for (var i = 0; i < textoMay.length; i++) {
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

function modelo347_formatoAlfanumerico347(texto: String)
{
  var validos = " &,-./0123456789:;ABCDEFGHIJKLMNOPQRSTUVWXYZ_"; /// Se quita la comilla \' por error en mayton

  if (!texto || texto == "") {
    return texto;
  }
  var textoMay = this.iface.formatearTexto(texto);
  var resultado: String;
  var iPos: Number;
  var caracter: String;
  var carAnterior = "";
  for (var i = 0; i < textoMay.length; i++) {
    caracter = textoMay.charAt(i);
    iPos = validos.find(caracter);
    if (!(caracter == " " && (carAnterior == " " || carAnterior == ""))) { /// Evita dos espacios seguidos
      resultado += caracter;
      carAnterior = caracter;
    }
  }
  return resultado;
}

function modelo347_importeMetalicoCli347(cursor, codCliente, fechaInicio, fechaFin)
{
  var util = new FLUtil;
  var valor = 0;
  if (util.fieldType("codcuentapagocli", "reciboscli") != 0) {
    valor = util.sqlSelect("reciboscli", "SUM(importe)", "codcliente = '" + codCliente + "' AND fechapago BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' AND (codcuentapagocli = '" + this.iface.cuentaPagoEfectivo347_ + "' OR codcuentapagocli IS NULL OR codcuentapagocli = '') AND estado = 'Pagado'");
  }
  valor = isNaN(valor) ? 0 : valor;
  return valor;
}

function modelo347_importeMetalicoProv347(cursor, codProveedor, fechaInicio, fechaFin)
{
  var util = new FLUtil;
  var valor = 0;
  if (util.fieldType("codcuentapagoprov", "recibosprov") != 0) {
    valor = util.sqlSelect("recibosprov", "SUM(importe)", "codproveedor = '" + codProveedor + "' AND fechapago BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' AND (codcuentapagoprov = '" + this.iface.cuentaPagoEfectivo347_ + "' OR codcuentapagoprov IS NULL OR codcuentapagoprov = '') AND estado = 'Pagado'");
  }
  valor = isNaN(valor) ? 0 : valor;
  return valor;
}

function modelo347_cargarCuentaPagoEfectivo()
{
  this.iface.cuentaPagoEfectivo347_ = this.iface.valorDefectoDatosFiscales("codcuentaefectivo")
}

                                    //// MODELO 347 /////////////////////////////////////////////////
                                    /////////////////////////////////////////////////////////////////
