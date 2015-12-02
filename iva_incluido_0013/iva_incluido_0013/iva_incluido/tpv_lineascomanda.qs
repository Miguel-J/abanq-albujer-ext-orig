
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO //////// ///////////////////////////////////////
class ivaIncluido extends oficial
{
  var bloqueoPrecio;
  function ivaIncluido(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.ivaIncluido_init();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor)
  {
    return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
  }
  function calcularPvpTarifa(referencia: String, codTarifa: String)
  {
    return this.ctx.ivaIncluido_calcularPvpTarifa(referencia, codTarifa);
  }
  function bufferChanged(fN)
  {
    return this.ctx.ivaIncluido_bufferChanged(fN);
  }
}
//// IVA INCLUIDO //////// ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO //////// ////////////////////////////////////////
function ivaIncluido_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "referencia": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    case "codimpuesto": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    case "ivaincluido": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
    }
    case "pvpunitarioiva": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    case "pvpunitario": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
    }
    case "cantidad": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    case "pvpsindtoiva":
    case "pvpsindto":
    case "dtopor": {
      formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
      break;
    }
    default:
      return this.iface.__bufferChanged(fN);
  }
}


function ivaIncluido_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  var referencia = cursor.valueBuffer("referencia");

  switch (fN) {
    case "pvpunitarioiva":
    case "pvpunitarioiva2":
    case "pvpunitario2":
    case "pvpsindto":
    case "pvptotal": {
      valor = formRecordlineaspedidoscli.iface.commonCalculateField(fN, cursor);
      break;
    }
    case "ivaincluido": {
      if (referencia && referencia != "") {
        valor = formRecordlineaspedidoscli.iface.commonCalculateField(fN, cursor);
      } else {
        valor = flfact_tpv.iface.pub_valorDefectoTPV("ivaincluido");
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function ivaIncluido_init()
{
  var _i = this.iface;
  _i.__init();
  formRecordlineaspedidoscli.iface.pub_habilitarPorIvaIncluido(form);
}


/** \D
Calcula el --pvpunitario-- aplicandole la tarifa establecida el el formulario de edición de comandas
@param referencia identificador del artíuclo
@param codTarifa identificador de la tarifa
@return devuelve el pvp del articulo con la tarifa apliada si la tiene o el pvp del artículo si no hay ninguna tarifa especificada
*/
function ivaIncluido_calcularPvpTarifa(referencia: String, codTarifa: String)
{
  debug("ivaIncluido_calcularPvpTarifa");
  var util = new FLUtil();
  var pvp: Number;

  if (codTarifa)
    pvp = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");

  if (!pvp)
    pvp = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");


  var codImpuesto = formRecordtpv_comandas.iface.calculateField("ivaarticulo");
  debug("codImpuesto " + codImpuesto);
  var iva = parseFloat(util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'"));
  var ivaInc = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");

  if (util.sqlSelect("tpv_datosgenerales", "ivaincluido", "1=1")) {
    if (!ivaInc)
      pvp = pvp  * ((100 + iva) / 100);
  } else {
    if (ivaInc)
      pvp = pvp / ((100 + iva) / 100);
  }

  pvp = util.roundFieldValue(pvp, "tpv_lineascomanda", "pvpunitario");

  return pvp;
}



//// IVAINCLUIDO //////// ////////////////////////////////////////
//////////////////////////////////////////////////////////////////
