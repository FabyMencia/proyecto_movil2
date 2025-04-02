import 'package:sqflite/sqflite.dart';
import 'package:proyecto_libreria/database/Databasehelper.dart';

class LibroDB {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Buscar libros por título
  Future<List<Map<String, dynamic>>> searchBooks(
    String query, {
    int? categoryId,
  }) async {
    try {
      Database db = await _databaseHelper.database;

      // Consulta SQL con filtro por categoría si se proporciona
      String queryString = '''
      SELECT 
        l.${DatabaseHelper.colIdLibro}, 
        l.${DatabaseHelper.colIsbn}, 
        l.${DatabaseHelper.colTitulo}, 
        l.${DatabaseHelper.colIdAutor},
        l.${DatabaseHelper.colIdCategoria},
        l.${DatabaseHelper.colSinopsis}, 
        l.${DatabaseHelper.colAnoPublicacion}, 
        l.${DatabaseHelper.colPdfLibro}, 
        l.${DatabaseHelper.colImagenLibro}, 
        a.${DatabaseHelper.colNombreAutor}, 
        c.${DatabaseHelper.colNombreCategoria}
      FROM ${DatabaseHelper.libroTable} l
      INNER JOIN ${DatabaseHelper.autorTable} a ON l.${DatabaseHelper.colIdAutor} = a.${DatabaseHelper.colIdAutor}
      INNER JOIN ${DatabaseHelper.categoriaTable} c ON l.${DatabaseHelper.colIdCategoria} = c.${DatabaseHelper.colIdCategoria}
      WHERE l.${DatabaseHelper.colTitulo} LIKE ?
    ''';

      // Si se selecciona una categoría, agregamos el filtro por categoría
      if (categoryId != null) {
        queryString += ' AND l.${DatabaseHelper.colIdCategoria} = ?';
      }

      var result = await db.rawQuery(queryString, [
        '%$query%',
        if (categoryId != null) categoryId,
      ]);

      return result;
    } catch (e) {
      return [];
    }
  }
}
