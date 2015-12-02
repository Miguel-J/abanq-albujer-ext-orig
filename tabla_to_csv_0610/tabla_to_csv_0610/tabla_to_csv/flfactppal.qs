
/** @class_declaration tablaToCsv */
/////////////////////////////////////////////////////////////////
//// TABLA_TO_CSV //////////////////////////////////////////////
class tablaToCsv extends oficial
{
  function tablaToCsv(context)
  {
    oficial(context);
  }

  function toCsv(tabla, campos)
  {
    return this.ctx.tablaToCsv_toCsv(tabla, campos);
  }
  function openFile(fileName)
  {
    return this.ctx.tablaToCsv_openFile(fileName);
  }

  function formatValue(val, campo, tabla)
  {
    return this.ctx.tablaToCsv_formatValue(val, campo, tabla);
  }
}
//// TABLA_TO_CSV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubTablaToCsv */
/////////////////////////////////////////////////////////////////
//// PUB_TABLA_TO_CSV ///////////////////////////////////////////
class pubTablaToCsv extends ifaceCtx
{
  function pubTablaToCsv(context)
  {
    ifaceCtx(context);
  }
  function pub_toCsv(tabla, campos)
  {
    return this.toCsv(tabla, campos);
  }
  function pub_openFile(fileName)
  {
    return this.openFile(fileName);
  }
}
//// PUB_TABLA_TO_CSV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tablaToCsv */
/////////////////////////////////////////////////////////////////
//// TABLA_TO_CSV ///////////////////////////////////////////////
function tablaToCsv_toCsv(tabla, campos)
{
  var cur = new FLSqlCursor(tabla);
  if (!cur.select() || !cur.size())
    return;

  var dirExp = System.getenv("HOMEPATH");
  if (dirExp.isEmpty()) dirExp = System.getenv("HOME");
  if (dirExp.isEmpty()) dirExp = System.getenv("TMP");
  if (dirExp.isEmpty()) dirExp = System.getenv("TMPDIR");
  if (dirExp.isEmpty()) dirExp = System.getenv("TEMP");
  if (dirExp.isEmpty()) dirExp = System.getenv("HOMEDRIVE");

  var fileCsv = Dir.cleanDirPath(dirExp) + "/" + tabla + ".csv";
  var file = new File(fileCsv);

  try {
    file.open(File.WriteOnly);
  } catch (e) {
    debug(e);
    return;
  }

  var util = new FLUtil;
  var linea = "", contenido = "";
  var i, camposTabla;

  if (campos != undefined && !campos.isEmpty()) {
    camposTabla = campos.split(",");
  } else {
    camposTabla = util.nombreCampos(tabla);
    camposTabla.shift();
  }


  for (i = 0; i < camposTabla.length; ++i) {
    if (!linea.isEmpty())
      linea += ",";
    linea += camposTabla[i];
  }

  contenido += linea + "\n";

  while (cur.next()) {
    linea = "";
    for (i = 0; i < camposTabla.length; ++i) {
      if (!linea.isEmpty())
        linea += ",";
      linea += this.iface.formatValue(cur.valueBuffer(camposTabla[i]), camposTabla[i], tabla);
    }
    contenido += linea + "\n";
  }

  file.write(contenido + "\r\n");
  file.close();

  return fileCsv;
}

function tablaToCsv_openFile(fileName)
{
  var util = new FLUtil;

  if (util.getOS() == "WIN32")
    return Process.execute("explorer " + Dir.convertSeparators(fileName));
  else
    return Process.execute("xdg-open " + fileName);
}

function tablaToCsv_formatValue(val, campo, tabla)
{
  var util = new FLUtil;
  var tipoCampo = util.fieldType(campo, tabla);
  var ret = "";

  switch (tipoCampo) {
    case 26:
    case 27:
    case 3:
    case 4:
      ret = "\"" + val + "\"";
      break;
    case 19:
      ret = "\"" + util.formatoMiles(val) + "\"";
      break;
    default:
      ret = val.toString();
  }

  return ret;
}
//// TABLA_TO_CSV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
