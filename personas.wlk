import medioPago.*

object programa {
  var property mes = 0
  const personas = []

  method pasaMes() {
    personas.forEach{persona => persona.cobrarSueldo()}
    personas.forEach{persona => persona.actualizarDeudas(mes)}    
    mes += 1
  }

  method personaConMasCosas() { // :(
    const maximoCosas = personas.map{persona => persona.cantCosas()}.max()
    const personaConMasCosas = personas.removeAllSuchThat{persona => persona.cantCosas() != maximoCosas}
    return personaConMasCosas

  }
}

class Persona {
  var property formaFavorita
  const mediosDisponibles = [efectivo]
  var property cantCosas = 0
  var sueldo // No sabia como saber el sueldo

  method comprar(cosa) {
    if (formaFavorita.puedePagar(self, cosa.precio())) {
      formaFavorita.gastar(cosa.precio())
      cantCosas += 1
    }
  }

  method cambiarFormaPreferida(forma) {
    formaFavorita = forma
  }

  method cobrarSueldo() {
    self.pagarDeudas()
  }

  method pagarDeudas() {
    mediosDisponibles.filter{medio => 
      if (medio.esCredito()) {
       medio.pagarCuotas(sueldo)
      }  
    }
  }

  method actualizarDeudas(mes) {
    mediosDisponibles.filter{medio => medio.esCredito()}.actualizarDeudas(mes)
  }
}

class Cosa {
  const property precio
}

class CompradorCompulsivo inherits Persona {
  override method comprar(cosa) {
    if (formaFavorita.puedePagar(self, cosa.precio())) {
      formaFavorita.gastar(cosa.precio())
      cantCosas += 1
    } else {
      if (mediosDisponibles.any{medio => medio.puedePagar() medio.gastar(cosa.precio())})
        cantCosas += 1
    }
  }
}

class PagadorCompulsivo inherits Persona {
  override method pagarDeudas() {
    
  }
}