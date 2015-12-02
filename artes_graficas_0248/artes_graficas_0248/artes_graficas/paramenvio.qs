/***************************************************************************
                 enviostrabajo.qs  -  description
                             -------------------
    begin                : mar abr 02 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
    return this.ctx.interna_init();
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String): String {
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
  var bloqueoPortes: Boolean = false;
  var bloqueoProvincia: Boolean = false;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.ctx.oficial_guardarDatos(cursor);
  }
  function validarDatos(xmlProceso: FLDomNode): Boolean {
    return this.ctx.oficial_validarDatos(xmlProceso);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function tbnDireccion_clicked()
  {
    return this.ctx.oficial_tbnDireccion_clicked();
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
  function pub_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.guardarDatos(cursor);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
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
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnDireccion"), "clicked()", this, "iface.tbnDireccion_clicked");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      var curRel: FLSqlCursor = cursor.cursorRelation();
      switch (curRel.table()) {
        case "paramlibro": {
          this.child("fdbPesoUnidad").setValue(this.iface.calculateField("pesounidad"));
          this.child("fdbNumCopias").setValue(this.iface.calculateField("numcopias"));
          this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
          break;
        }
        case "paramiptico": {
          this.child("fdbPesoUnidad").setValue(this.iface.calculateField("pesounidad"));
          this.child("fdbNumCopias").setValue(this.iface.calculateField("numcopias"));
          this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
          break;
        }
      }
      break;
    }
  }
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }

  if (!this.iface.validarDatos(xmlDocParam.firstChild()))
  {
    return false;
  }

  debug(xmlDocParam.toString());

  cursor.setValueBuffer("xml", xmlDocParam.toString());

  return true;
}

function interna_calculateField(fN: String): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String = this.iface.commonCalculateField(fN, cursor);

  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "numcopias":
    case "pesounidad": {
      this.child("fdbPeso").setValue(this.iface.calculateField("peso"));
      break;
    }
    case "idayvuelta":
    case "codagencia": {
      var codAgencia: String = cursor.valueBuffer("codagencia");
      if (!codAgencia || codAgencia == "") {
        break;
      }
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "peso":
    case "codpais": {
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        var codAgencia: String = cursor.valueBuffer("codagencia");
        if (!codAgencia || codAgencia == "") {
          this.child("fdbCodAgencia").setValue(this.iface.calculateField("codagencia"));
        }
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "ciudad": {
      debug("BCh ciudad bloqueoprov = " + debug(this.iface.bloqueoProvincia));
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        flfactppal.iface.pub_obtenerPoblacion(this);
        this.iface.bloqueoProvincia = false;
      }
      break;
    }
    case "idpoblacion": {
      if (cursor.valueBuffer("idpoblacion") == 0) {
        cursor.setNull("idpoblacion");
      }
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        var codAgencia: String = cursor.valueBuffer("codagencia");
        if (!codAgencia || codAgencia == "") {
          this.child("fdbCodAgencia").setValue(this.iface.calculateField("codagencia"));
        }
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "provincia": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        flfactppal.iface.pub_obtenerProvincia(this);
        this.iface.bloqueoProvincia = false;
      }
      break;
    }
    case "idprovincia": {
      if (cursor.valueBuffer("idprovincia") == 0) {
        cursor.setNull("idprovincia");
      }
      if (!this.iface.bloqueoPortes) {
        this.iface.bloqueoPortes = true;
        this.child("fdbPortes").setValue(this.iface.calculateField("portes"));
        var codAgencia: String = cursor.valueBuffer("codagencia");
        if (!codAgencia || codAgencia == "") {
          this.child("fdbCodAgencia").setValue(this.iface.calculateField("codagencia"));
        }
        this.iface.bloqueoPortes = false;
      }
      break;
    }
    case "codcliente": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        this.child("fdbCodProveedor").setValue("");
        this.child("fdbNombreDestino").setValue(this.iface.calculateField("nombredestinocli"));
        this.child("fdbDireccion").setValue(this.iface.calculateField("direccioncli"));
        this.child("fdbCodPostal").setValue(this.iface.calculateField("codpostalcli"));
        this.child("fdbIdPoblacion").setValue(this.iface.calculateField("idpoblacioncli"));
        this.child("fdbIdProvincia").setValue(this.iface.calculateField("idprovinciacli"));
        this.iface.bloqueoProvincia = false;
      }
      break;
    }
    case "codproveedor": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        this.child("fdbCodCliente").setValue("");
        this.child("fdbNombreDestino").setValue(this.iface.calculateField("nombredestinoprov"));
        this.child("fdbDireccion").setValue(this.iface.calculateField("direccionprov"));
        this.child("fdbCodPostal").setValue(this.iface.calculateField("codpostalprov"));
        this.child("fdbIdPoblacion").setValue(this.iface.calculateField("idpoblacionprov"));
        this.child("fdbIdProvincia").setValue(this.iface.calculateField("idprovinciaprov"));
        this.iface.bloqueoProvincia = false;
      }
      break;
    }

    //    case "coddir": {
    //      this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
    //      break;
    //    }
  }
}

function oficial_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.setContent("<Parametros/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var nodoAux: FLDomNode;
  var eParametro: FLDomElement;

  eDatos = xmlParam.createElement("DatosParam");
  nodoParam.appendChild(eDatos);

  var numCopias: Number = parseInt(cursor.valueBuffer("numcopias"));
  if (isNaN(numCopias) || numCopias == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el número de copias a enviar"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("NumCopias", numCopias);

  var pesoUnidad: Number = parseFloat(cursor.valueBuffer("pesounidad"));
  if (isNaN(pesoUnidad) || pesoUnidad == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el peso por unidad de las copias a enviar"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("PesoUnidad", pesoUnidad);

  var peso: Number = parseFloat(cursor.valueBuffer("peso"));
  //  peso = util.roundFieldValue(peso, "paramenvio", "peso");
  if (isNaN(peso) || peso == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el peso de las copias a enviar"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("Peso", peso);
  eDatos.setAttribute("IdaYVuelta", cursor.valueBuffer("idayvuelta") ? "true" : "false");

  var direccion: String = cursor.valueBuffer("direccion");
  eDatos.setAttribute("Direccion", direccion);
  var poblacion: String = cursor.valueBuffer("ciudad");
  eDatos.setAttribute("Poblacion", poblacion);
  var idPoblacion: String = cursor.valueBuffer("idpoblacion");
  eDatos.setAttribute("IdPoblacion", idPoblacion);
  var provincia: String = cursor.valueBuffer("provincia");
  eDatos.setAttribute("Provincia", provincia);
  var idProvincia: String = cursor.valueBuffer("idprovincia");
  eDatos.setAttribute("IdProvincia", idProvincia);
  var codPais: String = cursor.valueBuffer("codpais");
  eDatos.setAttribute("CodPais", codPais);
  var Nombre: String = cursor.valueBuffer("codpais");
  eDatos.setAttribute("CodPais", codPais);

  var codAgencia: Number = cursor.valueBuffer("codagencia");
  if (codAgencia && codAgencia != "")
  {
    eDatos = xmlParam.createElement("AgenciaTransporteParam");
    nodoParam.appendChild(eDatos);
    eDatos.setAttribute("Valor", codAgencia);
  }

  return xmlParam;
}

function oficial_validarDatos(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  return true;
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil;
  var valor: String;

  switch (fN)
  {
    case "portes": {
      var peso: Number = cursor.valueBuffer("peso");
      var codAgencia: String = cursor.valueBuffer("codagencia");
      var idPoblacion: String = cursor.valueBuffer("idpoblacion");
      var idProvincia: String = cursor.valueBuffer("idprovincia");
      var codPais: String = cursor.valueBuffer("codpais");
      if (codAgencia && codAgencia != "") {
        valor = flfactppal.iface.pub_obtenerPortesAgencia(codAgencia, peso, idPoblacion, idProvincia, codPais);
      } else {
        var datosPortes: Array = flfactppal.iface.pub_obtenerPortesMinimos(peso, idPoblacion, idProvincia, codPais);
        if (!datosPortes) {
          valor = 0;
          break;
        }
        valor = datosPortes["portes"];
      }
      if (cursor.valueBuffer("idayvuelta")) {
        valor *= 2;
      }
      break;
    }
    case "codagencia": {
      var peso: Number = cursor.valueBuffer("peso");
      var codAgencia: String = cursor.valueBuffer("codagencia");
      var idPoblacion: String = cursor.valueBuffer("idpoblacion");
      var idProvincia: String = cursor.valueBuffer("idprovincia");
      var codPais: String = cursor.valueBuffer("codpais");

      var datosPortes: Array = flfactppal.iface.pub_obtenerPortesMinimos(peso, idPoblacion, idProvincia, codPais);
      if (!datosPortes) {
        valor = 0;
        break;
      }
      valor = datosPortes["codagencia"];
      break;
    }
    case "codcliente": {
      var idParamLibro: String = cursor.valueBuffer("idparamlibro");
      if (idParamLibro && cursor.valueBuffer("idparamlibro") != "") {
        valor = util.sqlSelect("paramlibro pl INNER JOIN lineaspresupuestoscli lp ON pl.idlinea = lp.idlinea INNER JOIN presupuestoscli p ON lp.idpresupuesto = p.idpresupuesto", "p.codcliente", "pl.id = " + idParamLibro, "paramlibro,lineaspresupuestoscli,presupuestoscli");
      } else {
        var idParamIptico: String = cursor.valueBuffer("idparamiptico");
        if (idParamIptico && cursor.valueBuffer("idparamiptico") != "") {
          valor = util.sqlSelect("paramiptico pi INNER JOIN lineaspresupuestoscli lp ON pi.idlinea = lp.idlinea INNER JOIN presupuestoscli p ON lp.idpresupuesto = p.idpresupuesto", "p.codcliente", "pi.id = " + idParamIptico, "paramiptico,lineaspresupuestoscli,presupuestoscli");
        } else {
          var idParamTaco: String = cursor.valueBuffer("idparamtaco");
          if (idParamTaco && cursor.valueBuffer("idparamtaco") != "") {
            valor = util.sqlSelect("paramtaco pt INNER JOIN lineaspresupuestoscli lp ON pt.idlinea = lp.idlinea INNER JOIN presupuestoscli p ON lp.idpresupuesto = p.idpresupuesto", "p.codcliente", "pt.id = " + idParamTaco, "paramiptico,lineaspresupuestoscli,presupuestoscli");
          }
        }
      }
      break;
    }
    case "peso": {
      valor = parseFloat(cursor.valueBuffer("numcopias")) * parseFloat(cursor.valueBuffer("pesounidad"));
      break;
    }
    case "pesounidad": {
      var idParamLibro: String = cursor.valueBuffer("idparamlibro");
      if (idParamLibro && idParamLibro != "") {
        var curLibro: FLSqlCursor = cursor.cursorRelation();
        if (!curLibro) {
          curLibro = new FLSqlCursor("paramlibro");
          curLibro.select("id = " + idParamLibro);
          if (!curLibro.first()) {
            return false;
          }
          curLibro.setModeAccess(curLibro.Browse);
          curLibro.refreshBuffer();
        }
        var altoTrabajo: Number = parseFloat(curLibro.valueBuffer("altocerrado"));
        var anchoTrabajo: Number = parseFloat(curLibro.valueBuffer("anchocerrado"));
        var gramaje: Number = parseInt(curLibro.valueBuffer("gramaje"));
        var gramajeTapa: Number = parseInt(curLibro.valueBuffer("gramajetapa"));
        var numPaginas: Number = parseInt(curLibro.valueBuffer("numpaginas"));
        valor = ((((altoTrabajo / 100) * (anchoTrabajo / 100)) * gramaje / 1000) * (numPaginas / 2)) + (((altoTrabajo / 100) * (anchoTrabajo / 100)) * gramajeTapa / 1000);
      } else {
        var idParamIptico: String = cursor.valueBuffer("idparamiptico");
        if (idParamIptico && idParamIptico != "") {
          var curIptico: FLSqlCursor = cursor.cursorRelation();
          if (!curIptico) {
            curIptico = new FLSqlCursor("paramiptico");
            curIptico.select("id = " + idParamIptico);
            if (!curIptico.first()) {
              return false;
            }
            curIptico.setModeAccess(curIptico.Edit);
            curIptico.refreshBuffer();
          }
          var altoTrabajo: Number = parseFloat(curIptico.valueBuffer("altot"));
          var anchoTrabajo: Number = parseFloat(curIptico.valueBuffer("anchot"));
          var gramaje: Number = parseInt(curIptico.valueBuffer("gramaje"));
          valor = ((altoTrabajo / 100) * (anchoTrabajo / 100)) * gramaje / 1000;
        } else {
          var idParamTaco: String = cursor.valueBuffer("idparamtaco");
          if (idParamTaco && idParamTaco != "") {
            var curTaco: FLSqlCursor = cursor.cursorRelation();
            if (!curTaco) {
              curTaco = new FLSqlCursor("paramtaco");
              curTaco.select("id = " + idParamTaco);
              if (!curTaco.first()) {
                return false;
              }
              curTaco.setModeAccess(curTaco.Edit);
              curTaco.refreshBuffer();
            }
            var altoTrabajo: Number = parseFloat(curTaco.valueBuffer("altot"));
            var anchoTrabajo: Number = parseFloat(curTaco.valueBuffer("anchot"));
            var gramaje: Number = parseInt(curTaco.valueBuffer("gramaje"));
            var pesoCapa: Number = ((altoTrabajo / 100) * (anchoTrabajo / 100)) * gramaje / 1000;
            var refPapel: String;
            valor = 0;
            for (var iPapel: Number = 0; iPapel < 5; iPapel++) {
              refPapel = curTaco.valueBuffer("papel" + iPapel.toString());
              if (refPapel && refPapel != "") {
                valor += parseFloat(pesoCapa);
              }
            }
            var refCarton: String = curTaco.valueBuffer("carton");
            if (refCarton && refCarton != "") {
              var gramajeCarton: Number = util.sqlSelect("articulos", "gramaje", "referencia = '" + refCarton + "'");
              if (!isNaN(gramajeCarton)) {
                var pesoCarton: Number = ((altoTrabajo / 100) * (anchoTrabajo / 100)) * gramajeCarton / 1000;
                valor += parseFloat(pesoCarton);
              }
            }
            var canTaco: Number = parseInt(curTaco.valueBuffer("cantaco"));
            valor = valor * canTaco;
          }
        }
      }
      break;
    }
    case "numcopias": {
      var idParamLibro: String = cursor.valueBuffer("idparamlibro");
      if (idParamLibro && idParamLibro != "") {
        var curLibro: FLSqlCursor = cursor.cursorRelation();
        if (!curLibro) {
          curLibro = new FLSqlCursor("paramlibro");
          curLibro.select("id = " + idParamLibro);
          if (!curLibro.first()) {
            return false;
          }
          curLibro.setModeAccess(curLibro.Browse);
          curLibro.refreshBuffer();
        }
        valor = curLibro.valueBuffer("numcopias");
      } else {
        var idParamIptico: String = cursor.valueBuffer("idparamiptico");
        if (idParamIptico && idParamIptico != "") {
          valor = parseInt(util.sqlSelect("paramcantidad", "total", "idparamiptico = " + idParamIptico));
        } else {
          var idParamTaco: String = cursor.valueBuffer("idparamtaco");
          if (idParamTaco && idParamTaco != "") {
            var curTaco: FLSqlCursor = cursor.cursorRelation();
            if (!curTaco) {
              curTaco = new FLSqlCursor("paramtaco");
              curTaco.select("id = " + idParamTaco);
              if (!curTaco.first()) {
                return false;
              }
              curTaco.setModeAccess(curTaco.Browse);
              curTaco.refreshBuffer();
            }
            valor = curTaco.valueBuffer("numcopias");
          }
        }
      }
      break;
    }
    case "nombredestinocli": {
      valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      break;
    }
    case "nombredestinoprov": {
      valor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
      break;
    }
    case "direccioncli": {
      valor = util.sqlSelect("dirclientes", "direccion", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domenvio = true");
      break;
    }
    case "direccionprov": {
      valor = util.sqlSelect("dirproveedores", "direccion", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");
      break;
    }
    case "codpostalcli": {
      valor = util.sqlSelect("dirclientes", "codpostal", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domenvio = true");
      break;
    }
    case "codpostalprov": {
      valor = util.sqlSelect("dirproveedores", "codpostal", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");
      break;
    }
    case "idprovinciacli": {
      valor = util.sqlSelect("dirclientes", "idprovincia", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domenvio = true");
      break;
    }
    case "idprovinciaprov": {
      valor = util.sqlSelect("dirproveedores", "idprovincia", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");
      break;
    }
    case "idpoblacioncli": {
      valor = util.sqlSelect("dirclientes", "idpoblacion", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domenvio = true");
      break;
    }
    case "idpoblacionprov": {
      valor = util.sqlSelect("dirproveedores", "idpoblacion", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");
      break;
    }
  }

  return valor;
}

function oficial_tbnDireccion_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object;
  var curDireccion: FLSqlCursor;
  var tabla: String = "";
  var filtro: String = "";
  var codCliente: String = cursor.valueBuffer("codcliente");
  if (codCliente && codCliente != "") {
    tabla = "dirclientes";
    filtro = "codcliente = '" + codCliente + "'";
  } else {
    var codProveedor: String = cursor.valueBuffer("codproveedor");
    if (codProveedor && codProveedor != "") {
      tabla = "dirproveedores";
      filtro = "codproveedor = '" + codProveedor + "'";
    }
  }
  if (tabla == "") {
    return;
  }
  var f: Object = new FLFormSearchDB(tabla);
  var curDirecciones: FLSqlCursor = f.cursor();
  curDirecciones.setMainFilter(filtro);

  f.setMainWidget();
  var idDir: String = f.exec("id");
  if (!idDir) {
    return;
  }
  //  curDirecciones.select("coddir = " + codDir);
  //  curDirecciones.first();
  this.child("fdbDireccion").setValue(curDirecciones.valueBuffer("direccion"));
  this.child("fdbIdPoblacion").setValue(curDirecciones.valueBuffer("idpoblacion"));
  this.child("fdbIdProvincia").setValue(curDirecciones.valueBuffer("idprovincia"));
  this.child("fdbCodPostal").setValue(curDirecciones.valueBuffer("codpostal"));
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////