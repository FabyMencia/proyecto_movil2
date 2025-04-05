import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Databasehelper.dart';

class BibliotecaDb {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Obtener lecturas del usuario (libros descargados)
  Future<List<Map<String, dynamic>>> getUserLecturas(String idUsuario) async {
  final db = await _databaseHelper.database;

  // Obtener los libros de la tabla de lecturas
  final List<Map<String, dynamic>> lecturas = await db.query(
    DatabaseHelper.lecturasTable,
    where: '${DatabaseHelper.colIdUsuario} = ?',
    whereArgs: [idUsuario],
  );

  print("Lecturas para $idUsuario: $lecturas"); 
  // Crear una lista para almacenar los libros
  List<Map<String, dynamic>> librosDetalles = [];

  for (var lectura in lecturas) {
    final libroId = lectura[DatabaseHelper.colIdLibro];
    final libro = await db.query(
      DatabaseHelper.libroTable,
      where: '${DatabaseHelper.colIdLibro} = ?',
      whereArgs: [libroId],
    );

    if (libro.isNotEmpty) {
      librosDetalles.add(libro[0]); // Agregar el libro a la lista de detalles
    }
  }

  return librosDetalles; // Devuelve la lista de libros que el usuario ha agregado a sus lecturas
}

  // Obtener Colecciones por categoría (libros descargados ordenados por categorías)
  Future<Map<String, List<Map<String, dynamic>>>> getUserColecciones(String usuarioId) async {
    final db = await _databaseHelper.database;

    // Obtener los libros de lecturas
    final List<Map<String, dynamic>> lecturas = await db.query(
      DatabaseHelper.lecturasTable,
      where: '${DatabaseHelper.colIdUsuario} = ?',
      whereArgs: [usuarioId],
    );

    // Crear un mapa para almacenar libros por categoría
    Map<String, List<Map<String, dynamic>>> colecciones = {};

    // Obtener todos los libros en una sola consulta
    for (var lectura in lecturas) {
      final libroId = lectura[DatabaseHelper.colIdLibro];
      final libro = await db.query(
        DatabaseHelper.libroTable,
        where: '${DatabaseHelper.colIdLibro} = ?',
        whereArgs: [libroId],
      );

      if (libro.isNotEmpty) {
        final categoriaId = libro[0][DatabaseHelper.colIdCategoria];
        final categoria = await db.query(
          DatabaseHelper.categoriaTable,
          where: '${DatabaseHelper.colIdCategoria} = ?',
          whereArgs: [categoriaId],
        );

        // Asegúrate de que categoriaNombre sea un String
        final categoriaNombre = categoria.isNotEmpty ? categoria[0][DatabaseHelper.colNombreCategoria] as String : 'Sin categoría';

        if (!colecciones.containsKey(categoriaNombre)) {
          colecciones[categoriaNombre] = [];
        }
        colecciones[categoriaNombre]!.add(libro[0]);
      }
    }

    return colecciones; // Devuelve un mapa de colecciones
  }

  // Obtener recomendaciones (libros sugeridos para el usuario)
  Future<List<Map<String, dynamic>>> getLibrosNoAgregados(String usuarioId) async {
    final db = await _databaseHelper.database;

    try {
      final List<Map<String, dynamic>> todosLosLibros = await db.query(DatabaseHelper.libroTable);
      print("Todos los libros: $todosLosLibros");

      final List<Map<String, dynamic>> librosAgregados = await db.query(
        DatabaseHelper.lecturasTable,
        where: '${DatabaseHelper.colIdUsuario} = ?',
        whereArgs: [usuarioId],
      );

      print("Libros agregados: $librosAgregados");

      final Set<int> idsLibrosAgregados = librosAgregados.map((libro) => libro[DatabaseHelper.colIdLibro] as int).toSet();
      print("IDs de libros agregados: $idsLibrosAgregados");

      final List<Map<String, dynamic>> librosNoAgregados = todosLosLibros.where((libro) {
        final libroId = libro[DatabaseHelper.colIdLibro] as int;
        return !idsLibrosAgregados.contains(libroId);
      }).toList();

      print("Libros no agregados: $librosNoAgregados");
      return librosNoAgregados;
    } catch (e) {
      print("Error al obtener libros no agregados: $e");
      return [];
    }
  }

  // Método para agregar un libro a las lecturas
  Future<void> agregarLibro(String userId, int libroId) async {
    final db = await _databaseHelper.database;

    try {
      await db.insert(
        'lecturas', 
        {
          'user_id': userId,
          'libro_id': libroId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace, 
      );
      print("Libro agregado: userId: $userId, libroId: $libroId");
    } catch (e) {
      print("Error al insertar en la base de datos: $e");
    }
  }

}