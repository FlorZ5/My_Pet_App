class Vacuna {
  final int? idVacuna;
  final String nombre;
  final String dosis;
  final String marca;
  final String fecha;
  final int idUsuario;

  Vacuna({this.idVacuna, required this.nombre, required this.dosis, required this.marca, required this.fecha, required this.idUsuario});

  // Convertir a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'idVacuna': idVacuna,
      'nombre': nombre,
      'dosis': dosis,
      'marca': marca,
      'fecha': fecha,      
      'idUsuario': idUsuario,
    };
  }

  // Convertir de mapa a objeto Vacuna
  factory Vacuna.fromMap(Map<String, dynamic> map) {
    return Vacuna(
      idVacuna: map['idVacuna'],
      nombre: map['nombre'],
      dosis: map['dosis'],
      marca: map['marca'],
      fecha: map['fecha'],
      idUsuario: map['idUsuario'],
    );
  }
}
