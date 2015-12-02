
/** @class_declaration ctaExplotacion */
/////////////////////////////////////////////////////////////////
//// CTAEXPLOTACION //////////////////////////////////////////////////////
class ctaExplotacion extends oficial
{
  function ctaExplotacion(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.ctaExplotacion_init();
  }
}
//// CTAEXPLOTACION //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctaExplotacion */
/////////////////////////////////////////////////////////////////
//// CTAEXPLOTACION //////////////////////////////////////////////////////
function ctaExplotacion_init()
{
  this.iface.__init();

  var curTab: FLSqlCursor = new FLSqlCursor("co_codcuentaexp1");
  curTab.select();

  var util: FLUtil = new FLUtil;
  if (curTab.first())
    return;

  MessageBox.information(util.translate("scripts",  "A continuación se introducirán algunos datos iniciales\npara el informe de cuenta de explotación"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  // Códigos de nivel 1
  var datos = [["VB", "Ventas brutas", "", 1],
               ["DV", "Devoluciones de ventas", "Ventas netas", 2],
               ["VE", "Variación de existencias", "Valor de la producción", 3],
               ["CM", "Consumos", "Margen bruto", 4],
               ["CD", "Costes directos", "", 5],
               ["CI", "Costes indirectos", "Margen industrial", 6],
               ["CV", "Costes de ventas", "Margen de contribución", 7],
               ["GF", "Gastos fijos", "Resultado bruto de explotación", 8],
               ["CF", "Costes financieros", "Resultado neto de explotación", 9],
               ["GIE", "Gastos/Ingresos extraordinarios", "Beneficios antes de impuestos", 10],
               ["IS", "Impuesto sociedades", "Beneficios netos / Pérdidas", 11],
               ["AP", "Amortizaciones y provisiones", "CASH FLOW", 12],
               ["CFL", "Cash flow", "", 13]];

  for (i = 0; i < datos.length; i++) {
    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("codigo", datos[i][0]);
    curTab.setValueBuffer("descripcion", datos[i][1]);
    curTab.setValueBuffer("funcionpie", datos[i][2]);
    curTab.setValueBuffer("orden", datos[i][3]);
    curTab.commitBuffer();
  }

  // Códigos de nivel 2
  var datos = [["VB", "700", "Ventas "],
               ["DV", "708", "Devoluciones de ventas"],
               ["VE", "711", "Variac exist prod en curso"],
               ["VE", "712", "Variac exist prod terminados"],
               ["CM", "600", "Compras de mercaderías"],
               ["CM", "624.2", "Transportes compras"],
               ["CM", "609", "Rappel sobre compras (-)"],
               ["CM", "602", "Compras otros aprovisionamientos"],
               ["CM", "608", "Devolución compras o similares (-)"],
               ["CM", "610", "Variación de mercaderías"],
               ["CM", "611", "Variación de Materias primas"],
               ["CD", "607", "Trabajos realizados por otras empresas"],
               ["CD", "640.1", "Salarios Mano Obra Directa "],
               ["CD", "642.1", "Seg. Social Mano Obra Directa  "],
               ["CD", "649", "Otros gastos sociales"],
               ["CD", "649.1", "Incentivos M.O.D"],
               ["CD", "628.1", "Consumo electricidad y agua"],
               ["CD", "622.2", "Reparac. y conserv.maquinas "],
               ["CD", "621", "Arrendamientos"],
               ["CD", "682.1", "Amortizaciones Maquinaria, Utillajes e Instalac."],
               ["CI", "640.2", "Salarios M.O.Indirecta"],
               ["CI", "642.2", "Seg. Social M.O. Indirecta "],
               ["CV", "640.3", "Salarios personal de gestión de ventas"],
               ["CV", "642.3", "Seg. Social Personal de gestión ventas"],
               ["CV", "623.3", "Comisiones sobre ventas"],
               ["CV", "629.2", "Gastos comerciales varios"],
               ["CV", "624.1", "Transportes de ventas"],
               ["CV", "622.1", "Reparac. y conserv. vehiculos"],
               ["CV", "628.2", "Combustible vehículos de ventas"],
               ["CV", "625.1", "Seguros vehículos de ventas"],
               ["CV", "625.3", "Seguro cobro clientes"],
               ["CV", "682.2", "Amortizaciones de vehículos"],
               ["CV", "627", "Publicidad, Propaganda y Rel.Públicas"],
               ["GF", "640.4", "Salarios Personal Estructura"],
               ["GF", "642.4", "Seg. Social Personal Estructura"],
               ["GF", "623", "Serv.Prof.Independ./Asesorias/Gestorias"],
               ["GF", "649.2", "Otros gastos sociales"],
               ["GF", "622.3", "Reparac. y conserv. Estructura"],
               ["GF", "625.2", "Seguros generales, siniestros, etc.Resp.Civil"],
               ["GF", "626", "Servicios bancarios, comisiones y gastos"],
               ["GF", "628.3", "Teléfono, comunicaciones, mensajerías, etc."],
               ["GF", "629.1", "Material Oficina y otros varios"],
               ["GF", "631", "Tributos e Impuestos"],
               ["GF", "694", "Dotaciones Operaciones Tráfico"],
               ["GF", "682.3", "Amortizaciones Estructurales"],
               ["CF", "665", "Descuentos / Vtas Pronto pago"],
               ["CF", "769", "Ingresos financieros"],
               ["CF", "662", "Intereses deuda a largo plazo"],
               ["CF", "663", "Intereses deudas a corto plazo"],
               ["CF", "664", "Intereses por descuento de efectos"],
               ["CF", "669", "Otros gastos financieros"],
               ["CF", "768", "Diferencias negativas(-positivas) de cambio"],
               ["GIE", "678", "Gtos. extraordinarios"],
               ["GIE", "778", "Ingresos extraordinarios/Dot.Subv.Capital"],
               ["IS", "630", "Impuesto sobre sociedades"],
               ["AP", "682", "Amortizaciones"],
               ["AP", "692", "Provisiones"]];

  curTab = new FLSqlCursor("co_codcuentaexp2");
  curScta = new FLSqlCursor("co_subcuentas");

  // Vaciar tabla de códigos 2 just in case
  curTab.select("");
  while (curTab.next()) {
    with(curTab) {
      setModeAccess(curTab.Del);
      refreshBuffer();
      commitBuffer();
    }
  }

  util.createProgressDialog(util.translate("scripts", "Creando datos..."), datos.length);

  for (i = 0; i < datos.length; i++) {

    codCuentaExp = datos[i][1];

    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("codpadre", datos[i][0]);
    curTab.setValueBuffer("codigo", codCuentaExp);
    curTab.setValueBuffer("descripcion", datos[i][2]);
    curTab.commitBuffer();

    // Subcuentas de patrón tipo fijo: 600
    if (codCuentaExp.search(".") == -1) {
      curScta.select("codcuenta = '" + codCuentaExp + "'");
      while (curScta.next()) {
        curScta.setModeAccess(curScta.Edit);
        curScta.refreshBuffer();
        curScta.setValueBuffer("codcuentaexp", codCuentaExp);
        curScta.commitBuffer();
      }
    }

    // Subcuentas de patrón tipo: 600.1
    if (codCuentaExp.search(".1") > -1) {
      curScta.select("codcuenta = '" + codCuentaExp.left(3) + "'");
      while (curScta.next()) {
        curScta.setModeAccess(curScta.Edit);
        curScta.refreshBuffer();
        curScta.setValueBuffer("codcuentaexp", codCuentaExp);
        curScta.commitBuffer();
      }
    }

    util.setProgress(i);
  }
  util.destroyProgressDialog();
}
//// CTAEXPLOTACION //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
