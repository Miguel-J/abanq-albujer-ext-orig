
/** @class_declaration tpvCtaVta */
//////////////////////////////////////////////////////////////////
//// TPV CTA VTA //////////////////////////////////////////////
class tpvCtaVta extends oficial
{

  var longSubcuenta: Number;
  var bloqueoSubcuenta: Boolean;
  var ejercicioActual: String;
  var posActualPuntoSubcuenta: Number;

  function tpvCtaVta(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.tpvCtaVta_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.tpvCtaVta_bufferChanged(fN);
  }
  function calculateField(fN: String)
  {
    return this.ctx.tpvCtaVta_calculateField(fN);
  }
}
//// TPV CTA VTA //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tpvCtaVta */
/////////////////////////////////////////////////////////////////
//// TPV CTA VTA //////////////////////////////////////////////

function tpvCtaVta_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;

  if (sys.isLoadedModule("flcontppal")) {
    this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
    this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",
                                              "codejercicio = '" + this.iface.ejercicioActual + "'");
    this.iface.bloqueoSubcuenta = false;
    this.iface.posActualPuntoSubcuenta = -1;
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
  } else
    this.child("gbxContabilidad").enabled = false;
}


function tpvCtaVta_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  switch (fN) {
    case "codsubcuenta":
      if (!this.iface.bloqueoSubcuenta) {
        this.iface.bloqueoSubcuenta = true;
        this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      break;
    case "referencia":
      this.iface.bloqueoSubcuenta = true;
      this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
      this.iface.bloqueoSubcuenta = false;
      this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto", cursor));
    default:
      this.iface.__bufferChanged(fN);
  }
}

function tpvCtaVta_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (fN)
  {
    case "codsubcuenta":
      return util.sqlSelect("articulos", "codsubcuentaven",
      "referencia = '" + cursor.valueBuffer("referencia") + "'");
      break
    default:
      return this.iface.__calculateField(fN);
  }
}

//// TPV CTA VTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
