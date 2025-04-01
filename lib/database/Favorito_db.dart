import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Databasehelper.dart';
import 'package:proyecto_libreria/model/Favorito.dart';

class FavoritoDB {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Marcar/desmarcar libro como favorito usando el modelo Favorito
  Future<int> toggleFavorite(
    int idLibro,
    String idUsuario,
    bool isFavorite,
  ) async {
    try {
      Database db = await _databaseHelper.database;

      // Crear un objeto Favorito
      final favorito = Favorito(idUsuario, idLibro, isFavorite);

      // Verificar si ya existe un registro
      List<Map<String, dynamic>> existing = await db.query(
        DatabaseHelper.favoritosTable,
        where:
            '${DatabaseHelper.colIdLibro} = ? AND ${DatabaseHelper.colIdUsuario} = ?',
        whereArgs: [idLibro, idUsuario],
      );

      if (existing.isEmpty) {
        // Crear nuevo registro usando el modelo
        return await db.insert(DatabaseHelper.favoritosTable, favorito.toMap());
      } else {
        // Actualizar el ID del favorito existente
        favorito.idFavorito = existing.first[DatabaseHelper.colIdFavorito];

        // Actualizar registro existente usando el modelo
        return await db.update(
          DatabaseHelper.favoritosTable,
          favorito.toMap(),
          where: '${DatabaseHelper.colIdFavorito} = ?',
          whereArgs: [favorito.idFavorito],
        );
      }
    } catch (e) {
      return -1;
    }
  }

  // Obtener todos los favoritos del usuario como objetos Favorito con detalles adicionales del libro
  Future<List<Map<String, dynamic>>> getUserFavorites(String userId) async {
    try {
      Database db = await _databaseHelper.database;

      var result = await db.rawQuery(
        '''
        SELECT 
          f.${DatabaseHelper.colIdFavorito}, 
          f.${DatabaseHelper.colIdUsuario}, 
          f.${DatabaseHelper.colIdLibro},
          f.${DatabaseHelper.colEsFavorito},
          l.${DatabaseHelper.colTitulo}, 
          l.${DatabaseHelper.colImagenLibro},
          l.${DatabaseHelper.colAnoPublicacion},
          a.${DatabaseHelper.colNombreAutor},
          c.${DatabaseHelper.colNombreCategoria}
        FROM ${DatabaseHelper.favoritosTable} f
        INNER JOIN ${DatabaseHelper.libroTable} l ON f.${DatabaseHelper.colIdLibro} = l.${DatabaseHelper.colIdLibro}
        INNER JOIN ${DatabaseHelper.autorTable} a ON l.${DatabaseHelper.colIdAutor} = a.${DatabaseHelper.colIdAutor}
        INNER JOIN ${DatabaseHelper.categoriaTable} c ON l.${DatabaseHelper.colIdCategoria} = c.${DatabaseHelper.colIdCategoria}
        WHERE f.${DatabaseHelper.colIdUsuario} = ? AND f.${DatabaseHelper.colEsFavorito} = 1
      ''',
        [userId],
      );

      return result;
    } catch (e) {
      return [];
    }
  }

  // Insertar un nuevo favorito usando el modelo
  Future<int> insertFavorito(Favorito favorito) async {
    try {
      Database db = await _databaseHelper.database;
      return await db.insert(DatabaseHelper.favoritosTable, favorito.toMap());
    } catch (e) {
      return -1;
    }
  }

  // Actualizar un favorito existente usando el modelo
  Future<int> updateFavorito(Favorito favorito) async {
    try {
      if (favorito.idFavorito == null) {
        return -1;
      }

      Database db = await _databaseHelper.database;
      return await db.update(
        DatabaseHelper.favoritosTable,
        favorito.toMap(),
        where: '${DatabaseHelper.colIdFavorito} = ?',
        whereArgs: [favorito.idFavorito],
      );
    } catch (e) {
      return -1;
    }
  }

  // Eliminar un libro de favoritos
  Future<int> removeFavorite(int bookId, String userId) async {
    try {
      Database db = await _databaseHelper.database;

      return await db.delete(
        DatabaseHelper.favoritosTable,
        where:
            '${DatabaseHelper.colIdLibro} = ? AND ${DatabaseHelper.colIdUsuario} = ?',
        whereArgs: [bookId, userId],
      );
    } catch (e) {
      return -1;
    }
  }
}
