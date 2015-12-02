
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial
{
  var bloqueoPrecio, bloqueoTotal_;
  function ivaIncluido(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.ivaIncluido_init();
  }
  function habilitarPorIvaIncluido(miForm: Object)
  {
    return this.ctx.ivaIncluido_habilitarPorIvaIncluido(miForm);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor)
  {
    return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.ivaIncluido_commonBufferChanged(fN, miForm);
  }
  function calculaPrecio(miForm)
  {
    return this.ctx.ivaIncluido_calculaPrecio(miForm);
  }
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/** @class_declaration pubIvaIncluido */
/////////////////////////////////////////////////////////////////
//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
class pubIvaIncluido extends ifaceCtx
{
  function pubIvaIncluido(context)
  {
    ifaceCtx(context);
  }
  function pub_habilitarPorIvaIncluido(miForm: Object)
  {
    return this.habilitarPorIvaIncluido(miForm);
  }
}

//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
function ivaIncluido_init()
{
  var _i = this.iface;

  _i.bloqueoTotal_ = false;
  this.iface.__init();
  this.iface.habilitarPorIvaIncluido(form);
}

function ivaIncluido_habilitarPorIvaIncluido(miForm: Object)
{
  if (miForm.cursor().modeAccess() == miForm.cursor().Insert || miForm.cursor().modeAccess() == miForm.cursor().Edit) {
    if (miForm.cursor().valueBuffer("ivaincluido")) {
      miForm.child("fdbPvpUnitarioIva").setDisabled(false);
      miForm.child("fdbPvpSinDtoIva").setDisabled(false);
      miForm.child("fdbPvpUnitario").setDisabled(true);
      miForm.child("fdbPvpSinDto").setDisabled(true);
    } else {
      miForm.child("fdbPvpUnitarioIva").setDisabled(true);
      miForm.child("fdbPvpSinDtoIva").setDisabled(true);
      miForm.child("fdbPvpUnitario").setDisabled(false);
      miForm.child("fdbPvpSinDto").setDisabled(false);
    }
  }
}

function ivaIncluido_calculaPrecio(miForm)
{
  var _i = this.iface;
  var cursor = miForm.cursor();

  this.iface.bloqueoPrecio = true;
  var ivaIncluido = this.iface.commonCalculateField("ivaincluido", miForm.cursor());
  miForm.child("fdbIvaIncluido").setValue(ivaIncluido);
  miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
  miForm.cursor().setValueBuffer("costeunitario", this.iface.commonCalculateField("costeunitario", miForm.cursor()));

  if (ivaIncluido) {
    miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", miForm.cursor()));
    miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
  } else {
    miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
    miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
  }
  this.iface.bloqueoPrecio = false;
  this.iface.habilitarPorIvaIncluido(miForm);
}

function ivaIncluido_commonBufferChanged(fN: String, miForm: Object)
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = miForm.cursor();

  switch (fN) {

    case "ivaincluido": {
      this.iface.habilitarPorIvaIncluido(miForm);
    }
    case "iva": {
      if (!this.iface.bloqueoPrecio) {
        this.iface.bloqueoPrecio = true;
        if (miForm.cursor().valueBuffer("ivaincluido")) {
          miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
          miForm.cursor().setValueBuffer("pvpsindtoiva", this.iface.commonCalculateField("pvpsindtoiva2", miForm.cursor()));
          miForm.cursor().setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto2", miForm.cursor()));
        } else {
          miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
          miForm.cursor().setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
          miForm.cursor().setValueBuffer("pvpsindtoiva", this.iface.commonCalculateField("pvpsindtoiva", miForm.cursor()));
        }
        this.iface.bloqueoPrecio = false;
      }
      if (miForm.child("fdbPvpTotalIva")) {
        miForm.child("fdbPvpTotalIva").setDisabled(!cursor.valueBuffer("ivaincluido"));
      }
      break;
    }
    case "codimpuesto": {
      miForm.child("fdbIva").setValue(this.iface.commonCalculateField("iva", miForm.cursor()));
      miForm.child("fdbRecargo").setValue(this.iface.commonCalculateField("recargo", miForm.cursor()));
      /*      if (!this.iface.bloqueoPrecio && miForm.cursor().valueBuffer("ivaincluido")) {
              this.iface.bloqueoPrecio = true;
              miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
              this.iface.bloqueoPrecio = false;
            }*/
      break;
    }

    case "recargo": {
      if (!this.iface.bloqueoPrecio) {
        this.iface.bloqueoPrecio = true;
        if (miForm.cursor().valueBuffer("ivaincluido")) {
          miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
        } else {
          miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
        }
        this.iface.bloqueoPrecio = false;
      }
      break;
    }

    case "pvpunitarioiva": {
      if (!this.iface.bloqueoPrecio) {
        this.iface.bloqueoPrecio = true;
        miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
        this.iface.bloqueoPrecio = false;
      }
      break;
    }
    case "pvpunitario": {
      if (!this.iface.bloqueoPrecio) {
        this.iface.bloqueoPrecio = true;
        miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
        this.iface.bloqueoPrecio = false;
      }
    }
    case "cantidad": {
      if (miForm.cursor().valueBuffer("ivaincluido")) {
        miForm.cursor().setValueBuffer("pvpsindtoiva", this.iface.commonCalculateField("pvpsindtoiva2", miForm.cursor()));
        miForm.cursor().setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto2", miForm.cursor()));
      } else {
        this.iface.__commonBufferChanged(fN, miForm);
        miForm.cursor().setValueBuffer("pvpsindtoiva", this.iface.commonCalculateField("pvpsindtoiva", miForm.cursor()));
      }
      break;
    }

    case "pvpsindtoiva": {
      if (miForm.cursor().valueBuffer("ivaincluido")) {
        if (!_i.bloqueoTotal_) {
          _i.bloqueoTotal_ = true;
          miForm.cursor().setValueBuffer("pvptotaliva", this.iface.commonCalculateField("pvptotaliva2", miForm.cursor()));
          _i.bloqueoTotal_ = false;
        }
      }
      break;
    }
    case "pvpsindto":
    case "dtopor": {
      miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
    }
    case "dtolineal": {
      if (miForm.cursor().valueBuffer("ivaincluido")) {
        if (!_i.bloqueoTotal_) {
          _i.bloqueoTotal_ = true;
          miForm.cursor().setValueBuffer("pvptotaliva", this.iface.commonCalculateField("pvptotaliva2", miForm.cursor()));
          _i.bloqueoTotal_ = false;
        }
        miForm.cursor().setValueBuffer("pvptotal", this.iface.commonCalculateField("pvptotal2", miForm.cursor()));
      } else {
        this.iface.__commonBufferChanged(fN, miForm);
        miForm.cursor().setValueBuffer("pvptotaliva", this.iface.commonCalculateField("pvptotaliva", miForm.cursor()));
      }
      break;
    }
    case "pvptotaliva": { /// Para que el usuario ajuste el precio final y el descuento lineal se calcule automáticamente
      if (!_i.bloqueoTotal_) {
        _i.bloqueoTotal_ = true;
        sys.setObjText(miForm, "fdbDtoLineal", _i.commonCalculateField("dtolineal", cursor));
        _i.bloqueoTotal_ = false;
      }
      break;
    }
    //    case "pvptotal": {
    //      if (miForm.cursor().valueBuffer("ivaincluido")) {
    //        miForm.cursor().setValueBuffer("pvptotaliva", this.iface.commonCalculateField("pvptotaliva", miForm.cursor()));
    //      } else {
    //        miForm.cursor().setValueBuffer("pvptotaliva", this.iface.commonCalculateField("pvptotaliva2", miForm.cursor()));
    //      }
    //      break
    //    }
    default:
      return this.iface.__commonBufferChanged(fN, miForm);
  }
}

function ivaIncluido_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var util = new FLUtil();
  var valor;
  var referencia = cursor.valueBuffer("referencia");

  switch (fN) {
    case "ivaincluido": {
      valor = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
      break;
    }

    case "dtolineal": { /// Para que el usuario ajuste el precio final y el descuento lineal se calcule automáticamente
      var dtoLineal = cursor.valueBuffer("dtolineal");
      dtoLineal = isNaN(dtoLineal) ? 0 : dtoLineal;
      var valorTarifa = _i.commonCalculateField("pvptotaliva", cursor);
      valorTarifa = isNaN(valorTarifa) ? 0 : valorTarifa;
      var valorReal = cursor.valueBuffer("pvptotaliva");
      valorReal = isNaN(valorReal) ? 0 : valorReal;
      valor = parseFloat(valorTarifa) - parseFloat(valorReal) + parseFloat(dtoLineal);
      break;
    }
    case "pvpunitarioiva2": { // SIN IVA INCLUIDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      // El recargo no tiene por qué ir incluido
      //      var recargo= parseFloat(cursor.valueBuffer("recargo"));
      //      if (isNaN(recargo)) {
      //        iva = recargo;
      //      }
      //      iva += parseFloat(recargo);
      valor = cursor.valueBuffer("pvpunitario") * ((100 + iva) / 100);
      break;
    }
    case "pvpunitarioiva": { // CON IVA INCLUIDO
      valor = this.iface.__commonCalculateField("pvpunitario", cursor);
      break;
    }


    //    case "pvpunitario": { // SIN IVA INCLUIDO
    //      valor = this.iface.__commonCalculateField("pvpunitario", cursor);
    //    }
    case "pvpunitario2": { // CON IVA INCLUIDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      /// El recargo no tiene por qué ir incluido
      //      var recargo= parseFloat(cursor.valueBuffer("recargo"));
      //      if (isNaN(recargo)) {
      //        recargo = 0;
      //      }
      //      iva += parseFloat(recargo);
      valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) / ((100 + iva) / 100);
      break;
    }


    case "pvpsindto": { // SIN IVA INCLULIDO
      valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
      break;
    }
    case "pvpsindto2" : { // CON IVA INCLUIDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      //        var pvpSinDtoIva = parseFloat(cursor.valueBuffer("pvpsindtoiva"));
      //        valor =  pvpSinDtoIva - (pvpSinDtoIva*iva/100);

      valor = parseFloat(cursor.valueBuffer("pvpsindtoiva")) / ((100 + iva) / 100);
      break
      break
    }


    case "pvpsindtoiva": { // SIN IVA INCLUIDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      var pvpSinDto = parseFloat(cursor.valueBuffer("pvpsindto"));
      valor = parseFloat(pvpSinDto + (pvpSinDto * iva / 100));
      break;
    }
    case "pvpsindtoiva2": { // CON IVA INCLUIDO
      valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) * parseFloat(cursor.valueBuffer("cantidad"));
      valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpunitarioiva");
      break;
    }


    case "pvptotal": { // SIN IVA INCLUILDO
      var dtoPor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
      dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
      valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
      break;
    }
    case "pvptotal2": { // CON IVA INCLUILDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      //        var pvpTotalIva = parseFloat(cursor.valueBuffer("pvptotaliva"));
      //        valor =  pvpTotalIva - (pvpTotalIva*iva/100);
      valor = parseFloat(cursor.valueBuffer("pvptotaliva")) / ((100 + iva) / 100);
      break;
    }


    case "pvptotaliva": { // SIN IVA INCLUIDO
      var iva = parseFloat(cursor.valueBuffer("iva"));
      if (isNaN(iva)) {
        iva = 0;
      }
      var pvpTotal = parseFloat(cursor.valueBuffer("pvptotal"));
      valor = parseFloat(pvpTotal + (pvpTotal * iva / 100));
      break;
    }
    case "pvptotaliva2": { // CON IVA INCLUIDO
      var dtoPor = (cursor.valueBuffer("pvpsindtoiva") * cursor.valueBuffer("dtopor")) / 100;
      dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindtoiva");
      valor = cursor.valueBuffer("pvpsindtoiva") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
      break;
    }


    default:
      return this.iface.__commonCalculateField(fN, cursor);
  }
  return valor;
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////