class Cita {
  final int? idCita;
  final String fecha;
  final String hora;
  final String tipo;
  final int idUsuario;

  Cita({this.idCita, required this.fecha, required this.hora, required this.tipo, required this.idUsuario});

  // Convertir a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'idCita': idCita,
      'fecha': fecha,
      'hora': hora,
      'tipo': tipo,
      'idUsuario': idUsuario,
    };
  }

  // Convertir de mapa a objeto Cita
  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      idCita: map['idCita'],
      fecha: map['fecha'],
      hora: map['hora'],
      tipo: map['tipo'],
      idUsuario: map['idUsuario'],
    );
  }
}