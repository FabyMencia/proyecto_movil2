import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:proyecto_libreria/model/Users.dart';
import 'Databasehelper.dart';
class UsuarioDB {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Listar todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await _databaseHelper.database;
    return await db.query(DatabaseHelper.usuarioTable);
  }

  // Insertar un usuario
  Future<int> insertUser(Users user) async {
    Database db = await _databaseHelper.database;
    // Convertir de la estructura de Users a la estructura de la base de datos
    var map = <String, dynamic>{
      DatabaseHelper.colIdUsuario: user.userid,
      DatabaseHelper.colNombre: user.nombre,
      DatabaseHelper.colApellido: user.apellido,
      DatabaseHelper.colDescripcionUsuario: user.descripcion,
      DatabaseHelper.colIdGenero:
          1, // Por defecto, ya que user.genero es String
      DatabaseHelper.colPassword: user.password,
    };
    return await db.insert(DatabaseHelper.usuarioTable, map);
  }

  // Actualizar usuario
  Future<int> updateUser(Users user) async {
    Database db = await _databaseHelper.database;
    // Convertir de la estructura de Users a la estructura de la base de datos
    var map = <String, dynamic>{
      DatabaseHelper.colNombre: user.nombre,
      DatabaseHelper.colApellido: user.apellido,
      DatabaseHelper.colDescripcionUsuario: user.descripcion,
      DatabaseHelper.colIdGenero:
          1, // Por defecto, ya que user.genero es String
      DatabaseHelper.colPassword: user.password,
    };
    return await db.update(
      DatabaseHelper.usuarioTable,
      map,
      where: '${DatabaseHelper.colIdUsuario} = ?',
      whereArgs: [user.userid],
    );
  }

  // Eliminar usuario
  Future<int> deleteUser(String id) async {
    Database db = await _databaseHelper.database;
    return await db.delete(
      DatabaseHelper.usuarioTable,
      where: '${DatabaseHelper.colIdUsuario} = ?',
      whereArgs: [id],
    );
  }

  // Obtener usuario por ID
  Future<Users?> getUserById(String userid) async {
    try {
      Database db = await _databaseHelper.database;

      // Obtener datos de usuario con el género como String
      List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT u.${DatabaseHelper.colIdUsuario}, 
               u.${DatabaseHelper.colNombre}, 
               u.${DatabaseHelper.colApellido}, 
               u.${DatabaseHelper.colDescripcionUsuario}, 
               g.${DatabaseHelper.colUsuarioGenero}, 
               u.${DatabaseHelper.colPassword}
        FROM ${DatabaseHelper.usuarioTable} u
        LEFT JOIN ${DatabaseHelper.generoTable} g 
        ON u.${DatabaseHelper.colIdGenero} = g.${DatabaseHelper.colIdGenero}
        WHERE u.${DatabaseHelper.colIdUsuario} = ?
      ''',
        [userid],
      );

      if (result.isNotEmpty) {
        // Convertir al formato esperado por Users.fromMapObject
        var userMap = {
          'userid': result.first[DatabaseHelper.colIdUsuario],
          'name': result.first[DatabaseHelper.colNombre],
          'lastname': result.first[DatabaseHelper.colApellido],
          'description': result.first[DatabaseHelper.colDescripcionUsuario],
          'gender':
              result.first[DatabaseHelper.colUsuarioGenero] ?? 'Masculino',
          'password': result.first[DatabaseHelper.colPassword],
        };

        return Users.fromMapObject(userMap);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Verificar credenciales de usuario (login)
  Future<Users?> validateUser(String userid, String password) async {
    try {
      Database db = await _databaseHelper.database;

      List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT u.${DatabaseHelper.colIdUsuario}, 
               u.${DatabaseHelper.colNombre}, 
               u.${DatabaseHelper.colApellido}, 
               u.${DatabaseHelper.colDescripcionUsuario}, 
               g.${DatabaseHelper.colUsuarioGenero}, 
               u.${DatabaseHelper.colPassword}
        FROM ${DatabaseHelper.usuarioTable} u
        LEFT JOIN ${DatabaseHelper.generoTable} g 
        ON u.${DatabaseHelper.colIdGenero} = g.${DatabaseHelper.colIdGenero}
        WHERE u.${DatabaseHelper.colIdUsuario} = ? AND u.${DatabaseHelper.colPassword} = ?
      ''',
        [userid, password],
      );

      if (result.isNotEmpty) {
        // Convertir al formato esperado por Users.fromMapObject
        var userMap = {
          'userid': result.first[DatabaseHelper.colIdUsuario],
          'name': result.first[DatabaseHelper.colNombre],
          'lastname': result.first[DatabaseHelper.colApellido],
          'description': result.first[DatabaseHelper.colDescripcionUsuario],
          'gender':
              result.first[DatabaseHelper.colUsuarioGenero] ?? 'Masculino',
          'password': result.first[DatabaseHelper.colPassword],
        };

        return Users.fromMapObject(userMap);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
