// Patrón singleton para el manejo de la sesión de usuario
class UserSession {
  UserSession._internal(); // Constructor privado (El "_" le otorga el private)
  static final UserSession _instance = UserSession._internal(); // Instanciado estático y único de la clase
  // Al usar factory, no se crea un objeto nueva, sino que se devuelve siempre la misma instancia
  // cada vez que alguien llama al constructor
  factory UserSession() => _instance;

  // Tipo? [nombreTipo] -> Atributo nulleable, puede empezar siendo null
  String? id;
  String? nombre;
  String? correo;
  String? fechaCreacion;
  bool? administrador;

  // Guardado de datos
  void guardarDatos(Map<String, dynamic> data) {
    id = data['id'];
    nombre = data['nombre'];
    correo = data['correo'];
    fechaCreacion = data['fechaCreacion'];
    administrador = data['administrador'];
  }
}