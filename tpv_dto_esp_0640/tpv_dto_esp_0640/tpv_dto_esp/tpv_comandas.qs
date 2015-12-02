
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial
{
  var bloqueoDto: Boolean;
  function dtoEspecial(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.dtoEspecial_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.dtoEspecial_bufferChanged(fN);
  }
  function calcularTotales()
  {
    return this.ctx.dtoEspecial_calcularTotales();
  }
  function calculateField(fN: String): String {
    return this.ctx.dtoEspecial_calculateField(fN);
  }
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
//////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ////////////////////////////////////////////////
function dtoEspecial_bufferChanged(fN: String)
{
  switch (fN) {
    case "total": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbNeto").setValue(this.iface.calculateField("neto2"));
        this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva2"));
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp2"));
        this.child("fdbPorDtoEsp").setValue(this.iface.calculateField("pordtoesp"));
        this.iface.bloqueoDto = false;
      }
      this.iface.__bufferChanged(fN);
      break;
    }
    case "totaliva": {
      if (!this.iface.bloqueoDto) {
        this.iface.__bufferChanged(fN);
      }
      break;
    }
    case "neto": {
      if (!this.iface.bloqueoDto) {
        form.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
        //      form.child("fdbTotalComandaRecargo").setValue(this.iface.calculateField("totalrecargo"));
        this.iface.__bufferChanged(fN);
      }
      break;
    }
    /** \C
    El --neto-- es el producto del --netosindtoesp-- por el --pordtoesp--
    \end */
    case "netosindtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
        this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
        this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
        this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
        this.iface.bloqueoDto = false;
      }

      break;
    }
    case "pordtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
        this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
        this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
        this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
        this.iface.bloqueoDto = false;
      }
      break;
    }
    case "dtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbPorDtoEsp").setValue(this.iface.calculateField("pordtoesp"));
        this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
        this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
        this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
        this.iface.bloqueoDto = false;
      }
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

function dtoEspecial_calcularTotales()
{
  var idFactura: Number = this.cursor().valueBuffer("idfactura");
  this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
  this.iface.__calcularTotales();
}

function dtoEspecial_init()
{
  this.iface.__init();

  this.iface.bloqueoDto = false;
}

function dtoEspecial_calculateField(fN: String): String {
  var util = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var valor;

  switch (fN)
  {
    case "neto2": { /// Neto cuando se cambia manualmente el total de la venta
      var iva: Number = parseFloat(util.sqlSelect("tpv_lineascomanda", "iva", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda")));
      if (isNaN(iva)) {
        iva = 0;
      }
      valor = (parseFloat(cursor.valueBuffer("total")) * 100) / (100 + iva);
      valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "neto"));
      break;
    }
    case "totaliva2": { /// Total de IVA cuando se cambia manualmente el total de la venta
      valor = parseFloat(cursor.valueBuffer("total")) - parseFloat(cursor.valueBuffer("neto"))
              valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "totaliva"));
      break;
    }
    case "dtoesp2": { /// Descuento especial cuando se cambia manualmente el total de la venta
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("neto"))
              valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "dtoesp"));
      break;
    }
    case "totaliva": {
      var porDto: Number = cursor.valueBuffer("pordtoesp");
      if (!porDto || porDto == 0) {
        valor = this.iface.__calculateField(fN);
        break;
      }
      var codCli: String = cursor.valueBuffer("codcliente");
      var regIva: String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
      if (regIva == "U.E." || regIva == "Exento") {
        valor = 0;
        break;
      }
      valor = util.sqlSelect("tpv_lineascomanda", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
      valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "totaliva"));
      break;
    }
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
      valor = this.iface.__calculateField("neto");
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
      valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "neto"));
      break;
    }
    /** \C
    El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
    \end */
    case "dtoesp": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "dtoesp"));
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
      valor = parseFloat(util.roundFieldValue(valor, "tpv_comandas", "pordtoesp"));
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
      break;
    }
  }
  return valor;
}
//// DTO ESPECIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
