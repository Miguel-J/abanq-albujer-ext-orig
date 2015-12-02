
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial
{
  function articuloscomp(context)
  {
    oficial(context);
  }
  function filtroBase(): String {
    return this.ctx.articuloscomp_filtroBase();
  }
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends articuloscomp
{
  function sofa(context)
  {
    articuloscomp(context);
  }
  function lanzarTarea()
  {
    return this.ctx.sofa_lanzarTarea();
  }
  function textChangedTarea(text: String)
  {
    return this.ctx.sofa_textChangedTarea(text);
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_filtroBase(): String {
  return "tipoobjeto IN ('lotesstock','pr_ordenesproduccion')";
}

//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////






/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////

function sofa_lanzarTarea()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idTarea: String = (this.iface.ledTarea.text).toString().toUpperCase();

  if (idTarea.startsWith("MO")) {
    var codTerminal: String;
    codTerminal = util.readSettingEntry("scripts/flprodppal/codCentroCoste");
    var codTipoCentro: String = util.sqlSelect("pr_centroscoste", "codtipocentro", "codcentro = '" + codTerminal + "'");
    var idTipoTarea: String = "";
    var modulo: String = idTarea.left(10);
    switch (codTipoCentro) {
      case "CORTE": {
        idTipoTarea = "CORTE";
        break;
      }
      case "COSIDO": {
        var sufijo: String = idTarea.right(1);
        idTipoTarea = "COSIDO";
        if (sufijo != "M" && sufijo != "F")
          sufijo = "";

        idTipoTarea = idTipoTarea + sufijo;
        break;
      }
      case "MONTAJE": {
        idTipoTarea = "MONTAJE";
        break;
      }
      case "RELLENADO": {
        idTipoTarea = "RELLENO";
        break;
      }
      case "EMBALADO": {
        idTipoTarea = "EMBALADO";
        break;
      }
    }
    idTarea = util.sqlSelect("pr_tareas", "idtarea", "idtipotarea = '" + idTipoTarea + "' AND idobjeto = '" + modulo + "'");
  }

  cursor.setMainFilter("UPPER(idtarea) = '" + idTarea + "'");
  this.iface.tdbTareas.refresh();
  if (cursor.valueBuffer("idtarea") != idTarea) {
    MessageBox.warning(util.translate("scripts", "No hay ninguna tarea con código ") + idTarea, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.iface.ledTarea.text = "";
    this.iface.ledTarea.setFocus();
    this.iface.filtrarPendientes();
    return;
  }
  if (cursor.valueBuffer("estado") == "OFF") {
    MessageBox.warning(util.translate("scripts", "La tarea indicada (%1) no está activa.\nEsto es debido a que alguna de sus tareas precedentes todavía no ha terminado").arg(idTarea), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  this.iface.mostrarDatosTarea();
  this.iface.avanzarTarea()
}

/** \D
Filtrado del texto de la linea de edición de tareas para trabajar de forma rápida utilizando solamente el teclado númerico.
\end */
function sofa_textChangedTarea(text: String)
{
  var txt: String = text;

  /** \C Al introducir el carácter '/' al final del texto del campo de tarea, se borra el campo de tarea y el del trabajador, situando el foco en este último.
  \end */
  if (txt.endsWith("/")) {
    this.iface.lblTrabajador.text = "";
    this.iface.ledTarea.text = "";
    this.iface.ledTrabajador.text = "";
    this.iface.ledTrabajador.setFocus();
    this.iface.filtrarPendientes();
  }
  /** \C Al introducir el carácter '*' al final del texto del campo de tarea se cambia el contenido actual de este
  campo por la cadena 'TA'. La cadena 'TA' corresponde al prefijo utilizado en los códigos de tareas.
  \end */
  if (txt.endsWith("*")) {
    this.iface.ledTarea.text = "TA";
    this.iface.ledTarea.setFocus();
  }
  /** \C Al introducir el carácter '.' se reformatea el valor del código de la tareas reemplazando dicho el carácter "."
  por los ceros "0" necesarios hasta completar el número de dígitos total, a su vez elimina los caracteres sobrantes cuando se supere el límite de dígitos.
  \end */
  var limite: Number = 8;
  if (this.iface.ledTarea.text.startsWith("MO"))
    limite = 11;

  this.iface.posActualPuntoTarea = flcolaproc.iface.pub_formatearCodigo(this.iface.ledTarea, limite, this.iface.posActualPuntoTarea);
}
//// PROD_SOFA //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
