
/** @class_declaration funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

class funChile extends oficial
{
  function funChile(context)
  {
    oficial(context);
  }

  function init()
  {
    this.ctx.funChile_init();
  }
  function obtenerDV(rutBase: String): String {
    return this.ctx.funChile_obtenerDV(rutBase);
  }
  function esValidoRUT(rut: String): Boolean {
    return this.ctx.funChile_esValidoRUT(rut);
  }
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubChile */
/////////////////////////////////////////////////////////////////
//// PUB_CHILE //////////////////////////////////////////////////

class pubChile extends funChile
{
  function pubChile(context)
  {
    funChile(context);
  }
  function pub_obtenerDV(rutBase: String): String {
    return this.obtenerDV(rutBase);
  }
  function pub_esValidoRUT(rut: String): Boolean {
    return this.esValidoRUT(rut);
  }
}

//// PUB_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

function funChile_init()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("empresa", "id", "1 = 1"))
    return;

  this.iface.__init();

  var cursor: FLSqlCursor = new FLSqlCursor("impuestos");
  with(cursor) {
    setModeAccess(cursor.Insert);
    refreshBuffer();
    setValueBuffer("codimpuesto", "IVA19");
    setValueBuffer("descripcion", "I.V.A. 19%");
    setValueBuffer("iva", "19");
    setValueBuffer("recargo", "0");
    commitBuffer();
  }
  delete cursor;

  cursor = new FLSqlCursor("series");
  with(cursor) {
    setModeAccess(cursor.Insert);
    refreshBuffer();
    setValueBuffer("codserie", "BO");
    setValueBuffer("descripcion", "SERIE BOLETAS");
    commitBuffer();
  }
  delete cursor;

  cursor = new FLSqlCursor("secuenciasejercicios");
  var idSec: Number;
  with(cursor) {
    setModeAccess(cursor.Insert);
    refreshBuffer();
    setValueBuffer("codserie", "BO");
    setValueBuffer("codejercicio", "0001");
    idSec = valueBuffer("id");
    commitBuffer();
  }
  delete cursor;

  cursor = new FLSqlCursor("secuencias");
  with(cursor) {
    setModeAccess(cursor.Insert);
    refreshBuffer();
    setValueBuffer("id", idSec);
    setValueBuffer("nombre", "nfacturacli");
    setValueBuffer("valor", 1);
    commitBuffer();
    setModeAccess(cursor.Insert);
    refreshBuffer();
    setValueBuffer("id", idSec);
    setValueBuffer("nombre", "nfacturaprov");
    setValueBuffer("valor", 1);
    commitBuffer();
  }
  delete cursor;
}

function funChile_obtenerDV(rutBase: String): String {
  if (rutBase.length < 7)
    return "";

  var r: String = rutBase.toUpperCase().left(8);
  var dvr: String = "0";
  var suma: Number = 0;
  var mul: Number = 2;
  var res: Number = 0;
  var dvi: Number = 0;

  for (var i: Number = r.length - 1 ; i >= 0; i--)
  {
    suma += parseInt(r.charAt(i)) * mul;
    if (mul == 7)
      mul = 2;
    else
      mul++;
  }

  res = suma % 11;

  if (res == 1)
    dvr = "K";
  else if (res == 0)
    dvr = "0";
  else {
    dvi = 11 - res;
    dvr = dvi.toString();
  }

  return dvr;
}

function funChile_esValidoRUT(rut: String): Boolean {
  var regExp: RegExp = /(\d{7, 8})-([\dK])/;
  var dv: String;

  rut.toUpperCase().match(regExp, "");

  dv = this.iface.obtenerDV(regExp.capturedTexts[0])

  return (dv == regExp.capturedTexts[2]);
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

