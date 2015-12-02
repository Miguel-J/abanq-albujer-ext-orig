
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIO ///////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.gym_init();
  }
  function filtrarBono()
  {
    return this.ctx.gym_filtrarBono();
  }
  function validateForm(): Boolean {
    return this.ctx.gym_validateForm();
  }
  function comprobarBono(): Boolean {
    return this.ctx.gym_comprobarBono();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.gym_bufferChanged(fN);
  }
  function obtenerBono(): Boolean {
    return this.ctx.gym_obtenerBono();
  }
}
//// GIMNASIO ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIO ///////////////////////////////////////////////////
function gym_init()
{
  this.iface.__init();

  this.iface.filtrarBono();
}

function gym_filtrarBono()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codCliente: String = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + cursor.valueBuffer("codalumno") + "'");

  this.child("fdbCodBono").setFilter("codcliente = '" + codCliente + "'");
}

function gym_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.comprobarBono())
  {
    return false;
  }

  return true;
}

/** \D Comprueba que el cliente asociado al alumno sea el mismo que el asociado al bono
\end */
function gym_comprobarBono(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codBono: String = cursor.valueBuffer("codbono");
  if (!codBono || codBono == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar el código de bono"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var codClienteAlumno: String = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + cursor.valueBuffer("codalumno") + "'");
  var codClienteBono: String = util.sqlSelect("bonosgym", "codcliente", "codbono = '" + cursor.valueBuffer("codbono") + "'");

  if (codClienteAlumno != codClienteBono)
  {
    var nombreCA: String = util.sqlSelect("clientes", "nombre", "codcliente = '" + codClienteAlumno + "'");
    var nombreCB: String = util.sqlSelect("clientes", "nombre", "codcliente = '" + codClienteBono + "'");
    MessageBox.warning(util.translate("scripts", "El cliente asociado al alumno:\n%1 - %2\nes distinto del cliente asociado al bono:\n%3 - %4").arg(codClienteAlumno).arg(nombreCA).arg(codClienteBono).arg(nombreCB), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function gym_bufferChanged(fN: String)
{
  switch (fN) {
    case "codalumno": {
      this.iface.filtrarBono();
      this.iface.obtenerBono();
      break;
    }
    default: {
      //      this.iface.__bufferChanged(fN);
    }
  }
}

function gym_obtenerBono(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codAlumno: String = cursor.valueBuffer("codalumno");
  if (!util.sqlSelect("fo_alumnos", "codalumno", "codalumno = '" + codAlumno + "'"))
  {
    return false;
  }
  var curAlumno: FLSqlCursor = new FLSqlCursor("fo_alumnos");
  curAlumno.select("codalumno = '" + codAlumno + "'");
  if (!curAlumno.first())
  {
    return false;
  }
  var datos: Array = formRecordfo_sesiones.iface.datosAccesoSesionAlumno(cursor.cursorRelation(), curAlumno);
  if (!datos)
  {
    return false;
  }
  this.child("fdbCodBono").setValue(datos["codbono"]);
}
//// GIMNASIO ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
