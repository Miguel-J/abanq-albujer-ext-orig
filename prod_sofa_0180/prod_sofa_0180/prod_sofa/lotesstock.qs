
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends prod
{
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function calculateCounter(curLS: FLSqlCursor): String {
    return this.ctx.sofa_calculateCounter(curLS);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.sofa_bufferChanged(fN);
  }
  function mostrarPedido()
  {
    return this.ctx.sofa_mostrarPedido();
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
function sofa_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.__init();

  this.iface.mostrarPedido();
}

/** \C Los códigos de lote tienen distinto prefijo según la familia asociada al lote:
<ul>
<li>Tela: Prefijo RO (rollo)</li>
<li>Corte: Prefijo CO (corte)</li>
<li>Módulo: Prefijo MO (módulo)</li>
<li>Resto: Prefijo LS (lote de stock)</li>
</ul>
\end */
function sofa_calculateCounter(curLS: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();

  var prefijo: String;
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLS.valueBuffer("referencia") + "'");
  switch (codFamilia)
  {
    case "CORT": {
      prefijo = "CO";
      break;
    }
    case "TELA": {
      prefijo = "RO";
      break;
    }
    case "MOD": {
      prefijo = "MO";
      break;
    }
    default: {
      prefijo = "LS";
    }
  }

  var ultimoLote: Number = util.sqlSelect("secuenciaslotes", "valor", "prefijo = '" + prefijo + "'");

  if (!ultimoLote)
  {
    debug(2);
    var idUltimo: String = util.sqlSelect("lotesstock", "codlote", "codlote LIKE '" + prefijo + "%' ORDER BY codlote DESC");

    if (idUltimo)
      ultimoLote = parseFloat(idUltimo.right(8));
    else
      ultimoLote = 0;

    ultimoLote += 1;
    util.sqlInsert("secuenciaslotes", "prefijo,valor", prefijo + "," + ultimoLote)
  } else {
    ultimoLote += 1;
    util.sqlUpdate("secuenciaslotes", "valor", ultimoLote, "prefijo = '" + prefijo + "'");
  }

  var id: String = prefijo + flfacturac.iface.pub_cerosIzquierda((ultimoLote).toString(), 8);

  return id;
}

function sofa_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "referencia": {
      this.child("fdbCodLote").setValue(this.iface.calculateCounter(cursor));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function sofa_mostrarPedido()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var texto: String = "";
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  var codModulo: String;
  var codLote: String = cursor.valueBuffer("codlote");
  if (codFamilia == "CORT") {
    codModulo = util.sqlSelect("movistock", "codloteprod", "codlote = '" + codLote + "' AND codloteprod <> '' AND codloteprod IS NOT NULL");
    if (!codModulo)
      return;
  } else if (codFamilia == "MOD") {
    codModulo = codLote;
  } else {
    return;
  }
  var qryPedido: String = new FLSqlQuery;
  with(qryPedido) {
    setTablesList("movistock,pedidoscli");
    setSelect("p.codigo, p.fecha, p.nombrecliente");
    setFrom("movistock ms INNER JOIN lineaspedidoscli lp ON ms.idlineapc = lp.idlinea INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido");
    setWhere("ms.codlote = '" + codModulo + "'");
    setForwardOnly(true);
  }
  if (!qryPedido.exec()) {
    return false;
  }

  if (qryPedido.first()) {
    texto = util.translate("scripts", "Pedido %1 del día %2 para %3").arg(qryPedido.value("p.codigo")).arg(util.dateAMDtoDMA(qryPedido.value("p.fecha"))).arg(qryPedido.value("p.nombrecliente"));
  } else {
    texto = util.translate("scripts", "Este lote no está asociado a ningún pedido");
  }
  this.child("lblPedido").text = texto;
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
