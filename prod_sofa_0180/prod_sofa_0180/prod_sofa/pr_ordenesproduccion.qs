
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class prodSofa extends oficial
{
  var chkConTela: Object;
  var chkCompletos: Object;
  var pedidosIncluidos: String;
  var pedidosNoIncluidos: String;
  function prodSofa(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.prodSofa_init();
  }
  function otrosCriterios()
  {
    return this.ctx.prodSofa_otrosCriterios();
  }
  function buscar()
  {
    this.ctx.prodSofa_buscar();
  }
  //  function cargarDatos():Boolean {
  //    return this.ctx.prodSofa_cargarDatos();
  //  }
  function hayTelaLote(codLote: String): Boolean {
    return this.ctx.prodSofa_hayTelaLote(codLote);
  }
  function hayTelaPedido(codPedido: String): Boolean {
    return this.ctx.prodSofa_hayTelaPedido(codPedido);
  }
  function hayArticulosSinStock(): Boolean {
    return this.ctx.prodSofa_hayArticulosSinStock();
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
function prodSofa_init()
{
  this.iface.chkConTela = this.child("chkConTela");
  this.iface.chkCompletos = this.child("chkCompletos");

  this.iface.chkConTela.checked = false;
  this.iface.chkCompletos.checked = false
                                    this.child("fdbCodFamilia").setFilter("codfamilia <> 'CORT'");
  this.child("fdbReferencia").setFilter("codfamilia <> 'CORT'");

  this.iface.__init();
}

/** \C
Muestra las unidades de producto que cumplen los criterios de búsqueda y no son CORTES
\end */
function prodSofa_otrosCriterios()
{
  var criterios: String = " AND a.codfamilia <> 'CORT'";
  var codRuta: String = this.cursor().valueBuffer("codruta");
  if (codRuta && codRuta != "")
    criterios += " AND dirclientes.codruta = '" + codRuta + "'";

  return  criterios;
}

/** \C
Muestra las unidades de producto que cumplen los criterios de búsqueda
\end */
function prodSofa_buscar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var totalFilas: Number = this.iface.tblArticulos.numRows();
  var referencia: String = cursor.valueBuffer("referencia");
  var codFamilia: String = cursor.valueBuffer("codfamilia");
  var fechaDesde: Date;
  var fechaHasta: Date;
  var criteriosBusqueda: String =  "";
  this.iface.pedidosIncluidos = "";
  this.iface.pedidosNoIncluidos = "";

  if (!cursor.isNull("fechadesde")) {
    fechaDesde = cursor.valueBuffer("fechadesde");
    criteriosBusqueda += " AND ls.fechafabricacion >= '" + fechaDesde + "'";
  } else {
    fechaDesde = false;
  }

  if (!cursor.isNull("fechahasta")) {
    fechaHasta = cursor.valueBuffer("fechahasta");
    criteriosBusqueda += " AND ls.fechafabricacion <= '" + fechaHasta + "'";
  } else {
    fechaHasta = false;
  }

  if (referencia && referencia != "")
    criteriosBusqueda += " AND ls.referencia = '" + referencia + "'";
  if (codFamilia && codFamilia != "")
    criteriosBusqueda += " AND a.codfamilia = '" + codFamilia + "'";

  criteriosBusqueda += this.iface.otrosCriterios();
  var qryProcesos: FLSqlQuery = new FLSqlQuery();
  with(qryProcesos) {
    setTablesList("lotesstock,articulos,pr_procesos");
    setSelect("ls.codlote, ls.referencia, ls.canlote, ls.fechafabricacion,p.idproceso,p.idtipoproceso,pc.codigo,pc.codcliente,pc.nombrecliente");
    setFrom("lotesstock ls INNER JOIN articulos a ON a.referencia = ls.referencia INNER JOIN pr_procesos p ON ls.codlote = p.idobjeto LEFT OUTER JOIN lineaspedidoscli lpc ON P.idlineapedidocli = lpc.idlinea INNER JOIN pedidoscli pc ON lpc.idpedido = pc.idpedido INNER JOIN dirclientes ON pc.coddir = dirclientes.id");
    setWhere("p.estado = 'OFF'" + criteriosBusqueda);
  }
  if (!qryProcesos.exec())
    return;
  debug(qryProcesos.sql());

  if (qryProcesos.size() == 0) {
    MessageBox.information(util.translate("scripts", "No hay procesos de producción que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  criteriosBusqueda = "";
  if (fechaDesde && fechaDesde != "")
    criteriosBusqueda = " AND p.fechasalida >= '" + fechaDesde + "'";
  if (fechaHasta && fechaHasta != "")
    criteriosBusqueda = " AND p.fechasalida <= '" + fechaHasta + "'";

  var fechaMinima: String = "";
  var fechaFabricacion: String = "";
  var fechaMinMov: String = "";
  var fechaMinComp: String = "";
  var codPedido: String = "";
  var nombreCliente: String = "";
  var idPedidoMov: Number;
  var idPedidoComp: Number;
  var datosPedidoComp: Array;
  var idTipoProceso: String;

  while (qryProcesos.next()) {
    debug(3);
    idTipoProceso = qryProcesos.value("p.idtipoproceso");
    nombreCliente = qryProcesos.value("pc.nombrecliente");
    codPedido = qryProcesos.value("pc.codigo");

    //datosPedidoComp = flprodppal.iface.pub_buscarPedidoFechaMinima(qryLotes.value("ls.codlote"),criteriosBusqueda);

    /*
        if (criteriosBusqueda != "")
          if (!datosPedidoComp)
            continue;
    */

    //    fechaMinima = "";
    //    codPedido = "";
    //    nombreCliente = "";
    //    if (datosPedidoComp) {
    //      fechaMinima = datosPedidoComp["fecha"];
    //      codPedido = datosPedidoComp["codigo"];
    //      nombreCliente = datosPedidoComp["nombreCliente"];
    //    }

    var qryComponentes: FLSqlQuery = new FLSqlQuery();
    with(qryComponentes) {
      setTablesList("movistock,pr_tipostareapro");
      setSelect("ms.idstock, ms.fechaprev, ms.codlote,ttp.idtipoproceso");
      setFrom("movistock ms INNER JOIN pr_tipostareapro ttp ON ms.idtipotareapro = ttp.idtipotareapro");
      setWhere("codloteprod = '" + qryProcesos.value("ls.codlote") + "' AND cantidad < 0 AND ttp.idtipoproceso = '" + idTipoProceso + "'");
      setForwardOnly(true);
    }
    if (!qryComponentes.exec())
      return;

    var arrayEvolStock: Array;
    var hoy: Date = new Date();
    var indice: Number;
    var enStock: String = util.translate("scripts", "Sí");
    var codLote: String;
    var fechaConsumo: String;

    while (qryComponentes.next()) {
      codLote = qryComponentes.value("ms.codlote");
      if (codLote && codLote != "") {
        if (util.sqlSelect("lotesstock", "estado", "codlote = '" + codLote + "'") == "TERMINADO") {
          continue;
        } else {
          enStock = util.translate("scripts", "No");
          break;
        }
      }

      arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("ms.idstock"), hoy.toString());
      if (qryComponentes.value("ms.fechaprev")) {
        fechaConsumo = qryComponentes.value("ms.fechaprev");
      } else {
        fechaConsumo = hoy.toString();
      }
      indice = flfactalma.iface.pub_buscarIndiceAES(fechaConsumo, arrayEvolStock);

      if (indice >= 0) {
        if (arrayEvolStock[indice]["NN"] > 0) {
          enStock = util.translate("scripts", "No");
          break;
        }
      } else {
        enStock = util.translate("scripts", "No");
        break;
      }
    }

    var hayTela: Boolean = this.iface.hayTelaLote(qryProcesos.value("ls.codlote"));

    if (this.iface.chkCompletos.checked) {
      if (this.iface.pedidosNoIncluidos.find("'" + codPedido + "'") != -1)
        continue;

      if (this.iface.pedidosIncluidos.find("'" + codPedido + "'") == -1) {
        if (this.iface.hayTelaPedido(codPedido)) {
          if (this.iface.pedidosIncluidos != "")
            this.iface.pedidosIncluidos += ", "
                                           this.iface.pedidosIncluidos += "'" + codPedido + "'";
        } else {
          if (this.iface.pedidosNoIncluidos != "")
            this.iface.pedidosNoIncluidos += ", "
                                             this.iface.pedidosNoIncluidos += "'" + codPedido + "'";
          continue;
        }
      }
    } else if (!hayTela && this.iface.chkConTela.checked)
      continue;
    filaActual = this.iface.tblArticulos.numRows();

    fechaFabricacion = qryProcesos.value("ls.fechafabricacion");
    this.iface.tblArticulos.insertRows(filaActual);
    this.iface.tblArticulos.setText(filaActual, this.iface.CODLOTE, qryProcesos.value("ls.codlote"));
    this.iface.tblArticulos.setText(filaActual, this.iface.REFERENCIA, qryProcesos.value("ls.referencia"));
    this.iface.tblArticulos.setText(filaActual, this.iface.TIPOPROCESO, idTipoProceso);
    this.iface.tblArticulos.setText(filaActual, this.iface.PEDIDO, codPedido);
    this.iface.tblArticulos.setText(filaActual, this.iface.CLIENTE, nombreCliente);
    this.iface.tblArticulos.setText(filaActual, this.iface.TOTAL, qryProcesos.value("ls.canlote"));
    this.iface.tblArticulos.setText(filaActual, this.iface.FPRODUCCION, util.dateAMDtoDMA(fechaFabricacion));
    this.iface.tblArticulos.setText(filaActual, this.iface.FSALIDA, util.dateAMDtoDMA(fechaMinima));
    this.iface.tblArticulos.setText(filaActual, this.iface.ENSTOCK, enStock);
    this.iface.tblArticulos.setText(filaActual, this.iface.INCLUIR, "Sí");
    this.iface.tblArticulos.setText(filaActual, this.iface.IDPROCESO, qryProcesos.value("p.idproceso"));
  }

  this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
  if (this.iface.tblArticulos.numRows() > 0)
    this.iface.establecerEstadoBotones("calcular");
  else
    MessageBox.information(util.translate("scripts", "No hay procesos de producción que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);

}

function prodSofa_hayTelaLote(codLote: String): Boolean {
  var qryComponentes: FLSqlQuery = new FLSqlQuery();
  var qryLotes: FLSqlQuery = new FLSqlQuery();
  with(qryLotes)
  {
    setTablesList("movistock,lotesstock,articulos");
    setSelect("ls.codlote");
    setFrom("movistock ms INNER JOIN lotesstock ls ON ms.codlote = ls.codlote INNER JOIN articulos a ON a.referencia = ls.referencia");
    setWhere("ms.codloteprod = '" + codLote + "' AND a.codfamilia = 'CORT' AND ms.cantidad < 0 AND ls.estado = 'PTE'");
  }

  if (!qryLotes.exec())
    return;
  debug("Lotes  " + qryLotes.sql());
  var arrayEvolStock: Array;
  var codLote: String;
  var indice: Number;
  var hoy: Date = new Date();
  while (qryLotes.next())
  {
    with(qryComponentes) {
      setTablesList("movistock");
      setSelect("idstock, fechaprev");
      setFrom("movistock");
      setWhere("codloteprod = '" + qryLotes.value("ls.codlote") + "' AND cantidad < 0");
      setForwardOnly(true);
    }
    if (!qryComponentes.exec())
      return;
    debug(qryComponentes.sql());

    while (qryComponentes.next()) {
      arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("idstock"), hoy.toString());
      indice = flfactalma.iface.pub_buscarIndiceAES(qryComponentes.value("fechaprev"), arrayEvolStock);

      if (indice >= 0) {
        if (arrayEvolStock[indice]["NN"] > 0) {
          return false;
        }
      } else {
        return false;
      }
    }
  }
  return true;
}

function prodSofa_hayTelaPedido(codPedido: String): Boolean {
  var qryLotes: FLSqlQuery = new FLSqlQuery();
  with(qryLotes)
  {
    setTablesList("movistock,pedidoscli,lineaspedidoscli");
    setSelect("ls.codlote");
    setFrom("pedidoscli p INNER JOIN lineaspedidoscli lp ON p.idpedido = lp.idpedido INNER JOIN lotesstock ls ON lp.idlinea = ls.idlineapc INNER JOIN pr_procesos ON lp.idlinea = pr_procesos.idlineapedidocli INNER JOIN articulos a ON a.referencia = ls.referencia");
    setWhere("ls.estado = 'PTE' AND pr_procesos.estado = 'OFF' AND a.fabricado AND p.codigo = '" + codPedido + "' AND a.codfamilia = 'MOD'");
  }

  if (!qryLotes.exec())
    return;

  while (qryLotes.next())
  {
    if (!this.iface.hayTelaLote(qryLotes.value("ms.codlote")))
      return false;
  }

  return true;
}

// function prodSofa_cargarDatos():Boolean
// {
//  var codLote:String;
//  var cantidad:String;
//  var referencia:String;
//  for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
//    if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
//      codLote = this.iface.tblArticulos.text(fila, this.iface.CODLOTE);
//      cantidad = this.iface.tblArticulos.text(fila, this.iface.TOTAL);
//      referencia = this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
//      if (!flprodppal.iface.pub_cargarTareasLote(codLote, cantidad, referencia))
//        return false;
//    }
//  }
//
//  if (!flprodppal.iface.pub_establecerSecuencias(true))
//    return false;
//
//  if (!flprodppal.iface.pub_iniciarCentrosCoste())
//    return false;
//  return true;
// }

function prodSofa_hayArticulosSinStock(): Boolean {
  return true;
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

