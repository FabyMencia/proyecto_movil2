class Users {
  late String _userid;
  late String _nombre;
  late String _apellido;
  String? _descripcion;
  late String _genero;
  late String _password;

  Users(
    this._userid,
    this._nombre,
    this._apellido,
    this._genero,
    this._password, [
    this._descripcion,
  ]);
  String get userid => _userid;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get genero => _genero;
  String? get descripcion => _descripcion;
  String get password => _password;

  set userid(String newuser) {
    if (newuser.length <= 20) {
      this.userid = newuser;
    }
  }

  set password(String newpass) {
    if (newpass.length <= 20) {
      this._password = newpass;
    }
  }

  set nombre(String newname) {
    if (newname.length <= 15) {
      this._nombre = newname;
    }
  }

  set apellido(String newlname) {
    if (newlname.length <= 15) {
      this._apellido = newlname;
    }
  }

  set genero(String newgender) {
    if (newgender.length <= 20) {
      this._genero = newgender;
    }
  }

  set descirpcion(String? newdesc) {
    if (newdesc!.length <= 100) {
      this._descripcion = newdesc;
    }
  }

  // Esto convierte un usuario a un mapa para poder enviarlo a la base de datos
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['userid'] = _userid;
    map['password'] = _password;
    map['name'] = _nombre;
    map['lastname'] = _apellido;
    map['gender'] = _genero;
    map['description'] = _descripcion;
    return map;
  }

  //Esto extrae el usuario de la base de datos y lo convierte en un objeto para poder manipular
  Users.fromMapObject(Map<String, dynamic> map) {
    this._userid = map['userid'];
    this._nombre = map['name'];
    this._apellido = map['lastname'];
    this._genero = map['gender'];
    this._password = map['password'];
    this._descripcion = map['description'];
  }
}
