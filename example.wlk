class Nave {
  var velocidad = 0
  var direccion = 0
  var combustible = 0

  method initialize() {
    if (not velocidad.between(0, 100) ||
      not direccion.between(-10, 10))
      self.error("No se puede instanciar")
  }

  method acelerar(cuanto) {
    velocidad = 100000.min(velocidad + cuanto)
  }

  method desacelerar(cuanto) {
    velocidad = 0.max(velocidad - cuanto)
  }

  method irHaciaElSol() {
    direccion = 10
  }

  method escaparDelSol() {
    direccion = - 10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acercarseUnPocoAlSol() {
    direccion = 10.min(direccion + 1)
  }

  method alejarseUnPocoDelSol() {
    direccion = (-10).max(direccion - 1)
  }

  method prepararViaje() // metodo abstracto que obliga a todas las instancias a que lo definan.
  
  method accionAdicional(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  } 

  method cargarCombustible(unaCantidad) {
    combustible += unaCantidad
  }

  method descargarCombustible(unaCantidad) {
    combustible = 0.max(combustible - unaCantidad)
  }

  method estaTranquila() = combustible >= 4000 && velocidad <= 12000

  method recibirAmenaza() 

  
}

class NaveBaliza inherits Nave {
  var colorBaliza = "Verde"

  method cambiarColorDeBaliza(colorNuevo) {
    if (not ["Verde", "Rojo", "Azul"].contains(colorNuevo))
      self.error("No es un color permitido")  // Lanzar un error y corta la ejecucion. no continua con el codigo.
    colorBaliza = colorNuevo
  }

  override method prepararViaje() {
    self.accionAdicional()
    colorBaliza = "Verde"
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila() = super() && colorBaliza != "Rojo"

  override method recibirAmenaza(){ 
    self.escapar()
    self.avisar()
  }

  method escapar() {
    self.irHaciaElSol()
  }

  method avisar() { 
    self.cambiarColorDeBaliza("Rojo")
  }

}

class NavePasajeros inherits Nave {
  const property cantPasajeros
  var racionesComida = 0
  var racionesBebida = 0

  method cargarRacionesComida(unaCantidad){
    racionesComida += unaCantidad
  }

  method cargarRacionesBebida(unaCantidad){
    racionesBebida += unaCantidad
  }

  override method prepararViaje() {
    self.accionAdicional()
    self.cargarRacionesComida(4 * cantPasajeros)
    self.cargarRacionesBebida(6 * cantPasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method recibirAmenaza(){ 
    self.escapar()
    self.avisar()
  }

  method escapar() {
    velocidad = velocidad * 2
  }

  method avisar() { 
    racionesComida = racionesComida - cantPasajeros
    racionesBebida = racionesBebida - 2 * cantPasajeros
  }

}

class NaveHospital inherits NavePasajeros {
  var property quirofanosPreparados = false
  override method estaTranquila() = super() && not quirofanosPreparados

 override method recibirAmenaza() {
  super()
  quirofanosPreparados = true
 }
}

class NaveCombate inherits Nave {
  var visibilidad = true
  var misiles = false
  const mensajes = []

  method ponerseVisible(){
    visibilidad = true
  }
  method ponerseInvisible(){
    visibilidad = true
  }

  method estaInvisible() = visibilidad

  method desplegarMisiles(){
    misiles = true
  }

  method replegarMisiles(){
    misiles = false
  }

  method misilesDesplegados() = misiles

  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }

  method mensajesEmitidos() = mensajes

  method primerMensajeEmitido() = mensajes.first()
  
  method ultimoMensajeEmitido() = mensajes.last()

  method esEscueta() = not mensajes.any{m=> m.size() > 30}
  // method esEscueta() = mensajes.all{m=> m.size() <= 30}

  method emitioMensaje(mensaje) = mensajes.contains(mensaje)

  override method prepararViaje(){
    self.accionAdicional()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = super() && not misiles

    override method recibirAmenaza(){ 
    self.escapar()
    self.avisar()
  }

  method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  method avisar() { 
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveSigilosa inherits NaveCombate {
  override method estaTranquila() = super() && visibilidad

  override method recibirAmenaza() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}