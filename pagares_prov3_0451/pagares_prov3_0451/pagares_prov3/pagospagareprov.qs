/***************************************************************************
                 pagospagareprov.qs  -  description
                             -------------------
    begin                : mie ene 31 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @ file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var ejercicioActual: String;
  var bloqueoSubcuenta: Boolean;
  var longSubcuenta: Number;
  var contabActivada: Boolean;
  var noGenAsiento: Boolean;
  function oficial(context)
  {
    interna(context);
  }
  function desconexion()
  {
    return this.ctx.oficial_desconexion();
  }
  function validateForm(): Boolean {
    return this.ctx.oficial_validateForm();
  }
  function acceptedForm()
  {
    return this.ctx.oficial_acceptedForm();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.oficial_calculateField(fN);
  }
  /*
    function bngTasaCambio_clicked(opcion:Number) {
      return this.ctx.oficial_bngTasaCambio_clicked(opcion);
    }
  */
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  //this.iface.bngTasaCambio = this.child("bngTasaCambio");
  //this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
  this.iface.noGenAsiento = false;

  this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  if (this.iface.contabActivada) {
    this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
  } else {
    this.child("tbwPagDevProv").setTabEnabled("contabilidad", false);
  }

  this.child("fdbTipo").setDisabled(true);
  //this.child("fdbTasaConv").setDisabled(true);
  this.child("tdbPartidas").setReadOnly(true);

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this, "closed()", this, "iface.desconexion");
  //connect(this.iface.bngTasaCambio, "clicked(int)", this, "iface.bngTasaCambio_clicked()");


  var curPagosDevol: FLSqlCursor = new FLSqlCursor("pagospagareprov");
  curPagosDevol.select("idpagare = " + cursor.cursorRelation().valueBuffer("idpagare") + " ORDER BY fecha, idpagodevol");
  var last: Boolean = false;
  if (curPagosDevol.last()) {
    last = true;
    curPagosDevol.setModeAccess(curPagosDevol.Browse);
    curPagosDevol.refreshBuffer();
    if (curPagosDevol.valueBuffer("nogenerarasiento") && curPagosDevol.valueBuffer("tipo") == "Pago") {
      this.iface.noGenAsiento = true;
      this.child("fdbNoGenerarAsiento").setValue(true);
    }
  }
  switch (cursor.modeAccess()) {
      /** \C
      En modo inserción. Los pagos y devoluciones funcionan de forma alterna: un nuevo pagarés generará un pago. El siguiente será una devolucion, después un pago y así sucesivamente
      */
    case cursor.Insert:
      if (last) {
        curPagosDevol.setModeAccess(curPagosDevol.Browse);
        curPagosDevol.refreshBuffer();
        if (curPagosDevol.valueBuffer("tipo") == "Pago") {
          this.child("fdbTipo").setValue("Devolución");
          this.child("fdbCodCuenta").setValue(util.sqlSelect("pagospagareprov", "codcuenta", "idpagare = " + cursor.valueBuffer("idpagare") + " AND tipo = 'Pago' ORDER BY fecha DESC"));
          if (this.iface.contabActivada) {
            this.child("fdbCodSubcuenta").setValue(util.sqlSelect("pagospagareprov", "codsubcuenta", "idpagare = " + cursor.valueBuffer("idpagare") + " AND tipo = 'Pago' ORDER BY fecha DESC"));
            //this.child("fdbCodCuenta").setDisabled(true);
            this.child("fdbIdSubcuenta").setDisabled(true);
            this.child("fdbCodSubcuenta").setDisabled(true);
          }
        } else {
          this.child("fdbTipo").setValue("Pago");
          this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
          /*
          if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
            this.child("fdbTasaConv").setDisabled(false);
            this.child("rbnTasaActual").checked = true;
            this.iface.bngTasaCambio_clicked(0);
          }
          */
        }
        this.child("fdbFecha").setValue(util.addDays(curPagosDevol.valueBuffer("fecha"), 1));
      } else {
        this.child("fdbTipo").setValue("Pago");
        this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
        if (this.iface.contabActivada) {
          this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
        }
        /*
        if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
          this.child("fdbTasaConv").setDisabled(false);
          this.child("rbnTasaActual").checked = true;
          this.iface.bngTasaCambio_clicked(0);
        }
        */
      }
      break;
    case cursor.Edit:
      if (cursor.valueBuffer("idsubcuenta") == "0")
        cursor.setValueBuffer("idsubcuenta", "");
      break;
  }
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////

function oficial_desconexion()
{
  disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  /** \C
  Si es una devolución, está activada la contabilidad y su pago correspondiente no genera asiento no puede generar asiento
  \end */
  if (this.iface.contabActivada && this.iface.noGenAsiento && this.cursor().valueBuffer("tipo") == "Devolución" && !this.child("fdbNoGenerarAsiento").value())
  {
    MessageBox.warning(util.translate("scripts", "No se puede generar el asiento de una devolución cuyo pago no tiene asiento asociado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  Si la contabilidad está integrada, se debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución
  \end */
  if (this.iface.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0))
  {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior
  \end */
  var curPagosDevol: FLSqlCursor = new FLSqlCursor("pagospagareprov");
  curPagosDevol.select("idpagare = " + cursor.cursorRelation().valueBuffer("idpagare") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
  if (curPagosDevol.last())
  {
    curPagosDevol.setModeAccess(curPagosDevol.Browse);
    curPagosDevol.refreshBuffer();
    if (util.daysTo(curPagosDevol.valueBuffer("fecha"), cursor.valueBuffer("fecha")) <= 0) {
      MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}

/** \C
Si se ha establecido un pago o devolución, la factura correspondiente al recibo se bloquea y no podrá editarse.
\end */
function oficial_acceptedForm()
{
  /*
    var cursor:FLSqlCursor = this.cursor();
    var idFactura:Number = cursor.cursorRelation().valueBuffer("idfactura");
    var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
    curFactura.select("idfactura = " + idFactura);

    if (curFactura.first())
      curFactura.setUnLock("editable", false);

    var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagospagareprov");
    curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
    if (curPagosDevol.last())
      curPagosDevol.setUnLock("editable", false);
  */
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
      /** \C
      Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
      \end */
    case "codsubcuenta":
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().endsWith(".")) {
        var codSubcuenta = this.child("fdbCodSubcuenta").value().toString();
        codSubcuenta = codSubcuenta.substring(0, codSubcuenta.length - 1);
        var numCeros: Number = this.iface.longSubcuenta - codSubcuenta.toString().length;
        for (var i: Number = 0; i < numCeros; i++)
          codSubcuenta += "0";
        this.iface.bloqueoSubcuenta = true;
        this.child("fdbCodSubcuenta").setValue(codSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length ==
          this.iface.longSubcuenta) {
        this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
      }
      break;
      /** \C
      Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como cuenta contable para el pago. La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
      \end */
      /*
          case "codcuenta":
          case "ctaentidad":
          case "ctaagencia":
      */
    case "cuenta":
      this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
      //this.child("fdbDc").setValue(this.iface.calculateField("dc"));
      break;
  }
}

function oficial_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var res: String;
  switch (fN)
  {
      /** \D
      La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
      \end */
    case "idsubcuentadefecto": {
      if (this.iface.contabActivada) {
        var codSubcuenta: String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
        if (codSubcuenta)
          res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
      }
      break;
    }
    case "idsubcuenta": {
      var codSubcuenta: String = cursor.valueBuffer("codsubcuenta").toString();
      if (codSubcuenta.length == this.iface.longSubcuenta)
        res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
      break;
    }
    /** \C
    La cuenta bancaria por defecto será la del pagaré.
    \end */
    case "codcuenta": {
      res = cursor.cursorRelation().valueBuffer("codcuenta");
      break;
    }
    /*
        case "dc": {
          var entidad = cursor.valueBuffer("ctaentidad");
          var agencia = cursor.valueBuffer("ctaagencia");
          var cuenta = cursor.valueBuffer("cuenta");
          if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty()
              && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
            var dc1 = util.calcularDC(entidad + agencia);
            var dc2 = util.calcularDC(cuenta);
            res = dc1 + dc2;
          }
          break;
        }
    */
  }
  return res;
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo de la factura original o del cambio actual de la divisa del recibo
@param  opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
/*
function oficial_bngTasaCambio_clicked(opcion:Number)
{
    var util:FLUtil = new FLUtil();
    var cursor:FLSqlCursor = this.cursor();
    switch (opcion) {
    case 0: // Tasa actual
        this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv",
            "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'"));
        break;
    case 1: // Tasa de la factura
        this.child("fdbTasaConv").setValue(util.sqlSelect("facturasprov", "tasaconv",
            "idfactura = " + cursor.cursorRelation().valueBuffer("idfactura")));
        break;
    }
}
*/

//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////







