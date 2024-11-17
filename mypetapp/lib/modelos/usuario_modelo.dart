class Usuario {
  int? idUsuario;
  String nombre;
  int  edad;
  String especie;
  String sexo;
  String raza;
  String color;
  double peso;
  String correo;
  String usuario;
  String password;

  Usuario({this.idUsuario, required this.nombre, required this.edad, required this.especie, required this.sexo, required this.raza, required this.color, required this.peso, required this.correo, required this.usuario, required this.password});
  
  Map<String, dynamic> toMap(){
    return{
      'idUsuario':idUsuario, 
      'nombre':nombre,
      'edad':edad,
      'especie':especie,
      'sexo':sexo,
      'raza':raza,
      'color':color,
      'peso':peso,
      'correo':correo,
      'usuario':usuario,
      'password':password
    };
  }
  factory Usuario.fromMap(Map<String, dynamic>map){
    return Usuario (
      idUsuario:map['idUsuario'],
      nombre:map['nombre'],
      edad: map['edad'],
      especie: map ['especie'],
      sexo: map ['sexo'],
      raza: map['raza'],
      color: map['color'],
      peso: map['peso'],
      correo: map['correo'],
      usuario: map['usuario'],
      password: map['password']
    );
  }
}