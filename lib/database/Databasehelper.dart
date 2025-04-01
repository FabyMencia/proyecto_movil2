import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHelper {
  // Nombres de tablas
  static const String usuarioTable = 'usuario';
  static const String libroTable = 'libro';
  static const String autorTable = 'autor';
  static const String categoriaTable = 'categoria';
  static const String generoTable = 'genero';
  static const String descargasTable = 'descargas';
  static const String favoritosTable = 'favoritos';

  // Columnas para usuario
  static const String colIdUsuario = 'id_usuario';
  static const String colNombre = 'nombre';
  static const String colApellido = 'apellido';
  static const String colDescripcionUsuario = 'descripcion_usuario';
  static const String colIdGenero = 'id_genero';
  static const String colPassword = 'password';

  // Columnas para libro
  static const String colIdLibro = 'id_libro';
  static const String colIsbn = 'isbn';
  static const String colTitulo = 'titulo';
  static const String colIdAutor = 'id_autor';
  static const String colIdCategoria = 'id_categoria';
  static const String colSinopsis = 'sinopsis';
  static const String colAnoPublicacion = 'ano_publicacion';
  static const String colPdfLibro = 'pdf_libro';
  static const String colImagenLibro = 'imagen_libro';

  // Columnas para autor
  static const String colNombreAutor = 'nombre_autor';

  // Columnas para categoria
  static const String colNombreCategoria = 'nombre_categoria';

  // Columnas para genero
  static const String colUsuarioGenero = 'usuario_genero';

  // Columnas para descargas
  static const String colIdDescarga = 'id_descarga';
  static const String colFechaDescarga = 'fecha_descarga';

  // Columnas para favoritos
  static const String colIdFavorito = 'id_favorito';
  static const String colEsFavorito = 'es_favorito';

  static late DatabaseHelper _databaseHelper = DatabaseHelper._createInstance();
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // La variable _databaseHelper ya está inicializada con late, así que no se necesita verificar si es null
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDataBase();
    return _database!;
  }

  Future<Database> _initializeDataBase() async {
    try {
      // Configurar la fábrica de base de datos según la plataforma
      if (kIsWeb) {
        // Web: Use `sqflite_common_ffi_web`
        databaseFactory = databaseFactoryFfiWeb;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop: Use `sqflite_common_ffi`
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      String path = join(await getDatabasesPath(), 'library.db');

      return await openDatabase(path, version: 1, onCreate: _createDB);
    } catch (e) {
      rethrow;
    }
  }

  void _createDB(Database db, int version) async {
    try {
      // Crear tabla genero
      await db.execute('''
        CREATE TABLE $generoTable (
          $colIdGenero INTEGER PRIMARY KEY AUTOINCREMENT,
          $colUsuarioGenero TEXT
        )
      ''');

      // Crear tabla usuario
      await db.execute('''
        CREATE TABLE $usuarioTable (
          $colIdUsuario TEXT PRIMARY KEY,
          $colNombre TEXT,
          $colApellido TEXT,
          $colDescripcionUsuario TEXT,
          $colIdGenero INTEGER,
          $colPassword TEXT,
          FOREIGN KEY ($colIdGenero) REFERENCES $generoTable ($colIdGenero)
        )
      ''');

      // Crear tabla autor
      await db.execute('''
        CREATE TABLE $autorTable (
          $colIdAutor INTEGER PRIMARY KEY AUTOINCREMENT,
          $colNombreAutor TEXT
        )
      ''');

      // Crear tabla categoria
      await db.execute('''
        CREATE TABLE $categoriaTable (
          $colIdCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
          $colNombreCategoria TEXT
        )
      ''');

      // Crear tabla libro
      await db.execute('''
        CREATE TABLE $libroTable (
          $colIdLibro INTEGER PRIMARY KEY AUTOINCREMENT,
          $colIsbn TEXT UNIQUE,
          $colTitulo TEXT,
          $colIdAutor INTEGER,
          $colIdCategoria INTEGER,
          $colSinopsis TEXT,
          $colAnoPublicacion INTEGER,
          $colPdfLibro TEXT,
          $colImagenLibro TEXT,
          FOREIGN KEY ($colIdAutor) REFERENCES $autorTable ($colIdAutor),
          FOREIGN KEY ($colIdCategoria) REFERENCES $categoriaTable ($colIdCategoria)
        )
      ''');

      // Crear tabla descargas
      await db.execute('''
        CREATE TABLE $descargasTable (
          $colIdDescarga INTEGER PRIMARY KEY AUTOINCREMENT,
          $colIdUsuario TEXT,
          $colIdLibro INTEGER,
          $colFechaDescarga TEXT,
          FOREIGN KEY ($colIdUsuario) REFERENCES $usuarioTable ($colIdUsuario),
          FOREIGN KEY ($colIdLibro) REFERENCES $libroTable ($colIdLibro)
        )
      ''');

      // Crear tabla favoritos
      await db.execute('''
        CREATE TABLE $favoritosTable (
          $colIdFavorito INTEGER PRIMARY KEY AUTOINCREMENT,
          $colIdUsuario TEXT,
          $colIdLibro INTEGER,
          $colEsFavorito INTEGER DEFAULT 0,
          FOREIGN KEY ($colIdUsuario) REFERENCES $usuarioTable ($colIdUsuario),
          FOREIGN KEY ($colIdLibro) REFERENCES $libroTable ($colIdLibro)
        )
      ''');

      await _insertInitialData(db);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _insertInitialData(Database db) async {
    try {
      // Insertar datos de ejemplo para genero
      await db.execute('''
        INSERT INTO $generoTable ($colUsuarioGenero) VALUES 
        ('Masculino'),
        ('Femenino'),
        ('Otro')
      ''');

      // Insertar datos de usuario de ejemplo
      await db.execute(
        '''
        INSERT INTO $usuarioTable ($colIdUsuario, $colNombre, $colApellido, $colDescripcionUsuario, $colIdGenero, $colPassword) 
        VALUES (?, ?, ?, ?, ?, ?)
      ''',
        [
          'user123',
          'John',
          'Doe',
          'Loves reading books',
          1,
          'securepassword123',
        ],
      );

      await db.execute(
        '''
        INSERT INTO $usuarioTable ($colIdUsuario, $colNombre, $colApellido, $colDescripcionUsuario, $colIdGenero, $colPassword) 
        VALUES (?, ?, ?, ?, ?, ?)
      ''',
        [
          'user12',
          'David',
          'Ruiz',
          'Soy una persona muy extrovertida y feliz',
          1,
          'securepassword123',
        ],
      );

      await db.execute(
        '''
        INSERT INTO $usuarioTable ($colIdUsuario, $colNombre, $colApellido, $colDescripcionUsuario, $colIdGenero, $colPassword) 
        VALUES (?, ?, ?, ?, ?, ?)
      ''',
        [
          'user1',
          'Luis',
          'Paz',
          'Nadie lee mas libros que yo soy un fanatico',
          1,
          'securepassword123',
        ],
      );

      // Insertar datos de ejemplo para autor
      await db.execute('''
        INSERT INTO $autorTable ($colNombreAutor) VALUES 
        ('Gabriel García Márquez'),
        ('J.K. Rowling'),
        ('Stephen King'),
        ('George Orwell'),
        ('Antoine de Saint-Exupéry'),
        ('J.R.R. Tolkien')
      ''');

      // Insertar datos de ejemplo para categoria
      await db.execute('''
        INSERT INTO $categoriaTable ($colNombreCategoria) VALUES 
        ('Ficción'),
        ('No ficción'),
        ('Ciencia Ficción'),
        ('Fantasía'),
        ('Terror'),
        ('Realismo mágico'),
        ('Literatura infantil'),
        ('Aventura'),
        ('Juvenil'),
        ('Fábula')
      ''');

      // Insertar datos de ejemplo para libros
      await db.execute('''
        INSERT INTO $libroTable 
        ($colIsbn, $colTitulo, $colIdAutor, $colIdCategoria, $colSinopsis, $colAnoPublicacion, $colImagenLibro) 
        VALUES 
        ('9780307474278', 'Cien años de soledad', 1, 6, 'La historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo.', 1967, 'https://via.placeholder.com/150'),
        ('9788478884957', 'Harry Potter y la piedra filosofal', 2, 9, 'El primer año de Harry Potter en la escuela de magia y hechicería Hogwarts.', 1997, 'https://via.placeholder.com/150'),
        ('9788497594257', 'El resplandor', 3, 5, 'Un escritor y su familia cuidan de un hotel aislado durante el invierno, donde una presencia siniestra influye en el padre hacia la violencia.', 1977, 'https://via.placeholder.com/150'),
        ('9788499890944', '1984', 4, 3, 'Una sociedad totalitaria donde el gobierno controla cada aspecto de la vida de las personas.', 1949, 'https://via.placeholder.com/150'),
        ('9788498381498', 'El principito', 5, 10, 'Un pequeño príncipe que viaja por el universo descubriendo la extraña manera en que los adultos ven la vida.', 1943, 'https://via.placeholder.com/150'),
        ('9788445073735', 'El señor de los anillos', 6, 8, 'Un hobbit debe destruir un anillo mágico para evitar que caiga en manos del Señor Oscuro.', 1954, 'https://via.placeholder.com/150')
      ''');

      // Insertar datos de ejemplo para favoritos
      await db.execute('''
        INSERT INTO $favoritosTable ($colIdUsuario, $colIdLibro, $colEsFavorito) VALUES 
        ('user123', 1, 1),
        ('user123', 6, 1),
        ('user123', 5, 1),
        ('user123', 2, 1),
        ('user12', 3, 1),
        ('user12', 4, 1),
        ('user1', 2, 1),
        ('user1', 5, 1)
      ''');
    } catch (e) {
      rethrow;
    }
  }
}
