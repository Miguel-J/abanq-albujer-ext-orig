
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
class distEjer extends oficial
{
  function distEjer(context)
  {
    oficial(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.distEjer_bufferChanged(fN);
  }
}
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
function distEjer_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "cantidad": {
      sys.setObjText(this, "fdbCanFactura", _i.calculateField("canfactura"));
      _i.__bufferChanged(fN);
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
