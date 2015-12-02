
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILERES ////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.alquiler_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.alquiler_bufferChanged(fN);
  }
  function habilitaSeAlquila()
  {
    return this.ctx.alquiler_habilitaSeAlquila();
  }
}
//// ALQUILERES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILERES /////////////////////////////////////////////////
function alquiler_init()
{
  var _i = this.iface;
  _i.__init();
  _i.habilitaSeAlquila();
}

function alquiler_bufferChanged(fN)
{
  var _i = this.iface;
  switch (fN) {
    case "sealquila": {
      _i.habilitaSeAlquila();
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function alquiler_habilitaSeAlquila()
{
  var cursor = this.cursor();
  this.child("tbwArticulo").setTabEnabled("alquiler", cursor.valueBuffer("sealquila"));
  if (cursor.valueBuffer("sealquila")) {
    var oDatosCal = new Object;
    oDatosCal.fechaInicio = new Date;
    formcalobjetomes.iface.pub_calObjetoMesOn(this, oDatosCal);
  } else {
    //formcalobjetomes.iface.pub_calObjetoMesOff();
  }
}
//// ALQUILERES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
