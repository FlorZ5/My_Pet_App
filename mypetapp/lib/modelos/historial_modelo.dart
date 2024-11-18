class Historial {
  final int? idHistorial;
  final String enfermedad;
  final String tratamiento;
  final String estadoTratamiento; // est
  final int idUsuario;

  Historial({this.idHistorial, required this.enfermedad, required this.tratamiento, required this.estadoTratamiento, required this.idUsuario});

  // Convertir a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'idHistorial': idHistorial,
      'enfermedad': enfermedad,
      'tratamiento': tratamiento,
      'estadoTratamiento': estadoTratamiento,
      'idUsuario': idUsuario,
    };
  }

  // Convertir de mapa a objeto Cita
  factory Historial.fromMap(Map<String, dynamic> map) {
    return Historial(
      idHistorial: map['idHistorial'],
      enfermedad: map['enfermedad'],
      tratamiento: map['tratamiento'],
      estadoTratamiento: map['estadoTratamiento'],
      idUsuario: map['idUsuario'],
    );
  }
}