
/** @class_declaration servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
class servclinl extends serviciosCli
{
  function servclinl(context)
  {
    serviciosCli(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.servclinl_commonCalculateField(fN, cursor);
  }
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
function servclinl_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
    case "numlinea": {
      var tabla: String = cursor.table();
      var idTabla: String;
      var campoId: String;
      switch (tabla) {
        case "lineasservicioscli": {
          campoId = "idservicio";
          idTabla = cursor.valueBuffer("idservicio");

          valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " ORDER BY numlinea DESC"));
          if (isNaN(valor)) {
            valor = 0;
          }
          valor++;
          break;
        }
        default: {
          valor = this.iface.__commonCalculateField(fN, cursor);
          break;
        }
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }

  return valor;
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////
