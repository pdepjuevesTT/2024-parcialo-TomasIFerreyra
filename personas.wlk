import medioPago.*

object programa {
  var mes = 0
  const personas = []

  method pasaMes() {
    personas.forEach{persona => persona.cobrarSueldo()}
    mes += 1

  }
}

class Persona {
  var property formaFavorita
  const mediosDisponibles = [efectivo]
  var cantCosas
  var sueldo

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
    mediosDisponibles.filter{medio => medio.esCredito()}.pagarCuotas(sueldo)
  }
}

class Cosa {
  const property precio
}