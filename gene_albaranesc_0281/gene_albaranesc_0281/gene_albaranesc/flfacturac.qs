
/** @class_declaration geneAlbc */
/////////////////////////////////////////////////////////////////
//// GENE_ALBC //////////////////////////////////////////////////
class geneAlbc extends oficial
{
  var geneFacturaCli = false;
  function geneAlbc(context)
  {
    oficial(context);
  }
  function afterCommit_pedidoscli(curPedido)
  {
    return this.ctx.geneAlbc_afterCommit_pedidoscli(curPedido);
  }
  function gestionPedidoParcial(curPedido)
  {
    return this.ctx.geneAlbc_gestionPedidoParcial(curPedido);
  }
}
//// GENE_ALBC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition geneAlbc */
/////////////////////////////////////////////////////////////////
//// GENE_ALBC //////////////////////////////////////////////////
function geneAlbc_afterCommit_pedidoscli(curPedido)
{
  var _i = this.iface;
  if (!_i.__afterCommit_pedidoscli(curPedido)) {
    return false;
  }

  var idAlbaran = _i.gestionPedidoParcial(curPedido);
  if (!idAlbaran) {
    return false;
  }

  return true;
}

function geneAlbc_gestionPedidoParcial(curPedido)
{
  var util: FLUtil;
  var _i = this.iface;

  var curT = new FLSqlCursor("empresa");

  var idAlbaran;
  if (curPedido.modeAccess() == curPedido.Edit && curPedido.action() == "pedidoscliparciales") {
    var canAlbaran = AQUtil.sqlSelect("lineaspedidoscli", "SUM(canalbaran)", "idpedido = " + curPedido.valueBuffer("idpedido"));
    if (!canAlbaran) {
      sys.warnMsgBox(sys.translate("No ha seleccionado ninguna línea. No se generará el albarán"));
      return true;
    }

    curT.transaction(false);
    try {
      idAlbaran = formpedidoscli.iface.pub_generarAlbaranParcial(curPedido);
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

    if (_i.geneFacturaCli) {
      curT.transaction(false);
      try {
        // Establecemos el valor canalbaran para que no se generen albaranes sin líneas
        //        var curLineasPedido = new FLSqlCursor("lineaspedidoscli");
        //        var where = "idpedido = " + curPedido.valueBuffer("idpedido");
        //        curLineasPedido.select(where);
        //        while(curLineasPedido.next()) {
        //          curLineasPedido.setModeAccess(curLineasPedido.Edit);
        //          curLineasPedido.refreshBuffer();
        //          curLineasPedido.setValueBuffer("canalbaran",parseFloat(curLineasPedido.valueBuffer("cantidad")) - parseFloat(curLineasPedido.valueBuffer("totalenalbaran")));
        //          if(!curLineasPedido.commitBuffer()) {
        //            curT.rollback();
        //            return false;
        //          }
        //        }

        if (idAlbaran) {
          var curAlbaran = new FLSqlCursor("albaranescli");
          curT.commit();
          where = "idalbaran = " + idAlbaran;
          curAlbaran.select(where);
          if (curAlbaran.first()) {
            if (formalbaranescli.iface.pub_generarFactura(where, curAlbaran))
              curT.commit();
            else
              curT.rollback();
          } else
            curT.rollback();
        } else
          curT.rollback();
      } catch (e) {
        curT.rollback();
        MessageBox.critical(sys.translate("Hubo un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
      }

      _i.geneFacturaCli = false;
    }
  } else {
    idAlbaran = true;
  }


  return idAlbaran;
}
//// GENE_ALBC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
