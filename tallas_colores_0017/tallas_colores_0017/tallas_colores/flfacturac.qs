
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  //  function afterCommit_lineaspedidoscli(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.tallasColores_afterCommit_lineaspedidoscli(curLA);
  //  }
  //  function afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.tallasColores_afterCommit_lineasalbaranescli(curLA);
  //  }
  //  function afterCommit_lineasfacturascli(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.tallasColores_afterCommit_lineasfacturascli(curLA);
  //  }
  //  function afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.tallasColores_afterCommit_lineasalbaranesprov(curLA);
  //  }
  //  function afterCommit_lineasfacturasprov(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.tallasColores_afterCommit_lineasfacturasprov(curLA);
  //  }
}
//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
/// Traspasado a flfactalma (funciones controlStock...)
// function tallasColores_afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
// {
//  if (!sys.isLoadedModule("flfactalma"))
//    return true;
//
//  var util:FLUtil = new FLUtil();
//  var codAlmacen:String = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLP.valueBuffer("idpedido"));
//  if (codAlmacen == false)
//    codAlmacen = curLP.cursorRelation().valueBuffer("codalmacen");
//  switch(curLP.modeAccess()) {
//    case curLP.Insert:
//      var cantidad:Number = -1 * parseFloat(curLP.valueBuffer("cantidad"));
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), cantidad))
//        return false;
//      break;
//    case curLP.Del:
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), curLP.valueBuffer("cantidad")))
//        return false;
//      break;
//    case curLP.Edit:
//      if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia")
//        || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad")
//        || curLP.valueBuffer("talla") != curLP.valueBufferCopy("talla")
//        || curLP.valueBuffer("color") != curLP.valueBufferCopy("color")) {
//        var cantidad:Number = -1 * parseFloat(curLP.valueBuffer("cantidad"));
//        if (flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBufferCopy("referencia"), curLP.valueBufferCopy("talla"), curLP.valueBufferCopy("color"), curLP.valueBufferCopy("cantidad"))) {
//          if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), cantidad))
//            return false;
//        } else
//          return false;
//      }
//      break;
//  }
//  return true;
// }
//
// function tallasColores_afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean
// {
//  if (!sys.isLoadedModule("flfactalma"))
//    return true;
//
//  if (curLA.valueBuffer("idlineapedido") != 0)
//    return true;
//
//  var util:FLUtil = new FLUtil();
//  var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
//  if (!codAlmacen || codAlmacen == "")
//      return true;
//
//  switch(curLA.modeAccess()) {
//    case curLA.Insert:
//      var cantidad:Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
//        return false;
//      break;
//    case curLA.Del:
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
//        return false;
//      break;
//    case curLA.Edit:
//      if (curLA.valueBuffer("referencia") != curLA.valueBufferCopy("referencia")
//        || curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")
//        || curLA.valueBuffer("talla") != curLA.valueBufferCopy("talla")
//        || curLA.valueBuffer("color") != curLA.valueBufferCopy("color")) {
//        var cantidad:Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
//        if (flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBufferCopy("referencia"), curLA.valueBufferCopy("talla"), curLA.valueBufferCopy("color"), curLA.valueBufferCopy("cantidad"))) {
//          if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
//              return false;
//        } else
//          return false;
//      }
//      break;
//  }
//  return true;
// }
//
//
// function tallasColores_afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
// {
//    if (!sys.isLoadedModule("flfactalma"))
//        return true;
//
//    var util:FLUtil = new FLUtil();
//    var automatica:Boolean = util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));
//    if (automatica == false) {
//        var codAlmacen = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
//        if (!codAlmacen || codAlmacen == "")
//            return true;
//        switch(curLF.modeAccess()) {
//            case curLF.Insert:
//                var cantidad:Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
//                if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
//                    return false;
//                break;
//            case curLF.Del:
//                if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
//                    return false;
//                break;
//            case curLF.Edit:
//                if (curLF.valueBuffer("referencia") != curLF.valueBufferCopy("referencia")
//                    || curLF.valueBuffer("cantidad") != curLF.valueBufferCopy("cantidad")
//                    || curLF.valueBuffer("talla") != curLF.valueBufferCopy("talla")
//                    || curLF.valueBuffer("color") != curLF.valueBufferCopy("color")) {
//                    var cantidad:Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
//                    if (flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBufferCopy("referencia"), curLF.valueBufferCopy("talla"), curLF.valueBufferCopy("color"), curLF.valueBufferCopy("cantidad"))) {
//                        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
//                            return false;
//                    } else
//                        return false;
//                }
//                break;
//        }
//    }
//    return true;
// }
//
// function tallasColores_afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean
// {
//  if (!sys.isLoadedModule("flfactalma"))
//      return true;
//
//  var util:FLUtil = new FLUtil();
//  var codAlmacen:String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
//  if (!codAlmacen || codAlmacen == "")
//    return true;
//  switch(curLA.modeAccess()) {
//    case curLA.Insert:
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
//        return false;
//      break;
//    case curLA.Del: {
//      var cantidad:Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
//      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
//        return false;
//      break;
//    }
//    case curLA.Edit:
//      if (curLA.valueBuffer("referencia") != curLA.valueBufferCopy("referencia")
//          || curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")
//          || curLA.valueBuffer("talla") != curLA.valueBufferCopy("talla")
//          || curLA.valueBuffer("color") != curLA.valueBufferCopy("color")) {
//        var cantidad:Number = -1 * parseFloat(curLA.valueBufferCopy("cantidad"));
//        if (flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBufferCopy("referencia"), curLA.valueBufferCopy("talla"), curLA.valueBufferCopy("color"), cantidad)) {
//          if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
//            return false;
//        } else
//          return false;
//      }
//      break;
//  }
//  return true;
// }
//
// function tallasColores_afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
// {
//    if (!sys.isLoadedModule("flfactalma"))
//        return true;
//
//    var util:FLUtil = new FLUtil();
//    switch(curLF.modeAccess()) {
//        case curLF.Edit:
//            if (curLF.valueBuffer("referencia") != curLF.valueBufferCopy("referencia"))
//                flfactalma.iface.cambiarCosteMedio(curLF.valueBufferCopy("referencia"));
//        case curLF.Insert:
//        case curLF.Del:
//            flfactalma.iface.cambiarCosteMedio(curLF.valueBuffer("referencia"));
//        break;
//    }
//
//    var automatica:Boolean = util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));
//    if (automatica == false) {
//        var codAlmacen:String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
//        if (!codAlmacen || codAlmacen == "")
//            return true;
//        switch(curLF.modeAccess()) {
//            case curLF.Insert:
//                if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
//                    return false;
//                break;
//            case curLF.Del:
//                var cantidad:Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
//                if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
//                    return false;
//                break;
//            case curLF.Edit:
//                if (curLF.valueBuffer("referencia") != curLF.valueBufferCopy("referencia")
//                      || curLF.valueBuffer("cantidad") != curLF.valueBufferCopy("cantidad")
//                      || curLF.valueBuffer("talla") != curLF.valueBufferCopy("talla")
//                      || curLF.valueBuffer("color") != curLF.valueBufferCopy("color")) {
//                    var cantidad:Number = -1 * parseFloat(curLF.valueBufferCopy("cantidad"));
//                    if (flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBufferCopy("referencia"), curLF.valueBufferCopy("talla"), curLF.valueBufferCopy("color"), cantidad)) {
//                        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
//                            return false;
//                    } else
//                        return false;
//                }
//                break;
//        }
//    }
//    return true;
// }


//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


