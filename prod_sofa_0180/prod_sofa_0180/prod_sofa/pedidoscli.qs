
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends prod
{
  var pbnInsertarLineaAuto: Object;
  var idLineaSeleccionada_: Number
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function insertarLineaAuto()
  {
    return this.ctx.sofa_insertarLineaAuto();
  }
  function crearLineaAuto(referenciaNueva: String, idSeleccionada: Number): Boolean {
    return this.ctx.sofa_crearLineaAuto(referenciaNueva, idSeleccionada);
  }
  function getIdLineaSeleccionada(): Number {
    return this.ctx.sofa_getIdLineaSeleccionada();
  }
  function setIdLineaSeleccionada(id: Number)
  {
    return this.ctx.sofa_setIdLineaSeleccionada(id);
  }
  function validateForm(): Boolean {
    return this.ctx.sofa_validateForm();
  }
}
//// PROD_SOFA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSofa */
/////////////////////////////////////////////////////////////////
//// PUB_sofa ///////////////////////////////////////////////
class pubSofa extends ifaceCtx
{
  function pubSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_getIdLineaSeleccionada(): Number {
    return this.getIdLineaSeleccionada();
  }
  function pub_setIdLineaSeleccionada(id: Number)
  {
    return this.setIdLineaSeleccionada(id);
  }
}
//// PUB_sofa ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
function sofa_init()
{
  this.iface.__init();

  this.iface.pbnInsertarLineaAuto = this.child("pbnInsertarLineaAuto");
  this.iface.pbnInsertarLineaAuto.close();
  connect(this.iface.pbnInsertarLineaAuto, "clicked()", this, "iface.insertarLineaAuto()");
  this.iface.idLineaSeleccionada_ = 0;
}

function sofa_insertarLineaAuto()
{
  var util: FLUtil;

  var idSeleccionada: Number = this.child("tdbLineasPedidosCli").cursor().valueBuffer("idlinea");
  if (!idSeleccionada) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar una línea para copiar sus datos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  this.iface.idLineaSeleccionada_ = idSeleccionada;

  var idModelo: String = this.child("tdbLineasPedidosCli").cursor().valueBuffer("idmodelo");
  var f: Object = new FLFormSearchDB("articulos");
  var cursor: FLSqlCursor = f.cursor();

  var filtro: String = "idmodelo = '" + idModelo + "' AND codfamilia = 'MOD'";
  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.setMainFilter(filtro);
  cursor.refreshBuffer();

  var referenciaNueva: String = f.exec("referencia");

  if (referenciaNueva && referenciaNueva != "") {
    if (!this.iface.crearLineaAuto(referenciaNueva, idSeleccionada))
      return false;
  }

  this.child("tdbLineasPedidosCli").refresh();

  this.iface.idLineaSeleccionada_ = 0;
}

function sofa_crearLineaAuto(referenciaNueva: String, idSeleccionada: Number): Boolean {
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (!idSeleccionada || !referenciaNueva || referenciaNueva == "")
    return false;

  var qry: FLSqlQuery = new FLSqlQuery()
  with(qry)
  {
    setTablesList("lineaspedidoscli");
    setSelect("idpedido,referencia,cantidad,codimpuesto,dtolineal,dtopor,irpf,idpatas,idserietela,idmodelo,idopcionarticulo");
    setFrom("lineaspedidoscli");
    setWhere("idlinea = " + idSeleccionada);
    setForwardOnly(true);
  }
  if (!qry.exec())
    return false;

  if (!qry.first())
    return false;

  var referencia: String = qry.value("referencia");
  var descripcion: String = util.sqlSelect("articulos", "descripcion", "referencia = '" + referenciaNueva + "'");
  var configuracion: String = util.sqlSelect("articulos", "configuracion", "referencia = '" + referenciaNueva + "'");
  var cantidad: Number = qry.value("cantidad");
  var idPedido: Number = qry.value("idpedido");
  var codimpuesto: String = qry.value("codimpuesto");
  var iva: Number = parseFloat(flfacturac.iface.pub_campoImpuesto("iva", codimpuesto, cursor.valueBuffer("fecha")));

  if (!iva)
    iva = 0;
  var dtolineal = parseFloat(qry.value("dtolineal"));
  var dtopor: Number = parseFloat(qry.value("dtopor"));
  var recargo = parseFloat(flfacturac.iface.pub_campoImpuesto("recargo", codimpuesto, cursor.valueBuffer("fecha")));
  if (!recargo)
    recargo = 0;

  var irpf: Number = parseFloat(qry.value("irpf"));
  var idpatas: String = qry.value("idpatas");
  var idserietela: String = qry.value("idserietela");
  var idmodelo: String = qry.value("idmodelo");
  var corte: String = util.sqlSelect("articuloscomp INNER JOIN articulos ON articuloscomp.refcomponente = articulos.referencia", "articuloscomp.refcomponente", "articuloscomp.refcompuesto = '" + referencia + "' AND articulos.codfamilia = 'CORT'", "articuloscomp,articulos");
  if (!corte || corte == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene definido un tipo de corte para el módulo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var corteNuevo: String = util.sqlSelect("articuloscomp INNER JOIN articulos ON articuloscomp.refcomponente = articulos.referencia", "articuloscomp.refcomponente", "articuloscomp.refcompuesto = '" + referenciaNueva + "' AND articulos.codfamilia = 'CORT'", "articuloscomp,articulos");
  if (!corteNuevo || corteNuevo == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene definido un tipo de corte para el módulo %1").arg(referenciaNueva), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idOpcionArticuloLinea: Number = qry.value("idopcionarticulo");

  if (!idOpcionArticuloLinea)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida una opción de corte para el corte %1").arg(corte), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idOpcionLinea: Number = util.sqlSelect("tiposopcionartcomp toa INNER JOIN opcionesarticulocomp oa ON toa.idtipoopcionart = oa.idtipoopcionart", "oa.idopcion", "oa.idopcionarticulo = " + idOpcionArticuloLinea + " AND toa.referencia = '" + corte + "'", "tiposopcionartcomp,opcionesarticulocomp");
  if (!idOpcionLinea)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida una opción de corte para el corte %1").arg(corte), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idOpcionArticuloLineaNueva: Number = util.sqlSelect("tiposopcionartcomp toa INNER JOIN opcionesarticulocomp oa ON toa.idtipoopcionart = oa.idtipoopcionart", "oa.idopcionarticulo", "toa.referencia = '" + corteNuevo + "' AND oa.idopcion = " + idOpcionLinea, "opcionesarticulocomp,tiposopcionartcomp");

  if (!idOpcionArticuloLineaNueva)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida una opción de corte para el corte %1").arg(corteNuevo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curLinea: FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
  with(curLinea)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idpedido", idPedido);
    setValueBuffer("referencia", referenciaNueva);
    setValueBuffer("descripcion", descripcion);
    setValueBuffer("cantidad", cantidad);
    setValueBuffer("totalenalbaran", 0);
    setValueBuffer("codimpuesto", codimpuesto);
    setValueBuffer("iva", iva);
    setValueBuffer("dtolineal", dtolineal);
    setValueBuffer("dtopor", dtopor);
    setValueBuffer("recargo", recargo);
    setValueBuffer("irpf", irpf);
    setValueBuffer("idpatas", idpatas);
    setValueBuffer("idserietela", idserietela);
    setValueBuffer("idmodelo", idmodelo);
    setValueBuffer("configuracion", configuracion);
    setValueBuffer("idopcionarticulo", idOpcionArticuloLineaNueva);
    debug("************* opción " + idOpcionArticuloLineaNueva);

    if (!commitBuffer())
      return false;
  }

  var idLinea: Number = parseFloat(curLinea.valueBuffer("idlinea"));
  var curTelasLinea: FLSqlCursor = new FLSqlCursor("telaslineapc");

  var qryTelaLinea: FLSqlQuery = new FLSqlQuery()
  with(qryTelaLinea)
  {
    setTablesList("telaslineapc");
    setSelect("desccomponente,reftela,descripcion,idcomponente");
    setFrom("telaslineapc");
    setWhere("idlinea = " + idSeleccionada);
    setForwardOnly(true);
  }
  if (!qryTelaLinea.exec())
    return false;

  var idTipoOpcion: String;
  var idOpcion: String;
  var idComponenteNueva: String;
  while (qryTelaLinea.next())
  {
    //    idTipoOpcionArt = util.sqlSelect("articuloscomp ac INNER JOIN tiposopcionartcomp toac ON ac.idtipoopcionart = toac.idtipoopcionart", "toac.idtipoopcion", "ac.id = " + qryTelaLinea.value("idcomponente"));
    //    idOpcionArticulo = util.sqlSelect("articuloscomp", "idopcionarticulo", "id = " + qryTelaLinea.value("idcomponente"));
    //    idComponenteNueva = util.sqlSelect("articuloscomp", "id", "idtipoopcionart = " + idTipoOpcionArt + " AND idopcionarticulo = " + idOpcionArticulo);
    with(curTelasLinea) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("idlinea", idLinea);
      setValueBuffer("desccomponente", qryTelaLinea.value("desccomponente"));
      setValueBuffer("reftela", qryTelaLinea.value("reftela"));
      setValueBuffer("descripcion", qryTelaLinea.value("descripcion"));
      setValueBuffer("idcomponente", qryTelaLinea.value("idcomponente"));

      if (!commitBuffer())
        return false;
    }
  }

  with(curLinea)
  {
    select("idlinea = " + idLinea);
    setModeAccess(Edit);
    refreshBuffer();

    setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", curLinea));
    setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLinea));
    setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLinea));

    formpedidoscli.iface.pub_setModoOriginal("Insert");
    if (!commitBuffer())
      return false;
  }

  return true;
}

function sofa_getIdLineaSeleccionada(): Number {
  return this.iface.idLineaSeleccionada_;
}

function sofa_setIdLineaSeleccionada(id: Number)
{
  this.iface.idLineaSeleccionada_ = id;
}

function sofa_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var refCliente: String = cursor.valueBuffer("refcliente");
  var codCliente: String = cursor.valueBuffer("codcliente");
  if (refCliente && refCliente != "")
  {
    var codPedido: String = util.sqlSelect("pedidoscli", "codigo", "refcliente = '" + refCliente + "' AND codcliente = '" + codCliente + "' AND idpedido <> " + cursor.valueBuffer("idpedido"));
    if (codPedido && codPedido != "") {
      MessageBox.warning(util.translate("scripts", "Ya existe un pedido (%1) con la referencia %2 para el cliente %3").arg(codPedido).arg(refCliente).arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}
//// PROD_SOFA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
