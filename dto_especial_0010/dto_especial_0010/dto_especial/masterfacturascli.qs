
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial
{
  function dtoEspecial(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
  }
  function copiaCampoFactura(nombreCampo, cursor, campoInformado)
  {
    return this.ctx.dtoEspecial_copiaCampoFactura(nombreCampo, cursor, campoInformado);
  }
  function totalesFactura(): Boolean {
    return this.ctx.dtoEspecial_totalesFactura();
  }
  function damePorDtoCabecera(cursor)
  {
    return this.ctx.dtoEspecial_damePorDtoCabecera(cursor);
  }
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util = new FLUtil();
  var valor;

  switch (fN)
  {
      /// Se usa la función damePorDtoCabecera
      //    case "totaliva": {
      //      var porDto:Number = cursor.valueBuffer("pordtoesp");
      //      if (!porDto || porDto == 0) {
      //        valor = this.iface.__commonCalculateField(fN, cursor);
      //        break;
      //      }
      //      var codCli:String = cursor.valueBuffer("codcliente");
      //      var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
      //      if (regIva == "U.E." || regIva == "Exento") {
      //        valor = 0;
      //        break;
      //      }
      //      valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
      //      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
      //      break;
      //    }
      //    case "totalrecargo": {
      //      var porDto:Number = cursor.valueBuffer("pordtoesp");
      //      if (!porDto || porDto == 0) {
      //        valor = this.iface.__commonCalculateField(fN, cursor);
      //        break;
      //      }
      //      var codCli:String = cursor.valueBuffer("codcliente");
      //      var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
      //      if (regIva == "U.E." || regIva == "Exento") {
      //        valor = 0;
      //        break;
      //      }
      //      valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
      //      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
      //      break;
      //    }
      /** \C
      El --netosindtoesp-- es la suma del pvp total de las líneas de factura
      \end */
    case "netosindtoesp": {
      valor = this.iface.__commonCalculateField("neto", cursor);
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "neto"));
      break;
    }
    /** \C
    El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
    \end */
    case "dtoesp": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "dtoesp"));
      break;
    }
    /** \C
    El --pordtoesp-- es el --dtoesp-- entre el --netosindtoesp-- por 100
    \end */
    case "pordtoesp": {
      if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
        valor = (parseFloat(cursor.valueBuffer("dtoesp")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
      } else {
        valor = cursor.valueBuffer("pordtoesp");
      }
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "pordtoesp"));
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

function dtoEspecial_copiaCampoFactura(nombreCampo, cursor, campoInformado)
{
  var _i = this.iface;
  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;
  var valor;
  switch (nombreCampo) {
      /// Estos valores se totalizan al final de la copia
    case "netosindtoesp":
    case "dtoesp": {
      valor = 0;
      break;
    }
    default: {
      if (!_i.__copiaCampoFactura(nombreCampo, cursor, campoInformado)) {
        return false;
      }
      return true;
      break;
    }
  }
  if (nulo) {
    this.iface.curFactura.setNull(nombreCampo);
  } else {
    this.iface.curFactura.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function dtoEspecial_totalesFactura(): Boolean {
  with(this.iface.curFactura)
  {
    setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", this));
    setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", this));
    setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
  }

  return true;
}

function dtoEspecial_damePorDtoCabecera(cursor)
{
  var dto = cursor.valueBuffer("pordtoesp");
  dto = isNaN(dto) ? 0 : dto;
  return dto;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////