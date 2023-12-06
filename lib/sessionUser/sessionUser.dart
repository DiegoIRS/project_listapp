class SessionUser {
  static int? _idEstudiante;
  static int? _idCarrera; // Añade esta línea para idCarrera
  static String? _nombre;
  static String? _correo;

  static int? get idEstudiante => _idEstudiante;
  static int? get idCarrera => _idCarrera; // Añade un getter para idCarrera
  static String? get nombre => _nombre;
  static String? get correo => _correo;

  static set idEstudiante(int? value) => _idEstudiante = value;
  static set idCarrera(int? value) => _idCarrera = value; // Añade un setter para idCarrera
  static set nombre(String? value) => _nombre = value;
  static set correo(String? value) => _correo = value;
}
