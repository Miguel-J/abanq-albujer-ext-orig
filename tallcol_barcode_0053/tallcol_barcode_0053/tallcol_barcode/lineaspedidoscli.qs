
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  var bloqueoBarCode_;
  var bloqueoReferencia_;
  function barCode(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.barCode_init();
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.barCode_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.barCode_commonCalculateField(fN, cursor);
  }
  function datosWhereTablaPadre(cursor)
  {
    return this.ctx.barCode_datosWhereTablaPadre(cursor);
  }
  function validateForm()
  {
    return this.ctx.barCode_validateForm();
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
  var _i = this.iface;
  _i.__init();

  var cursor = this.cursor();
  if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
    this.child("fdbBarCode").setFilter("");
  } else {
    this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
  }
  _i.bloqueoBarCode_ = false;
  _i.bloqueoReferencia_ = false;

}

function barCode_commonBufferChanged(fN, miForm)
{
  debug("barCode_commonBufferChanged fN: " + fN);
  var _i = this.iface;
  var cursor = miForm.cursor();
  switch (fN) {
    case "barcode": {
      if (!_i.bloqueoBarCode_) {
        _i.bloqueoBarCode_ = true;
        if (cursor.valueBuffer("barcode") == "" || cursor.isNull("barcode")) {
          miForm.child("fdbTalla").setValue("");
          miForm.child("fdbColor").setValue("");
        } else {
          var ref = _i.commonCalculateField("referencia", cursor);
          if (ref && ref != "") {
            miForm.child("fdbReferencia").setValue(ref);
            if (cursor.fieldType("ivaincluido") == 18) { // para saber si está cargada la extensión de ivaincluido
              if (cursor.valueBuffer("ivaincluido")) {
                miForm.child("fdbPvpUnitarioIva").setValue(_i.commonCalculateField("pvpunitarioiva", miForm.cursor()));
                miForm.cursor().setValueBuffer("pvpunitario", _i.commonCalculateField("pvpunitario2", miForm.cursor()));
              } else {
                miForm.cursor().setValueBuffer("pvpunitario", _i.commonCalculateField("pvpunitario", miForm.cursor()));
                miForm.child("fdbPvpUnitarioIva").setValue(_i.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
              }
            } else {
              miForm.child("fdbPvpUnitario").setValue(_i.commonCalculateField("pvpunitario", cursor));
            }
          }
        }
        _i.bloqueoBarCode_ = false;
      }
      break;
    }
    case "referencia": {
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
        miForm.child("fdbDescripcion").setValue("");
        miForm.child("fdbBarCode").setFilter("");
        miForm.child("fdbBarCode").setValue("");
        miForm.child("fdbTalla").setValue("");
        miForm.child("fdbColor").setValue("");
      } else {
        var referencia = cursor.valueBuffer("referencia");
        miForm.child("fdbBarCode").setFilter("referencia = '" + referencia + "'");

        var barCodeUnico = _i.commonCalculateField("barcodeunico", cursor);
        if (barCodeUnico) {
          miForm.child("fdbBarCode").setValue(barCodeUnico);
        }

        if (!AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "' AND referencia = '" + referencia + "'")) {
          if (!_i.bloqueoBarCode_) {
            _i.bloqueoBarCode_ = true;
            miForm.child("fdbBarCode").setValue("");
            miForm.child("fdbTalla").setValue("");
            miForm.child("fdbColor").setValue("");
            _i.bloqueoBarCode_ = false;
          }
        }
      }
      _i.__commonBufferChanged(fN, miForm);
      break;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function barCode_commonCalculateField(fN, cursor)
{
  var _i = this.iface;

  var valor;
  var datosTP = _i.datosTablaPadre(cursor);
  if (!datosTP) {
    return false;
  }
  var wherePadre = datosTP.where;
  var tablaPadre = datosTP.tabla;

  switch (fN) {
    case "referencia": {
      valor = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      if (!valor) {
        valor = "";
      }
      break;
    }
    case "pvpunitario": {
      var codCliente: String = datosTP["codcliente"];
      var barcode: String = cursor.valueBuffer("barcode");
      var referencia: String = cursor.valueBuffer("referencia");
      var codTarifa: String = _i.obtenerTarifa(codCliente, cursor);
      var tasaConv: Number = datosTP["tasaconv"];

      // 1. Barcode con tarifa?
      if (codTarifa) {
        valor = AQUtil.sqlSelect("atributostarifas", "pvp", "barcode = '" + barcode + "' AND codtarifa = '" + codTarifa + "'");
        if (!valor || isNaN(valor)) {
          return _i.__commonCalculateField(fN, cursor);
        }
      }
      // 2. Barcode con precio especial?
      if (!valor) {
        var qryBarcode: FLSqlQuery = new FLSqlQuery();
        with(qryBarcode) {
          setTablesList("atributosarticulos");
          setSelect("pvp");
          setFrom("atributosarticulos");
          setWhere("pvpespecial = true AND barcode = '" + barcode + "'");
          setForwardOnly(true);
        }
        if (!qryBarcode.exec()) {
          return false;
        }
        // 3. Precio normal del artículo
        if (!qryBarcode.first()) {
          return _i.__commonCalculateField(fN, cursor);
        } else {
          valor = qryBarcode.value("pvp");
        }
      }
      valor = parseFloat(valor) / tasaConv;
      break;
    }
    case "barcodeunico": {
      valor = parseFloat(AQUtil.sqlSelect("atributosarticulos", "COUNT(barcode)", "referencia = '" + cursor.valueBuffer("referencia") + "'"));
      if (valor == 1) {
        valor = AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      } else {
        valor = false;
      }
      break
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }

  return valor;
}

/** \D Devuelve la tabla padre de la tabla parámetro, así como la cláusula where necesaria para localizar el registro padre
@param  cursor: Cursor cuyo padre se busca
@return Array formado por:
  * where: Cláusula where
  * tabla: Nombre de la tabla padre
o false si hay error
\end */
function barCode_datosWhereTablaPadre(cursor)
{
  var _i = this.iface;

  var datos = new Object;

  switch (cursor.table()) {
    case "lineastallacolcli": {
      datos.where  = cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre");
      switch (cursor.valueBuffer("tabla")) {
        case "lineaspresupuestoscli": {
          datos.tabla = "presupuestoscli";
          break;
        }
        case "lineaspedidoscli": {
          datos.tabla = "pedidoscli";
          break;
        }
        case "lineasalbaranescli": {
          datos.tabla = "albaranescli";
          break;
        }
        case "lineasfacturascli": {
          datos.tabla = "facturascli";
          break;
        }
      }
      break;
    }
    default: {
      datos = _i.__datosWhereTablaPadre(cursor);
    }
  }
  return datos;
}

function barCode_validateForm()
{
  var _i = this.iface;
  if (!_i.__validateForm())
    return false;

  var cursor = this.cursor();

  if (!flfacturac.iface.pub_validarLinea(cursor))
    return false;

  return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
