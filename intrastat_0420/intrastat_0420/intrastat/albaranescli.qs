
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
    this.child("fdbCodProvincia").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codprovintrastatcli"));
    this.child("fdbCodCondicionEntrega").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codentregintrastatcli"));
    this.child("fdbNaturalezaTransaccion").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codnaturintrastatcli"));
    this.child("fdbModoTransporte").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codtranspintrastatcli"));
    this.child("fdbCodPuerto").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpuertointrastatcli"));
    this.child("fdbCodRegimen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codregintrastatcli"));
  }

  this.child("fdbCodRegimen").setFilter("tipo = 'E'");
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
  if (cursor.valueBuffer("codpais") == codPaisEmpresa) {
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
      this.child("fdbNoIntrastat").setValue(this.iface.calculateField("nointrastat"));
      this.iface.habilitarIntrastat();
      break;
    }
    default : {
      this.iface.__bufferChanged(fN);
    }
  }
}

//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
