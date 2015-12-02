
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function facturar(codigo: String)
  {
    return this.ctx.gym_facturar(codigo);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
/** \D Para los contratos que vienen de un bono de suscripción marca como caducados aquellos que hayan rebasado la fecha de caducidad del bono
@param codigo: Código opcional del contrato. Si está vacío se comprueban todos.
\end */
function gym_facturar(codigo: String)
{
  var util: FLUtil = new FLUtil;
  var curContrato: FLSqlCursor = new FLSqlCursor("contratos");

  var filtro: String = "estado = 'Vigente'";
  if (codigo && codigo != "") {
    filtro += " AND codigo = '" + codigo + "'";
  }

  var fechaCaducidad: String;
  var hoy: Date = new Date;
  var nombreCliente: String;
  var datosContrato: String;
  curContrato.select();
  while (curContrato.next()) {
    fechaCaducidad = util.sqlSelect("bonosgym", "fechacaducidad", "codcontrato = '" + curContrato.valueBuffer("codigo") + "'");
    if (!fechaCaducidad) {
      continue;
    }
    if (util.daysTo(hoy, fechaCaducidad) >= 0) {
      continue;
    }

    nombreCliente = util.sqlSelect("clientes", "nombre", "codcliente = '" + curContrato.valueBuffer("codcliente") + "'");
    datosContrato = curContrato.valueBuffer("codigo") + " - " + curContrato.valueBuffer("codcliente") + " - " + nombreCliente + "\n";

    var res: Number = MessageBox.information(util.translate("scripts", "El siguiente contrato tiene como fecha de caducidad %1. ¿Desea marcarlo como Caducado?").arg(util.dateAMDtoDMA(fechaCaducidad)) + "\n" + datosContrato, MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      continue;
    }
    curContrato.setModeAccess(curContrato.Edit);
    curContrato.refreshBuffer();
    curContrato.setValueBuffer("estado", "Caducado");
    if (!curContrato.commitBuffer()) {
      return false;
    }
  }

  this.iface.__facturar(codigo);
}

//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
