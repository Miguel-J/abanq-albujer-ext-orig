
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends prod
{
  var idGrupo: Number;
  var idPatasDefecto: String;
  var desArticulo: String;
  var idTipoOpcionMarcada_: String;
  var idTipoOpcionArtMarcada_: String;

  var tdbModulos: Object;
  var bloqueoSeleccion: Boolean;
  var bloqueoSeleccionInicial: Boolean;

  var telas: Array;
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.sofa_bufferChanged(fN);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.sofa_commonCalculateField(fN, cursor);
  }
  function validateForm(): Boolean {
    return this.ctx.sofa_validateForm();
  }
  function calcularModeloConfiguracion()
  {
    return this.ctx.sofa_calcularModeloConfiguracion();
  }
  function gestionGrupos()
  {
    return this.ctx.sofa_gestionGrupos();
  }
  function obtenerTela(idComponente: string, idLinea: Number): String {
    return this.ctx.sofa_obtenerTela(idComponente, idLinea);
  }
  function obtenerMarcada(): String {
    return this.ctx.sofa_obtenerMarcada();
  }
  function obtenerPatas(idLinea: Number): String {
    return this.ctx.sofa_obtenerPatas(idLinea);
  }
  function obtenerIdTipoOpcionArtMarcada()
  {
    return this.ctx.sofa_obtenerIdTipoOpcionArtMarcada();
  }
  function filtrarModulos()
  {
    return this.ctx.sofa_filtrarModulos();
  }
  function obtenerCorte(referencia: String): String {
    return this.ctx.sofa_obtenerCorte(referencia);
  }
  function borrarTelas(): Boolean {
    return this.ctx.sofa_borrarTelas();
  }
  function generarTelas(): Boolean {
    return this.ctx.sofa_generarTelas();
  }
  function siguienteMarcada()
  {
    return this.ctx.sofa_siguienteMarcada();
  }
  function telaModificada()
  {
    return this.ctx.sofa_telaModificada();
  }
  function calculateField(fN: String): String {
    return this.ctx.sofa_calculateField(fN);
  }
  function quitarModulo()
  {
    return this.ctx.sofa_quitarModulo();
  }
  function guardarLinea(): Boolean {
    return this.ctx.sofa_guardarLinea();
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
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
  function pub_obtenerTela(idComponente: String, idLinea: Number): String {
    return this.obtenerTela(idComponente, idLinea);
  }
  function pub_obtenerMarcada(): String {
    return this.obtenerMarcada();
  }
  function pub_obtenerPatas(idLinea: Number): String {
    return this.obtenerPatas(idLinea);
  }
  function pub_obtenerIdTipoOpcionArtMarcada()
  {
    return this.obtenerIdTipoOpcionArtMarcada();
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

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  formRecordpedidoscli.iface.pub_setIdLineaSeleccionada(0);

  this.iface.tdbModulos = this.child("tdbModulos");
  this.iface.bloqueoSeleccion = true;
  this.iface.idTipoOpcionMarcada_ = util.sqlSelect("tiposopcioncomp", "idtipoopcion", "tipo = 'MARCADA'");

  if (!this.iface.idTipoOpcionMarcada_) {
    MessageBox.warning(util.translate("scripts", "No tiene definido un tipo de opción MARCADA para artículos compuestos.\nSin esta definición no es posible calcular la tela de los módulos.\nCree un tipo de opción con nombre 'MARCADA' en el módulo de almacén."), MessageBox.Ok, MessageBox.NoButton);
  }
  this.iface.idTipoOpcionArtMarcada_ = false;

  this.child("fdbIdPatas").setFilter("codfamilia = 'PATA'");
  this.child("fdbIdOpcionArticulo").setFilter("1 = 2");

  connect(this.child("tbnSiguienteMarcada"), "clicked()", this, "iface.siguienteMarcada()");
  connect(this.child("tdbTelasLineaPC").cursor(), "bufferCommited()", this, "iface.telaModificada()");
  debug(sys.nameUser());
  if (sys.nameUser() == "facturalux" || sys.nameUser() == "infosial")
    connect(this.child("tbnQuitarModulo"), "clicked()", this, "iface.quitarModulo");
  else
    this.child("tbnQuitarModulo").close();


  this.iface.tdbModulos.cursor().setMainFilter("codfamilia = 'MOD'");
  this.iface.tdbModulos.setReadOnly(true);
  var columnas: Array = new Array("idmodelo", "configuracion", "descripcion", "referencia");
  this.iface.tdbModulos.setOrderCols(columnas);


  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      formpedidoscli.iface.pub_setModoOriginal("Insert");
      var codCliente: String = util.sqlSelect("pedidoscli", "codcliente", "idpedido = " + cursor.valueBuffer("idpedido"));
      if (codCliente && codCliente != "") {
        var codTarifa: String = this.iface.obtenerTarifa(codCliente);
        if (codTarifa && codTarifa != "") {
          var valorPunto: Number = parseFloat(util.sqlSelect("tarifas", "valorpunto", "codtarifa = '" + codTarifa + "'"));
          if (!valorPunto)
            valorPunto = "";
          this.child("fdbValorPunto").setValue(valorPunto);
        }
      }
      break;
    }
    case cursor.Edit: {
      formpedidoscli.iface.pub_setModoOriginal("Edit");
      this.child("gbxConfiguracion").setDisabled(true);
      break;
    }
  }

  if (this.cursor().modeAccess() != this.cursor().Insert) {
    this.child("fdbObservCorte").setDisabled(true);
    this.child("fdbObservMontaje").setDisabled(true);
  }

  this.iface.filtrarModulos();

  this.iface.tdbModulos.refresh();

  this.iface.bloqueoSeleccionInicial = true;
  connect(this.iface.tdbModulos.cursor(), "newBuffer()", this, "iface.calcularModeloConfiguracion()");
  this.iface.bloqueoSeleccion = false;

}

function sofa_bufferChanged(fN: String)
{
  var util: FLUtil;
  switch (fN) {
    case "valorpunto":
    case "idserietela": {
      this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
      break;
    }
    case "idmodelo": {
      if (!this.iface.bloqueoSeleccion) {
        this.iface.bloqueoSeleccion = true;
        this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
        this.iface.filtrarModulos();
        this.iface.bloqueoSeleccion = false;
      }
      break;
    }
    case "configuracion": {
      if (!this.iface.bloqueoSeleccion) {
        this.iface.bloqueoSeleccion = true;
        this.iface.filtrarModulos();
        this.iface.bloqueoSeleccion = false;
      }
      break;
    }
    case "referencia": {
      this.iface.controlArticuloProd();
      this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto"));
      this.iface.idTipoOpcionArtMarcada_ = false;
      this.cursor().setNull("idopcionarticulo");
      this.child("fdbIdOpcionArticulo").setFilter("1 = 2");
      this.iface.borrarTelas();
      var referencia: String = this.child("fdbReferencia").value();
      var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");

      this.iface.desArticulo = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
      if (!this.iface.desArticulo)
        this.iface.desArticulo = "";
      this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
      if (codFamilia != "MOD")
        return true;

      var refCorte: String = this.iface.obtenerCorte(referencia);
      if (!refCorte) {
        MessageBox.warning(util.translate("scripts", "El artículo %1 no tiene ningún corte asociado.").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      if (!this.iface.idTipoOpcionMarcada_) {
        MessageBox.warning(util.translate("scripts", "Debe crear el tipo de opción MARCADA para crear pedidos de módulos."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      this.iface.idTipoOpcionArtMarcada_ = util.sqlSelect("tiposopcionartcomp", "idtipoopcionart", "idtipoopcion = " + this.iface.idTipoOpcionMarcada_ + " AND referencia = '" + refCorte + "'");
      if (!this.iface.idTipoOpcionArtMarcada_) {
        MessageBox.warning(util.translate("scripts", "El corte %1 no tiene asociado un tipo de opción MARCADA.\nDebe editar el corte y asociarle dicha opción").arg(refCorte), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      this.child("fdbIdOpcionArticulo").setFilter("idtipoopcionart = " + this.iface.idTipoOpcionArtMarcada_);

      this.iface.idPatasDefecto = util.sqlSelect("articuloscomp", "refcomponente", "refcompuesto = '" + referencia + "' AND codfamiliacomponente = 'PATA'");
      if (!this.iface.idPatasDefecto)
        this.iface.idPatasDefecto = "";

      this.child("fdbIdPatas").setValue(this.iface.idPatasDefecto);

      if (!this.iface.bloqueoSeleccion) {
        var configuracion: String = util.sqlSelect("articulos", "configuracion", "referencia = '" + referencia + "'");
        if (!configuracion)
          return false;

        var idmodelo: String = util.sqlSelect("articulos", "idmodelo", "referencia = '" + referencia + "'");
        if (!idmodelo)
          return false;

        this.iface.bloqueoSeleccion = true;
        this.child("fdbIdModelo").setValue(idmodelo);
        this.child("fdbConfiguracion").setValue(configuracion);
        this.iface.filtrarModulos();
        this.iface.bloqueoSeleccion = false;
      }

      this.child("fdbDescripcion").setValue(this.iface.calculateField("descripcion"));
      break;
    }
    case "idpatas": {
      this.child("fdbDescripcion").setValue(this.iface.calculateField("descripcion"));
      break;
    }
    case "idmarcada": {
      //this.iface.habilitarTelas();
      break;
    }
    case "idopcionarticulo": {
      this.iface.generarTelas();
      break;
    }
    default : {
      return this.iface.__bufferChanged(fN);
    }
  }
  return true;
}

function sofa_filtrarModulos()
{
  var filtro: String = "";
  if (this.child("fdbConfiguracion").value() && this.child("fdbConfiguracion").value() != "")
    filtro += " AND UPPER(configuracion) = '" + this.child("fdbConfiguracion").value().toUpperCase() + "'"
              if (this.child("fdbIdModelo").value() && this.child("fdbIdModelo").value() != "")
                filtro += " AND idmodelo = '" + this.child("fdbIdModelo").value() + "'";

  this.iface.tdbModulos.cursor().setMainFilter("codfamilia = 'MOD'" + filtro);
  this.iface.tdbModulos.refresh();
  if (this.cursor().modeAccess() == this.cursor().Insert) {
    if (this.iface.tdbModulos.cursor().size() == 1)
      this.child("fdbReferencia").setValue(this.iface.tdbModulos.cursor().valueBuffer("referencia"));
    if (this.iface.tdbModulos.cursor().size() > 1) {
      this.child("fdbReferencia").setValue("");
      this.child("fdbDescripcion").setValue("");
    }
  }
}

function sofa_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var res: Number;
  var util: FLUtil = new FLUtil();

  var datosTP: Array = this.iface.datosTablaPadre(cursor);
  if (!datosTP)
    return false;
  var wherePadre: String = datosTP.where;
  var tablaPadre: String = datosTP.tabla;

  switch (fN)
  {
      /** \C
      La --idserietela-- es la serie correspondiente a la tela más cara (mayor código de serie) de las telas elegidas
      */
    case "idserietela": {
      res = util.sqlSelect("telaslineapc tl INNER JOIN articulos a ON tl.reftela = a.referencia INNER JOIN seriestela st ON a.idserietela  = st.idserietela", "st.idserietela", "tl.idlinea = " + cursor.valueBuffer("idlinea") + " ORDER BY st.costemetro DESC", "seriestela,articulos,telaslineapc");
      break;
    }
    case "pvpunitario": {
      //      res = 0;
      //      var referencia:String = cursor.valueBuffer("referencia");
      //      if (!referencia)
      //        return 0;
      //
      //      var idSerieTela:String = cursor.valueBuffer("idserietela");
      //      if (idSerieTela) {
      //        var grupoClientes:String = util.sqlSelect("clientes", "codgrupo", "codcliente = '" + cursor.cursorRelation().valueBuffer("codcliente") + "'");
      //        var precioModulo:Number = 0;
      //        if (grupoClientes && grupoClientes != "")
      //          precioModulo = util.sqlSelect("preciosbase", "precio", "idserietela='" + idSerieTela + "'" + " AND modulo = '" + referencia + "' AND codgrupo = '" + grupoClientes + "'");
      //        else
      //          precioModulo = util.sqlSelect("preciosbase", "precio", "idserietela='" + idSerieTela + "'" + " AND modulo = '" + referencia + "' AND codgrupo IS NULL");
      //        res += parseFloat(precioModulo);
      //      }
      //      break;
      var referencia: String = cursor.valueBuffer("referencia");
      var familia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
      var codCliente: String = util.sqlSelect(tablaPadre, "codcliente", wherePadre);
      var codTarifa: String = this.iface.obtenerTarifa(codCliente);
      if (!codTarifa) {
        res = 0;
        break;
      }

      var valorPunto: Number = 1;
      if (tablaPadre == "pedidoscli" || tablaPadre == "albaranescli")
        valorPunto = cursor.valueBuffer("valorpunto");
      else
        valorPunto = parseFloat(util.sqlSelect("tarifas", "valorpunto", "codtarifa = '" + codTarifa + "'"));
      if (!valorPunto)
        valorPunto = 1;
      switch (familia) {
        case "MOD": {
          var idSerieTela: String = cursor.valueBuffer("idserietela");
          if (!idSerieTela || idSerieTela == "") {
            res = 0;
            break;
          }
          var precioBase: Number = parseFloat(util.sqlSelect("preciosbase", "precio", "idserietela = '" + idSerieTela + "' AND modulo = '" + referencia + "'"));
          if (!precioBase) {
            res = 0;
            break;
          }
          res = precioBase * valorPunto;
          if (!res)
            res = 0;
          break;
        }
        case "TELA": {
          var serieTela: String = util.sqlSelect("articulos", "idserietela", "referencia = '" + referencia + "'");
          res = parseFloat(util.sqlSelect("seriestela", "pvp", "idserietela = '" + serieTela + "'"))
                res = res  * valorPunto;
          if (!res)
            res = 0;
          break;
        }
        default: {
          res = parseFloat(this.iface.__commonCalculateField(fN, cursor)) * valorPunto;
          if (!res)
            res = 0;
          break;
        }
      }
      break;
    }
    case "descripcion": {
      res = this.iface.desArticulo;
      var qryTelas: FLSqlQuery = new FLSqlQuery;
      with(qryTelas) {
        setTablesList("telaslineapc");
        setSelect("desccomponente, descripcion");
        setFrom("telaslineapc");
        setWhere("idlinea = " + cursor.valueBuffer("idlinea") + " ORDER BY desccomponente DESC");
        setForwardOnly(true);
      }
      if (!qryTelas.exec())
        return false;
      while (qryTelas.next()) {
        if (qryTelas.size() == 1)
          res += ", " + qryTelas.value("descripcion");
        else
          res += ", " + qryTelas.value("desccomponente") + " " + qryTelas.value("descripcion");
      }
      var idPatas: String = cursor.valueBuffer("idpatas");
      if (idPatas != "" && idPatas != this.iface.idPatasDefecto)
        res += ", " + idPatas;
      break;
    }
    default: {
      res = this.iface.__commonCalculateField(fN, cursor)
    }
  }

        return res;
}

/** \C
En el caso de que la línea de pedido contenga un sofá, y no un artículo, realiza las siguientes comprobaciones:
1. Debe introducirse el modelo, configuración y telas del sofá
2. La combinación configuración - modelo debe estar definida en la tabla de módulos
3. Debe existir un precio base para cada módulo especificado en la configuración.
*/
function sofa_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var referencia: String = cursor.valueBuffer("referencia");

  if (!referencia || referencia == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer una referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
  if (codFamilia && codFamilia == "MOD")
  {
    if (cursor.valueBuffer("idopcionarticulo") == 0 || cursor.isNull("idopcionarticulo")) {
      MessageBox.warning(util.translate("scripts", "Debe establecer la marcada"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    if (cursor.valueBuffer("idopcionarticulo") == 0)
    {
      cursor.setNull("idopcionarticulo");
    }
  }

  var qry: FLSqlQuery = new FLSqlQuery;
  qry.setTablesList("telaslineapc");
  qry.setSelect("descripcion");
  qry.setFrom("telaslineapc");
  qry.setWhere("idlinea = " + cursor.valueBuffer("idlinea"));

  if (!qry.exec())
    return false;

  while (qry.next())
  {
    if (!qry.value("descripcion") || qry.value("descripcion") == "") {
      MessageBox.warning(util.translate("scripts", "Debe especificar la tela para cada marcada"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}

/** \D
Pregunta por el grupo al que se asociará la línea de pedido
Los artículos normales (con referencia) se asocian siempre al grupo 0.
Los sofás se asocian al grupo que el usuario elija
*/
function sofa_gestionGrupos()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  if (cursor.modeAccess() != cursor.Insert) {
    var configuracion: String =  cursor.valueBuffer("configuracion");
    this.iface.idGrupo = cursor.valueBuffer("idgrupo");
  } else {
    var numLineas: Number = util.sqlSelect("lineaspedidoscli", "COUNT(idlinea)",
                                           "idpedido = '" + cursor.cursorRelation().valueBuffer("idpedido") + "'"
                                           + " AND idgrupo <> 0");
    if (numLineas > 0) {
      var qryGrupos: FLSqlQuery = new FLSqlQuery;
      qryGrupos.setTablesList("lineaspedidoscli");
      qryGrupos.setSelect("idgrupo");
      qryGrupos.setFrom("lineaspedidoscli");
      qryGrupos.setWhere("idpedido = '" + cursor.cursorRelation().valueBuffer("idpedido")
                         + "' GROUP BY idgrupo");
      qryGrupos.exec();
      var i: Number = 0;
      var grupos: Array = [];
      grupos[0] = util.translate("scripts", "Nuevo grupo");
      while (qryGrupos.next()) {
        i++;
        grupos[i] = qryGrupos.value(0);
      }

      this.iface.idGrupo = Input.getItem(util.translate("scripts", "Asociar al grupo:"),
                                         grupos, false, util.translate("scripts", "Grupo"));
      if (this.iface.idGrupo == util.translate("scripts", "Nuevo grupo") || !this.iface.idGrupo)
        this.iface.idGrupo = i;
      this.child("fdbGrupo").setValue(this.iface.idGrupo);
    } else {
      this.iface.idGrupo = 1;
      this.child("fdbGrupo").setValue(this.iface.idGrupo);
    }
  }
}

/** \D Función llamada desde flfactalma. Devuelve la tela asociada al componente indicado en la tabla de telas por línea de pedido (telaslineapc)
\end */
function sofa_obtenerTela(idComponente: String, idLinea: Number): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor
  if (!idLinea)
    idLinea = formRecordpedidoscli.iface.pub_getIdLineaSeleccionada();

  if (!idLinea)
  {
    cursor = this.cursor();
    idLinea = cursor.valueBuffer("idlinea");
  }


  var refTela: String = util.sqlSelect("telaslineapc", "reftela", "idlinea = " + idLinea + " AND idcomponente = " + idComponente);
  if (!refTela)
    return "-1";

  return refTela;
}

function sofa_obtenerMarcada(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor;
  var idLinea: Number = formRecordpedidoscli.iface.pub_getIdLineaSeleccionada();
  var idOpcion: Number;

  if (!idLinea)
  {
    cursor = this.cursor();
    idOpcion = this.cursor().valueBuffer("idopcionarticulo");
  } else {
    idOpcion = util.sqlSelect("lineaspedidoscli", "idopcionarticulo", "idlinea = " + idLinea);
  }

  return idOpcion;
}

function sofa_obtenerPatas(idLinea: Number): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor;
  var idPatas: Number;

  if (!idLinea)
    idLinea = formRecordpedidoscli.iface.pub_getIdLineaSeleccionada();

  if (!idLinea)
  {
    cursor = this.cursor();
    idPatas = this.cursor().valueBuffer("idpatas");
  } else {
    idPatas = util.sqlSelect("lineaspedidoscli", "idpatas", "idlinea = " + idLinea);
  }

  return idPatas;
}

function sofa_calcularModeloConfiguracion()
{
  if (!this.iface.bloqueoSeleccion && !this.iface.bloqueoSeleccionInicial) {
    var configuracion: String = this.iface.tdbModulos.cursor().valueBuffer("configuracion");
    if (!configuracion)
      return false;

    var idmodelo: String = this.iface.tdbModulos.cursor().valueBuffer("idmodelo");
    if (!idmodelo)
      return false;

    this.iface.bloqueoSeleccion = true;
    this.child("fdbIdModelo").setValue(idmodelo);
    this.child("fdbConfiguracion").setValue(configuracion);

    if (this.iface.tdbModulos.cursor().size() > 1)
      this.child("fdbReferencia").setValue(this.iface.tdbModulos.cursor().valueBuffer("referencia"));

    this.iface.bloqueoSeleccion = false;
  }

  this.iface.bloqueoSeleccionInicial = false;
}

/** \D Función recursiva que obtiene el componente del módulo que es de la familia corte
@referencia: Módulo o componente que puede contener el corte
\end */
function sofa_obtenerCorte(referencia: String): String {
  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  with(qryComponentes)
  {
    setTablesList("articuloscomp,articulos");
    setSelect("ac.refcomponente, a.codfamilia");
    setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
    setWhere("ac.refcompuesto = '" + referencia + "'");
    setForwardOnly(true);
  }
  if (!qryComponentes.exec())
    return false;

  var refCorte: String;
  while (qryComponentes.next())
  {
    if (qryComponentes.value("a.codfamilia")  == "CORT")
      return qryComponentes.value("ac.refcomponente");

    refCorte = this.iface.obtenerCorte(qryComponentes.value("ac.refcomponente"));
    if (refCorte)
      return refCorte;
  }
  return false;
}

function sofa_borrarTelas(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (this.child("tdbTelasLineaPC").cursor().size() <= 0)
    return true;

  if (!util.sqlDelete("telaslineapc", "idlinea = " + cursor.valueBuffer("idlinea")))
    return false;

  this.child("tdbTelasLineaPC").refresh();
  this.iface.telaModificada();
  return true;
}

function sofa_generarTelas(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idOpcionArticulo: String = cursor.valueBuffer("idopcionarticulo");
  if (!idOpcionArticulo || idOpcionArticulo == "")
    return false;

  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbTelasLineaPC").cursor().commitBufferCursorRelation())
      return false;
  }

  var referencia: String = cursor.valueBuffer("referencia");


  var refCorte: String = this.iface.obtenerCorte(referencia);
  if (!refCorte)
  {
    MessageBox.warning(util.translate("scripts", "El artículo %1 no tiene ningún corte asociado.").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!this.iface.borrarTelas())
    return false;

  var qryTelas: FLSqlQuery = new FLSqlQuery();
  with(qryTelas)
  {
    setTablesList("articuloscomp");
    setSelect("id, desccomponente");
    setFrom("articuloscomp");
    setWhere("refcompuesto = '" + refCorte + "' AND idopcionarticulo = " + idOpcionArticulo + " AND codfamiliacomponente = 'TELA'");
    setForwardOnly(true);
  }
  if (!qryTelas.exec())
    return false;

  var curTela: FLSqlCursor = new FLSqlCursor("telaslineapc");
  while (qryTelas.next())
  {
    curTela.setModeAccess(curTela.Insert);
    curTela.refreshBuffer();
    curTela.setValueBuffer("idlinea", cursor.valueBuffer("idlinea"));
    curTela.setValueBuffer("desccomponente", qryTelas.value("desccomponente"));
    curTela.setValueBuffer("idcomponente", qryTelas.value("id"));
    if (!curTela.commitBuffer())
      return false;
  }
  this.child("tdbTelasLineaPC").refresh();
  this.iface.telaModificada();
  return true;
}

function sofa_siguienteMarcada()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.idTipoOpcionArtMarcada_)
    return false;

  var idOpcionArticulo: String = cursor.valueBuffer("idopcionarticulo");
  var idOpcionArtNueva: String;
  if (!idOpcionArticulo || idOpcionArticulo == "") {
    idOpcionArtNueva = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + this.iface.idTipoOpcionArtMarcada_ + " AND valordefecto = true");
  } else {
    idOpcionArtNueva = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + this.iface.idTipoOpcionArtMarcada_ + " AND idopcionarticulo > " + idOpcionArticulo + " ORDER BY idopcionarticulo");
    if (!idOpcionArtNueva) {
      idOpcionArtNueva = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + this.iface.idTipoOpcionArtMarcada_ + " AND idopcionarticulo > 0 ORDER BY idopcionarticulo");
    }
  }
  if (idOpcionArtNueva && idOpcionArtNueva != idOpcionArticulo)
    this.child("fdbIdOpcionArticulo").setValue(idOpcionArtNueva);
}

function sofa_telaModificada()
{
  this.child("fdbIdSerieTela").setValue(this.iface.calculateField("idserietela"));
  this.child("fdbDescripcion").setValue(this.iface.calculateField("descripcion"));
}

function sofa_obtenerIdTipoOpcionArtMarcada()
{
  return this.iface.idTipoOpcionArtMarcada_
}

function sofa_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  switch (fN)
  {
    case "pvpunitario": {
      var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      if (codFamilia && codFamilia == "TELA") {
        valor = util.sqlSelect("articulos a INNER JOIN seriestela st ON a.idserietela = st.idserietela", "st.pvp", "a.referencia = '" + cursor.valueBuffer("referencia") + "'", "articulos,seriestela");
      } else {
        valor = this.iface.__calculateField(fN);
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

function sofa_quitarModulo()
{
  debug("sofa_quitarModulo");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  debug(sys.nameUser());
  if (sys.nameUser() != "facturalux" && sys.nameUser() != "infosial")
    return;

  if (!util.sqlSelect("articulos", "codfamilia", "referencia = '" + cursor.valueBuffer("referencia") + "'") == "MOD") {
    MessageBox.warning(util.translate("scripts", "Este botón solo puede usarse para quitar módulos del pedido"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  var codLote: String = this.child("tdbLotesStock").cursor().valueBuffer("codlote");
  if (!codLote) {
    return;
  }
  var res: Number = MessageBox.warning(util.translate("scripts", "Va a quitar el módulo %1 del pedido.\n¿Está seguro?").arg(codLote), MessageBox.No, MessageBox.Yes);
  if (res != MessageBox.Yes) {
    return;
  }

  if (!util.sqlDelete("movistock", "codlote = '" + codLote + "'"))
    return;
  if (!util.sqlDelete("movistock", "codloteprod = '" + codLote + "'"))
    return;
  if (!util.sqlDelete("lotesstock", "codlote = '" + codLote + "'"))
    return;

  this.child("tdbMoviStock").refresh();
  this.child("tdbLotesStock").refresh();
}

function sofa_guardarLinea(): Boolean {

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = cursor.valueBuffer("referencia");

  switch (this.iface.datosProceso_["tipoproduccion"])
  {
    case "F": { /// Fabricación
      var curProcesos: FLSqlCursor = this.child("tdbProcesos").cursor();
      if (!flfactalma.iface.pub_controlStockPedidosCli(this.cursor()))
        return false;
      formpedidoscli.iface.pub_setModoOriginal("Browse");

      this.child("gbxConfiguracion").setDisabled(true);
      this.child("gbxModulos").setDisabled(true);
      this.child("fdbReferencia").setDisabled(true);
      this.child("fdbCantidad").setDisabled(true);
      this.iface.tbnGuardar.enabled = false;
      //      if (!curProcesos.commitBufferCursorRelation())
      //        return false;
      // debug("SIGUE *************************");
      //      var idLineaPedido:String = cursor.valueBuffer("idlinea");
      //
      //      var codLote:String;
      //      var qryLotes:FLSqlQuery = new FLSqlQuery;
      //      with (qryLotes) {
      //        setTablesList("lotesstock");
      //        setSelect("codlote");
      //        setFrom("lotesstock");
      //        setWhere("codlote IN (SELECT codlote FROM movistock WHERE idlineapc = " + cursor.valueBuffer("idlinea") + ") AND estado = 'PTE'");
      //        setForwardOnly(true);
      //      }
      //      if (!qryLotes.exec()) {
      //        return false;
      //      }
      //      while (qryLotes.next()) {
      //        codLote = qryLotes.value("codlote");
      //        if (util.sqlSelect("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso", "p.idproceso", "p.idobjeto = '" + codLote + "' AND tp.tipoobjeto = 'lotesstock'")) {
      //          MessageBox.warning(util.translate("scripts", "Error: El lote %1, en estado PTE, ya tiene un proceso asociado").arg(codLote));
      //          return false;
      //        }
      //        if (!flcolaproc.iface.pub_crearProcesoProd(referencia, codLote, idLineaPedido)) {
      //          MessageBox.warning(util.translate("scripts", "Error al crear el proceso %1 para el lote %2").arg(this.iface.datosProceso_["idtipoproceso"]).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
      //          return false;
      //        }
      //      }
      break;
    }
    default: {
      return this.iface.__guardarLinea();
    }
  }
  return true;
}
//// PROD_SOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
