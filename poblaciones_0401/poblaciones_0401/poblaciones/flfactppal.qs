
/** @class_declaration pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
class pobla extends oficial
{
  function pobla(context)
  {
    oficial(context);
  }
  function obtenerPoblacion(formulario: Object, campoIdProv: String, campoProvincia: String, campoPais: String, campoIdPob: String, campoPoblacion: String)
  {
    return this.ctx.pobla_obtenerPoblacion(formulario, campoIdProv, campoProvincia, campoPais, campoIdPob, campoPoblacion);
  }
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pub_pobla */
/////////////////////////////////////////////////////////////////
//// PUB_POBLACIONES ////////////////////////////////////////////
class pub_pobla extends ifaceCtx
{
  function pub_pobla(context)
  {
    ifaceCtx(context);
  }
  function pub_obtenerPoblacion(formulario: Object, campoIdProv: String, campoProvincia: String, campoPais: String, campoIdPob: String, campoPoblacion: String)
  {
    return this.obtenerPoblacion(formulario, campoIdProv, campoProvincia, campoPais, campoIdPob, campoPoblacion);
  }
}
//// PUB_POBLACIONES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
/** \D Autocompleta la población cuando el usuario pulsa . u ofrece la lista de provincias que comienzan por el valor actual del campo para que el usuario elija
@param  formulario  Formulario que contiene el campo de provincia
@param  campoId Campo del id de provincia en base de datos
@param  campoProvincia Campo del valor de la provincia en base de datos
@param  campoPais Campo del código de país en base de datos
\end */
function pobla_obtenerPoblacion(formulario: Object, campoIdProv: String, campoProvincia: String, campoPais: String, campoIdPob: String, campoPoblacion: String)
{
  var util: FLUtil = new FLUtil;
  if (!campoIdPob) {
    campoIdPob = "idpoblacion";
  }
  if (!campoPoblacion) {
    campoPoblacion = "ciudad";
  }
  if (!campoIdProv) {
    campoIdProv = "idprovincia";
  }
  if (!campoProvincia) {
    campoProvincia = "provincia";
  }
  if (!campoPais) {
    campoPais = "codpais";
  }

  formulario.cursor().setNull(campoIdPob);
  var poblacion: String = formulario.cursor().valueBuffer(campoPoblacion);
  if (!poblacion || poblacion == "")
    return;

  if (poblacion.endsWith(".")) {
    //provincia = util.utf8(provincia);

    poblacion = poblacion.left(poblacion.length - 1);
    poblacion = poblacion.toUpperCase();

    var where: String = "UPPER(poblacion) LIKE '" + poblacion + "%'";

    var idProvincia: String = formulario.cursor().valueBuffer(campoIdProv);
    if (idProvincia && idProvincia != "")
      where += " AND idprovincia = " + idProvincia;

    var codPais: String = formulario.cursor().valueBuffer(campoPais);
    if (codPais && codPais != "")
      where += " AND codpais = '" + codPais + "'";

    var qryPoblacion: FLSqlQuery = new FLSqlQuery;
    with(qryPoblacion) {
      setTablesList("poblaciones");
      setSelect("idpoblacion, idprovincia, codpais");
      setFrom("poblaciones");
      setForwardOnly(true);
    }
    qryPoblacion.setWhere(where);

    if (!qryPoblacion.exec())
      return false;

    switch (qryPoblacion.size()) {
      case 0: {
        return;
      }
      case 1: {
        if (!qryPoblacion.first()) {
          return false;
        }
        formulario.cursor().setValueBuffer(campoIdPob, qryPoblacion.value("idpoblacion"));
        formulario.cursor().setValueBuffer(campoIdProv, qryPoblacion.value("idprovincia"));
        formulario.cursor().setValueBuffer(campoPais, qryPoblacion.value("codpais"));
        break;
      }
      default: {
        var listaPoblaciones: String = "";
        while (qryPoblacion.next()) {
          if (listaPoblaciones != "")
            listaPoblaciones += ", ";
          listaPoblaciones += qryPoblacion.value("idpoblacion");
        }
        var f: Object = new FLFormSearchDB("poblaciones");
        var curPoblaciones: FLSqlCursor = f.cursor();
        curPoblaciones.setMainFilter("idpoblacion IN (" + listaPoblaciones + ")");

        f.setMainWidget();
        var idPoblacion: String = f.exec("idpoblacion");

        if (idPoblacion) {
          formulario.cursor().setValueBuffer(campoIdPob, idPoblacion);
          formulario.cursor().setValueBuffer(campoIdProv, util.sqlSelect("poblaciones", "idprovincia", "idpoblacion = " + idPoblacion));
          formulario.cursor().setValueBuffer(campoPais, util.sqlSelect("poblaciones", "codpais", "idpoblacion = " + idPoblacion));
        }
        break;
      }
    }
  }
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
