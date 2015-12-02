
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
class partidas extends dtoEspecial
{
  var bloqueoGastos: Boolean;
  var bloqueoBeneficio: Boolean;
  var curLineaPar_: FLSqlCursor;
  function partidas(context)
  {
    dtoEspecial(context);
  }
  function init()
  {
    return this.ctx.partidas_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.partidas_bufferChanged(fN);
  }
  function calcularTotales()
  {
    return this.ctx.partidas_calcularTotales();
  }
  function filtrarLineas()
  {
    return this.ctx.partidas_filtrarLineas();
  }
  function insertarLinea()
  {
    return this.ctx.partidas_insertarLinea();
  }
  function editarLinea()
  {
    return this.ctx.partidas_editarLinea();
  }
  function borrarLinea()
  {
    return this.ctx.partidas_borrarLinea();
  }
  function guardar()
  {
    return this.ctx.partidas_guardar();
  }
  function comprobarCapituloActivo(): String {
    return this.ctx.partidas_comprobarCapituloActivo();
  }
}
//// PARTIDAS_FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPartidas */
/////////////////////////////////////////////////////////////////
//// PUB_PARTIDAS ///////////////////////////////////////////////
class pubPartidas extends ifaceCtx
{
  function pubPartidas(context)
  {
    ifaceCtx(context);
  }
  function pub_comprobarCapituloActivo(): String {
    return this.comprobarCapituloActivo();
  }
}

//// PUB_PARTIDAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT /////////////////////////////////////////////
function partidas_init()
{
  this.iface.__init();
  connect(this.child("tdbPartidasAlb").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  connect(this.child("tdbPartidasAlb").cursor(), "newBuffer()", this, "iface.filtrarLineas");
  this.iface.filtrarLineas();
  connect(this.child("chkMostrarTodas"), "clicked()", this, "iface.filtrarLineas");

  connect(this.child("toolButtomInsert"), "clicked()", this, "iface.insertarLinea");
  connect(this.child("toolButtonEdit"), "clicked()", this, "iface.editarLinea");
  connect(this.child("toolButtonDelete"), "clicked()", this, "iface.borrarLinea");
  this.iface.bloqueoGastos = false;
  this.iface.bloqueoBeneficio = false;
}

function partidas_bufferChanged(fN: String)
{
  switch (fN) {
    case "netosindtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
        this.iface.bloqueoDto = false;
      }
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbGastos").setValue(this.iface.calculateField("gastos"));
        this.iface.bloqueoGastos = false;
      }
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbBeneficio").setValue(this.iface.calculateField("beneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      break;
    }
    case "porgastos": {
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbGastos").setValue(this.iface.calculateField("gastos"));
        this.iface.bloqueoGastos = false;
      }
      break;
    }
    case "gastos": {
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbPorGastos").setValue(this.iface.calculateField("porgastos"));
        this.iface.bloqueoGastos = false;
      }
      this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
      break;
    }
    case "porbeneficio": {
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbBeneficio").setValue(this.iface.calculateField("beneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      break;
    }
    case "beneficio": {
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbPorBeneficio").setValue(this.iface.calculateField("porbeneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

function partidas_insertarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasAlbaranesCli").cursor().insertRecord();
}

function partidas_editarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasAlbaranesCli").editRecord();
}

function partidas_borrarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasAlbaranesCli").deleteRecord();
}

function partidas_guardar()
{
  var cursor: FLSqlCursor = this.cursor();
  var idAlbaran: String = cursor.valueBuffer("idalbaran");

  while (cursor.transactionLevel() > 1) {
    sys.processEvents();
  }
  cursor.commitBuffer();
  cursor.commit();
  cursor.transaction(false);
  cursor.select("idalbaran = " + idAlbaran);
  cursor.first();
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
}

function partidas_calcularTotales()
{
  this.iface.filtrarLineas();
  this.iface.__calcularTotales();
}

function partidas_filtrarLineas()
{
  var util: FLUtil = new FLUtil;
  var filtro: String = "";
  var textoFiltro: String = "";
  var curPartidas: FLSqlCursor = this.child("tdbPartidasAlb").cursor();
  var idPartida: String = curPartidas.valueBuffer("idpartidaalb");
  if (!idPartida || idPartida == "" || this.child("chkMostrarTodas").checked) {
    textoFiltro = util.translate("scripts", "Mostrando todas las líneas");
  } else {
    var desPartida: String = curPartidas.valueBuffer("descripcion");
    textoFiltro = util.translate("scripts", "Líneas de %1").arg(desPartida);
    filtro = "idpartidaalb = " + idPartida;
  }
  this.child("lblFiltro").text = textoFiltro;
  this.child("tdbLineasAlbaranesCli").setFilter(filtro);
  this.child("tdbLineasAlbaranesCli").refresh();
}

function partidas_comprobarCapituloActivo(): String {
  var valor: String;
  var curPartidas: FLSqlCursor = this.child("tdbPartidasAlb").cursor();
  var idPartida: String = curPartidas.valueBuffer("idpartidaalb");
  if (!idPartida || idPartida == "" || this.child("chkMostrarTodas").checked)
  {
    valor = "";
  } else {
    valor = idPartida;
  }
  return valor;
}

//// PARTIDAS_FACT /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
