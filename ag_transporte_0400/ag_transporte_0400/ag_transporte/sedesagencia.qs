
/** @class_declaration agTrans */
/////////////////////////////////////////////////////////////////
//// AGENCIAS DE TRANSPORTE /////////////////////////////////////
class agTrans extends oficial
{
  function agTrans(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.agTrans_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.agTrans_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.agTrans_validateForm();
  }
}
//// AGENCIAS DE TRANSPORTE /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition agTrans */
/////////////////////////////////////////////////////////////////
//// AGENCIAS DE TRANSPORTE /////////////////////////////////////
function agTrans_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "ciudad": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        flfactppal.iface.pub_obtenerPoblacion(this);
        this.iface.bloqueoProvincia = false;
      }
      break;
    }
    case "idpoblacion": {
      if (cursor.valueBuffer("idpoblacion") == 0) {
        cursor.setNull("idpoblacion");
      }
      break;
    }
    default: {
      this.iface.__bufferChanged();
    }
  }
}

function agTrans_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "idprovincia": {
      valor = util.sqlSelect("poblaciones", "idprovincia", "idpoblacion = " + cursor.valueBuffer("idpoblacion"));
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }

  return valor;
}

function agTrans_validateForm(): Boolean {
  if (!this.iface.__validateForm())
  {
    return false;
  }

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idPoblacion: String = cursor.valueBuffer("idpoblacion");
  var idProvincia: String = cursor.valueBuffer("idprovincia");
  var codPais: String = cursor.valueBuffer("codpais");
  if (idPoblacion && idPoblacion != "")
  {
    if (!util.sqlSelect("poblaciones", "idpoblacion", "idpoblacion = " + idPoblacion + " AND idprovincia = " + idProvincia + " AND codpais = '" + codPais + "'")) {
      MessageBox.warning(util.translate("scripts", "Los identificadores de población, provincia y país no son coherentes"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  return true;
}
//// AGENCIAS DE TRANSPORTE /////////////////////////////////////
/////////////////////////////////////////////////////////////////
