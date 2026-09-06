class Clase {
  final String id;
  final String nombre;
  final String horario;
  final String entrenador;
  final String cupo;

  Clase({
    required this.id,
    required this.nombre,
    required this.horario,
    required this.entrenador,
    required this.cupo,
  });

  // Convierte el JSON de MockAPI a nuestro objeto de Dart
  factory Clase.fromJson(Map<String, dynamic> json) {
    return Clase(
      id: json['id']?.toString() ?? '', // MockAPI suele usar Strings para los IDs
      nombre: json['nombre'] ?? '',
      horario: json['horario'] ?? '',
      entrenador: json['entrenador'] ?? '',
      cupo: json['cupo']?.toString() ?? '',
    );
  }

  // Convierte nuestro objeto Dart a JSON para enviarlo a MockAPI
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'horario': horario,
      'entrenador': entrenador,
      'cupo': cupo,
    };
  }
}