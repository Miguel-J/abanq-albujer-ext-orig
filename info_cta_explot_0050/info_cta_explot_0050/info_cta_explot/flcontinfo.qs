
/** @class_declaration ctaExplotacion */
/////////////////////////////////////////////////////////////////
//// CTAEXPLOTACION //////////////////////////////////////////////////////
class ctaExplotacion extends oficial
{

  var totalesCE: Array;
  var valoresCE: Array;
  var valorProduccionCE: Array;

  var margenBrutoCE: Array;
  var margenIndustrialCE: Array;
  var margenContribucionCE: Array;
  var resultadoBrutoExpCE: Array;
  var resultadoNetoExpCE: Array;
  var beneficiosAntesdeImpuestos: Array;
  var beneficiosNetos: Array;

  function ctaExplotacion(context)
  {
    oficial(context);
  }
  function cabeceraCE(nodo: FLDomNode, campo: String): String {
    return this.ctx.ctaExplotacion_cabeceraCE(nodo, campo);
  }
  function valorCE(nodo: FLDomNode, campo: String): String {
    return this.ctx.ctaExplotacion_valorCE(nodo, campo);
  }
  function establecerDatos()
  {
    return this.ctx.ctaExplotacion_establecerDatos();
  }
  function cabeceraInformeCE(nodo: FLDomNode, campo: String): String {
    return this.ctx.ctaExplotacion_cabeceraInformeCE(nodo, campo);
  }
}
//// CTAEXPLOTACION //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubCtaExplotacion */
/////////////////////////////////////////////////////////////////
//// PUBCTAEXPLOTACION //////////////////////////////////////////////////////
class pubCtaExplotacion extends ctaExplotacion
{
  function pubCtaExplotacion(context)
  {
    ctaExplotacion(context);
  }
  function pub_cabeceraCE(nodo: FLDomNode, campo: String): String {
    return this.cabeceraCE(nodo, campo);
  }
  function pub_valorCE(nodo: FLDomNode, campo: String): String {
    return this.valorCE(nodo, campo);
  }
  function pub_establecerDatos()
  {
    return this.establecerDatos();
  }
  function pub_cabeceraInformeCE(nodo: FLDomNode, campo: String): String {
    return this.ctx.ctaExplotacion_cabeceraInformeCE(nodo, campo);
  }
}
//// PUBCTAEXPLOTACION //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctaExplotacion */
/////////////////////////////////////////////////////////////////
//// CTAEXPLOTACION //////////////////////////////////////////////////////

/** \D Guarda en un array los datos de la cuenta de explotación.
Utilizado para los campos especiales
\end */
function ctaExplotacion_establecerDatos()
{
  // Query para obtener las sumas
  var q = new FLSqlQuery();
  q.setTablesList("co_i_cuentaexp_buffer");
  q.setFrom("co_i_cuentaexp_buffer");

  this.iface.valoresCE = [];
  this.iface.totalesCE = [];
  this.iface.valorProduccionCE = [];
  this.iface.margenBrutoCE = [];
  this.iface.margenIndustrialCE = [];
  this.iface.margenContribucionCE = [];
  this.iface.resultadoBrutoExpCE = [];
  this.iface.resultadoNetoExpCE = [];
  this.iface.beneficiosAntesdeImpuestos = [];
  this.iface.beneficiosNetos = [];

  var codCuenta1: String, codCuenta2: String;

  //Sumas
  q.setSelect("codcuenta2,sumaact,sumaant,sumatot");
  q.exec();
  while (q.next()) {
    codCuenta2 = q.value(0).toString();
    this.iface.valoresCE[codCuenta2] = new Array(2);
    this.iface.valoresCE[codCuenta2][0] = q.value(1);
    this.iface.valoresCE[codCuenta2][1] = q.value(2);
    this.iface.valoresCE[codCuenta2][2] = q.value(3);
  }

  var ventasBrutas0: Number = 0;
  var ventasBrutas1: Number = 0;
  var ventasBrutas2: Number = 0;

  var devolucionesVentas0: Number = 0;
  var devolucionesVentas1: Number = 0;
  var devolucionesVentas2: Number = 0;

  var variacionExistencias0: Number = 0;
  var variacionExistencias1: Number = 0;
  var variacionExistencias2: Number = 0;


  //Totales
  q.setSelect("codcuenta1,sum(sumaact),sum(sumaant),sum(sumatot)");
  q.setWhere("1 = 1 GROUP BY codcuenta1");
  q.exec();
  while (q.next()) {
    codCuenta1 = q.value(0).toString();
    this.iface.totalesCE[codCuenta1] = new Array(2);
    this.iface.totalesCE[codCuenta1][0] = q.value(1);
    this.iface.totalesCE[codCuenta1][1] = q.value(2);
    this.iface.totalesCE[codCuenta1][2] = q.value(3);

    debug(codCuenta1 + " " + q.value(0));

    switch (codCuenta1) {
      case "VB":
        ventasBrutas0 = Math.abs(q.value(1));
        ventasBrutas1 = Math.abs(q.value(2));
        ventasBrutas2 = Math.abs(q.value(3));
        break;
      case "DV":
        devolucionesVentas0 = Math.abs(q.value(1));
        devolucionesVentas1 = Math.abs(q.value(2));
        devolucionesVentas2 = Math.abs(q.value(3));
        break;
      case "VE":
        variacionExistencias0 = Math.abs(q.value(1));
        variacionExistencias1 = Math.abs(q.value(2));
        variacionExistencias2 = Math.abs(q.value(3));
        break;
      case "AP":
        amortizacionesProviciones0 = Math.abs(q.value(1));
        amortizacionesProviciones1 = Math.abs(q.value(2));
        amortizacionesProviciones2 = Math.abs(q.value(3));
        break;
    }
  }

  // Valores de producción
  var ventasBrutas: Number, ventasNetas: Number;

  this.iface.valorProduccionCE[0] = ventasBrutas0 - devolucionesVentas0 + variacionExistencias0;
  this.iface.valorProduccionCE[1] = ventasBrutas1 - devolucionesVentas1 + variacionExistencias1;
  this.iface.valorProduccionCE[2] = ventasBrutas2 - devolucionesVentas2 + variacionExistencias2;


  // Popular porcentajes en la columna de total
  var cursor: FLSqlCursor = new FLSqlCursor("co_i_cuentaexp_buffer");
  cursor.select();
  while (cursor.next()) {
    cursor.setModeAccess(cursor.Edit);
    cursor.refreshBuffer();
    porTot = 0;
    if (this.iface.valorProduccionCE[2])
      porTot = cursor.valueBuffer("sumatot") * 100 / this.iface.valorProduccionCE[2];
    cursor.setValueBuffer("portot", porTot);
    cursor.commitBuffer();
  }
}

/** \D Devuelve el código de un ejercicio. Utilizado para los encabezados
@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Código del ejercicio
\end */
function ctaExplotacion_cabeceraCE(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var texCampo: String = new String(campo);
  var codEjercicio: String;

  switch (texCampo)
  {
    case "act":
      codEjercicio = this.iface.ejActPYG;
      break;
    case "ant":
      codEjercicio = this.iface.ejAntPYG;
      break;
    case "tot":
      codEjercicio = util.translate("scripts", "TOTAL");
      break;
  }

  return codEjercicio;
}

/** \D Obtiene un campo calculado para el informe
@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Resultado del cálculo
\end */
function ctaExplotacion_valorCE(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var result: String = "";

  var texCampo: String = new String(campo);
  var codCuenta1: String = nodo.attributeValue("buf.codcuenta1");
  var titulo: String = "";
  var funcion: Number, porSuma: Number, porFuncion: Number;
  var tipo: Number = 0;

  switch (texCampo)
  {
    case "suma":
    case "porsuma":
    case "funcion":
    case "porfuncion":
      tipo = 0;
      break;
    case "suma2":
    case "porsuma2":
    case "funcion2":
    case "porfuncion2":
      tipo = 1;
      break;
    case "sumatot":
    case "porsumatot":
    case "funciontot":
    case "porfunciontot":
      tipo = 2;
      break;
  }

  suma = this.iface.totalesCE[codCuenta1][tipo];

  switch (codCuenta1)
  {
    case "DV":
      funcion = this.iface.totalesCE["VB"][tipo] - this.iface.totalesCE[codCuenta1][tipo];
      break;
    case "VE":
      funcion = this.iface.valorProduccionCE[tipo];
      break;
    case "CM":
      //Quitamos rappel y dev de ventas
      suma = this.iface.totalesCE[codCuenta1][tipo] - 2 * this.iface.valoresCE["607"][tipo] - 2 * this.iface.valoresCE["608"][tipo] - 2 * this.iface.valoresCE["609"][tipo] - 2 * this.iface.valoresCE["651"][tipo];
      funcion = this.iface.valorProduccionCE[tipo] - suma;
      this.iface.margenBrutoCE[tipo] = funcion;
      break;
    case "CI":
      funcion = this.iface.margenBrutoCE[tipo] - this.iface.totalesCE[codCuenta1][tipo] - this.iface.totalesCE["CD"][tipo];
      this.iface.margenIndustrialCE[tipo] = funcion;
      break;
    case "CV":
      funcion = this.iface.margenIndustrialCE[tipo] - this.iface.totalesCE[codCuenta1][tipo];
      this.iface.margenContribucionCE[tipo] = funcion;
      break;
    case "GF":
      funcion = this.iface.margenContribucionCE[tipo] - this.iface.totalesCE[codCuenta1][tipo];
      this.iface.resultadoBrutoExpCE[tipo] = funcion;
      break;
    case "CF":
      //Quitamos ingresos financieros y diferencias de cambio
      suma = this.iface.totalesCE[codCuenta1][tipo] - 2 * this.iface.valoresCE["768"][tipo] - 2 * this.iface.valoresCE["769"][tipo];
      funcion = this.iface.resultadoBrutoExpCE[tipo] - suma;
      this.iface.resultadoNetoExpCE[tipo] = funcion;
      break;
    case "GIE":
      //Quitamos los gastos extraordinarios
      suma = this.iface.totalesCE[codCuenta1][tipo] - 2 * this.iface.valoresCE["678"][tipo];
      funcion = this.iface.resultadoNetoExpCE[tipo] - this.iface.valoresCE["678"][tipo] + this.iface.valoresCE["778"][tipo];
      this.iface.beneficiosAntesdeImpuestos[tipo] = funcion;
      break;
    case "IS":
      funcion = this.iface.beneficiosAntesdeImpuestos[tipo] - this.iface.totalesCE[codCuenta1][tipo];
      this.iface.beneficiosNetos[tipo] = funcion;
      break;
    case "AP":
      funcion = this.iface.beneficiosNetos[tipo] + this.iface.totalesCE[codCuenta1][tipo];
      break;
  }

  porSuma = suma * 100 / this.iface.valorProduccionCE[tipo];
  porFuncion = funcion * 100 / this.iface.valorProduccionCE[tipo];

  switch (texCampo)
  {
    case "titulo":
      titulo = util.sqlSelect("co_codcuentaexp1", "funcionpie", "codigo = '" + codCuenta1 + "'");
      result = titulo.upper();
      break;

    case "suma":
    case "suma2":
    case "sumatot":
      result = suma;
      break;

    case "porsuma":
    case "porsuma2":
    case "porsumatot":
      result = porSuma;
      break;

    case "funcion":
    case "funcion2":
    case "funciontot":
      result = funcion;
      break;

    case "porfuncion":
    case "porfuncion2":
    case "porfunciontot":
      result = porFuncion;
      break;
  }

  return result;
}

function ctaExplotacion_cabeceraInformeCE(nodo: FLDomNode, campo: String): String {
  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var ejAct: String, ejAnt: String;
  var fchDesde: String, fchHasta: String;
  var fchDesdeAnt: String, fchHastaAnt: String;

  var texto: String;
  var sep: String = "       ";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();

  qCondiciones.setTablesList(this.iface.nombreInformeActual);
  qCondiciones.setFrom(this.iface.nombreInformeActual);
  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (texCampo)
  {

    case "cuentaexp":

      qCondiciones.setSelect("descripcion,codejercicio,codejercicio2,fechadesde,fechahasta,fechadesde2,fechahasta2");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);
      ejAnt = qCondiciones.value(2);

      fchDesde = qCondiciones.value(3).toString().left(10);
      fchHasta = qCondiciones.value(4).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      texto = "[ " + desc + " ]" + sep +
      "Ejercicio " + ejAct +
      "  " + fchDesde + " - " + fchHasta;


      if (ejAnt) {
        fchDesde2 = qCondiciones.value(5).toString().left(10);
        fchHasta2 = qCondiciones.value(6).toString().left(10);
        fchDesde2 = util.dateAMDtoDMA(fchDesde2);
        fchHasta2 = util.dateAMDtoDMA(fchHasta2);

        texto += sep + "Ejercicio " + ejAnt +
        "  " + fchDesde2 + " - " + fchHasta2;
      }

      break;
  }

  return texto;
}

//// CTAEXPLOTACION //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
