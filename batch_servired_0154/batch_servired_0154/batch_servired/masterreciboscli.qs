
/** @class_declaration batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED //////////////////////////////////////////////

class batchServired extends oficial
{
  function batchServired(context)
  {
    oficial(context);
  }

  function init()
  {
    this.ctx.batchServired_init();
  }
  function volcarDesdeDiscoSR()
  {
    return this.ctx.batchServired_volcarADiscoSR();
  }
  function desRegistro(codReg: String): Array {
    return this.ctx.batchServired_desRegistro(codReg);
  }
  function procesarRegistro(reg: String, nombreFichero: String)
  {
    this.ctx.batchServired_procesarRegistro(reg, nombreFichero);
  }
}

//// BATCH_SERVIRED ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED /////////////////////////////////////////////

function batchServired_init()
{
  this.iface.__init();

  connect(this.child("pbnDesdeDiscoSR"), "clicked()", this, "iface.volcarDesdeDiscoSR");
}

function batchServired_volcarADiscoSR()
{
  var util: FLUtil = new FLUtil();
  var nombreFichero: String = FileDialog.getOpenFileName("*.*");

  if (!nombreFichero || nombreFichero.isEmpty()) {
    MessageBox.warning(util.translate("scripts", "Hay que indicar el fichero."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var contenido: String = File.read(nombreFichero);
  var file: Object = new File(nombreFichero);

  file.open(File.ReadOnly);

  util.createProgressDialog(util.translate("scripts", "Procesando resultado de operaciones con ServiRed..."), contenido.length);
  util.setProgress(1);

  var reg: String;
  var steps: Number;

  while (!file.eof) {
    reg = file.readLine();
    this.iface.procesarRegistro(reg, nombreFichero + ".log");
    steps += reg.length;
    util.setProgress(steps);
  }

  util.setProgress(contenido.length);
  util.destroyProgressDialog();

  file.close();

  var util: FLUtil = new FLUtil();
  MessageBox.information(util.translate("scripts", "Procesado fichero de ServiRed.\nEl registro de las operaciones se ha guardado en: \n\n%1\n\n").arg(nombreFichero + ".log"), MessageBox.Ok, MessageBox.NoButton);
}

function batchServired_desRegistro(codReg: String): Array {
  var ret: Array = [];

  switch (codReg)
  {
      //  ret["NOMBRE_CAMPO"] => LONGITUD
      //
      /** \D Registro de cabecera \end */
    case "91":
      // No necesario
      break;

      /** \D Registro de operaciones \end */
    case "92":
      ret["TIPO"] = 2;
      ret["IDENTIFICADOR"] = 12;
      ret["PEDIDO"] = 12;
      ret["PEDIDO_BASE"] = 12;
      ret["TIPO_OPERACION"] = 2;
      ret["FECHA_OPERACION"] = 21;
      ret["ESTADO"] = 1;
      ret["RESULTADO"] = 1;
      ret["COD_RESPUESTA"] = 6;
      break;

      /** \D Registro de totales \end */
    case "93":
      // No necesario
      break;
  }

  return ret;
}

function batchServired_procesarRegistro(reg: String, nombreFichero: String)
{
  if (!reg || reg.isEmpty())
    return;

  var codReg: String = reg.left(2);

  if (codReg != "92")
    return;

  var desReg: Array = this.iface.desRegistro(codReg);

  var identificador: String = reg.mid(2, desReg["IDENTIFICADOR"]);
  var tipoOp: String = reg.mid(26, desReg["TIPO_OPERACION"]);
  var estado: String = reg.mid(49, desReg["ESTADO"]);
  var resultado: String = reg.mid(50, desReg["RESULTADO"]);
  var codRespuesta: String = reg.mid(51, desReg["COD_RESPUESTA"]);
  var pedido: String = reg.mid(14, desReg["PEDIDO"]);

  var resreg: String;
  var codReciboHex: String = identificador.replace(/\$/g, "00").replace(/ /g, "");
  var codReciboL: String = codReciboHex.left(codReciboHex.length - 3);
  var codReciboR: String = codReciboHex.right(3);
  var codReciboN: Number = parseInt(codReciboL.mid(6, codReciboL.length - 6), 16);
  var codRecibo: String = codReciboL.left(6) + flfactppal.iface.pub_cerosIzquierda(codReciboN.toString(), 6).right(6) + codReciboR;

  resreg = "IDENTIFICADOR : " + identificador + " -> " + codRecibo;
  resreg += " TIPO_OPERACION : " + tipoOp;
  resreg += " ESTADO : " + estado;
  resreg += " RESULTADO : " + resultado;
  resreg += " COD_RESPUESTA : " + codRespuesta;
  resreg += " PEDIDO : " + pedido;

  if (estado == "F" && (resultado == "1" || resultado == "9")) {
    if (resultado == "1")
      resreg += "\r\n** DENEGADO ** ";
    else
      resreg += "\r\n** ERROR DE FORMATO ** ";

    var qryRecibos: FLSqlQuery = new FLSqlQuery;

    qryRecibos.setTablesList("reciboscli");
    qryRecibos.setSelect("idremesa,idrecibo");
    qryRecibos.setFrom("reciboscli");
    qryRecibos.setWhere("codigo = '" + codRecibo + "'");
    resreg += "=> ELIMINAR RECIBO ";
    if (qryRecibos.exec() && qryRecibos.next()) {
      resreg += "=> EXCLUYENDO RECIBO DE LA REMESA Nº : " + qryRecibos.value(0) + " ";
      if (formRecordremesas.iface.pub_excluirReciboRemesa(qryRecibos.value(1), qryRecibos.value(0)))
        resreg += "=> OK. RECIBO EXCLUIDO";
      else
        resreg += "=> ¡¡ ERROR GRAVE !! NO SE HA PODIDO EXCLUIR RECIBO DE LA REMESA Nº : " + qryRecibos.value(0) + " . HÁGALO MANUALMENTE";
    } else
      resreg += "=> ¡¡ ERROR GRAVE !! NO SE HA PODIDO ELIMINAR EL RECIBO. HÁGALO MANUALMENTE";
  } else {
    var util: FLUtil = new FLUtil();

    util.sqlUpdate("reciboscli", "pedido", pedido, "codigo = '" + codRecibo + "'");
    resreg += "\r\n-- AUTORIZADO -- ";
  }

  var fileName: String = nombreFichero;

  var file: Object = new File(fileName);
  file.open(File.WriteOnly | File.Append);

  file.write(resreg + "\r\n\r\n");

  file.close();
}

//// BATCH_SERVIRED //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
