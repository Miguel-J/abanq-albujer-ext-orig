
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.ivaNav_commonCalculateField(fN, cursor);
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.ivaNav_commonBufferChanged(fN, miForm);
  }
  function camposTablaPadre(cursor)
  {
    return this.ctx.ivaNav_camposTablaPadre(cursor);
  }
  function commonInit(miForm)
  {
    return this.ctx.ivaNav_commonInit(miForm);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "iva": {
      var datosTP = _i.datosTablaPadre(cursor)
                    var codImpuesto = cursor.valueBuffer("codimpuesto");
      valor = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, datosTP["fecha"], "cli", datosTP["codgrupoivaneg"]);
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "recargo": {
      var datosTP = _i.datosTablaPadre(cursor)
                    var codImpuesto = cursor.valueBuffer("codimpuesto");
      valor = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, datosTP["fecha"], "cli", datosTP["codgrupoivaneg"]);
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function ivaNav_commonBufferChanged(fN, miForm)
{
  var _i = this.iface;
  switch (fN) {
    case "codimpuesto": {
      flfacturac.iface.pub_habilitaPorIva(miForm);
      _i.__commonBufferChanged(fN, miForm);
      break;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function ivaNav_commonInit(miForm)
{
  flfacturac.iface.pub_habilitaPorIva(miForm);
}

function ivaNav_camposTablaPadre(cursor)
{
  var _i = this.iface;

  var aCampos = _i.__camposTablaPadre(cursor);

  if (cursor.table() != "tpv_lineascomanda") {
    aCampos.push("codgrupoivaneg");
  }

  return aCampos;
}

//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
