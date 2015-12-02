
/** @class_declaration diariomes */
/////////////////////////////////////////////////////////////////
//// DIARIOMES //////////////////////////////////////////////
class diariomes extends pgc2008
{
  var debeTotal;
  var haberTotal;
  var debeMes;
  var haberMes;
  function diariomes(context)
  {
    pgc2008(context);
  }
  function cabeceraInforme(nodo, campo)
  {
    return this.ctx.diariomes_cabeceraInforme(nodo, campo);
  }
  function inicializarTotalesDiario(nodo, campo)
  {
    return this.ctx.diariomes_inicializarTotalesDiario(nodo, campo);
  }
  function inicializarTotalesMes(nodo, campo)
  {
    return this.ctx.diariomes_inicializarTotalesMes(nodo, campo);
  }
  function mostrarMes(nodo, campo)
  {
    return this.ctx.diariomes_mostrarMes(nodo, campo);
  }
  function sumarDebeMes(nodo, campo)
  {
    return this.ctx.diariomes_sumarDebeMes(nodo, campo);
  }
  function sumarHaberMes(nodo, campo)
  {
    return this.ctx.diariomes_sumarHaberMes(nodo, campo);
  }
  function mostrarDebeTotal()
  {
    return this.ctx.diariomes_mostrarDebeTotal();
  }
  function mostrarHaberTotal()
  {
    return this.ctx.diariomes_mostrarHaberTotal();
  }
  function mostrarDebeMes()
  {
    return this.ctx.diariomes_mostrarDebeMes();
  }
  function mostrarHaberMes()
  {
    return this.ctx.diariomes_mostrarHaberMes();
  }
  function mostrarDescuadreMes()
  {
    return this.ctx.diariomes_mostrarDescuadreMes();
  }
  function mostrarDescuadreTotal()
  {
    return this.ctx.diariomes_mostrarDescuadreTotal();
  }
}
//// DIARIOMES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDiarioMes */
/////////////////////////////////////////////////////////////////
//// PUB_DIARIOMES ////////////////////////////////////////
class pubDiarioMes extends ifaceCtx
{
  function pubDiarioMes(context)
  {
    ifaceCtx(context);
  }
  function pub_inicializarTotalesDiario(nodo, campo)
  {
    return this.inicializarTotalesDiario(nodo, campo);
  }
  function pub_inicializarTotalesMes(nodo, campo)
  {
    return this.inicializarTotalesMes(nodo, campo);
  }
  function pub_mostrarMes(nodo, campo)
  {
    return this.mostrarMes(nodo, campo);
  }
  function pub_sumarDebeMes(nodo, campo)
  {
    return this.sumarDebeMes(nodo, campo);
  }
  function pub_sumarHaberMes(nodo, campo)
  {
    return this.sumarHaberMes(nodo, campo);
  }
  function pub_mostrarDebeTotal()
  {
    return this.mostrarDebeTotal();
  }
  function pub_mostrarHaberTotal()
  {
    return this.mostrarHaberTotal();
  }
  function pub_mostrarDebeMes()
  {
    return this.mostrarDebeMes();
  }
  function pub_mostrarHaberMes()
  {
    return this.mostrarHaberMes();
  }
  function pub_mostrarDescuadreMes()
  {
    return this.mostrarDescuadreMes();
  }
  function pub_mostrarDescuadreTotal()
  {
    return this.mostrarDescuadreTotal();
  }
}

//// PUB_DIARIOMES ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition diariomes */
/////////////////////////////////////////////////////////////////
//// DIARIOMES //////////////////////////////////////////////
function diariomes_cabeceraInforme(nodo, campo)
{
  var texCampo = new String(campo);

  var util: FLUtil = new FLUtil();
  var desc;
  var ejAct, ejAnt;

  var texto;
  var sep = "       ";

  var qCondiciones = new FLSqlQuery();

  qCondiciones.setTablesList(this.iface.nombreInformeActual);
  qCondiciones.setFrom(this.iface.nombreInformeActual);
  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (texCampo) {
    case "diariomes": {

      qCondiciones.
      setSelect
      ("descripcion,codejercicio,fechadesde,fechahasta");
      debug(qCondiciones.sql());
      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);

      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      texto = "[ " + desc + " ]" + sep +
              "Ejercicio " + ejAct + sep +
              "Periodo  " + fchDesde + " - " + fchHasta;

      break;
    }
    default: {
      return this.iface.__cabeceraInforme(nodo, campo);
    }
  }

  if (!texto)
    texto = "";

  return texto;
}

function diariomes_inicializarTotalesDiario(nodo, campo)
{
  this.iface.debeTotal = 0;
  this.iface.haberTotal = 0;
}

function diariomes_inicializarTotalesMes(nodo, campo)
{
  this.iface.debeMes = 0;
  this.iface.haberMes = 0;

  if (campo && campo != "")
    return nodo.attributeValue(campo)
  }

       function diariomes_mostrarMes(nodo, campo)
{
  return nodo.attributeValue(campo)
}

       function diariomes_sumarDebeMes(nodo, campo)
{
  var debe = parseFloat(nodo.attributeValue(campo))
             this.iface.debeMes += debe;
  this.iface.debeTotal += debe;

  return debe;
}

function diariomes_sumarHaberMes(nodo, campo)
{
  var haber = parseFloat(nodo.attributeValue(campo))
              this.iface.haberMes += haber;
  this.iface.haberTotal += haber;

  return haber;
}

function diariomes_mostrarDebeTotal()
{
  return this.iface.debeTotal;
}

function diariomes_mostrarHaberTotal()
{
  return this.iface.haberTotal;
}

function diariomes_mostrarDebeMes()
{
  return this.iface.debeMes;
}

function diariomes_mostrarHaberMes()
{
  return this.iface.haberMes;
}

function diariomes_mostrarDescuadreMes()
{
  return this.iface.debeMes - this.iface.debeMes;
}
function diariomes_mostrarDescuadreTotal()
{
  return this.iface.debeTotal - this.iface.debeTotal;
}
//// DIARIOMES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
