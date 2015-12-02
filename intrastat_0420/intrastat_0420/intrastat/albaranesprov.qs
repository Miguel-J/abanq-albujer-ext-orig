
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT /////////////////////////////////////////////////
class intrastat extends oficial
{
  function intrastat(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.intrastat_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.intrastat_bufferChanged(fN);
  }
  function habilitarIntrastat()
  {
    return this.ctx.intrastat_habilitarIntrastat();
  }
  function calculateField(fN: String): String {
    return this.ctx.intrastat_calculateField(fN);
  }
}
//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT /////////////////////////////////////////////////
function intrastat_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodProvincia").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codprovintrastatprov"));
    this.child("fdbCodCondicionEntrega").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codentregintrastatprov"));
    this.child("fdbNaturalezaTransaccion").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codnaturintrastatprov"));
    this.child("fdbModoTransporte").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codtranspintrastatprov"));
    this.child("fdbCodPuerto").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpuertointrastatprov"));
    this.child("fdbCodRegimen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codregintrastatprov"));
  }

  this.child("fdbCodRegimen").setFilter("tipo = 'I'");
  this.iface.habilitarIntrastat();
}

function intrastat_habilitarIntrastat()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var codPaisEmpresa: String = flfactppal.iface.pub_valorDefectoEmpresa("codpais");
  if (!codPaisEmpresa) {
    return false;
  }
  var paisProveedor: String = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
  if (paisProveedor == codPaisEmpresa) {
    this.child("fdbNoIntrastat").setDisabled(true);
  } else {
    this.child("fdbNoIntrastat").setDisabled(false);
  }
  this.iface.bufferChanged("nointrastat");
}

function intrastat_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "nointrastat": {
      if (cursor.valueBuffer("nointrastat") == true) {
        this.child("gbxIntrastat").setDisabled(true);
      } else {
        this.child("gbxIntrastat").setDisabled(false);
      }
      break;
    }
    case "codpais": {
      this.iface.__bufferChanged(fN);
      this.child("fdbNoIntrastat").setValue(this.iface.calculateField("nointrastat"));
      this.iface.habilitarIntrastat();
      break;
    }
    case "codproveedor": {
      this.iface.__bufferChanged(fN);
      this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
      break;
    }
    default : {
      this.iface.__bufferChanged(fN);
    }
  }
}

function intrastat_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  var peso: Number = 0;
  switch (fN)
  {
    case "codpais": {
      valor = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
      break;
    }
  }

  return valor;
}

//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
