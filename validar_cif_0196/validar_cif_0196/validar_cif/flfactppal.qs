
/** @class_declaration valCif */
/////////////////////////////////////////////////////////////////
//// VALIDACI”N DE CIF //////////////////////////////////////////
class valCif extends oficial
{
  function valCif(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.valCif_init();
  }
  function validarCif(cif: String, tipoIdFiscal: String, codPais: String): String {
    return this.ctx.valCif_validarCif(cif, tipoIdFiscal, codPais);
  }
  function validarCIFDocCli(cursor: FLSqlCursor): Boolean {
    return this.ctx.valCif_validarCIFDocCli(cursor);
  }
  function validarCIFDocProv(cursor: FLSqlCursor): Boolean {
    return this.ctx.valCif_validarCIFDocProv(cursor);
  }
}
//// VALIDACI”N DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_declaration pubValCif */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class pubValCif extends ifaceCtx
{
  function pubValCif(context)
  {
    ifaceCtx(context);
  }
  function pub_validarCif(cif: String, tipoIdFiscal: String, codPais: String): String {
    return this.validarCif(cif, tipoIdFiscal, codPais);
  }
  function pub_validarCIFDocCli(cursor: FLSqlCursor): Boolean {
    return this.validarCIFDocCli(cursor);
  }
  function pub_validarCIFDocProv(cursor: FLSqlCursor): Boolean {
    return this.validarCIFDocProv(cursor);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition valCif*/
/////////////////////////////////////////////////////////////////
//// VALIDACI”N DE CIF //////////////////////////////////////////
function valCif_init()
{
  this.iface.__init();
}

function valCif_validarCif(cif: String, tipoIdFiscal: String, codPais: String): String {
  var util: FLUtil = new FLUtil();

  //  if (codPais = "FR") {
  //    if (tipoIdFiscal != "NIF" && tipoIdFiscal != "NIF/IVA") return "OK";
  //
  //    cif = cif.toUpperCase();
  //    vat = cif.replace(/^FR/,"");
  //    if (vat.length != 11)
  //      return util.translate("scripts", "Longitud del CIF/NIF incorrecta");
  //    //expresion = /(^[0-9]|[A-H]|[J-N]|[P-Z]{2})([0-9]{1,9})([A-Z]{1}$)/;
  //    //ok = expresion.search(vat);
  //    ok = 0;
  //    if (ok == -1) {
  //      return util.translate("scripts","Caracteres inv√°lidos en CIF/NIF");
  //    }
  //    c1 = vat.charAt(0);
  //    c2 = vat.charAt(1);
  //    if (!isNaN(c1) && !isNaN(c2)) {
  //    // NIF Viejo
  //      dc = parseInt(c1 * 10) + parseInt(c2);
  //      n = parseFloat(vat.right(9));
  //      dc2 = (n * 100 + 12) % 97;
  //      return dc == dc2 ? "OK" : util.translate("scripts","Formato de CIF/NIF inv·lido");
  //    } else {
  //    // NIF Nuevo
  //      c = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ";
  //      vC1 = c.find(c1);
  //      vC2 = c.find(c2);
  //      if (vC1 < 0 || vC2 < 0) {
  //        util.translate("scripts","Formato de CIF/NIF inv·lido");
  //      }
  //      if (vC1 < 10) {
  //        s = vC1 * 24 + vC2 - 10;
  //      } else {
  //        s = vC1 * 34 + vC2 - 100;
  //      }
  //      x = s % 11;
  //      s = Math.floor(s / 11) + 1;
  //      n = parseFloat(vat.right(9));
  //      y = (n + s) % 11;
  //      return x == y ? "OK" : util.translate("scripts","Formato de CIF/NIF inv·lido");
  //    }
  //  }


  if (!codPais || codPais == "")
    return "OK";

  if (!util.sqlSelect("paises", "exigirvalidacion", "codpais = '" + codPais + "'"))
    return "OK";

  if (!tipoIdFiscal || tipoIdFiscal == "")
    tipoIdFiscal = "NIF";

  var textoFun: String = util.sqlSelect("paises", "funcionvalidacion", "codpais = '" + codPais + "'");
  if (!textoFun || textoFun == "")
    util.translate("scripts", "Aunque tiene activado Exigir validaciÛn de CIF/NIF para el\npaÌs %1 no tiene definida la correspondiente funciÛn de validaciÛn".arg(codPais));

  var funcionVal = new Function(textoFun);
  var resultado = funcionVal(cif, tipoIdFiscal);
  return resultado;
}

function valCif_validarCIFDocCli(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var cif: String = cursor.valueBuffer("cifnif");
  var codCliente: String = cursor.valueBuffer("codcliente");
  var codPais: String;
  var tipoIdFiscal: String;
  if (codCliente && codCliente != "")
  {
    codPais = util.sqlSelect("dirclientes", "codpais", "codcliente = '" + codCliente + "' AND domfacturacion = true");
    tipoIdFiscal = util.sqlSelect("clientes", "tipoidfiscal", "codcliente = '" + codCliente + "'");
  }
  if (!codPais || codPais == "")
  {
    codPais = cursor.valueBuffer("codpais");
  }
  if (!codPais || codPais == "")
  {
    MessageBox.warning(util.translate("scripts", "Para validar el CIF/NIF debe establecer el paÌs en la direcciÛn de facturaciÛn del cliente, o bien en la direcciÛn de este documento"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var res: String = this.iface.validarCif(cif, tipoIdFiscal, codPais);
  if (res != "OK")
  {
    MessageBox.warning(res, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function valCif_validarCIFDocProv(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var cif: String = cursor.valueBuffer("cifnif");
  var codProveedor: String = cursor.valueBuffer("codproveedor");
  var codPais: String;
  var tipoIdFiscal: String;
  if (codProveedor && codProveedor != "")
  {
    codPais = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");
    tipoIdFiscal = util.sqlSelect("proveedores", "tipoidfiscal", "codproveedor = '" + codProveedor + "'");
  }
  if (!codPais || codPais == "")
  {
    MessageBox.warning(util.translate("scripts", "Para validar el CIF/NIF debe establecer el paÌs en la direcciÛn principal del proveedor seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false
  }

  var res: String = this.iface.validarCif(cif, tipoIdFiscal, codPais);
  if (res != "OK")
  {
    MessageBox.warning(res, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

// function validarCIF(argum)
// {
//  var cif = argum.toString();
//  var util = new FLUtil;
//
//  if (cif.length != 9)
//    return util.translate("scripts", "Longitud del CIF/NIF incorrecta");
//
//  var digito0;
//  var digito1;
//  var digito2;
//  var digito3;
//  var digito4;
//  var digito5;
//  var digito6;
//  var digito7;
//  var digito8;
//
//  var esCIF:Boolean;
//  digito0 = parseInt(cif.charAt(0));
//  if (isNaN(digito0))
//    esCIF = true;
//  else
//    esCIF = false;
//
//  // Desde 1 - 7 deben ser n˙meros
//  digito1 = parseInt(cif.charAt(1));
//  if (isNaN(digito1))
//    return util.translate("scripts", "El 2∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito2 = parseInt(cif.charAt(2));
//  if (isNaN(digito2))
//    return util.translate("scripts", "El 3∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito3 = parseInt(cif.charAt(3));
//  if (isNaN(digito3))
//    return util.translate("scripts", "El 4∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito4 = parseInt(cif.charAt(4));
//  if (isNaN(digito4))
//    return util.translate("scripts", "El 5∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito5 = parseInt(cif.charAt(5));
//  if (isNaN(digito5))
//    return util.translate("scripts", "El 6∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito6 = parseInt(cif.charAt(6));
//  if (isNaN(digito6))
//    return util.translate("scripts", "El 7∫ dÌgito del CIF/NIF debe ser un n˙mero");
//  digito7 = parseInt(cif.charAt(7));
//  if (isNaN(digito7))
//    return util.translate("scripts", "El 8∫ dÌgito del CIF/NIF debe ser un n˙mero");
//
//  digito8 = parseInt(cif.charAt(8));
//  if (isNaN(digito8)) {
//    if (esCIF) {
//      return util.translate("scripts", "Formato del CIF/NIF incorrecto");
//    }
//  } else {
//    if (!esCIF) {
//      return util.translate("scripts", "Formato del CIF/NIF incorrecto");
//    }
//  }
//
//  var aux:Number;
//  if (esCIF) {
//    var pares:Number = digito2 + digito4 + digito6;
//    var impares:Number = 0;
//    aux = digito1 * 2;
//    impares += (aux % 10);
//    impares += (aux - (aux % 10)) / 10;
//    aux = digito3 * 2;
//    impares += (aux % 10);
//    impares += (aux - (aux % 10)) / 10;
//    aux = digito5 * 2;
//    impares += (aux % 10);
//    impares += (aux - (aux % 10)) / 10;
//    aux = digito7 * 2;
//    impares += (aux % 10);
//    impares += (aux - (aux % 10)) / 10;
//    var suma = pares + impares;
//    var digitoControl = 10 - (suma % 10);
//    if (digitoControl != digito8)
//      return util.translate("scripts", "DÌgito de control del CIF incorrecto");
//  } else {
//    var dni:Number = parseFloat(cif.left(8));
//    var cadena = "TRWAGMYFPDXBNJZSQVHLCKET";
//      var posicion = dni % 23;
//      letra = cadena.charAt(posicion);
//      if (letra != digito8.toUpperCase())
//      return util.translate("scripts", "Letra de control del NIF incorrecta");
//  }
//  return "OK";
// }

//// VALIDACI”N DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

