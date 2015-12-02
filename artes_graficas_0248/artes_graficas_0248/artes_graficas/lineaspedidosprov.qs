
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends prod
{
  var anchoPlas_: Number;
  var codFamilia_: String;
  var bloqueoCantidad: Boolean;
  var bloqueoPVP: Boolean;
  function artesG(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.artesG_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.artesG_commonCalculateField(fN, cursor);
  }
  function obtenerFamilia(referencia: String): String {
    return this.ctx.artesG_obtenerFamilia(referencia);
  }
  function habilitacionesFamilia(miForm: Object)
  {
    return this.ctx.artesG_habilitacionesFamilia(miForm);
  }
  function establecerAliasPapel(miForm: Object)
  {
    return this.ctx.artesG_establecerAliasPapel(miForm);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// PUB_ARTES_G/////////////////////////////////////////////////
class pubArtesG extends ifaceCtx
{
  function pubArtesG(context)
  {
    ifaceCtx(context);
  }
  function pub_obtenerFamilia(referencia: String): String {
    return this.obtenerFamilia(referencia);
  }
  function pub_habilitacionesFamilia(miForm: Object)
  {
    return this.habilitacionesFamilia(miForm);
  }
  function pub_establecerAliasPapel(miForm: Object)
  {
    return this.establecerAliasPapel(miForm);
  }
}

const iface = new pubArtesG(this);
//// PUB_ARTES_G/////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.iface.obtenerFamilia("sin familia");
      break;
    }
    case cursor.Edit: {
      this.iface.obtenerFamilia(cursor.valueBuffer("referencia"));
      break;
    }
  }
  this.iface.habilitacionesFamilia(this);
  this.iface.bloqueoCantidad = false;
  this.iface.establecerAliasPapel(this);
}

function artesG_commonBufferChanged(fN: String, miForm)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = miForm.cursor();

  switch (fN) {
    case "referencia": {
      var referencia: String = cursor.valueBuffer("referencia");
      this.iface.obtenerFamilia(referencia);
      switch (this.iface.codFamilia_) {
        case "PLAS": {
          if (isNaN(this.iface.anchoPlas_) || this.iface.anchoPlas_ == 0) {
            MessageBox.warning(util.translate("scripts", "No tiene definido el ancho de rollo para el artículo %1.\nDebe especificar este valor en la tabla de artículos.").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
            this.iface.establecerAliasPapel(this);
            return;
          }
          break;
        }
        case "PAPE": {
          break;
        }
      }
      this.iface.habilitacionesFamilia(miForm);
      this.iface.__commonBufferChanged(fN, miForm);
      break;
    }
    case "udpapel": {
      miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", cursor));
      if (!this.iface.bloqueoCantidad) {
        this.iface.bloqueoCantidad = true;
        miForm.child("fdbCantidadAux").setValue(this.iface.commonCalculateField("cantidadaux", cursor));
        this.iface.bloqueoCantidad = false;
      }
      this.iface.establecerAliasPapel(miForm);
      break;
    }
    case "cantidad": {
      if (!this.iface.bloqueoCantidad) {
        this.iface.bloqueoCantidad = true;
        miForm.child("fdbCantidadAux").setValue(this.iface.commonCalculateField("cantidadaux", cursor));
        this.iface.bloqueoCantidad = false;
      }
      if (!this.iface.bloqueoPVP) {
        this.iface.bloqueoPVP = true;
        this.iface.__commonBufferChanged(fN, miForm);
        this.iface.bloqueoPVP = false;
      }
      //      this.child("fdbPvpPliego").setValue(this.iface.commonCalculateField("pvppliego", cursor));
      break;
    }
    case "cantidadaux": {
      if (!this.iface.bloqueoCantidad) {
        this.iface.bloqueoCantidad = true;
        miForm.child("fdbCantidad").setValue(this.iface.commonCalculateField("cantidad", cursor));
        this.iface.bloqueoCantidad = false;
      }
      break;
    }
    case "unidades": {
      if (!this.iface.bloqueoCantidad) {
        this.iface.bloqueoCantidad = true;
        miForm.child("fdbCantidad").setValue(this.iface.commonCalculateField("cantidad", cursor));
        this.iface.bloqueoCantidad = false;
      }
      break;
    }
    case "pvpsindto": {
      if (this.iface.codFamilia_ == "PAPE") {
        if (!this.iface.bloqueoPVP) {
          this.iface.bloqueoPVP = true;
          miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario2", cursor));
          this.iface.bloqueoPVP = false;
        }
      }
      this.iface.__commonBufferChanged(fN, miForm);
      miForm.child("fdbPvpPliego").setValue(this.iface.commonCalculateField("pvppliego", cursor));
      break;
    }
    case "pvpunitario": {
      if (!this.iface.bloqueoPVP) {
        this.iface.bloqueoPVP = true;
        this.iface.__commonBufferChanged(fN, miForm);
        this.iface.bloqueoPVP = false;
      }
      break;
    }
    default: {
      this.iface.__commonBufferChanged(fN, miForm);
    }
  }
}

function artesG_establecerAliasPapel(miForm)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = miForm.cursor();
  switch (this.iface.codFamilia_) {
    case "PAPE": {
      switch (cursor.valueBuffer("udpapel")) {
        case "No":
        case "Unidad": {
          miForm.child("fdbCantidadAux").setFieldAlias(util.translate("scripts", "Pliegos"));
          break;
        }
        case "Resma": {
          miForm.child("fdbCantidadAux").setFieldAlias(util.translate("scripts", "Resmas"));
          break;
        }
        case "Euroton.": {
          miForm.child("fdbCantidadAux").setFieldAlias(util.translate("scripts", "E.T."));
          break;
        }
      }
      break;
    }
    case "PLAS": {
      miForm.child("fdbCantidadAux").setFieldAlias(util.translate("scripts", "m / Unidad"));
      break;
    }
    default: {
      miForm.child("fdbCantidadAux").setFieldAlias("");
      break;
    }
  }
}


function artesG_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var res: String;
  switch (fN)
  {
    case "pvpunitario": {
      switch (this.iface.codFamilia_) {
        case "PAPE": {
          var datosTP: Array = this.iface.datosTablaPadre(cursor);
          if (!datosTP)
            return false;
          var wherePadre: String = datosTP.where;
          var tablaPadre: String = datosTP.tabla;

          var codProveedor: String = util.sqlSelect(tablaPadre, "codproveedor", wherePadre);
          var codDivisa: String = util.sqlSelect(tablaPadre, "coddivisa", wherePadre);
          var qryCostes: FLSqlQuery = new FLSqlQuery;
          with(qryCostes) {
            setTablesList("articulosprov");
            setSelect("coste, costeresma, costeet");
            setFrom("articulosprov");
            setWhere("referencia = '" + cursor.valueBuffer("referencia") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
            setForwardOnly(true);
          }
          if (!qryCostes.exec())
            return;

          if (!qryCostes.first()) {
            res = 0;
            break;
          }

          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              res = 0;
              break;
            }
            case "Unidad": {
              res = qryCostes.value("coste");
              break;
            }
            case "Resma": {
              res = qryCostes.value("costeresma");
              break;
            }
            case "Euroton.": {
              res = qryCostes.value("costeet");
              break;
            }
          }
          break;
        }
        case "PLAS": {
          var costeMetro: Number = this.iface.__commonCalculateField(fN, cursor);
          res = costeMetro * this.iface.anchoPlas_ / 100;
          break;
        }
        default: {
          res = this.iface.__commonCalculateField(fN, cursor);
          break;
        }
      }
      break;
    }
    case "pvpsindto": {
      switch (this.iface.codFamilia_) {
        case "PAPE": {
          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              res = this.iface.__commonCalculateField(fN, cursor);
              break;
            }
            case "Unidad":
            case "Resma":
            case "Euroton.": {
              res = parseFloat(cursor.valueBuffer("cantidadaux")) * parseFloat(cursor.valueBuffer("pvpunitario"));
              break;
            }
          }
          break;
        }
        default: {
          res = this.iface.__commonCalculateField(fN, cursor);
          break;
        }
      }
      break;
    }
    case "pvpunitario2": {
      switch (this.iface.codFamilia_) {
        case "PAPE": {
          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              res = res = parseFloat(cursor.valueBuffer("pvpsindto")) / parseFloat(cursor.valueBuffer("cantidad"));
              break;
            }
            case "Unidad":
            case "Resma":
            case "Euroton.": {
              res = parseFloat(cursor.valueBuffer("pvpsindto")) / parseFloat(cursor.valueBuffer("cantidadaux"));
              break;
            }
          }
          break;
        }
        default: {
          res = res = parseFloat(cursor.valueBuffer("pvpsindto")) / parseFloat(cursor.valueBuffer("cantidad"));
          break;
        }
      }
      break
    }
    case "pvppliego": {
      switch (this.iface.codFamilia_) {
        case "PAPE": {
          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              res = "";
              break;
            }
            default: {
              res = cursor.valueBuffer("pvpsindto") / cursor.valueBuffer("cantidad");
              break;
            }
          }
          break;
        }
        default: {
          res = "";
          break;
        }
      }
      break;
    }
    case "cantidad": {
      switch (this.iface.codFamilia_) {
        case "PLAS": {
          res = parseFloat(cursor.valueBuffer("unidades")) * parseFloat(cursor.valueBuffer("cantidadaux"));
          break;
        }
        case "PAPE": {
          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              break;
            }
            case "Unidad": {
              res = cursor.valueBuffer("cantidadaux");
              break;
            }
            case "Resma": {
              res = cursor.valueBuffer("cantidadaux") * 500;
              break;
            }
            case "Euroton.": {
              var qryPapel: FLSqlQuery = new FLSqlQuery;
              qryPapel.setTablesList("articulos");
              qryPapel.setSelect("altopliego, anchopliego, gramaje");
              qryPapel.setFrom("articulos");
              qryPapel.setWhere("referencia = '" + cursor.valueBuffer("referencia") + "'");
              qryPapel.setForwardOnly(true);
              if (!qryPapel.exec()) {
                break;
              }
              if (!qryPapel.first()) {
                break;
              }
              var alto: Number = parseFloat(qryPapel.value("altopliego"));
              var ancho: Number = parseFloat(qryPapel.value("anchopliego"));
              var gramaje: Number = parseFloat(qryPapel.value("gramaje"));
              res = cursor.valueBuffer("cantidadaux") * (1000000 / ((alto / 100) * (ancho / 100) * gramaje));
              break;
            }
          }
          break;
        }
      }
      break;
    }
    case "cantidadaux": {
      switch (this.iface.codFamilia_) {
        case "PLAS": {
          res = parseFloat(cursor.valueBuffer("cantidad")) / this.iface.anchoPlas_;
          break;
        }
        case "PAPE": {
          switch (cursor.valueBuffer("udpapel")) {
            case "No": {
              break;
            }
            case "Unidad": {
              res = cursor.valueBuffer("cantidad");
              break;
            }
            case "Resma": {
              res = cursor.valueBuffer("cantidad") / 500;
              break;
            }
            case "Euroton.": {
              var qryPapel: FLSqlQuery = new FLSqlQuery;
              qryPapel.setTablesList("articulos");
              qryPapel.setSelect("altopliego, anchopliego, gramaje");
              qryPapel.setFrom("articulos");
              qryPapel.setWhere("referencia = '" + cursor.valueBuffer("referencia") + "'");
              qryPapel.setForwardOnly(true);
              if (!qryPapel.exec()) {
                break;
              }
              if (!qryPapel.first()) {
                break;
              }
              var alto: Number = parseFloat(qryPapel.value("altopliego"));
              var ancho: Number = parseFloat(qryPapel.value("anchopliego"));
              var gramaje: Number = parseFloat(qryPapel.value("gramaje"));
              res = cursor.valueBuffer("cantidad") / (1000000 / ((alto / 100) * (ancho / 100) * gramaje));
              break;
            }
          }
          break;
        }
      }
      break;
    }
    default: {
      res = this.iface.__commonCalculateField(fN, cursor);
    }
  }
  return res;
}

function artesG_obtenerFamilia(referencia: String): Boolean {
  var util: FLUtil = new FLUtil;
  this.iface.codFamilia_ = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");

  switch (this.iface.codFamilia_)
  {
    case "PLAS": {
      this.iface.anchoPlas_ = parseFloat(util.sqlSelect("articulos", "anchopliego", "referencia = '" + referencia + "'"));
      if (!isNaN(this.iface.anchoPlas_) && this.iface.anchoPlas_ != 0) {
        this.iface.anchoPlas_ = this.iface.anchoPlas_ / 100;
      }
      break;
    }
    default: {
      this.iface.anchoPlas_ = false;
    }
  }
  return true;
}

function artesG_habilitacionesFamilia(miForm: Object)
{
  switch (this.iface.codFamilia_) {
    case "PLAS": {
      miForm.child("fdbCantidadAux").setDisabled(false);
      miForm.child("fdbUdPapel").setValue("No");
      miForm.child("fdbUdPapel").setDisabled(true);
      miForm.child("fdbUnidades").setDisabled(false);
      miForm.child("fdbCantidad").setDisabled(true);
      break;
    }
    case "PAPE": {
      miForm.child("fdbCantidadAux").setDisabled(false);
      miForm.child("fdbUdPapel").setDisabled(false);
      miForm.child("fdbUnidades").setDisabled(true);
      miForm.child("fdbCantidad").setDisabled(false);
      break;
    }
    default: {
      miForm.child("fdbCantidadAux").setValue("");
      miForm.child("fdbCantidadAux").setDisabled(true);
      miForm.child("fdbUdPapel").setValue("No");
      miForm.child("fdbUdPapel").setDisabled(true);
      miForm.child("fdbUnidades").setDisabled(true);
      miForm.child("fdbCantidad").setDisabled(false);
      break;
    }
  }
}

//// ARTES GRÁFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
