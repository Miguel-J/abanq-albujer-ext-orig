
/** @class_declaration envMailFra */
//////////////////////////////////////////////////////////////////
//// ENVIO EMAIL FACTURAS /////////////////////////////////
class envMailFra extends oficial
{
  function envMailFra(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.envMailFra_init();
  }
  function cambiarCodificacion(valor)
  {
    return this.ctx.envMailFra_cambiarCodificacion(valor);
  }
  function cambiarRutaAdjuntos(valor)
  {
    return this.ctx.envMailFra_cambiarRutaAdjuntos(valor);
  }
  function buscarRuraAdjunto()
  {
    return this.ctx.envMailFra_buscarRuraAdjunto();
  }
}
//// ENVIO EMAIL FACTURAS /////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition envMailFra */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL FACTURAS //////////////////////////////////
function envMailFra_init()
{
  var _i = this.iface;

  _i.__init();

  this.child("lineEditCodificacion").text = AQUtil.readSettingEntry("scripts/flfacturac/encodingLocal");

  this.child("lineEditRutaAdjuntos").text = AQUtil.readSettingEntry("scripts/flfacturac/rutaAdjuntos");

  connect(this.child("lineEditCodificacion"), "textChanged(QString)", _i, "cambiarCodificacion()");
  connect(this.child("lineEditRutaAdjuntos"), "textChanged(QString)", _i, "cambiarRutaAdjuntos()");
  connect(this.child("pbnCambiarRutaAdjunto"), "clicked()", _i, "buscarRuraAdjunto()");
}

function envMailFra_cambiarCodificacion(valor)
{
  AQUtil.writeSettingEntry("scripts/flfacturac/encodingLocal", valor);
}

function envMailFra_cambiarRutaAdjuntos(valor)
{
  AQUtil.writeSettingEntry("scripts/flfacturac/rutaAdjuntos", valor);
}

function envMailFra_buscarRuraAdjunto()
{
  var ruta = FileDialog.getExistingDirectory(sys.translate(""), sys.translate("Directorio de ficheros adjuntos"));

  if (!File.isDir(ruta)) {
    MessageBox.information(util.translate("scripts", "Ruta errónea"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  this.child("lineEditRutaAdjuntos").text = ruta;
  AQUtil.writeSettingEntry("scripts/flfacturac/rutaAdjuntos", ruta);
}
//// ENVIO MAIL FACTURAS //////////////////////////////////
/////////////////////////////////////////////////////////////////
