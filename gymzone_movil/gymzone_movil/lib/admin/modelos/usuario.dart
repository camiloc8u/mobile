class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String numDoc;
  final String rol;
  final String estadoCuenta;
  final String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numDoc,
    required this.rol,
    required this.estadoCuenta,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['idusuario'] ?? 0,
      nombre: json['primer_nombre'] ?? '',
      apellido: json['primer_apellido'] ?? '',
      numDoc: json['num_doc'] ?? '',
      rol: json['rol'] ?? 'Cliente',
      estadoCuenta: json['estado_cuenta'] ?? 'Activo',
      correo: json['correo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primer_nombre': nombre,
      'primer_apellido': apellido,
      'num_doc': numDoc,
      'rol': rol,
      'estado_cuenta': estadoCuenta,
      'correo': correo,
    };
  }
}