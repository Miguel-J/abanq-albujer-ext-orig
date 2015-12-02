
/** @class_declaration geneAlbp */
/////////////////////////////////////////////////////////////////
//// GENE_ALBP //////////////////////////////////////////////////
class geneAlbp extends oficial
{
  var geneFacturaProv = false;
  function geneAlbp(context)
  {
    oficial(context);
  }
  function afterCommit_pedidosprov(curPedido: FLSqlCursor): Boolean {
    return this.ctx.geneAlbp_afterCommit_pedidosprov(curPedido);
  }
}
//// GENE_ALBP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition geneAlbp */
/////////////////////////////////////////////////////////////////
//// GENE_ALBP //////////////////////////////////////////////////
function geneAlbp_afterCommit_pedidosprov(curPedido: FLSqlCursor): Boolean {
  var _i = this.iface;
  var util: FLUtil;

  var idAlbaran;
  if (curPedido.modeAccess() == curPedido.Edit && curPedido.action() == "pedidosprovparciales")
  {
    var canAlbaran = AQUtil.sqlSelect("lineaspedidosprov", "SUM(canalbaran)", "idpedido = " + curPedido.valueBuffer("idpedido"));
    if (!canAlbaran) {
      sys.warnMsgBox(sys.translate("No ha seleccionado ninguna línea. No se generará el albarán"));
      return true;
    }
    var curT = new FLSqlCursor("empresa");
    curT.transaction(false);
    try {
      idAlbaran = formpedidosprov.iface.pub_generarAlbaranParcial(curPedido);
      if (idAlbaran) {
        curT.commit();
      } else {
        curT.rollback();
        return false;
      }
    } catch (e) {
      curT.rollback();
      MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del albarán"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    if (_i.geneFacturaProv) {
      curT.transaction(false);
      try {
        if (idAlbaran) {
          where = "idalbaran = " + idAlbaran;
          var curAlbaran = new FLSqlCursor("albaranesprov");
          curAlbaran.select(where);
          if (curAlbaran.first()) {
            curT.commit();
            curT.transaction(false);
            idFactura = formalbaranesprov.iface.pub_generarFactura(where, curAlbaran);
            if (idFactura) {
              curT.commit();
            } else
              curT.rollback();
          } else
            curT.rollback();
        } else
          curT.rollback();
      } catch (e) {
        curT.rollback();
        MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
      }
    }
  }

  return true;
}
//// GENE_ALBP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
