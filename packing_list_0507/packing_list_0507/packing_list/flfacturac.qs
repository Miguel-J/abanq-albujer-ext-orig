
/** @class_declaration packing */
/////////////////////////////////////////////////////////////////
//// PACKING LIST ///////////////////////////////////////////////
class packing extends oficial
{
  function packing(context)
  {
    oficial(context);
  }
  function afterCommit_lineasbulto(curLinea: FLSqlCursor): Boolean {
    return this.ctx.packing_afterCommit_lineasbulto(curLinea);
  }
  function afterCommit_bultosdespacho(curBulto: FLSqlCursor): Boolean {
    return this.ctx.packing_afterCommit_bultosdespacho(curBulto);
  }
  function actualizarDespachadoLA(idLineaAlbaran: String): Boolean {
    return this.ctx.packing_actualizarDespachadoLA(idLineaAlbaran);
  }
  function actualizarNumeroBulto(curBulto: FLSqlCursor): Boolean {
    return this.ctx.packing_actualizarNumeroBulto(curBulto);
  }
  function afterCommit_embalajesbulto(curEB: FLSqlCursor): Boolean {
    return this.ctx.packing_afterCommit_embalajesbulto(curEB);
  }
}
//// PACKING LIST ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition packing */
/////////////////////////////////////////////////////////////////
//// PACKING LIST ///////////////////////////////////////////////
function packing_afterCommit_lineasbulto(curLinea: FLSqlCursor): Boolean {
  debug("packing_afterCommit_lineasbulto");
  var idLineaAlbaran: String = curLinea.valueBuffer("idlineaalbaran");
  if (!this.iface.actualizarDespachadoLA(idLineaAlbaran))
  {
    return false;
  }
  return true;
}

function packing_afterCommit_bultosdespacho(curBulto: FLSqlCursor): Boolean {
  switch (curBulto.modeAccess())
  {
    case curBulto.Edit: {
      if (curBulto.valueBuffer("numero") != curBulto.valueBufferCopy("numero")) {
        if (!this.iface.actualizarNumeroBulto(curBulto)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function packing_actualizarDespachadoLA(idLineaAlbaran: String): Boolean {
  debug("packing_actualizarDespachadoLA");
  var util: FLUtil = new FLUtil;

  var canDespachada: Number = parseFloat(util.sqlSelect("lineasbulto", "SUM(cantidad)", "idlineaalbaran = " + idLineaAlbaran));
  if (isNaN(canDespachada))
  {
    canDespachada = 0;
  }
  debug("Actualizando despachada a " + canDespachada);
  var curLA: FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
  curLA.setActivatedCommitActions(false);
  curLA.setActivatedCheckIntegrity(false);
  curLA.select("idlinea = " + idLineaAlbaran);
  if (!curLA.first())
  {
    return false;
  }
  curLA.setModeAccess(curLA.Edit);
  curLA.refreshBuffer();
  curLA.setValueBuffer("candespachada", canDespachada);
  var despachado: Boolean = (canDespachada >= parseFloat(curLA.valueBuffer("cantidad")));
  curLA.setValueBuffer("despachado", despachado);
  if (!curLA.commitBuffer())
  {
    return false;
  }
  return true;
}

function packing_actualizarNumeroBulto(curBulto: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idBulto: String = curBulto.valueBuffer("idbulto");
  var numBulto: String = curBulto.valueBuffer("numero");

  var curLB: FLSqlCursor = new FLSqlCursor("lineasbulto");
  curLB.setActivatedCommitActions(false);
  curLB.setActivatedCheckIntegrity(false);
  curLB.select("idbulto = " + idBulto);
  if (!curLB.first())
  {
    return false;
  }
  curLB.setModeAccess(curLB.Edit);
  curLB.refreshBuffer();
  curLB.setValueBuffer("numbulto", numBulto);
  if (!curLB.commitBuffer())
  {
    return false;
  }
  return true;
}

/** \C
Si la línea de albarán no proviene de una línea de pedido, realiza la actualización del stock correspondiente al artículo seleccionado en la línea
\end */
function packing_afterCommit_embalajesbulto(curEB: FLSqlCursor): Boolean {
  if (sys.isLoadedModule("flfactalma"))
  {
    if (!flfactalma.iface.pub_controlStockEmbalajes(curEB)) {
      return false;
    }
  }
  return true;
}

//// PACKING LIST ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
