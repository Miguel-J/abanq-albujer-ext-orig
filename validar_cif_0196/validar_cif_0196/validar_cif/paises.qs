
/** @class_declaration valCif */
/////////////////////////////////////////////////////////////////
//// VALIDACIÓN DE CIF //////////////////////////////////////////
class valCif extends oficial
{
  var exigir: Boolean;
  function valCif(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.valCif_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.valCif_bufferChanged(fN);
  }
  function pbnEstablecerFuncion_clicked()
  {
    return this.ctx.valCif_pbnEstablecerFuncion_clicked();
  }
  function textoFuncion()
  {
    return this.ctx.valCif_textoFuncion();
  }
  function textoFuncionFr()
  {
    return this.ctx.valCif_textoFuncionFr();
  }
}
//// VALIDACIÓN DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition valCif*/
/////////////////////////////////////////////////////////////////
//// VALIDACIÓN DE CIF //////////////////////////////////////////
function valCif_init()
{
  this.iface.__init();
  this.iface.exigir = true;
  connect(this.child("pbnEstablecerFuncion"), "clicked()", this, "iface.pbnEstablecerFuncion_clicked()");
}

function valCif_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "exigirvalidacion": {
      if (cursor.valueBuffer("exigirvalidacion") == true) {
        var codIso: String = cursor.valueBuffer("codiso");
        if (!codIso || codIso == "") {
          MessageBox.information(util.translate("scripts", "No tiene establecido el código I.S.O. para el país.\nDebe establecerlo antes de exigir la validación"), MessageBox.Ok, MessageBox.NoButton);
          this.child("fdbExigirValidacion").setValue(false)
          return false;
        }
        if (codIso == "ES") {
          if (this.iface.exigir == true) {
            this.child("fdbFuncionValidacion").setValue(this.iface.textoFuncion());
            this.child("fdbFuncionValidacion").setDisabled(false);
          }
          this.iface.exigir = false;
        }
      }
      break;
    }
  }
}

function valCif_pbnEstablecerFuncion_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  if (cursor.valueBuffer("exigirvalidacion") == true) {
    var res: Number = MessageBox.information(util.translate("scripts", "Va a modificar la función de validación por la función por defecto para el país con código I.S.O. %1\n¿Desea continuar?").arg(cursor.valueBuffer("codiso")), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;

    if (cursor.valueBuffer("codiso") == "ES") {
      this.child("fdbFuncionValidacion").setValue(this.iface.textoFuncion());
      this.child("fdbFuncionValidacion").setDisabled(false);
    }
    if (cursor.valueBuffer("codiso") == "FR") {
      this.child("fdbFuncionValidacion").setValue(this.iface.textoFuncionFr());
      this.child("fdbFuncionValidacion").setDisabled(false);
    }
  }
}

function valCif_textoFuncion(): String {
  var texto: String = "if (!arguments[0]) return util.translate(\"scripts\", \"Debe indicar el CIF/NIF\");\n" +
  "cif = arguments[0].toString(); \n" +
  "tipoIdFiscal = arguments[1].toString(); \n" +
  "util = new FLUtil;\n" +
  "if (tipoIdFiscal != \"NIF\") return \"OK\";\n" +
  "if (cif == \"0\") return \"OK\";\n" +
  "cif = cif.toUpperCase();\n" +
  "vat = cif.replace(/^ES/,\"\");\n" +
  "if (vat.length != 9)\n" +
  "	return util.translate(\"scripts\", \"Longitud del CIF/NIF incorrecta\");\n" +
  "switch(vat.left(1)) {\n" +
  "	case \"X\": {\n" +
  "		vat = \"0\" + vat.right(8);\n" +
  "		break;\n" +
  "	}\n" +
  "	case \"Y\": {\n" +
  "		vat= \"1\" + vat.right(8);\n" +
  "		break;\n" +
  "	}\n" +
  "	case \"Z\": {\n" +
  "		vat= \"2\" + vat.right(8);\n" +
  "		break;\n" +
  "	}\n" +
  "}\n" +
  "expresion = /(^[A-Z]{1})([0-9]{1,7})([0-9]{1}$)/;\n" +
  "ok = expresion.search(vat);\n" +
  "if (ok == -1) {\n" +
  "	expresion = /(^[A-Z]{1})([0-9]{1,7})([A-Z]{1}$)/;\n" +
  "	ok = expresion.search(vat);\n" +
  "	if (ok == -1) {\n" +
  "		expresion = /()(^[0-9]{1,8})([A-Z]{1}$)/;\n" +
  "		ok = expresion.search(vat);\n" +
  "		if (ok == -1)\n" +
  "			return util.translate(\"scripts\",\"Caracteres invÃ¡lidos en CIF/NIF\");\n" +
  "		}\n" +
  "	}\n" +
  "tipo = expresion.cap(1);\n" +
  "nro = expresion.cap(2);\n" +
  "dc = expresion.cap(3);\n" +
  "if (tipo == \"\"){\n" +
  "	nro = \"00000000\" + nro;\n" +
  "	textonro = nro.right(8);\n" +
  "	nro = parseFloat(textonro);\n" +
  "	}\n" +
  "else {\n" +
  "	nro = \"0000000\" + nro;\n" +
  "	textonro = nro.right(7);\n" +
  "	nro = parseFloat(textonro);\n" +
  "}\n" +
  "expresion = /[A-J]|[NPQRSUVW]/;\n" +
  "ok = expresion.search(tipo);\n" +
  "if (ok != -1) {\n" +
  "	lista = \"JABCDEFGHI\";\n" +
  "	control = 0 ;\n" +
  "	pares = 0 ;\n" +
  "	impares = 0 ;\n" +
  "	for ( i = 0; i < textonro.length; i++ ) {\n" +
  "		if (i%2==0) {\n" +
  "			c = parseInt(textonro.substring(i, i+1)) * 2;\n" +
  "			c = c%10 + Math.floor(c/10);\n" +
  "			impares += c;\n" +
  "		} else {\n" +
  "			c = parseInt(textonro.substring(i,i+1));\n" +
  "			pares += c;\n" +
  "		}\n" +
  "	}\n" +
  "	control = parseInt(pares) + parseInt(impares);\n" +

  "	control = 10 - control % 10;\n" +
  "	if (control == 10) control = 0;\n" +
  "	control = parseInt(control);\n" +
  "	expresion2 = /[KPQS]/;\n" +
  "	ok = expresion2.search(tipo);\n" +
  "	if (ok != -1) {\n" +
  "		control = lista.substring(control,control+1);\n" +
  "	} else {\n" +
  "		expresion2 = /[ABEH]/;\n" +
  "		ok = expresion2.search(tipo);\n" +
  "		if (ok != -1) {\n" +
  "			// Control es un número para ABEH\n" +
  "		} else {\n" +
  "			if (isNaN(dc)) {\n" +
  "				control = lista.substring(control,control+1);\n" +
  "			}\n" +
  "		}\n" +
  "	}\n" +
  "} else {\n" +
  "	expresion = /[KLMX]/;\n" +
  "	ok = expresion.search(tipo);\n" +
  "	if (ok != -1 | tipo == \"\"){\n" +
  "		letras = \"TRWAGMYFPDXBNJZSQVHLCKE\";\n" +
  "		control = nro % 23;\n" +
  "		control = letras.substring(control,control+1);\n" +
  "	}\n" +
  "	else\n" +
  "		return util.translate(\"scripts\",\"Formato de CIF/NIF inválido\");\n" +
  "}\n" +
  "if (control != dc)\n" +
  "	return util.translate(\"scripts\",\"Formato de CIF/NIF inválido\");\n" +
  "else return \"OK\";\n";

  return texto;

}

function valCif_textoFuncionFr()
{
  var texto = "if (!arguments[0]) return util.translate(\"scripts\", \"Debe indicar el CIF/NIF\");\n" +
              "cif = arguments[0].toString();\n" +
              "tipoIdFiscal = arguments[1].toString(); \n" +
              "util = new FLUtil;\n" +
              "\n" +
              "cif = cif.toUpperCase();\n" +
              "if (!cif.startsWith(\"FR\")) return util.translate(\"scripts\", \"El CIF/NIF debe comenzar por 'FR'\");\n" +
              "vat = cif.replace(/^FR/,\"\");\n" +
              "if (vat.length != 11) return util.translate(\"scripts\", \"Longitud del CIF/NIF incorrecta\");\n" +
              "c1 = vat.charAt(0);\n" +
              "c2 = vat.charAt(1);\n" +
              "if (!isNaN(c1) && !isNaN(c2)) {\n" +
              "// NIF Viejo\n" +
              "  dc = parseInt(c1 * 10) + parseInt(c2);\n" +
              "  n = parseFloat(vat.right(9));\n" +
              "  dc2 = (n * 100 + 12) % 97;\n" +
              "  return dc == dc2 ? \"OK\" : util.translate(\"scripts\", \"Formato de CIF/NIF inválido\");\n" +
              "} else {\n" +
              "// NIF Nuevo\n" +
              "  c = \"0123456789ABCDEFGHJKLMNPQRSTUVWXYZ\";\n" +
              "  vC1 = c.find(c1);\n" +
              "  vC2 = c.find(c2);\n" +
              "  if (vC1 < 0 || vC2 < 0) util.translate(\"scripts\", \"Formato de CIF/NIF inválido\");\n" +
              "  s = (vC1 < 10) ? vC1 * 24 + vC2 - 10 : vC1 * 34 + vC2 - 100;\n" +
              "  x = s % 11;\n" +
              "  s = Math.floor(s / 11) + 1;\n" +
              "  n = parseFloat(vat.right(9));\n" +
              "  y = (n + s) % 11;\n" +
              "  return x == y ? \"OK\" : util.translate(\"scripts\", \"Formato de CIF/NIF inválido\");\n" +
              "}\n";

  return texto;
}

//// VALIDACIÓN DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
