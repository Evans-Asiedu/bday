import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bdayapp/src/models/person_model.dart';

class DBHandler{
  DBHandler._();

  static final DBHandler db = DBHandler._();

  static const dbNAME = 'bday.db';
  static const table = 'PersonsTable';
  static const String id = 'id';
  static const String name = 'name';
  static const String dateOfBirth = 'dateOfBirth';
  static const String photoOfPerson = 'photoOfPerson';
  static const String relationship = 'relationship';

  static Database? _database;

  Future<Database> get database async{
    // ignore: unrelated_type_equality_checks
    if(_database != null){
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  // initialize the database table
  initDB() async{
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbNAME);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onOpen: (db){});
    return db;
  }

  // create the database table
  _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE $table ('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT,'
        '$dateOfBirth TEXT,'
        '$photoOfPerson TEXT,'
        '$relationship TEXT)'
    );
  }

  //save person
  Future<int> addPerson(Person person) async{
    var dbClient = await database;
    int personId = await dbClient.insert(table, person.toMap());
    return personId;
  }

  //edit person
  Future <int> editPerson(Person person, int id) async{
    var dbClient = await database;
    int personId = await dbClient.update(
      table, person.toMap(),
      where: "id = ?",
      whereArgs: [id]
    );
    return personId;
  }

  //sort all persons
  Future<List<Person>> getAllPersonsSorted() async{
    var dbClient = await database;
    var result = await dbClient.rawQuery("SELECT * FROM $table ORDER BY $name");
    List<Person> sortedList = result.isNotEmpty ?
      result.map((person) => Person.fromMap(person)).toList() : [];
    return sortedList;
  }

  //get all persons
  Future <List<Person>> getAllPersons() async{
    var dbClient = await database;
    var result = await dbClient.query(table);
    List<Person> list = result.isNotEmpty ?
        result.map((person) => Person.fromMap(person)).toList() : [];
    return list;
  }

  //get person
  Future<Person> getPerson(int id) async{
    var dbClient = await database;
    var result = await dbClient.query(table, where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Person.fromMap(result.first) : Person.empty();
  }

  // delete person
  Future<int> deletePerson(int id) async{
    var dbClient = await database;
    var personId = await dbClient.delete(table, where: "id = ?", whereArgs: [id]);
    return personId;
  }

  // close database
  Future<void> close() async{
    var dbClient = await database;
    return dbClient.close();
  }

} // end of database handler