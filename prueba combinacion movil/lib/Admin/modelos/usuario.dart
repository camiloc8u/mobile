class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String rol;
  final String numDoc; 
  final String estadoCuenta; 

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.rol,
    required this.numDoc,
    required this.estadoCuenta,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['idusuario'] ?? json['id'] ?? 0,
      nombre: json['primer_nombre'] ?? '',
      apellido: json['primer_apellido'] ?? '',
      correo: json['correo'] ?? '',
      rol: json['rol'] ?? 'Cliente',
      numDoc: json['num_doc']?.toString() ?? '', 
      estadoCuenta: json['estado_cuenta']?.toString() ?? 'Activo', 
    );
  }
}