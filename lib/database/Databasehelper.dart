import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:proyecto_libreria/model/Users.dart';

class DatabaseHelper {
   String usertable = 'user_table';
  String _userid = 'userid';
  String _nombre = 'name';
  String _apellido = 'lastname';
  String? _descripcion = 'description';
  String _genero = 'gender';
  String _password = 'password';
  static late DatabaseHelper _databaseHelper=DatabaseHelper._createInstance();
  static Database? _database;
 

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); // si no esta instanciada crea la instancia
    }
    return _databaseHelper;
  }
 Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDataBase();
    return _database!;
  }

  Future _initializeDataBase() async {
    DatabaseFactory dbFactory;
     if (kIsWeb) {
      // Web: Use `sqflite_common_ffi_web`
      dbFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: Use `sqflite_common_ffi`
      sqfliteFfiInit();
      dbFactory = databaseFactoryFfi;
    } else {
      // Mobile (Android/iOS): Use standard `sqflite`
      dbFactory = databaseFactory;
    }
     String path = join(await getDatabasesPath(), 'library.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $usertable ($_userid TEXT,$_nombre TEXT,$_apellido TEXT,$_descripcion TEXT,$_genero TEXT,$_password TEXT)',
    );
     await db.execute(
    'INSERT INTO $usertable ($_userid, $_nombre, $_apellido, $_descripcion, $_genero, $_password) VALUES (?, ?, ?, ?, ?, ?)',
    ['user123', 'John', 'Doe', 'Loves reading books', 'Male', 'securepassword123'],
  );
  await db.execute(
    'INSERT INTO $usertable ($_userid, $_nombre, $_apellido, $_descripcion, $_genero, $_password) VALUES (?, ?, ?, ?, ?, ?)',
    ['user12', 'David', 'Ruiz', 'Soy una persona muy extrovertida y feliz', 'Male', 'securepassword123'],
  );
  await db.execute(
    'INSERT INTO $usertable ($_userid, $_nombre, $_apellido, $_descripcion, $_genero, $_password) VALUES (?, ?, ?, ?, ?, ?)',
    ['user1', 'Luis', 'Paz', 'Nadie lee mas libros que yo soy un fanatico', 'Male', 'securepassword123'],
  );
  }

  //Listar todos los usuarios
  Future<List<Map<String, dynamic>>> getallUsers() async {
    Database db = await database;
    var result = await db.query(usertable);
    return result;
  }

  //Inserta un usuario
  Future<int> insertUser(Users user) async {
    Database db = await this.database;
    var result = await db.insert(usertable, user.toMap());
    return result;
  }

  //Actualizar usuario
  Future<int> updateUser(Users user) async {
    Database db = await this.database;
    var result = await db.update(
      usertable,
      user.toMap(),
      where: '$_userid = ?',
      whereArgs: [user.userid],
    );
    return result;
  }

  //Eliminar usuario
  Future<int> deleteUser(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete(
      'DELETE FROM $usertable WHERE $_userid = $id',
      [id],
    );
    return result;
  }

  //get number of object in database
  Future<int?> getcount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
      'SELECT COUNT(*) FROM $usertable',
    );
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
  // Fetch a specific user by ID
Future<Users?> getUserById(String userid) async {
  Database db = await database;
  List<Map<String, dynamic>> result = await db.query(
    'user_table',
    where: 'userid = ?',
    whereArgs: [userid],
  );

  if (result.isNotEmpty) {
    return Users.fromMapObject(result.first);
  } else {
    return null;
  }
}
}
