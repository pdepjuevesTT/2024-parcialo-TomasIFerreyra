import personas.*

class MedioConSaldo {
  var property saldo

  method puedePagar(persona, precio) = saldo >= precio
  
  method gastar(precio) {
    saldo -= precio
  }
}

object efectivo inherits MedioConSaldo(saldo = 0) {
  method sumarEfectivo(cantidad) {
    saldo += cantidad
  }
}

class Debito inherits MedioConSaldo {
  const propietarios = []

  method esPropietario(persona) = propietarios.contains(persona)

  override method puedePagar(persona, precio) = 
    super(persona, precio) and self.esPropietario(persona)
}

class Credito {
  const banco
  const cantCuotas
  const cuotasFuturas = []
  const cuotasPendientes = []

  method puedePagar(persona, precio) = banco.montoMax() >= precio

  method gastar(precio) {
    self.generarCuotasFuturas(precio)
  }

  method generarCuotasFuturas(precio) { // :(
    var mes = programa.mes() 
    var i = 0
    cantCuotas.times{
      mes += 1
      i += 1
      cuotasFuturas.add(new Cuota(mes = mes, numCuota = i, valor = precio, tarjeta = self))
    }
  }

  method pagarCuotas(dinero) {
    var resto = dinero
    cuotasPendientes.forEach{cuota => 
    if (cuota.pagar(resto))
      cuotasPendientes.remove(cuota)
      resto -= cuota.valorFinal()
    }
    efectivo.sumarEfectivo(resto)
    // if (resto == dinero) no se pago ninguna deuda
  }

  method totalCuotasImpagas() {
    cuotasPendientes.sum()
  }

  method actualizarDeudas(mes){
    cuotasFuturas.forEach{cuota => 
    if (cuota.mes() == mes) {
      cuotasFuturas.remove(cuota)
      cuotasPendientes.add(cuota)
    }
    }
  }
}

class CreditoPremium inherits Credito {
    override method puedePagar(persona, precio) = true // Sin monto maximo
}

object bancoCentral {
  const property interes = 2
}

class Banco {
  const property montoMax
}

class Cuota {
  const property mes
  const valor
  const numCuota
  const tarjeta

  method valorFinal() = (valor * bancoCentral.interes()) / tarjeta.cantCuotas()

  method pagar(resto) = resto >= self.valorFinal() 
}