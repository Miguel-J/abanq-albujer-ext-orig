
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.barCode_init();
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.barCode_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.barCode_commonCalculateField(fN, cursor);
  }
  function datosTablaPadre(cursor: FLSqlCursor): Array {
    return this.ctx.barCode_datosTablaPadre(cursor);
  }
  function validateForm(): Boolean {
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
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
    this.child("fdbBarCode").setFilter("");
  else
    this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
}

function barCode_commonBufferChanged(fN: String, miForm: Object)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = miForm.cursor();
  switch (fN) {
    case "barcode": {
      if (cursor.valueBuffer("barcode") == "" || cursor.isNull("barcode")) {
        miForm.child("fdbTalla").setValue("");
        miForm.child("fdbColor").setValue("");
      } else {
        var ref = this.iface.commonCalculateField("referencia", cursor)
        if (ref && ref != "") {
          miForm.child("fdbReferencia").setValue(ref);
          miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", cursor));
        }
      }
      break;
    }
    case "referencia": {
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
        miForm.child("fdbBarCode").setFilter("");
        miForm.child("fdbDescripcion").setValue("");
        miForm.child("fdbBarCode").setValue("");
      } else {
        var referencia = cursor.valueBuffer("referencia");
        miForm.child("fdbBarCode").setFilter("referencia = '" + referencia + "'");
        if (!AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "' AND referencia = '" + referencia + "'")) {
          miForm.child("fdbBarCode").setValue("");
        }
      }
      this.iface.__commonBufferChanged(fN, miForm);
      break;
    }
    default: {
      this.iface.__commonBufferChanged(fN, miForm);
    }
  }
}

function barCode_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  var datosTP: Array = this.iface.datosTablaPadre(cursor);
  if (!datosTP)
    return false;
  var wherePadre: String = datosTP.where;
  var tablaPadre: String = datosTP.tabla;

  switch (fN)
  {
    case "referencia": {
      valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      if (!valor) {
        valor = "";
      }
      break;
    }
    case "pvpunitario": {
      var codProveedor: String = datosTP["codproveedor"];
      var codDivisa: String = datosTP["coddivisa"];
      var qryBarcode: FLSqlQuery = new FLSqlQuery();
      with(qryBarcode) {
        setTablesList("barcodeprov");
        setSelect("coste");
        setFrom("barcodeprov");
        setWhere("barcode = '" + cursor.valueBuffer("barcode") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
        setForwardOnly(true);
      }
      if (!qryBarcode.exec()) {
        return false;
      }
      if (!qryBarcode.first()) {
        valor = this.iface.__commonCalculateField(fN, cursor);
      } else {
        valor = qryBarcode.value("coste");
        var tasaConv: Number = datosTP["tasaconv"];
        valor = parseFloat(valor) / tasaConv;
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
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
function barCode_datosTablaPadre(cursor)
{
  var datos: Array;
  switch (cursor.table()) {
    case "lineastallacol": {
      datos.where  = cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre");
      switch (cursor.valueBuffer("tabla")) {
        case "lineaspedidosprov": {
          datos.tabla = "pedidosprov";
          break;
        }
        case "lineasalbaranesprov": {
          datos.tabla = "albaranesprov";
          break;
        }
        case "lineasfacturasprov": {
          datos.tabla = "facturasprov";
          break;
        }
      }
      var qryDatos: FLSqlQuery = new FLSqlQuery;
      qryDatos.setTablesList(datos.tabla);
      qryDatos.setSelect("coddivisa, codproveedor, fecha, tasaconv, codserie");
      qryDatos.setFrom(datos.tabla);
      qryDatos.setWhere(datos.where);
      qryDatos.setForwardOnly(true);
      if (!qryDatos.exec()) {
        return false;
      }
      if (!qryDatos.first()) {
        return false;
      }
      datos["coddivisa"] = qryDatos.value("coddivisa");
      datos["tasaconv"] = qryDatos.value("tasaconv");
      datos["codproveedor"] = qryDatos.value("codproveedor");
      datos["fecha"] = qryDatos.value("fecha");
      datos["codserie"] = qryDatos.value("codserie");
      break;
    }
    default: {
      datos = this.iface.__datosTablaPadre(cursor);
    }
  }
  return datos;
}

function barCode_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var cursor: FLSqlCursor = this.cursor();

  if (!flfacturac.iface.pub_validarLinea(cursor))
    return false;

  return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
