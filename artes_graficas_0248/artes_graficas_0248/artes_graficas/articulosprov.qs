
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends oficial
{
  var bloqueoCoste: Boolean;
  function artesG(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.artesG_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.artesG_calculateField(fN);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.cursorRelation().valueBuffer("codfamilia") != "PAPE") {
    this.child("gbxArtesGraficas").enabled = false;
    this.iface.bloqueoCoste = false;
  }
  connect(cursor, "bufferChanged(String)", this, "iface.bufferChanged()");
}

function artesG_bufferChanged(fN: String)
{
  switch (fN) {
    case "coste": {
      if (!this.iface.bloqueoCoste) {
        this.iface.bloqueoCoste = true;
        this.child("fdbCosteResma").setValue(this.iface.calculateField("costeresma"));
        this.child("fdbCosteET").setValue(this.iface.calculateField("costeet"));
        this.iface.bloqueoCoste = false;
      }
      break;
    }
    case "costeresma": {
      if (!this.iface.bloqueoCoste) {
        this.iface.bloqueoCoste = true;
        this.child("fdbCoste").setValue(this.iface.calculateField("coste"));
        this.child("fdbCosteET").setValue(this.iface.calculateField("costeet"));
        this.iface.bloqueoCoste = false;
      }
      break;
    }
    case "costeet": {
      if (!this.iface.bloqueoCoste) {
        this.iface.bloqueoCoste = true;
        this.child("fdbCoste").setValue(this.iface.calculateField("coste2"));
        this.child("fdbCosteResma").setValue(this.iface.calculateField("costeresma"));
        this.iface.bloqueoCoste = false;
      }
      break;
    }
  }
}

function artesG_calculateField(fN: String): String {
  var res: String;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN)
  {
    case "coste": {
      res = parseFloat(cursor.valueBuffer("costeresma")) / 500;
      break;
    }
    case "coste2": {
      var curPapel: FLSqlCursor = cursor.cursorRelation();
      var ancho: Number = parseFloat(curPapel.valueBuffer("anchopliego"));
      if (isNaN(ancho) || ancho == 0) {
        res = 0;
        break;
      }
      var alto: Number = parseFloat(curPapel.valueBuffer("altopliego"));
      if (isNaN(alto) || alto == 0) {
        res = 0;
        break;
      }
      var gramaje: Number = parseFloat(curPapel.valueBuffer("gramaje"));
      if (isNaN(gramaje) || gramaje == 0) {
        res = 0;
        break;
      }
      res = parseFloat(cursor.valueBuffer("costeet")) * ((ancho / 100) * (alto / 100) * (gramaje * 0.000001));
      break;
    }
    case "costeresma": {
      res = parseFloat(cursor.valueBuffer("coste")) * 500;
      break;
    }
    case "costeet": {
      var curPapel: FLSqlCursor = cursor.cursorRelation();
      var ancho: Number = parseFloat(curPapel.valueBuffer("anchopliego"));
      if (isNaN(ancho) || ancho == 0) {
        res = 0;
        break;
      }
      var alto: Number = parseFloat(curPapel.valueBuffer("altopliego"));
      if (isNaN(alto) || alto == 0) {
        res = 0;
        break;
      }
      var gramaje: Number = parseFloat(curPapel.valueBuffer("gramaje"));
      if (isNaN(gramaje) || gramaje == 0) {
        res = 0;
        break;
      }
      res = parseFloat(cursor.valueBuffer("coste")) / ((ancho / 100) * (alto / 100) * (gramaje * 0.000001));
      break;
    }

  }
  return res;
}

//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
