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
  const cuotasPendientes = []

  method puedePagar(persona, precio) = banco.montoMax() >= precio

  method gastar(precio) {
    self.generarCuota(self.valorCuota(precio))
  }

  method valorCuota(precio) = (precio * bancoCentral.interes()) / cantCuotas // sacar

  method generarCuota(valor) {
    cuotasPendientes.add(new Cuota(mes = programa.mes, numCuota = 0, valor = valor, tarjeta = self))
  }

  method pagarCuotas(sueldo) {
    cuotasPendientes.forEach{cuota => cuota.pagar(sueldo)}
  }

  method totalCuotasImpagas(mes) {
    
  }
}

object bancoCentral {
  const property interes = 2
}

class Banco {
  const property montoMax
}

class Cuota {
  const mes
  var valor
  const numCuota
  const tarjeta

  method calcularValor() = (valor * bancoCentral.interes()) / tarjeta.cantCuotas()

  method pagar(sueldo) {
    if (sueldo >= valor) {
      valor = 0
      //sueldo -= valor

    }
  }
}