
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class prodSofa extends prod
{
  var curTelaCorte: FLSqlCursor;
  function prodSofa(context)
  {
    prod(context);
  }
  //  function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
  //    return this.ctx.prodSofa_datosArticulo(cursor,referencia);
  //  }
  function copiarAnexosArticulo(refOriginal: String, refNueva: String)
  {
    return this.ctx.prodSofa_copiarAnexosArticulo(refOriginal, refNueva);
  }
  function copiarTelaCorte(id: Number, referencia: String): Number {
    return this.ctx.prodSofa_copiarTelaCorte(id, referencia);
  }
  function copiarTablaTelasCorte(refOriginal: String, refNueva: String): Boolean {
    return this.ctx.prodSofa_copiarTablaTelasCorte(refOriginal, refNueva);
  }
  function datosTelaCorte(cursorOrigen: FLSqlCursor, referencia: String): Boolean {
    return this.ctx.prodSofa_datosTelaCorte(cursorOrigen, referencia);
  }
  //  function datosArticuloComp(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean {
  //    return this.ctx.prodSofa_datosArticuloComp(cursor,cursorNuevo,referencia);
  //  }
  function copiarArticulo(refOriginal: String): String {
    return this.ctx.prodSofa_copiarArticulo(refOriginal);
  }
  function referenciaModCopia(): Array {
    return this.ctx.prodSofa_referenciaModCopia();
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
// function prodSofa_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
// {
//  if (!this.iface.__datosArticulo(cursor,referencia))
//    return false;
//
//  cursor.setValueBuffer("idserietela",this.iface.curArticulo.valueBuffer("idserietela"));
//  cursor.setValueBuffer("anchura",this.iface.curArticulo.valueBuffer("anchura"));
//  cursor.setValueBuffer("partecorte",this.iface.curArticulo.valueBuffer("partecorte"));
//  return true;
// }

function prodSofa_copiarAnexosArticulo(refOriginal: String, refNueva: String): Boolean {
  if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva))
  {
    return false;
  }
  if (!this.iface.copiarTablaTelasCorte(refOriginal, refNueva))
  {
    return false;
  }
  return true;
}

function prodSofa_copiarTablaTelasCorte(refOriginal: String, refNueva: String): Boolean {
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("telascorte");
  q.setSelect("idcorte");
  q.setFrom("telascorte");
  q.setWhere("referencia = '" + refOriginal + "'");

  if (!q.exec())
  {
    return false;
  }
  while (q.next())
  {
    if (!this.iface.copiarTelaCorte(q.value("idcorte"), refNueva)) {
      return false;
    }
  }

  return true;
}

function prodSofa_copiarTelaCorte(id: Number, refNueva: String): Number {
  var util: FLUtil = new FLUtil;

  var curTelaCorteOrigen: FLSqlCursor = new FLSqlCursor("telascorte");
  curTelaCorteOrigen.select("idcorte = " + id);
  if (!curTelaCorteOrigen.first())
  {
    return false;
  }
  curTelaCorteOrigen.setModeAccess(curTelaCorteOrigen.Browse);
  curTelaCorteOrigen.refreshBuffer();

  if (!this.iface.curTelaCorte)
  {
    this.iface.curTelaCorte = new FLSqlCursor("telascorte");
  }
  this.iface.curTelaCorte.setModeAccess(this.iface.curTelaCorte.Insert);
  this.iface.curTelaCorte.refreshBuffer();
  this.iface.curTelaCorte.setValueBuffer("referencia", refNueva);

  //  if (!this.iface.datosTelaCorte(curTelaCorte,curTelaCorteNueva,referencia))
  //    return false;
  var campos: Array = util.nombreCampos("telascorte");
  var totalCampos: Number = campos[0];
  for (var i: Number = 1; i <= totalCampos; i++)
  {
    if (!this.iface.datosTelaCorte(curTelaCorteOrigen, campos[i])) {
      return false;
    }
  }

  if (!this.iface.curTelaCorte.commitBuffer())
  {
    return false;
  }
  var idNuevo: Number = this.iface.curTelaCorte.valueBuffer("idcorte");

  return idNuevo;
}

function prodSofa_datosTelaCorte(cursorOrigen: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil = new FLUtil;

  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idcorte": {
      return true;
      break;
    }
    default: {
      if (cursorOrigen.isNull(campo)) {
        this.iface.curTelaCorte.setNull(campo);
      } else {
        this.iface.curTelaCorte.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
      }
    }
  }
  return true;
  //  cursorNuevo.setValueBuffer("referencia",referencia);
  //  cursorNuevo.setValueBuffer("longitud",cursor.valueBuffer("longitud"));
  //  cursorNuevo.setValueBuffer("anchura",cursor.valueBuffer("anchura"));

  //  return true;
}

// function prodSofa_datosArticuloComp(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean
// {
//  cursorNuevo.setValueBuffer("codfamiliacomponente",cursor.valueBuffer("codfamiliacomponente"));
//  cursorNuevo.setValueBuffer("idtipotareapro",cursor.valueBuffer("idtipotareapro"));
//  cursorNuevo.setValueBuffer("diasantelacion",cursor.valueBuffer("diasantelacion"));
//
//  return this.iface.__datosArticuloComp(cursor,cursorNuevo,referencia);
// }

function prodSofa_copiarArticulo(refOriginal: String): String {
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var datosNuevoArticulo: Array;
  switch (cursor.valueBuffer("codfamilia"))
  {
    case "MOD":
    case "CORT":
    case "ESQ": {
      datosNuevoArticulo = this.iface.referenciaModCopia();
      if (!datosNuevoArticulo) {
        return false;
      }
      if (util.sqlSelect("articulos", "referencia", "referencia = '" + datosNuevoArticulo["referencia"] + "'")) {
        MessageBox.warning(util.translate("scripts", "Ya existe un artículo con esa referencia"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var curArticuloOrigen: FLSqlCursor = new FLSqlCursor("articulos");
      curArticuloOrigen.select("referencia = '" + refOriginal + "'");
      if (!curArticuloOrigen.first()) {
        return false;
      }
      curArticuloOrigen.setModeAccess(curArticuloOrigen.Browse);
      curArticuloOrigen.refreshBuffer();

      if (!this.iface.curArticulo) {
        this.iface.curArticulo = new FLSqlCursor("articulos");
      }
      this.iface.curArticulo.setModeAccess(this.iface.curArticulo.Insert);
      this.iface.curArticulo.refreshBuffer();
      this.iface.curArticulo.setValueBuffer("referencia", datosNuevoArticulo["referencia"]);
      this.iface.curArticulo.setValueBuffer("idmodelo", datosNuevoArticulo["idmodelo"]);
      this.iface.curArticulo.setValueBuffer("configuracion", datosNuevoArticulo["configuracion"]);

      //      var curNuevoArticulo:FLSqlCursor = new FLSqlCursor("articulos");
      //      curNuevoArticulo.setModeAccess(curNuevoArticulo.Insert);
      //      curNuevoArticulo.refreshBuffer();
      //      curNuevoArticulo.setValueBuffer("referencia", datosNuevoArticulo["referencia"]);
      //      curNuevoArticulo.setValueBuffer("idmodelo", datosNuevoArticulo["idmodelo"]);
      //      curNuevoArticulo.setValueBuffer("configuracion", datosNuevoArticulo["configuracion"]);

      var campos: Array = util.nombreCampos("articulos");
      var totalCampos: Number = campos[0];
      for (var i: Number = 1; i <= totalCampos; i++) {
        if (!this.iface.datosArticulo(curArticuloOrigen, campos[i])) {
          return false;
        }
      }

      //      if (!this.iface.datosArticulo(curNuevoArticulo, datosNuevoArticulo["referencia"]))
      //        return false;

      if (!this.iface.curArticulo.commitBuffer()) {
        return false;
      }

      if (!this.iface.copiarAnexosArticulo(refOriginal, datosNuevoArticulo["referencia"])) {
        return false;
      }
      break;
    }
    default: {
      return this.iface.__copiarArticulo(refOriginal);
    }
  }

  return datosNuevoArticulo["referencia"];
}

function prodSofa_referenciaModCopia(): Array {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var res: Array = [];
  var formCopia: Object = new FLFormSearchDB("copiaarticulo");
  var curCopia: FLSqlCursor = formCopia.cursor();

  curCopia.select("idusuario = '" + sys.nameUser() + "'");
  if (curCopia.first())
  {
    curCopia.setModeAccess(curCopia.Edit);
    curCopia.refreshBuffer()
  } else {
    curCopia.setModeAccess(curCopia.Insert);
    curCopia.refreshBuffer()
    curCopia.setValueBuffer("idusuario", sys.nameUser());
  }
  curCopia.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
  curCopia.setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
  curCopia.setValueBuffer("configuracion", cursor.valueBuffer("configuracion"));
  curCopia.setValueBuffer("codfamilia", cursor.valueBuffer("codfamilia"));

  formCopia.setMainWidget();
  var referencia: String = formCopia.exec("referencia");
  if (!referencia)
  {
    return false;
  }
  var id: String = curCopia.valueBuffer("id");
  if (!curCopia.commitBuffer())
  {
    return false;
  }
  var qryCopia: FLSqlQuery = new FLSqlQuery;
  with(qryCopia)
  {
    setTablesList("copiaarticulo");
    setSelect("referencia, idmodelo, configuracion");
    setFrom("copiaarticulo");
    setWhere("id = " + id);
    setForwardOnly(true);
  }
  if (!qryCopia.exec())
  {
    return false;
  }
  if (!qryCopia.first())
  {
    return false;
  }
  res["referencia"] = qryCopia.value("referencia");
  res["idmodelo"] = qryCopia.value("idmodelo");
  res["configuracion"] = qryCopia.value("configuracion");

  return res;
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
