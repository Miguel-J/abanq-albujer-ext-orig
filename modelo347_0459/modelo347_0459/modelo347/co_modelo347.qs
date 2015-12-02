/***************************************************************************
                 co_modelo347.qs  -  description
                             -------------------
    begin                : jue mar 12 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** \C
El modelo 347 recoge la información relativa a los clientes de la empresa que a lo largo del año fiscal facturan más de una determinada cantidad (3000 Euros), así como datos de los arrendamientos que la empresa
<br/>
Restricciones del modelo: El modelo calcula de forma automática los datos de registros de tipo 2 (Declarados). La clave por defecto asociada a todos los registros es:<br/>
A: Adquisiciones de bienes y servicios superiores a 3.005,06 euros.
<br/>
Datos necesarios: <br/>
Si el origen de datos seleccionados es Facturación: Todos los clientes estar identificados con su correspondiente CIF en el módulo principal de facturación. Todas las facturas emitidas a los mismos deben estar registradas en el módulo de facturación<br/>
Si el origen de datos seleccionados es Contabilidad: Todos los clientes estar identificados con su correspondiente CIF en el módulo principal de facturación. Todas las facturas emitidas a los mismos deben estar registradas en el módulo de contabilidad mediante su correspondiente asiento. Cada cliente debe tener una subcuenta contable individual
\end */
/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
  function calculateField(fN: String)
  {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var fechaInicio_, fechaFin_;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function calcularValores()
  {
    this.ctx.oficial_calcularValores();
  }
  function calcularValoresConta()
  {
    this.ctx.oficial_calcularValoresConta();
  }
  function borrarValores()
  {
    return this.ctx.oficial_borrarValores();
  }
  function desconectar()
  {
    return this.ctx.oficial_desconectar();
  }
  function calcularTotales()
  {
    return this.ctx.oficial_calcularTotales();
  }
  function establecerCondiciones()
  {
    return this.ctx.oficial_establecerCondiciones();
  }
  function whereFacturas()
  {
    return this.ctx.oficial_whereFacturas();
  }
  function whereCobros()
  {
    return this.ctx.oficial_whereCobros();
  }
  function whereContabilidadCli()
  {
    return this.ctx.oficial_whereContabilidadCli();
  }
  function whereContabilidadProv()
  {
    return this.ctx.oficial_whereContabilidadProv();
  }
  function mostrarDetalle()
  {
    return this.ctx.oficial_mostrarDetalle();
  }
  function mostrarDetalleFactCliente()
  {
    return this.ctx.oficial_mostrarDetalleFactCliente();
  }
  function mostrarDetalleFactProveedor()
  {
    return this.ctx.oficial_mostrarDetalleFactProveedor();
  }
  function mostrarDetalleCobrosTerceros()
  {
    return this.ctx.oficial_mostrarDetalleCobrosTerceros();
  }
  function mostrarDetalleContCliente()
  {
    return this.ctx.oficial_mostrarDetalleContCliente();
  }
  function mostrarDetalleContProveedor()
  {
    return this.ctx.oficial_mostrarDetalleContProveedor();
  }
  function registroFacturasCli(cifNif, T, importe)
  {
    return this.ctx.oficial_registroFacturasCli(cifNif, T, importe);
  }
  function registroFacturasProv(cifNif, T, importe)
  {
    return this.ctx.oficial_registroFacturasProv(cifNif, T, importe);
  }
  function registroCobroCli(cifNif, T, importe)
  {
    return this.ctx.oficial_registroCobroCli(cifNif, T, importe);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init()
{
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
  connect(this.child("tdbDeclarados").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  connect(this.child("tdbInmuebles").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  connect(this, "closed()", this, "iface.desconectar()");
  connect(this.child("pbnDetalle"), "clicked()", this, "iface.mostrarDetalle()");

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
    //this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
    this.child("fdbCifNif").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif"));
    var nombre = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs") + " " + flcontmode.iface.pub_valorDefectoDatosFiscales("nombre");
    this.child("fdbApellidosNombreRS").setValue(nombre);
    this.child("fdbTelefono").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("telefono"));
    this.child("fdbContacto").setValue(nombre);
  }
  this.iface.establecerCondiciones();
}

function interna_calculateField(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
      /** \C --totalentidades-- (Número total de entidades) es el total de registros contenidos en la tabla de la pestaña Registros Declarados
      \end */
    case "totalentidades":
      valor = this.child("tdbDeclarados").cursor().size();
      break;

      /** \C --importetotal-- es la suma de los importes de los registros contenidos en la tabla de la pestaña Registros Declarados.
      \end */
    case "importetotal":
      valor = util.sqlSelect("co_modelo347_tipo2d", "SUM(importe)", "idmodelo = " + cursor.valueBuffer("idmodelo"));
      if (!valor)
        valor = 0;
      break;

      /** \C --totalinmuebles-- (Número total de inmuebles) es el número de registros contenidos en la tabla de la pestaña Registros de Inmuebles.
      \end */
    case "totalinmuebles":
      valor = this.child("tdbInmuebles").cursor().size();
      break;

      /** \C --totalarrendamiento-- (Importe de las operaciones de arrendamiento de locales de negocio) es la suma de los importes de los registros contenidos en la tabla de la pestaña Registros de Inmuebles.
      \end */
    case "totalarrendamiento":
      valor = util.sqlSelect("co_modelo347_tipo2i", "SUM(importe)", "idmodelo = " + cursor.valueBuffer("idmodelo"));
      if (!valor)
        valor = 0;
      break;
  }
  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
  disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  disconnect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
  disconnect(this.child("tdbDeclarados").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  disconnect(this.child("tdbInmuebles").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
}

function oficial_bufferChanged(fN)
{
  switch (fN) {
  }
}

/** \D Calcula los valores de las casillas de resumen del modelo
\end */
function oficial_calcularTotales()
{
  this.child("tdbDeclarados").refresh();
  this.child("tdbInmuebles").refresh();

  this.child("fdbTotalEntidades").setValue(this.iface.calculateField("totalentidades"));
  this.child("fdbImporteTotal").setValue(this.iface.calculateField("importetotal"));
  this.child("fdbTotalInmuebles").setValue(this.iface.calculateField("totalinmuebles"));
  this.child("fdbTotalArrendamiento").setValue(this.iface.calculateField("totalarrendamiento"));
}

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de facturación
\end */
function oficial_calcularValores()
{
  var _i = this.iface;
  this.iface.borrarValores();

  flcontmode.iface.pub_cargarCuentaPagoEfectivo();
  var util = new FLUtil;
  var cursor = this.cursor();

  _i.fechaInicio_ = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
  _i.fechaFin_ = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");

  if (cursor.valueBuffer("origen") == "Contabilidad")
    return this.iface.calcularValoresConta();

  var numRegistros = 0;
  var qryDeclarados = new FLSqlQuery;
  qryDeclarados.setTablesList("facturascli");
  qryDeclarados.setSelect("cifnif, SUM(total), EXTRACT(QUARTER FROM fecha)");
  qryDeclarados.setFrom("facturascli");
  var where = this.iface.whereFacturas();
  where += " GROUP BY cifnif, EXTRACT(QUARTER FROM fecha) ORDER BY cifnif, EXTRACT(QUARTER FROM fecha)";

  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);

  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (B)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importe: Number;
  var importeMinimo = parseFloat(cursor.valueBuffer("importeminimo"));
  var qryRecibos = new FLSqlQuery;
  var qryPagos = new FLSqlQuery;
  var importeMetalico: Number;
  var codPais: String;
  var nombreCliente: String;
  var codCliente: String;
  var cifLimpio: String;
  var T = new Array(4);
  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  var cifNifNuevo = false;
  var cifNif = false;
  var iTrim, totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("cifnif");
    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(total)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroFacturasCli(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(total)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroFacturasCli(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }

  qryDeclarados.setTablesList("facturasprov");
  qryDeclarados.setSelect("cifnif, SUM(total), EXTRACT(QUARTER FROM fecha)");
  qryDeclarados.setFrom("facturasprov f");
  var where = this.iface.whereFacturas();
  where += " GROUP BY cifnif, EXTRACT(QUARTER FROM fecha) ORDER BY cifnif, EXTRACT(QUARTER FROM fecha)";
  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);

  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (A)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  cifNifNuevo = false;
  cifNif = false;
  totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("cifnif");
    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(total)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroFacturasProv(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(total)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroFacturasProv(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }


  var qryDeclarados = new FLSqlQuery;
  qryDeclarados.setTablesList("cobrosterceros,clientes");
  qryDeclarados.setSelect("c.cifnif, SUM(importe), EXTRACT(QUARTER FROM fechacobro)");
  qryDeclarados.setFrom("cobrosterceros t LEFT OUTER JOIN clientes c on t.codcliente = c.codcliente");
  var where = this.iface.whereCobros();
  where += " GROUP BY c.cifnif, EXTRACT(QUARTER FROM fechacobro) ORDER BY cifnif, EXTRACT(QUARTER FROM fechacobro)";

  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);

  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (C)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importe: Number;
  var importeMinimo = parseFloat(cursor.valueBuffer("importeminimocobros"));
  var qryRecibos = new FLSqlQuery;
  var qryPagos = new FLSqlQuery;
  var importeMetalico: Number;
  var codPais: String;
  var nombreCliente: String;
  var codCliente: String;
  var cifLimpio: String;
  var T = new Array(4);
  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  var cifNifNuevo = false;
  var cifNif = false;
  var iTrim, totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("c.cifnif");
    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fechacobro)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(importe)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroCobroCli(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fechacobro)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(importe)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroCobroCli(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }

  if (numRegistros == 0) {
    MessageBox.information(util.translate("scipts", "No se ha encontrado ningún cliente cuyo importe de cobro exceda del valor mínimo para los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
  }

  this.iface.calcularTotales();
}

function oficial_registroFacturasCli(cifNif, T, importe)
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importeMetalico = 0;
  var codCliente = util.sqlSelect("clientes", "codcliente", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  var nombreCliente = util.sqlSelect("clientes", "nombre", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  if (!nombreCliente) {
    nombreCliente = util.sqlSelect("facturascli", "nombrecliente", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  }
  nombreCliente = flcontmode.iface.pub_formatearTexto(nombreCliente);

  var codPais = util.sqlSelect("dirclientes dc INNER JOIN paises p ON dc.codpais = p.codpais", "p.codiso", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,paises");
  if ((codPais && codPais.toUpperCase() != "ES") || codPais == "") {
    return true;
  }
  codPais = "  ";

  if (cursor.modeAccess() == cursor.Insert) {
    if (!curDeclarados.commitBufferCursorRelation()) {
      return false;
    }
  }

  cifLimpio = flcontmode.iface.pub_limpiarCifNif(cifNif);
  if (cifLimpio.length > 9) {
    var res = MessageBox.warning(util.translate("scripts", "El CIF ó NIF %1 (%2) correspondiente a %3 tiene más de 9 dígitos, por lo que no entrará en la declaración.\nPulse Ignorar para continuar con el siguiente registro o Cancelar para cancelar la carga de datos").arg(cifLimpio).arg(cifNif).arg(nombreCliente), MessageBox.Ignore, MessageBox.Cancel);
    if (res == MessageBox.Ignore) {
      return true;
    } else {
      return false;
    }
  }

  importeMetalico = flcontmode.iface.pub_importeMetalicoCli347(cursor, codCliente, _i.fechaInicio_, _i.fechaFin_);
  if (importeMetalico < cursor.valueBuffer("importeminimoefectivo")) {
    importeMetalico = 0;
  }


  with(curDeclarados) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
    setValueBuffer("nifdeclarado", cifLimpio);
    setValueBuffer("nifreplegal", flfactppal.iface.pub_espaciosDerecha("", 9));
    if (nombreCliente && nombreCliente != "") {
      setValueBuffer("apellidosnombrers", nombreCliente.left(40));
    }
    setValueBuffer("codpais", codPais);
    setValueBuffer("codprovincia", util.sqlSelect("dirclientes dc INNER JOIN provincias p ON dc.idprovincia = p.idprovincia", "p.codigo", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,provincias"));
    setValueBuffer("importe", importe);
    setValueBuffer("clavecodigo", "B");
    setValueBuffer("importemetalico", importeMetalico);
  }
  for (var i = 1; i <= 4; i++) {
    curDeclarados.setValueBuffer("importet" + i.toString(), T[i - 1]);
  }
  curDeclarados.setValueBuffer("codclienteprov", codCliente);
  if (!curDeclarados.commitBuffer()) {
    MessageBox.critical(util.translate("scripts", "Falló la inserción de registro de declarado para el cliente: %1").arg(nombreCliente), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_registroFacturasProv(cifNif, T, importe)
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importeMetalico = 0;
  var codProveedor = util.sqlSelect("proveedores", "codproveedor", "cifnif = '" + cifNif + "' ORDER BY codproveedor");
  var nombreProveedor = util.sqlSelect("proveedores", "nombre", "cifnif = '" + cifNif + "' ORDER BY codproveedor");
  if (!nombreProveedor) {
    nombreProveedor = util.sqlSelect("facturasprov", "nombre", "cifnif = '" + cifNif + "' ORDER BY codproveedor");
  }
  nombreProveedor = flcontmode.iface.pub_formatearTexto(nombreProveedor);
  var codPais = util.sqlSelect("dirproveedores dp INNER JOIN paises p ON dp.codpais = p.codpais", "p.codiso", "dp.codproveedor = '" + codProveedor + "' AND dp.direccionppal = true", "dirproveedores,paises");
  if ((codPais && codPais.toUpperCase() != "ES") || codPais == "") {
    return true;
  }
  codPais = "  ";

  if (cursor.modeAccess() == cursor.Insert)  {
    if (!curDeclarados.commitBufferCursorRelation()) {
      return;
    }
  }

  cifLimpio = flcontmode.iface.pub_limpiarCifNif(cifNif);
  if (cifLimpio.length > 9) {
    var res = MessageBox.warning(util.translate("scripts", "El CIF ó NIF %1 (%2) correspondiente a %3 tiene más de nueve dígitos, por lo que no entrará en la declaración.\nPulse Ignorar para continuar con el siguiente registro o Cancelar para cancelar la carga de datos").arg(cifLimpio).arg(cifNif).arg(nombreProveedor), MessageBox.Ignore, MessageBox.Cancel);
    if (res == MessageBox.Ignore) {
      return true;
    } else {
      return false;
    }
  }
  importeMetalico = flcontmode.iface.pub_importeMetalicoProv347(cursor, codProveedor, _i.fechaInicio_, _i.fechaFin_);
  if (importeMetalico < cursor.valueBuffer("importeminimoefectivo")) {
    importeMetalico = 0;
  }

  with(curDeclarados) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
    setValueBuffer("nifdeclarado", cifLimpio);
    setValueBuffer("nifreplegal", flfactppal.iface.pub_espaciosDerecha("", 9));
    if (nombreProveedor && nombreProveedor != "") {
      setValueBuffer("apellidosnombrers", nombreProveedor.left(40));
    }
    setValueBuffer("codpais", codPais);
    setValueBuffer("codprovincia", util.sqlSelect("dirproveedores dp INNER JOIN provincias p ON dp.idprovincia = p.idprovincia", "p.codigo", "dp.codproveedor = '" + codProveedor + "' AND dp.direccionppal = true", "dirproveedores,provincias"));
    setValueBuffer("importe", importe);
    setValueBuffer("importemetalico", importeMetalico);
    setValueBuffer("clavecodigo", "A");
    setValueBuffer("codclienteprov", codProveedor);
  }
  for (var i = 1; i <= 4; i++) {
    curDeclarados.setValueBuffer("importet" + i.toString(), T[i - 1]);
  }
  if (!curDeclarados.commitBuffer()) {
    MessageBox.critical(util.translate("scripts", "Falló la inserción de registro de declarado para el proveedor: ") + nombreProveedor, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  numRegistros++;
  return true;
}

function oficial_registroCobroCli(cifNif, T, importe)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importeMetalico = 0;
  var codCliente = AQUtil.sqlSelect("clientes", "codcliente", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  var nombreCliente = AQUtil.sqlSelect("clientes", "nombre", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  if (!nombreCliente) {
    nombreCliente = AQUtil.sqlSelect("facturascli", "nombrecliente", "cifnif = '" + cifNif + "' ORDER BY codcliente");
  }
  nombreCliente = flcontmode.iface.pub_formatearTexto(nombreCliente);

  var codPais = AQUtil.sqlSelect("dirclientes dc INNER JOIN paises p ON dc.codpais = p.codpais", "p.codiso", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,paises");
  if ((codPais && codPais.toUpperCase() != "ES") || codPais == "") {
    return true;
  }
  codPais = "  ";

  if (cursor.modeAccess() == cursor.Insert) {
    if (!curDeclarados.commitBufferCursorRelation()) {
      return false;
    }
  }

  cifLimpio = flcontmode.iface.pub_limpiarCifNif(cifNif);
  if (cifLimpio.length > 9) {
    var res = MessageBox.warning(sys.translate("El CIF ó NIF %1 (%2) correspondiente a %3 tiene más de 9 dígitos, por lo que no entrará en la declaración.\nPulse Ignorar para continuar con el siguiente registro o Cancelar para cancelar la carga de datos").arg(cifLimpio).arg(cifNif).arg(nombreCliente), MessageBox.Ignore, MessageBox.Cancel);
    if (res == MessageBox.Ignore) {
      return true;
    } else {
      return false;
    }
  }

  //  importeMetalico = flcontmode.iface.pub_importeMetalicoCli347(cursor, codCliente, _i.fechaInicio_, _i.fechaFin_);
  //  if (importeMetalico < cursor.valueBuffer("importeminimoefectivo")) {
  //    importeMetalico = 0;
  //  }

  with(curDeclarados) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
    setValueBuffer("nifdeclarado", cifLimpio);
    setValueBuffer("nifreplegal", flfactppal.iface.pub_espaciosDerecha("", 9));
    if (nombreCliente && nombreCliente != "") {
      setValueBuffer("apellidosnombrers", nombreCliente.left(40));
    }
    setValueBuffer("codpais", codPais);
    setValueBuffer("codprovincia", AQUtil.sqlSelect("dirclientes dc INNER JOIN provincias p ON dc.idprovincia = p.idprovincia", "p.codigo", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,provincias"));
    setValueBuffer("importe", importe);
    setValueBuffer("clavecodigo", "C");
    setValueBuffer("importemetalico", importeMetalico);
  }
  for (var i = 1; i <= 4; i++) {
    curDeclarados.setValueBuffer("importet" + i.toString(), T[i - 1]);
  }
  curDeclarados.setValueBuffer("codclienteprov", codCliente);
  if (!curDeclarados.commitBuffer()) {
    MessageBox.critical(sys.translate("Falló la inserción de registro de declarado para el cliente: %1").arg(nombreCliente), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_whereFacturas()
{
  var cursor = this.cursor();
  var where = "codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND (nomodelo347 = false or nomodelo347 IS NULL)";
  var codSerie = cursor.valueBuffer("codserie");
  if (codSerie && codSerie != "") {
    where += " AND codserie = '" + cursor.valueBuffer("codserie") + "'";
  }
  return where;
}

function oficial_whereCobros()
{
  var cursor = this.cursor();
  var where = "codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND (nomodelo347 = false or nomodelo347 IS NULL)";

  return where;
}


/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValoresConta()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();

  var numRegistros = 0;
  var qryDeclarados = new FLSqlQuery;
  qryDeclarados.setTablesList("clientes,co_asientos,co_partidas,co_subcuentascli");
  qryDeclarados.setSelect("c.cifnif, SUM(pcli.debe - pcli.haber), EXTRACT(QUARTER FROM a.fecha)");
  qryDeclarados.setFrom("co_partidas pcli INNER JOIN co_subcuentascli scc ON pcli.idsubcuenta = scc.idsubcuenta INNER JOIN clientes c ON scc.codcliente = c.codcliente INNER JOIN co_asientos a ON pcli.idasiento = a.idasiento");
  var where = this.iface.whereContabilidadCli();
  where += " GROUP BY c.cifnif, EXTRACT(QUARTER FROM a.fecha) ORDER BY c.cifnif, EXTRACT(QUARTER FROM a.fecha)";
  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);
  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (B)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importe: Number;
  var importeMinimo = parseFloat(cursor.valueBuffer("importeminimo"));
  var qryRecibos = new FLSqlQuery;
  var qryPagos = new FLSqlQuery;
  var importeMetalico: Number;
  var codPais: String;
  var cifLimpio: String;

  var nombreCliente: String;
  var codCliente: String;

  var T = new Array(4);
  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  var cifNifNuevo = false;
  var cifNif = false;
  var iTrim, totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("c.cifnif");
    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM a.fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(pcli.debe - pcli.haber)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroFacturasCli(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM a.fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(pcli.debe - pcli.haber)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroFacturasCli(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }

  /*
    while (qryDeclarados.next()) {
      importeMetalico = 0;
      codCliente = util.sqlSelect("clientes", "codcliente", "cifnif = '" + qryDeclarados.value("c.cifnif") + "' ORDER BY codcliente");
      nombreCliente = util.sqlSelect("clientes", "nombre", "cifnif = '" + qryDeclarados.value("c.cifnif") + "' ORDER BY codcliente");
      nombreCliente = flcontmode.iface.pub_formatearTexto(nombreCliente);
      importe = parseFloat(qryDeclarados.value("SUM(pcli.debe - pcli.haber)"));
      if (importe < importeMinimo)
        continue;

      codPais = util.sqlSelect("dirclientes dc INNER JOIN paises p ON dc.codpais = p.codpais", "p.codiso", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,paises");
      if ((codPais && codPais.toUpperCase() != "ES") || codPais == "") {
        continue;
      }
      codPais = "  ";

      if (cursor.modeAccess() == cursor.Insert)
        if (!curDeclarados.commitBufferCursorRelation())
          return;

      cifLimpio = flcontmode.iface.pub_limpiarCifNif(qryDeclarados.value("c.cifnif"));
      if (cifLimpio.length > 9) {
        var res= MessageBox.warning(util.translate("scripts", "El CIF ó NIF %1 (%2) correspondiente a %3 tiene más de nueve dígitos, por lo que no entrará en la declaración.\nPulse Ignorar para continuar con el siguiente registro o Cancelar para cancelar la carga de datos").arg(cifLimpio).arg(qryDeclarados.value("c.cifnif")).arg(nombreCliente), MessageBox.Ignore, MessageBox.Cancel);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          return false;
        }
      }

      qryRecibos.setTablesList("reciboscli");
      qryRecibos.setSelect("idrecibo, importe");
      qryRecibos.setFrom("reciboscli");
      qryRecibos.setWhere("codcliente = '" + codCliente + "'");
      qryRecibos.setForwardOnly(true);

      if (!qryRecibos.exec()) {
        return false;
      }



      importeMetalico = flcontmode.iface.pub_importeMetalicoCli347(cursor, codCliente, _i.fechaInicio_, _i.fechaFin_);
      if (importeMetalico < cursor.valueBuffer("importeminimoefectivo")) {
        importeMetalico = 0;
      }

      with (curDeclarados) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
        setValueBuffer("nifdeclarado", cifLimpio);
        setValueBuffer("nifreplegal", flfactppal.iface.pub_espaciosDerecha("", 9));
        if (nombreCliente && nombreCliente != "") {
          setValueBuffer("apellidosnombrers", nombreCliente.left(40));
        }
        setValueBuffer("codpais", codPais);
        setValueBuffer("codprovincia", util.sqlSelect("dirclientes dc INNER JOIN provincias p ON dc.idprovincia = p.idprovincia", "p.codigo", "dc.codcliente = '" + codCliente + "' AND dc.domfacturacion = true", "dirclientes,provincias"));
        setValueBuffer("importe", importe);
        setValueBuffer("importemetalico", importeMetalico);
        setValueBuffer("clavecodigo", "B");
        setValueBuffer("codclienteprov", codCliente);
        if (!commitBuffer()) {
          MessageBox.critical(util.translate("scripts", "Falló la inserción de registro de declarado para el cliente: ") + qryDeclarados.value("c.nombre"), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        numRegistros++;
      }
    }
  */
  qryDeclarados.setTablesList("proveedores,co_asientos,co_partidas,co_subcuentasprov");
  qryDeclarados.setSelect("p.cifnif, SUM(pprov.haber - pprov.debe), EXTRACT(QUARTER FROM a.fecha)");
  qryDeclarados.setFrom("co_partidas pprov INNER JOIN co_subcuentasprov scp ON pprov.idsubcuenta = scp.idsubcuenta INNER JOIN proveedores p ON scp.codproveedor = p.codproveedor INNER JOIN co_asientos a ON a.idasiento = pprov.idasiento");
  var where = this.iface.whereContabilidadProv();
  where += " GROUP BY p.cifnif, EXTRACT(QUARTER FROM a.fecha) ORDER BY p.cifnif, EXTRACT(QUARTER FROM a.fecha)";
  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);
  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (A)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  cifNifNuevo = false;
  cifNif = false;
  totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("p.cifnif");
    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM a.fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(pprov.haber - pprov.debe)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroFacturasProv(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM a.fecha)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(pprov.haber - pprov.debe)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroFacturasProv(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }
  /*
    var codProveedor:String;
    var nombreProveedor:String;
    while (qryDeclarados.next()) {
      importeMetalico = 0;
      codProveedor = util.sqlSelect("proveedores", "codproveedor", "cifnif = '" + qryDeclarados.value("p.cifnif") + "' ORDER BY codproveedor");
      nombreProveedor = util.sqlSelect("proveedores", "nombre", "cifnif = '" + qryDeclarados.value("p.cifnif") + "' ORDER BY codproveedor");
      nombreProveedor = flcontmode.iface.pub_formatearTexto(nombreProveedor);
      importe = parseFloat(qryDeclarados.value("SUM(pprov.haber - pprov.debe)"));
      if (importe < importeMinimo) {
        continue;
      }

      codPais = util.sqlSelect("dirproveedores dp INNER JOIN paises p ON dp.codpais = p.codpais", "p.codiso", "dp.codproveedor = '" + codProveedor + "' AND dp.direccionppal = true", "dirproveedores,paises");
      if ((codPais && codPais.toUpperCase() != "ES") || codPais == "") {
        continue;
      }
      codPais = "  ";

      if (cursor.modeAccess() == cursor.Insert)
        if (!curDeclarados.commitBufferCursorRelation())
          return;

      cifLimpio = flcontmode.iface.pub_limpiarCifNif(qryDeclarados.value("p.cifnif"));
      if (cifLimpio.length > 9) {
        var res= MessageBox.warning(util.translate("scripts", "El CIF ó NIF %1 (%2) correspondiente a %3 tiene más de nueve dígitos, por lo que no entrará en la declaración.\nPulse Ignorar para continuar con el siguiente registro o Cancelar para cancelar la carga de datos").arg(cifLimpio).arg(qryDeclarados.value("p.cifnif")).arg(nombreProveedor), MessageBox.Ignore, MessageBox.Cancel);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          return false;
        }
      }

      importeMetalico = flcontmode.iface.pub_importeMetalicoProv347(cursor, codProveedor, _i.fechaInicio_, _i.fechaFin_);
      if (importeMetalico < cursor.valueBuffer("importeminimoefectivo")) {
        importeMetalico = 0;
      }

      with (curDeclarados) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
        setValueBuffer("nifdeclarado", cifLimpio);
        setValueBuffer("nifreplegal", flfactppal.iface.pub_espaciosDerecha("", 9));
        if (nombreProveedor && nombreProveedor != "") {
          setValueBuffer("apellidosnombrers", nombreProveedor.left(40));
        }
        setValueBuffer("codpais", codPais);
        setValueBuffer("codprovincia", util.sqlSelect("dirproveedores dp INNER JOIN provincias p ON dp.idprovincia = p.idprovincia", "p.codigo", "dp.codproveedor = '" + codProveedor + "' AND dp.direccionppal = true", "dirproveedores,provincias"));
        setValueBuffer("importe", importe);
        setValueBuffer("importemetalico", importeMetalico);
        setValueBuffer("clavecodigo", "A");
        setValueBuffer("codclienteprov", codProveedor);
        if (!commitBuffer()) {
          MessageBox.critical(util.translate("scripts", "Falló la inserción de registro de declarado para el proveedor: ") + qryDeclarados.value("p.nombre"), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        numRegistros++;
      }
    }
    */

  var qryDeclarados = new FLSqlQuery;
  qryDeclarados.setTablesList("cobrosterceros,clientes");
  qryDeclarados.setSelect("c.cifnif, SUM(importe), EXTRACT(QUARTER FROM fechacobro)");
  qryDeclarados.setFrom("cobrosterceros t LEFT OUTER JOIN clientes c on t.codcliente = c.codcliente");
  var where = this.iface.whereCobros();
  where += " GROUP BY c.cifnif, EXTRACT(QUARTER FROM fechacobro) ORDER BY cifnif, EXTRACT(QUARTER FROM fechacobro)";

  qryDeclarados.setWhere(where);
  qryDeclarados.setForwardOnly(true);

  if (!qryDeclarados.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de declarantes (C)"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curDeclarados = this.child("tdbDeclarados").cursor();
  var importe: Number;
  var importeMinimo = parseFloat(cursor.valueBuffer("importeminimocobros"));
  var qryRecibos = new FLSqlQuery;
  var qryPagos = new FLSqlQuery;
  var importeMetalico: Number;
  var codPais: String;
  var nombreCliente: String;
  var codCliente: String;
  var cifLimpio: String;
  var T = new Array(4);
  for (var i = 0; i < 4; i++) {
    T[i] = 0;
  }
  var cifNifNuevo = false;
  var cifNif = false;
  var iTrim, totalFacturado = 0;
  while (qryDeclarados.next()) {
    cifNifNuevo = qryDeclarados.value("c.cifnif");

    if (cifNifNuevo == cifNif || !cifNif) {
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fechacobro)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(importe)");
      totalFacturado += parseFloat(T[iTrim]);
    } else {
      if (totalFacturado >= importeMinimo) {
        if (!_i.registroCobroCli(cifNif, T, totalFacturado)) {
          return false;
        }
        numRegistros++;
      }
      for (var i = 0; i < 4; i++) {
        T[i] = 0;
      }
      iTrim = qryDeclarados.value("EXTRACT(QUARTER FROM fechacobro)") - 1;
      T[iTrim] = qryDeclarados.value("SUM(importe)");
      totalFacturado = parseFloat(T[iTrim]);
    }
    cifNif = cifNifNuevo;
  }
  if (totalFacturado >= importeMinimo) {
    if (!_i.registroCobroCli(cifNif, T, totalFacturado)) {
      return false;
    }
    numRegistros++;
  }

  if (numRegistros == 0) {
    MessageBox.information(util.translate("scipts", "No se ha encontrado ningún cliente o proveedor cuya facturación exceda del valor mínimo para los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
  }
  this.iface.calcularTotales();
  return true;
}

function oficial_whereContabilidadCli()
{
  var cursor = this.cursor();
  var where = "a.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND a.tipodocumento = 'Factura de cliente' AND (a.nomodelo347 = false or a.nomodelo347 IS NULL)";
  return where;
}
function oficial_whereContabilidadProv()
{
  var cursor = this.cursor();
  var where = "a.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND a.tipodocumento = 'Factura de proveedor' AND (nomodelo347 = false or nomodelo347 IS NULL)";
  return where;
}
/** \D Borra algunas de las casillas calculadas
\end */
function oficial_borrarValores()
{
  var util = new FLUtil();
  if (!util.sqlDelete("co_modelo347_tipo2d", "idmodelo = " + this.cursor().valueBuffer("idmodelo")));
  return false;

  this.iface.calcularTotales();

}

function oficial_establecerCondiciones()
{
  var util = new FLUtil();

  this.child("lblCondiciones").text = util.translate("scripts", "Para la correcta consulta de los datos para este modelo hay que tener en cuenta algunas condiciones que los datos deben cumplir.\nConsultas desde facturación:\nTodas las facturas de cliente deben estar asociadas a su correspondiente cliente en la tabla de clientes. Facturas sin código de cliente especificado no serán tenidas en cuenta. Lo mismo ocurre con facturas de proveedores.\nEn el caso de que haya dos clientes / proveedores con el mismo CIF, se mostrarán sus datos acumulados y se mostrará el nombre y país del primero encontrado (ordenando por código de cliente/proveedor)\n\nConsultas desde contabilidad:\nEl total para cada CIF coincidirá con la suma del saldo de las partidas incluidas en los asientos que contengan a las subcuentas de cliente / proveedor. El campo Tipo de documento de estos asientos debe esta marcado como Factura de cliente o Factura de proveedor. Dichas subcuentas del asiento de la factura deben estar asociadas al cliente / proveedor en la pestaña de Contabilidad de la ficha de clientes / proveedores.\nEn el caso de varios clientes o proveedores con el mismo CIF el sistema se comporta de la misma forma que en Facturación.\n\nSi se cumplen estas condiciones y no se crean facturas directamente desde asientos manuales las consultas de facturación y contabilidad deben coincidir.\n\nSólo se mostrarán los datos de clientes y proveedores cuya dirección de facturación/principal esté ligada a un país cuyo campo código I.S.O. sea 'ES'.");
}

function oficial_mostrarDetalle()
{
  var util = new FLUtil();
  var cursor = this.cursor();

  if (cursor.valueBuffer("origen") == "Facturación") {
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "B") {
      this.iface.mostrarDetalleFactCliente();
    }
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "A") {
      this.iface.mostrarDetalleFactProveedor();
    }
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "C") {
      this.iface.mostrarDetalleCobrosTerceros();
    }
  }
  if (cursor.valueBuffer("origen") == "Contabilidad") {
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "B") {
      this.iface.mostrarDetalleContCliente();
    }
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "A") {
      this.iface.mostrarDetalleContProveedor();
    }
    if (this.child("tdbDeclarados").cursor().valueBuffer("clavecodigo") == "C") {
      this.iface.mostrarDetalleCobrosTerceros();
    }
  }
}

function oficial_mostrarDetalleFactCliente()
{
  var f = new FLFormSearchDB("co_facturacioncli347");
  var curFacturas = f.cursor();
  var filtro = this.iface.whereFacturas();
  filtro += "AND cifnif = '" + this.child("tdbDeclarados").cursor().valueBuffer("nifdeclarado") + "' AND (nomodelo347 = false OR nomodelo347 IS NULL)";
  curFacturas.setMainFilter(filtro);
  f.setMainWidget();
  if (!f.exec()) {
    return false;
  }
}

function oficial_mostrarDetalleCobrosTerceros()
{
  var f = new FLFormSearchDB("co_cobrosterceros347");
  var curFacturas = f.cursor();
  var filtro = this.iface.whereCobros();
  filtro += "AND codcliente = '" + AQUtil.sqlSelect("clientes", "codcliente", "cifnif = '" + this.child("tdbDeclarados").cursor().valueBuffer("nifdeclarado") + "'") + "' AND (nomodelo347 = false OR nomodelo347 IS NULL)";
  curFacturas.setMainFilter(filtro);
  f.setMainWidget();
  if (!f.exec()) {
    return false;
  }
}

function oficial_mostrarDetalleFactProveedor()
{
  var f = new FLFormSearchDB("co_facturacionprov347");
  var curFacturas = f.cursor();
  var filtro = this.iface.whereFacturas();
  filtro += "AND cifnif = '" + this.child("tdbDeclarados").cursor().valueBuffer("nifdeclarado") + "' AND (nomodelo347 = false OR nomodelo347 IS NULL)";
  curFacturas.setMainFilter(filtro);
  f.setMainWidget();
  if (!f.exec()) {
    return false;
  }
}

function oficial_mostrarDetalleContCliente()
{
  var f = new FLFormSearchDB("co_contabilidadcli347");
  var curPartidas = f.cursor();
  var filtro = "idpartida IN (SELECT pcli.idpartida FROM  co_partidas pcli INNER JOIN co_asientos a ON pcli.idasiento = a.idasiento INNER JOIN co_subcuentascli scc ON pcli.idsubcuenta = scc.idsubcuenta INNER JOIN clientes c ON scc.codcliente = c.codcliente WHERE " + this.iface.whereContabilidadCli();

  filtro += " AND c.cifnif = '" + this.child("tdbDeclarados").cursor().valueBuffer("nifdeclarado") + "' AND (a.nomodelo347 = false OR a.nomodelo347 IS NULL))";
  curPartidas.setMainFilter(filtro);
  f.setMainWidget();
  if (!f.exec()) {
    return false;
  }
}

function oficial_mostrarDetalleContProveedor()
{
  var f = new FLFormSearchDB("co_contabilidadprov347");
  var curPartidas = f.cursor();
  var filtro = "idpartida IN (SELECT pprov.idpartida FROM  co_partidas pprov INNER JOIN co_asientos a ON pprov.idasiento = a.idasiento INNER JOIN co_subcuentasprov scp ON pprov.idsubcuenta = scp.idsubcuenta INNER JOIN proveedores p ON scp.codproveedor = p.codproveedor WHERE " + this.iface.whereContabilidadProv();

  filtro += " AND p.cifnif = '" + this.child("tdbDeclarados").cursor().valueBuffer("nifdeclarado") + "' AND (a.nomodelo347 = false OR a.nomodelo347 IS NULL))";
  curPartidas.setMainFilter(filtro);
  f.setMainWidget();
  if (!f.exec()) {
    return false;
  }
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
