/***************************************************************************
                 co_masterlibroscontables.qs  -  description
                             -------------------
    begin                : mie may 20 2009
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var xbrlDoc_: FLDomDocument;
  function oficial(context)
  {
    interna(context);
  }
  function tbnRecalcular_clicked()
  {
    return this.ctx.oficial_tbnRecalcular_clicked();
  }
  function crearAcumuladosLibros(): Boolean {
    return this.ctx.oficial_crearAcumuladosLibros();
  }
  function tbnGuardar_clicked()
  {
    return this.ctx.oficial_tbnGuardar_clicked();
  }
  function establecerContexto(tipoDoc: String, ejercicio: String): Boolean {
    return this.ctx.oficial_establecerContexto(tipoDoc, ejercicio);
  }
  function establecerDivisa(): Boolean {
    return this.ctx.oficial_establecerDivisa();
  }
  function establecerValores(): Boolean {
    return this.ctx.oficial_establecerValores();
  }
  function establecerNameSpaces(): Boolean {
    return this.ctx.oficial_establecerNameSpaces();
  }
  function establecerSchemaRef(): Boolean {
    return this.ctx.oficial_establecerSchemaRef();
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
function interna_init()
{
  debug("interna_init");
  connect(this.child("tbnRecalcular"), "clicked()", this, "iface.tbnRecalcular_clicked()");
  connect(this.child("tbnGuardar"), "clicked()", this, "iface.tbnGuardar_clicked()");

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_tbnRecalcular_clicked()
{
  var util: FLUtil = new FLUtil();

  var curCodBalance: FLSqlCursor = new FLSqlCursor("co_codbalances08");
  curCodBalance.select("1 = 1");
  while (curCodBalance.next()) {
    curCodBalance.setModeAccess(curCodBalance.Edit);
    curCodBalance.refreshBuffer();
    curCodBalance.setValueBuffer("codcompleto1", formRecordco_codbalances08.iface.pub_commonCalculateField("codcompleto1", curCodBalance));
    curCodBalance.setValueBuffer("codcompleto2", formRecordco_codbalances08.iface.pub_commonCalculateField("codcompleto2", curCodBalance));
    curCodBalance.setValueBuffer("codcompleto3", formRecordco_codbalances08.iface.pub_commonCalculateField("codcompleto3", curCodBalance));
    if (!curCodBalance.commitBuffer()) {
      return false;
    }
  }
  MessageBox.information(util.translate("scripts", "Códigos de balance 08 actualizados"), MessageBox.Ok, MessageBox.NoButton);

  this.iface.crearAcumuladosLibros();
}

function oficial_crearAcumuladosLibros(): Boolean {
  var util: FLUtil = new FLUtil;

  var nodosXbrl: Array = [
    ["A", "0", "pgc-07-c-bs:TotalActivo"],
    ["A-A", "1", "pgc-07-c-bs:ActivoNoCorriente"],
    ["A-A--I", "3", "pgc-07-c-bs:ActivoNoCorrienteInmovilizadoIntangible"],
    ["A-A--I-1", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleDesarrollo"],
    //pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleInvestigacion
    ["A-A--I-2", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleConcesiones"],
    ["A-A--I-3", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangiblePatentesLicenciasMarcasSimilares"],
    ["A-A--I-4", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleFondoComercio"],
    ["A-A--I-5", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleAplicacionesInformaticas"],
    ["A-A--I-6", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoIntangibleOtro"],
    ["A-A--II", "3", "pgc-07-c-bs:ActivoNoCorrienteInmovilizadoMaterial"],
    ["A-A--II-1", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoMaterialTerrenosConstrucciones"],
    ["A-A--II-2", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoMaterialInstalacionesTecnicasMaquinariaUtilajeMobiliarioOtro"],
    ["A-A--II-3", "4", "pgc-07-n:ActivoNoCorrienteInmovilizadoMaterialInmovilizadoEnCursoAnticipos"],
    ["A-A--III", "3", "pgc-07-c-bs:ActivoNoCorrienteInversionesInmobiliarias"],
    ["A-A--III-1", "4", "pgc-07-n:ActivoNoCorrienteInversionesInmobiliariasTerrenos"],
    ["A-A--III-2", "4", "pgc-07-n:ActivoNoCorrienteInversionesInmobiliariasConstrucciones"],
    ["A-A--IV", "3", "pgc-07-c-bs:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazo"],
    ["A-A--IV-1", "4", "pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoInstrumentosPatrimonio"],
    ["A-A--IV-2", "4", "pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoCreditosEmpresas"],
    ["A-A--IV-3", "4", "pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoValoresRepresentativosDeuda"],
    ["A-A--IV-4", "4", "pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoDerivados"],
    ["A-A--IV-5", "4", "pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoOtrosActivosFinancieros"],
    //pgc-07-n:ActivoNoCorrienteInversionesEmpresasGrupoEmpresasAsociadasLargoPlazoOtrasInversiones
    ["A-A--V", "3", "pgc-07-c-bs:ActivoNoCorrienteInversionesFinancierasLargoPlazo"],
    ["A-A--V-1", "4", "pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoInstrumentosPatrimonio"],
    ["A-A--V-2", "4", "pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoCreditosEmpresas"],
    ["A-A--V-3", "4", "pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoValoresRepresentativosDeuda"],
    ["A-A--V-4", "4", "pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoDerivados"],
    ["A-A--V-5", "4", "pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoOtrosActivosFinancieros"],
    //pgc-07-n:ActivoNoCorrienteInversionesFinancierasLargoPlazoOtrasInversiones
    ["A-A--VI", "3", "pgc-07-c-bs:ActivoNoCorrienteActivosImpuestoDiferido"],
    //ActivoNoCorrienteDeudasComercialesNoCorriente

    ["A-B", "1", "pgc-07-c-bs:ActivoCorriente"],
    ["A-B--I", "3", "pgc-07-c-na:ActivoCorrienteActivosNoCorrientesMantenidosParaVenta"],
    ["A-B--II", "3", "pgc-07-c-bs:ActivoCorrienteExistencias"],
    ["A-B--II-1", "4", "pgc-07-n:ActivoCorrienteExistenciasComerciales"],
    ["A-B--II-2", "4", "pgc-07-n:ActivoCorrienteExistenciasMateriasPrimasOtrosAprovisionamientos"],
    ["A-B--II-3", "4", "pgc-07-n:ActivoCorrienteExistenciasProductosCurso"],
    //pgc-07-n:ActivoCorrienteExistenciasProductosCursoCicloCorto
    //pgc-07-n:ActivoCorrienteExistenciasProductosCursoCicloLargo
    ["A-B--II-4", "4", "pgc-07-n:ActivoCorrienteExistenciasProductosTerminados"],
    //pgc-07-n:ActivoCorrienteExistenciasProductosTerminadosCicloLargo
    //pgc-07-n:ActivoCorrienteExistenciasProductosTerminadosCicloCorto
    ["A-B--II-5", "4", "pgc-07-n:ActivoCorrienteExistenciasSubproductosResiduosMaterialesRecuperados"],
    ["A-B--II-6", "4", "pgc-07-n:ActivoCorrienteExistenciasAnticiposProveedores"],
    ["A-B--III", "3", "pgc-07-c-bs:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrar"],
    ["A-B--III-1", "4", "pgc-07-c-bs:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarClientesVentasPrestacionesServicios"],
    //pgc-07-c-bs:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarClientesVentasPrestacionesServiciosLargoPlazo
    //pgc-07-c-bs:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarClientesVentasPrestacionesServiciosCortoPlazo
    ["A-B--III-2", "4", "pgc-07-n:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarClientesEmpresasGrupoAsociadas"],
    ["A-B--III-3", "4", "pgc-07-c-ap:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarOtrosDeudores"],
    ["A-B--III-4", "4", "pgc-07-n:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarPersonal"],
    ["A-B--III-5", "4", "pgc-07-n:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarActivosImpuestoCorriente"],
    ["A-B--III-6", "4", "pgc-07-n:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarOtrosCreditosAdministracionesPublicas"],
    ["A-B--III-7", "4", "pgc-07-c-bs:ActivoCorrienteDeudoresComercialesOtrasCuentasCobrarAccionistasDesembolsosExigidos"],
    ["A-B--IV", "3", "pgc-07-c-bs:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazo"],
    ["A-B--IV-1", "4", "pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoInstrumentosPatrimonio"],
    ["A-B--IV-2", "4", "pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoCreditosEmpresas"],
    ["A-B--IV-3", "4", "pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoValoresRepresentativosDeuda"],
    ["A-B--IV-4", "4", "pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoDerivados"],
    ["A-B--IV-5", "4", "pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoOtrosActivosFinancieros"],
    //pgc-07-n:ActivoCorrienteInversionesEmpresasGrupoEmpresasAsociadasCortoPlazoOtrasInversiones
    ["A-B--V", "3", "pgc-07-c-bs:ActivoCorrienteInversionesFinancierasCortoPlazo"],
    ["A-B--V-1", "4", "pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoInstrumentosPatrimonio"],
    ["A-B--V-2", "4", "pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoCreditosEmpresas"],
    ["A-B--V-3", "4", "pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoValoresRepresentativosDeuda"],
    ["A-B--V-4", "4", "pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoDerivados"],
    ["A-B--V-5", "4", "pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoOtrosActivosFinancieros"],
    //pgc-07-n:ActivoCorrienteInversionesFinancierasCortoPlazoOtrasInversiones
    ["A-B--VI", "3", "pgc-07-c-bs:ActivoCorrientePeriodificacionesCortoPlazo"],
    ["A-B--VII", "3", "pgc-07-c-bs:ActivoCorrienteEfectivoOtrosActivosLiquidosEquivalentes"],
    ["A-B--VII-1", "4", "pgc-07-n:ActivoCorrienteEfectivoOtrosActivosLiquidosEquivalentesTesoreria"],
    ["A-B--VII-2", "4", "pgc-07-n:ActivoCorrienteEfectivoOtrosActivosLiquidosEquivalentesOtrosActivosLiquidosEquivalentes"],


    ["P", "0", "pgc-07-c-bs:PatrimonioNetoPasivoTotal"],
    ["P-A", "1", "pgc-07-c-bs:PatrimonioNeto"],
    ["P-A-1", "2", "pgc-07-c-bs:PatrimonioNetoFondosPropios"],
    ["P-A-1-I", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosCapital"],
    ["P-A-1-I-1", "4", "pgc-07-c-bs:PatrimonioNetoFondosPropiosCapitalEscriturado"],
    ["P-A-1-I-2", "4", "pgc-07-c-bs:PatrimonioNetoFondosPropiosCapitalNoExigido"],
    ["P-A-1-II", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosPrimaEmision"],
    ["P-A-1-III", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosReservas"],
    ["P-A-1-III-1", "4", "pgc-07-n:PatrimonioNetoFondosPropiosReservasLegalEstatutarias"],
    ["P-A-1-III-2", "4", "pgc-07-n:PatrimonioNetoFondosPropiosReservasOtrasReservas"],
    ["P-A-1-IV", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosAccionesParticipacionesPatrimonioPropias"],
    ["P-A-1-V", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosResultadosEjerciciosAnteriores"],
    ["P-A-1-V-1", "4", "pgc-07-n:PatrimonioNetoFondosPropiosResultadosEjerciciosAnterioresRemanente"],
    ["P-A-1-V-2", "4", "pgc-07-n:PatrimonioNetoFondosPropiosResultadosEjerciciosAnterioresResultadosNegativosEjerciciosAnteriores"],
    ["P-A-1-VI", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosOtrasAportacionesSocios"],
    ["P-A-1-VII", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosResultadoEjercicio"],
    ["P-A-1-VIII", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosDividendoCuenta"],
    ["P-A-1-IX", "3", "pgc-07-c-bs:PatrimonioNetoFondosPropiosOtrosInstrumentosPatrimonioNeto"],
    ["P-A-2", "2", "pgc-07-c-bs:PatrimonioNetoAjustesCambioValor"],
    ["P-A-2-I", "3", "pgc-07-n:PatrimonioNetoAjustesCambioValorActivosFinancierosDisponiblesVenta"],
    ["P-A-2-II", "3", "pgc-07-n:PatrimonioNetoAjustesCambioValorOperacionesCobertura"],
    ["P-A-2-III", "3", "pgc-07-n:PatrimonioNetoAjustesCambioValorOtros"],
    //pgc-07-n:PatrimonioNetoAjustesCambioValorActivosNoCorrientesPasivosVinculadosMantenidosVenta
    //pgc-07-n:PatrimonioNetoAjustesCambioValorDiferenciaConversion
    ["P-A-3", "2", "pgc-07-c-bs:PatrimonioNetoSubvencionesDonacionesLegadosRecibidos"],

    ["P-B", "1", "pgc-07-c-bs:PasivoNoCorriente"],
    ["P-B--I", "3", "pgc-07-c-bs:PasivoNoCorrienteProvisionesLargoPlazo"],
    ["P-B--I-1", "4", "pgc-07-n:PasivoNoCorrienteProvisionesLargoPlazoObligacionesPrestacionesPersonalLargoPlazo"],
    ["P-B--I-2", "4", "pgc-07-n:PasivoNoCorrienteProvisionesLargoPlazoActuacionesMedioAmbientales"],
    ["P-B--I-3", "4", "pgc-07-n:PasivoNoCorrienteProvisionesLargoPlazoProvisionesReestructuracion"],
    ["P-B--I-4", "4", "pgc-07-n:PasivoNoCorrienteProvisionesLargoPlazoOtrasProvisiones"],
    ["P-B--II", "3", "pgc-07-c-bs:PasivoNoCorrienteDeudasLargoPlazo"],
    ["P-B--II-1", "4", "pgc-07-n:PasivoNoCorrienteDeudasLargoPlazoObligacionesOtrosValoresNegociables"],
    ["P-B--II-2", "4", "pgc-07-c-bs:PasivoNoCorrienteDeudasLargoPlazoDeudasEntidadesCredito"],
    ["P-B--II-3", "4", "pgc-07-c-bs:PasivoNoCorrienteDeudasLargoPlazoAcreedoresArrendamientoFinanciero"],
    ["P-B--II-4", "4", "pgc-07-n:PasivoNoCorrienteDeudasLargoPlazoDerivados"],
    ["P-B--II-5", "4", "pgc-07-n:PasivoNoCorrienteDeudasLargoPlazoOtrosPasivosFinancieros"],
    //["", "", "pgc-07-c-bs:PasivoNoCorrienteDeudaCaracteristicasEspecialesLargoPlazo"],
    ["P-B--III", "3", "pgc-07-c-bs:PasivoNoCorrienteDeudasEmpresasGrupoEmpresasAsociadasLargoPlazo"],
    ["P-B--IV", "3", "pgc-07-c-bs:PasivoNoCorrientePasivosImpuestoDiferido"],
    ["P-B--V", "3", "pgc-07-c-bs:PasivoNoCorrientePeriodificacionesLargoPlazo"],
    //PasivoNoCorrienteAcreedoresComercialesNoCorrientes

    ["P-C", "1", "pgc-07-c-bs:PasivoCorriente"],
    ["P-C--I", "3", "pgc-07-c-na:PasivoCorrientePasivosVinculadosActivosNoCorrientesMantenidosVenta"],
    ["P-C--II", "3", "pgc-07-c-bs:PasivoCorrienteProvisionesCortoPlazo"],
    ["P-C--III", "3", "pgc-07-c-bs:PasivoCorrienteDeudasCortoPlazo"],
    ["P-C--III-1", "4", "pgc-07-n:PasivoCorrienteDeudasCortoPlazoObligacionesOtrosValoresNegociables"],
    ["P-C--III-2", "4", "pgc-07-c-bs:PasivoCorrienteDeudasCortoPlazoDeudasEntidadesCredito"],
    ["P-C--III-3", "4", "pgc-07-c-bs:PasivoCorrienteDeudasCortoPlazoAcreedoresArrendamientoFinanciero"],
    ["P-C--III-4", "4", "pgc-07-n:PasivoCorrienteDeudasCortoPlazoObligacionesDerivados"],
    ["P-C--III-5", "4", "pgc-07-n:PasivoCorrienteDeudasCortoPlazoObligacionesOtrosPasivosFinancieros"],
    //["", "", "pgc-07-c-bs:PasivoCorrienteDeudasCaracteristicasEspecialesCortoPlazo"],
    ["P-C--IV", "3", "pgc-07-c-bs:PasivoCorrienteDeudasEmpresasGrupoEmpresasAsociadas"],
    ["P-C--V", "3", "pgc-07-c-bs:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagar"],
    ["P-C--V-1", "4", "pgc-07-c-bs:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarProveedores"],
    ["P-C--V-2", "4", "pgc-07-n:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarProveedoresEmpresasGrupoAsociadas"],
    ["P-C--V-3", "4", "pgc-07-c-ap:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarOtrosAcreedores"],
    ["P-C--V-4", "4", "pgc-07-n:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarPersonalRemuneracionesPendientesPago"],
    ["P-C--V-5", "4", "pgc-07-n:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarPasivoImpuestoCorriente"],
    ["P-C--V-6", "4", "pgc-07-n:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarOtrasDeudasAdministracionesPublicas"],
    ["P-C--V-7", "4", "pgc-07-n:PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarAnticiposClientes"],
    //pgc-07-c-bs_PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarProveedoresLargoPlazo
    //pgc-07-c-bs_PasivoCorrienteAcreedoresComercialesOtrasCuentasPagarProveedoresCortoPlazo
    ["P-C--VI", "3", "pgc-07-c-bs:PasivoCorrientePeriodificacionesCortoPlazo"],


    ["PG", "0", "pgc-07-c-bs:PerdidasGananciasResultadoEjercicio"],
    //pgc-07-c-na:PerdidasGananciasResultadoEjercicioProcedenteOperacionesContinuadas
    ["PG-A", "1", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadas"],
    ["PG-A-1", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasImporteNetoCifraNegocios"],
    ["PG-A-1-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasImporteNetoCifraNegociosVentas"],
    ["PG-A-1-b", "3", "pgc-07-n:GananciasOperacionesContinuadasImporteNetoCifraNegociosPrestacionesServicios"],
    ["PG-A-2", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasVariacionExistenciasProductosTerminadosProductosCursoFabricacion"],
    ["PG-A-3", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasTrabajosRealizadosEmpresaActivo"],
    ["PG-A-4", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasAprovisionamientos"],
    ["PG-A-4-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasAprovisionamientosConsumoMercaderias"],
    ["PG-A-4-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasAprovisionamientosConsumoMateriasPrimasOtrasMateriasConsumibles"],
    ["PG-A-4-c", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasAprovisionamientosTrabajosRealizadosOtrasEmpresas"],
    ["PG-A-4-d", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasAprovisionamientosDeterioroMercaderiasMateriasPrimasOtrosAprovisionamientos"],
    ["PG-A-5", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasOtrosIngresosExplotacion"],
    ["PG-A-5-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosIngresosExplotacionIngresosAccesoriosIngresosOtrosGestionCorriente"],
    ["PG-A-5-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosIngresosExplotacionSubvencionesExplotacionIncorporadasResultadoEjercicio"],
    ["PG-A-6", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasGestionPersonal"],
    ["PG-A-6-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGestionPersonalSueldosSalariosAsimilados"],
    ["PG-A-6-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGestionPersonalCargasSociales"],
    ["PG-A-6-c", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGestionPersonalProvisiones"],
    ["PG-A-7", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasOtrosGastosExplotacion"],
    ["PG-A-7-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosGastosExplotacionServiciosExteriores"],
    ["PG-A-7-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosGastosExplotacionTributos"],
    ["PG-A-7-c", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosGastosExplotacionPerdidasDeterioroVariacionProvisionesOperacionesComerciales"],
    ["PG-A-7-d", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasOtrosGastosExplotacionOtrosGastosGestionCorriente"],
    ["PG-A-8", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasAmortizacionInmovilizado"],
    ["PG-A-9", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasImputacionSubvencionesInmovilizadoNoFinancieroOtras"],
    ["PG-A-10", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasExcesosProvisiones"],
    ["PG-A-11", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInmovilizado"],
    ["PG-A-11-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInmovilizadoDeterioroPerdidas"],
    ["PG-A-11-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInmovilizadoResultadosEnajenacionesOtras"],
    //["", "", "pgc-07-c-bs:PerdidasGananciasResultadoExplotacion"],
    ["PG-A-12", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasIngresosFinancieros"],
    ["PG-A-12-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosParticipacionesInstrumentosPatrimonio"],
    ["PG-A-12-a-1", "4", "pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosParticipacionesInstrumentosPatrimonioEmpresasGrupoEmpresasAsociadas"],
    ["PG-A-12-a-2", "4", "pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosParticipacionesInstrumentosPatrimonioTerceros"],
    ["PG-A-12-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosValoresNegociablesOtrosInstrumentosFinancieros"],
    //pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosValoresNegociablesCreditosActivoInmovilizadoEmpresasGrupoEmpresasAsociadas
    //pgc-07-n:PerdidasGananciasOperacionesContinuadasIngresosFinancierosValoresNegociablesCreditosActivoInmovilizadoTerceros
    //pgc-07-c-ap:PerdidasGananciasOperacionesContinuadasIngresosFinancierosOtrosIngresosFinancieros
    //["PG-A-12-b", "3", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasIngresosFinancierosImputacionSubvencionesDonacionesLegadosCaracterFinanciero"],
    ["PG-A-13", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasGastosFinancieros"],
    ["PG-A-13-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGastosFinancierosDeudasEmpresasGrupoEmpresasAsociadas"],
    ["PG-A-13-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGastosFinancierosDeudasTerceros"],
    ["PG-A-13-c", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasGastosFinancierosActualizacionProvisiones"],
    ["PG-A-14", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasVariacionValorRazonableInstrumentosFinancieros"],
    ["PG-A-14-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasVariacionValorRazonableInstrumentosFinancierosCarteraNegociacionOtros"],
    ["PG-A-14-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasVariacionValorRazonableInstrumentosFinancierosImputacionResultadoEjercicioActivosFinancierosDisponiblesVenta"],
    ["PG-A-15", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasDiferenciasCambio"],
    ["PG-A-16", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInstrumentosFinancieros"],
    ["PG-A-16-a", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInstrumentosFinancierosDeteriorosPerdidas"],
    ["PG-A-16-b", "3", "pgc-07-n:PerdidasGananciasOperacionesContinuadasDeterioroResultadoEnajenacionesInstrumentosFinancierosResultadoEnajenacionesOtras"],
    ["PG-A-17", "2", "pgc-07-c-bs:PerdidasGananciasOperacionesContinuadasImpuestosSobreBeneficios"],
    //["", "", "pgc-07-c-bs:PerdidasGananciasResultadoFinanciero"],
    //["", "", "pgc-07-c-bs:PerdidasGananciasResultadoAntesImpuestos"],
    //pgc-07-c-bs_PerdidasGananciasOtrosResultados
    //pgc-07-c-na:PerdidasGananciasOperacionesContinuadasDiferenciaNegativaCombinacionesNegocios

    ["PG-B", "1", "pgc-07-n:PerdidasGananciasOperacionesInterrumpidas"],
    ["PG-B-18", "2", "pgc-07-n:PerdidasGananciasResultadoEjercicioProcedenteOperacionesInterrumpidas"],


    ["IG", "0", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosResultadoCuentaPerdidasGanancias"],
    //CambiosPatrimonioNetoIngresosGastosReconocidosTotal
    //pgc-07-c-bs_CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNeto
    ["IG-A", "1", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoTotal"],
    ["IG-A--I", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoValoracionInstrumentosFinancieros"],
    ["IG-A--I-1", "4", "pgc-07-n:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoValoracionInstrumentosFinancierosActivosFinancierosDisponiblesVenta"],
    ["IG-A--I-2", "4", "pgc-07-n:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoValoracionInstrumentosFinancierosOtrosIngresosOtrosGastos"],
    //["", "", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoActivosNoCorrientesPasivosVinculadosMantenidosParaVenta"],
    ["IG-A--II", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoCoberturasFlujosEfectivos"],
    ["IG-A--III", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoSubvencionesDonacionesLegados"],
    ["IG-A--IV", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoGanaciasPerdidasActuarialesOtrosAjustes"],
    ["IG-A--V", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoEfectoImpositivo"],
    //CambiosPatrimonioNetoIngresosGastosReconocidosIngresosGastosImputadosDirectamentePatrimonioNetoDiferenciasConversion

    ["IG-B", "1", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasTotal"],
    //pgc-07-c-bs_CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGanancias
    ["IG-B--VI", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasValoracionInstrumentosFinancieros"],
    ["IG-B--VI-1", "4", "pgc-07-n:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasValoracionInstrumentosFinancierosActivosFinancierosDisponiblesVenta"],
    ["IG-B--VI-2", "4", "pgc-07-n:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasValoracionInstrumentosFinancierosOtrosIngresosOtrosGastos"],
    //["IG-B--VI-1", "4", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasActivosNoCorrientesPasivosVinculadosMantenidosVenta"],
    ["IG-B--VII", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasCoberturasFlujosEfectivo"],
    ["IG-B--VIII", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasSubvencionesDonacionesLegadosRecibidos"],
    ["IG-B--IX", "3", "pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasEfectoImpositivo"]];
  //CambiosPatrimonioNetoIngresosGastosReconocidosTransferenciasCuentaPerdidasGananciasDiferenciasConversion

  //pgc-07-c-bs:BalanceSituacionVariable
  //pgc-07-c-bs:BalanceSituacionPresentacion
  //pgc-07-c-bs:ActivoPresentacion
  //pgc-07-c-bs:PatrimonioNetoPasivoPresentacion
  //pgc-07-c-bs:PerdidasGananciasPresentacion
  //pgc-07-c-bs:CambiosPatrimonioNetoPresentacion
  //pgc-07-c-bs:CambiosPatrimonioNetoIngresosGastosReconocidosPresentacion
  //pgc-07-n:PerdidasGananciasOperacionesContinuadasPresentacion

  //pgc-07-n-fe:EstadoFlujosEfectivoPresentacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionPresentacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionResultadoAntesImpuestos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultado
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoAmortizacionInmovilizado
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoCorreccionesValorativasDeterioro
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoVariacionProvisiones
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoImputacionSubvenciones
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoResultadosBajasEnajenacionesInmovilizado
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoResultadosBajasEnajenacionesInstrumentosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoIngresosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoGastosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoDiferenciasCambio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoVariacionvalorRazonableInstrumentosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionAjustesResultadoOtrosIngresosGastos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalCorriente
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalCorrienteExistencias
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalDeudores
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalOtrosActivosCorrientes
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalCorrienteAcreedores
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalCorrienteOtrosPasivosCorrientes
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionCambiosCapitalCorrienteOtrosActivosPasivosNoCorrientes
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacionPagoIntereses
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacionCobrosDividendos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacionCobrosIntereses
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacionCobrosImpuestosBeneficios
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionOtrosFlujosEfectivoActividadesExplotacionOtrosPagos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesExplotacionFlujosEfectivoActividadesExplotacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversiones
  //pgc-07-n-fe:EstadEstadoFlujosEfectivoActividadesInversionPagoInversionesEmpresasGrupoEmpresasAsociadas
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesInmovilizadoIntangible
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesInmovilizadoMaterial
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesInversionesInmobilizarias
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesOtrosActivosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesActivosNoCorrientesMantenidosVenta
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesUnidadNegocio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionPagoInversionesOtrosActivos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversiones
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesEmpresasGrupoEmpresasAsociadas
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesInmovilizadoIntangible
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesInmovilizadoMaterial
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesInversionesInmobiliarias
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesOtrosActivosFinancieros
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesActivosNoCorrientesMantenidosVenta
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesUnidadNegocio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesOtrosActivos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesInversionCobrosDesinversionesFlujosEfectivoActividadesInversion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionPresentacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonioEmisionInstrumentosPatrimonio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonioAmortizacionInstrumentosPatrimonio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonioAdquisicionInstrumentosPatrimonioPropio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonioEnajecaionInstrumentosPatrimonioPropio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPatrimonioSubvencionesDonancionesLegados
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinanciero
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmision
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmisionOblifacionesOtrosValoresNegociables
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmisionDeudasEntidadesCredito
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmisionDeudasEmpresasGrupoAsociadas
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmisionDeudasCaracteristicasEspeciales
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroEmisionOtrasDeudas
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacionObligaciones
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacionDeudasEntidadesCredito
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacionDeudasEmpresasGrupo
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacionDeudasCaracteristicasEspeciales
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionCobrosPagosInstrumentosPasivoFinancieroDevolucionAmortizacionOtrasDeudas
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionPagosDividendosRemuneracionesOtrosInstrumentosPatrimonio
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionPagosDividendosRemuneracionesOtrosInstrumentosPatrimonioDividendos
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionPagosDividendosRemuneracionesOtrosInstrumentosPatrimonioRemuneracion
  //pgc-07-n-fe:EstadoFlujosEfectivoActividadesFinanciacionFlujosEfectivoActividadesFinanciacion
  //pgc-07-n-fe:EstadoFlujosEfectivoEfectoVariacionesTiposCambio
  //pgc-07-n-fe:EstadoFlujosEfectivoAumentoDisminucionEfectivoEquivalentes
  //pgc-07-n-fe:EstadoFlujosEfectivoEfectivoEquivalentesComienzoEjercicio
  //pgc-07-n-fe_EstadoFlujosEfectivoEfectivoEquivalentesFinalEjercicio




  if (!util.sqlDelete("co_xbrlbalances08", "1 = 1"))
  {
    return false;
  }
  var curXbrl: FLSqlCursor = new FLSqlCursor("co_xbrlbalances08");
  for (var i: Number = 0; i < nodosXbrl.length; i++)
  {
    curXbrl.setModeAccess(curXbrl.Insert);
    curXbrl.refreshBuffer()
    curXbrl.setValueBuffer("codbalance", nodosXbrl[i][0]);
    curXbrl.setValueBuffer("nivel", nodosXbrl[i][1]);
    curXbrl.setValueBuffer("nodoxbrl", nodosXbrl[i][2]);
    if (!curXbrl.commitBuffer()) {
      return false;
    }
  }
}

function oficial_tbnGuardar_clicked()
{
  var util: FLUtil = new FLUtil();

  if (this.iface.xbrlDoc_) {
    delete this.iface.xbrlDoc_;
  }
  this.iface.xbrlDoc_ = new FLDomDocument;
  this.iface.xbrlDoc_.setContent("<xbrli:xbrl/>");

  this.iface.establecerNameSpaces();
  this.iface.establecerSchemaRef();
  this.iface.establecerContexto("Balance", "Actual");
  this.iface.establecerContexto("Balance", "Anterior");
  this.iface.establecerContexto("PYG", "Actual");
  this.iface.establecerContexto("PYG", "Anterior");
  this.iface.establecerDivisa();
  this.iface.establecerValores();

  var datos: String = this.iface.xbrlDoc_.toString(4);
  debug(datos);

  var fichero: String = FileDialog.getSaveFileName("*.*");
  if (!fichero) {
    return;
  }

  File.write(fichero, datos);
  MessageBox.information(util.translate("scripts", "El fichero %1 se guardó correctamente").arg(fichero), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_establecerContexto(tipoDoc: String, ejercicio: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  var anno: String;
  var fechaDesde: String;
  var fechaHasta: String;
  var codEjercicio: String;
  if (ejercicio == "Actual")
  {
    codEjercicio = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
    fechaDesde = cursor.valueBuffer("d_co__asientos_fechaact")
    fechaHasta = cursor.valueBuffer("h_co__asientos_fechaact")
  } else {
    codEjercicio = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
    fechaDesde = cursor.valueBuffer("d_co__asientos_fechaant")
    fechaHasta = cursor.valueBuffer("h_co__asientos_fechaant")
  }
  if (!codEjercicio || codEjercicio == "")
  {
    return true;
  }
  anno = fechaDesde.getYear();

  var eContexto: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:context");
  this.iface.xbrlDoc_.firstChild().appendChild(eContexto);
  eContexto.setAttribute("id", "Y1_" + anno + "_" + tipoDoc);

  var eEntidad: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:entity");
  eContexto.appendChild(eEntidad);

  var eIdentificador: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:identifier");
  eEntidad.appendChild(eIdentificador);

  var tNombre: FLDomText = this.iface.xbrlDoc_.createTextNode(flfactppal.iface.pub_valorDefectoEmpresa("nombre"));
  eIdentificador.appendChild(tNombre);

  var ePeriodo: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:period");
  eContexto.appendChild(ePeriodo);

  switch (tipoDoc)
  {
    case "Balance": {
      var eInstante: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:instant");
      ePeriodo.appendChild(eInstante);

      var tInstante: FLDomText = this.iface.xbrlDoc_.createTextNode(fechaHasta.toString().left(10));
      eInstante.appendChild(tInstante);
      break;
    }
    case "PYG": {
      var eStartDate: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:startDate");
      ePeriodo.appendChild(eStartDate);
      var tDesde: FLDomText = this.iface.xbrlDoc_.createTextNode(fechaDesde.toString().left(10));
      eStartDate.appendChild(tDesde);

      var eEndDate: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:endDate");
      ePeriodo.appendChild(eEndDate);
      var tHasta: FLDomText = this.iface.xbrlDoc_.createTextNode(fechaHasta.toString().left(10));
      eEndDate.appendChild(tHasta);
      break;
    }
  }

  return true;
}

function oficial_establecerDivisa(): Boolean {
  var eMoneda: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:unit");
  this.iface.xbrlDoc_.firstChild().appendChild(eMoneda);
  eMoneda.setAttribute("id", "euro");

  var eMedida: FLDomElement = this.iface.xbrlDoc_.createElement("xbrli:measure");
  eMoneda.appendChild(eMedida);

  var tMedida: FLDomText = this.iface.xbrlDoc_.createTextNode("iso4217:EUR");
  eMedida.appendChild(tMedida);

  return true;
}

function oficial_establecerSchemaRef(): Boolean {
  var eSchema: FLDomElement = this.iface.xbrlDoc_.createElement("link:schemaRef");
  this.iface.xbrlDoc_.firstChild().appendChild(eSchema);
  eSchema.setAttribute("xlink:type", "simple");
  eSchema.setAttribute("xlink:href", "http://www.icac.meh.es/taxonomia/pgc-2008-01-01/pgc07-normal-completo.xsd");

  return true;
}

function oficial_establecerValores(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idBalance: String = cursor.valueBuffer("id");

  var qryXbrl: FLSqlQuery = new FLSqlQuery;
  qryXbrl.setTablesList("co_xbrlbalances08_datos");
  qryXbrl.setSelect("nodoxbrl, saldo, contexto");
  qryXbrl.setFrom("co_xbrlbalances08_datos");
  qryXbrl.setWhere("idbalance = " + idBalance);
  qryXbrl.setForwardOnly(true);
  if (!qryXbrl.exec())
  {
    return false;
  }
  var eNodo: FLDomElement;
  var tNodo: FLDomText;
  var nombreNodo: String;
  var saldo: Number;

  while (qryXbrl.next())
  {
    nombreNodo = qryXbrl.value("nodoxbrl");
    saldo = parseFloat(qryXbrl.value("saldo"));
    if (isNaN(saldo)) {
      saldo = 0;
    }
    ///     saldo *= 100; Parece que lo de decimals no va
    //    saldo = Math.round(saldo);
    saldo = util.roundFieldValue(saldo, "co_xbrlbalances08_datos", "saldo");
    eNodo = this.iface.xbrlDoc_.createElement(nombreNodo);
    this.iface.xbrlDoc_.firstChild().appendChild(eNodo);
    eNodo.setAttribute("decimals", "2");
    eNodo.setAttribute("contextRef", qryXbrl.value("contexto"));
    eNodo.setAttribute("unitRef", "euro");

    tNodo = this.iface.xbrlDoc_.createTextNode(saldo);
    eNodo.appendChild(tNodo);
  }
  return true;
}

function oficial_establecerNameSpaces(): Boolean {
  var eXbrli: FLDomElement = this.iface.xbrlDoc_.firstChild().toElement();
  eXbrli.setAttribute("xmlns:pgc-07-v-n", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc07n-etpn", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/patrimonioNeto/B/EstadoTotalCambiosPatrimonioNeto/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-n-pyg", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/PerdidasGanancias/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-ref", "http://www.icac.meh.es/es/fr/gaap/pgc07/referenceParts/2008-01-01");
  eXbrli.setAttribute("xmlns:xbrldt", "http://xbrl.org/2005/xbrldt");
  eXbrli.setAttribute("xmlns:pgc-07-n-bal", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/balance/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-c-na", "http://www.icac.meh.es/es/fr/gaap/pgc07/comun-normalabreviado/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-roles", "http://www.icac.meh.es/es/fr/gaap/pgc07/roles/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-n-pnAdime", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/patrimonioNeto/A/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-n-fe", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/flujosefectivo/2008-01-01");
  eXbrli.setAttribute("xmlns:link", "http://www.xbrl.org/2003/linkbase");
  eXbrli.setAttribute("xmlns:pgc-07-types", "http://www.icac.meh.es/es/fr/gaap/pgc07/types/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc07n-d-vs", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/patrimonioNeto/B/VariacionSaldo/Dimension/2008-01-01");
  eXbrli.setAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink");
  eXbrli.setAttribute("xmlns:iso4217", "http://www.xbrl.org/2003/iso4217");
  eXbrli.setAttribute("xmlns:pgc-07-c-bs", "http://www.icac.meh.es/es/fr/gaap/pgc07/comun-base/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc-07-n", "http://www.icac.meh.es/es/fr/gaap/pgc07/normal/2008-01-01");
  eXbrli.setAttribute("xmlns:xbrldi", "http://xbrl.org/2006/xbrldi");
  eXbrli.setAttribute("xmlns:pgc07n-p-cpn", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/normal/patrimonioNeto/B/primary/CambiosPatrimonio/2008-01-01");
  eXbrli.setAttribute("xmlns:pgc07cbs-pn", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/comunbase/patrimonioNeto/B/primary/CambiosPatrimonio/2008-01-01");
  eXbrli.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
  eXbrli.setAttribute("xmlns:pgc07cbs-dvs", "http://www.icac.meh.es/es/fr/gaap/pgc07/cuentas/comunbase/patrimonioNeto/B/VariacionSaldo/Dimension/2008-01-01");
  eXbrli.setAttribute("xmlns:xbrli", "http://www.xbrl.org/2003/instance");

  return true;
}
//// OFICIAL //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
