
/** @class_declaration servDtoEsp */
/////////////////////////////////////////////////////////////////
//// SERV_DTOESP ////////////////////////////////////////////////
class servDtoEsp extends oficial
{
  var bloqueoDto: Boolean;
  function servDtoEsp(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.servDtoEsp_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.servDtoEsp_bufferChanged(fN);
  }
  function calcularTotales()
  {
    return this.ctx.servDtoEsp_calcularTotales();
  }
  function calculateField(fN: String): String { return this.ctx.servDtoEsp_calculateField(fN); }
}
//// SERV_DTOESP ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servDtoEsp */
//////////////////////////////////////////////////////////////////
//// SERV_DTOESP /////////////////////////////////////////////////
function servDtoEsp_bufferChanged(fN: String)
{
  switch (fN) {
    case "neto": {
      this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
      this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
      this.iface.__bufferChanged(fN);
    }
    /** \C
    El --neto-- es el producto del --netosindtoesp-- por el --pordtoesp--
    \end */
    case "netosindtoesp": {
      this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
      break;
    }
    case "pordtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
        this.iface.bloqueoDto = false;
      }
      break;
    }
    case "dtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbPorDtoEsp").setValue(this.iface.calculateField("pordtoesp"));
        this.iface.bloqueoDto = false;
      }
      this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

function servDtoEsp_calcularTotales()
{
  this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
  this.iface.__calcularTotales();
}

function servDtoEsp_init()
{
  this.iface.__init();

  this.iface.bloqueoDto = false;
}

function servDtoEsp_calculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN)
  {
      /** \C
      El --totaliva-- es la suma del iva correspondiente a las líneas de servicio
      \end */
    case "totaliva": {
      var porDto: Number = cursor.valueBuffer("pordtoesp");
      if (!porDto || porDto == 0) {
        valor = this.iface.__calculateField(fN, cursor);
        break;
      }
      valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totaliva"));
      break;
    }
    /** \C
    El --totarecargo-- es la suma del recargo correspondiente a las líneas de servicio
    \end */
    case "totalrecargo": {
      var porDto: Number = cursor.valueBuffer("pordtoesp");
      if (!porDto || porDto == 0) {
        valor = this.iface.__calculateField(fN, cursor);
        break;
      }
      valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totalrecargo"));
      break;
    }
    /** \C
    El --netosindtoesp-- es la suma del pvp total de las líneas de factura
    */
    case "netosindtoesp": {
      valor = this.iface.__calculateField("neto", cursor);
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp--
    */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "neto"));
      break;
    }
    /** \C
    El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
    */
    case "dtoesp": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "dtoesp"));
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
      valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "pordtoesp"));
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN, cursor);
      break;
    }

  }
  return valor;
}
//// SERV_DTOESP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
