
/** @class_declaration masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO /////////////////////////////////////////////
class masFormasPago extends oficial
{
  var bloqueo: Boolean;
  function masFormasPago(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.masFormasPago_init();
  }
  function cambioTipoPlazo(nuevoTipoPlazo)
  {
    return this.ctx.masFormasPago_cambioTipoPlazo(nuevoTipoPlazo);
  }
  function desconexion()
  {
    return this.ctx.masFormasPago_desconexion();
  }
}
//// MAS_FORMASPAGO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO ////////////////////////////////////////////
function masFormasPago_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  this.iface.bloqueo = false;
  var aux: Number = this.cursor().valueBuffer("tipoplazo");
  this.iface.cambioTipoPlazo(0);
  this.iface.cambioTipoPlazo(aux);

  connect(this.child("btgTipoPlazo"), "clicked(int)", this, "iface.cambioTipoPlazo");
  connect(form, "closed()", this, "iface.desconexion");
}

function masFormasPago_desconexion()
{
  disconnect(this.child("btgTipoPlazo"), "clicked(int)", this, "iface.cambioTipoPlazo");
}

/** \D Activa y desactiva los marcos según el tipo de plazo elegido

@param nuevoTipoPlazo Es el valor que devuelve el ListBox de la página: Porcentaje, Número de plazos o Importe fijo
\end */
function masFormasPago_cambioTipoPlazo(nuevoTipoPlazo)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (nuevoTipoPlazo) {
    case 0: // Porcentual
      this.iface.bloqueo = true;
      this.child("aplazado").setDisabled(false);
      this.child("fdbNPlazos").setDisabled(true);
      this.child("fdbImporteFijo").setDisabled(true);
      this.child("fdbImporteMinimo").setDisabled(true);
      this.child("fdbCadencia").setDisabled(true);
      this.child("chkPorcentual").setChecked(true);
      this.iface.bloqueo = false;
      break;

    case 1: // Número de plazos
      this.iface.bloqueo = true;
      this.child("aplazado").setValue(100 - this.iface.totalAplazado);
      this.child("aplazado").setDisabled(true);
      this.child("fdbNPlazos").setDisabled(false);
      this.child("fdbImporteFijo").setDisabled(true);
      this.child("fdbImporteMinimo").setDisabled(true);
      this.child("fdbCadencia").setDisabled(false);
      this.child("chkNPlazos").setChecked(true);
      this.iface.bloqueo = false;
      break;

    case 2: // Importe fijo
      this.iface.bloqueo = true;
      this.child("aplazado").setValue(100 - this.iface.totalAplazado);
      this.child("aplazado").setDisabled(true);
      this.child("fdbNPlazos").setDisabled(true);
      this.child("fdbImporteFijo").setDisabled(false);
      this.child("fdbImporteMinimo").setDisabled(false);
      this.child("fdbCadencia").setDisabled(false);
      this.child("chkImporteFijo").setChecked(true);
      this.iface.bloqueo = false;
      break;

  }
  this.cursor().setValueBuffer("tipoplazo", nuevoTipoPlazo);

}

//// MAS_FORMASPAGO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
