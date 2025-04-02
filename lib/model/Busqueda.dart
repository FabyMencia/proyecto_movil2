class Libro {
  int? _idLibro;
  late String _isbn;
  late String _titulo;
  late int _idAutor;
  late int _idCategoria;
  late String _sinopsis;
  late int _anoPublicacion;
  late String _pdfLibro;
  late String _imagenLibro;

  Libro(
    this._isbn,
    this._titulo,
    this._idAutor,
    this._idCategoria,
    this._sinopsis,
    this._anoPublicacion,
    this._pdfLibro,
    this._imagenLibro, {
    int? idLibro,
  }) {
    this._idLibro = idLibro;
  }

  // Getters
  int? get idLibro => _idLibro;
  String get isbn => _isbn;
  String get titulo => _titulo;
  int get idAutor => _idAutor;
  int get idCategoria => _idCategoria;
  String get sinopsis => _sinopsis;
  int get anoPublicacion => _anoPublicacion;
  String get pdfLibro => _pdfLibro;
  String get imagenLibro => _imagenLibro;

  // Conversión a Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'isbn': _isbn,
      'titulo': _titulo,
      'id_autor': _idAutor,
      'id_categoria': _idCategoria,
      'sinopsis': _sinopsis,
      'ano_publicacion': _anoPublicacion,
      'pdf_libro': _pdfLibro,
      'imagen_libro': _imagenLibro,
    };

    if (_idLibro != null) {
      map['id_libro'] = _idLibro;
    }

    return map;
  }

  // Constructor desde Map (para leer de la base de datos)
  Libro.fromMapObject(Map<String, dynamic> map) {
    this._idLibro = map['id_libro'];
    this._isbn = map['isbn'];
    this._titulo = map['titulo'];
    this._idAutor = map['id_autor'];
    this._idCategoria = map['id_categoria'];
    this._sinopsis = map['sinopsis'];
    this._anoPublicacion = map['ano_publicacion'];
    this._pdfLibro = map['pdf_libro'];
    this._imagenLibro = map['imagen_libro'];
  }
}
