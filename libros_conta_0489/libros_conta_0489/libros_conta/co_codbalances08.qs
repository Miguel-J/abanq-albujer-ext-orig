
/** @class_declaration libros */
/////////////////////////////////////////////////////////////////
//// LIBROS CONTABLES ///////////////////////////////////////////
class libros extends oficial
{
  function libros(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.libros_commonCalculateField(fN, cursor);
  }
}
//// LIBROS CONTABLES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition libros */
/////////////////////////////////////////////////////////////////
//// LIBROS CONTABLES ///////////////////////////////////////////
function libros_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var res: String;
  switch (fN)
  {
    case "codcompleto1": {
      res = cursor.valueBuffer("naturaleza") + "-";
      if (!cursor.isNull("nivel1")) {
        res += cursor.valueBuffer("nivel1");
      }
      break;
    }
    case "codcompleto2": {
      res = cursor.valueBuffer("naturaleza") + "-";
      if (!cursor.isNull("nivel1")) {
        res += cursor.valueBuffer("nivel1");
      }
      res += "-";
      if (!cursor.isNull("nivel2")) {
        res += cursor.valueBuffer("nivel2");
      }
      break;
    }
    case "codcompleto3": {
      res = cursor.valueBuffer("naturaleza") + "-";
      if (!cursor.isNull("nivel1")) {
        res += cursor.valueBuffer("nivel1");
      }
      res += "-";
      if (!cursor.isNull("nivel2")) {
        res += cursor.valueBuffer("nivel2");
      }
      res += "-";
      if (!cursor.isNull("nivel3")) {
        res += cursor.valueBuffer("nivel3");
      }
      break;
    }
  }
  return res;
}
//// LIBROS CONTABLES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
