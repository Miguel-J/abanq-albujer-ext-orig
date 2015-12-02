
/** @class_declaration punteo */
/////////////////////////////////////////////////////////////////
//// PUNTEO /////////////////////////////////////////////////////
class punteo extends oficial
{
  function punteo(context)
  {
    oficial(context);
  }
  function fullyCalculateField(fieldName, cursor, tableName, queryName, orderBy)
  {
    return this.ctx.punteo_fullyCalculateField(fieldName, cursor, tableName, queryName, orderBy);
  }
}
//// PUNTEO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition punteo */
/////////////////////////////////////////////////////////////////
//// PUNTEO Y CASACIÓN //////////////////////////////////////////
function punteo_fullyCalculateField(fieldName, cursor, tableName, queryName, orderBy)
{
  var _i = this.iface;
  switch (queryName) {
    case "co_qry_punteo_partidas": {
      switch (fieldName) {
        case "saldo": {
          return _i.__fullyCalculateField(fieldName, cursor, tableName, "co_partidasmayor", orderBy);
          break;
        }
        default: {
          return _i.__fullyCalculateField(fieldName, cursor, tableName, queryName, orderBy);
        }
      }
      break;
    }
    default: {
      return _i.__fullyCalculateField(fieldName, cursor, tableName, queryName, orderBy);
    }
  }
  return undefined;
}
//// PUNTEO Y CASACIÓN //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
