class Favorito {
  int? _idFavorito;
  late String _idUsuario;
  late int _idLibro;
  late bool _esFavorito;

  Favorito(
    this._idUsuario,
    this._idLibro,
    this._esFavorito,
    {int? idFavorito}
  ) {
    this._idFavorito = idFavorito;
  }

  // Getters
  int? get idFavorito => _idFavorito;
  String get idUsuario => _idUsuario;
  int get idLibro => _idLibro;
  bool get esFavorito => _esFavorito;

  // Setters
  set idFavorito(int? newIdFavorito) {
    this._idFavorito = newIdFavorito;
  }
  
  set idUsuario(String newIdUsuario) {
    if (newIdUsuario.isNotEmpty) {
      this._idUsuario = newIdUsuario;
    }
  }

  set idLibro(int newIdLibro) {
    this._idLibro = newIdLibro;
  }

  set esFavorito(bool newEsFavorito) {
    this._esFavorito = newEsFavorito;
  }

  // Conversión a Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_usuario': _idUsuario,
      'id_libro': _idLibro,
      'es_favorito': _esFavorito ? 1 : 0,
    };

    if (_idFavorito != null) {
      map['id_favorito'] = _idFavorito;
    }

    return map;
  }

  // Constructor desde Map (para leer de la base de datos)
  Favorito.fromMapObject(Map<String, dynamic> map) {
    this._idFavorito = map['id_favorito'];
    this._idUsuario = map['id_usuario'];
    this._idLibro = map['id_libro'];
    this._esFavorito = map['es_favorito'] == 1;
  }
}