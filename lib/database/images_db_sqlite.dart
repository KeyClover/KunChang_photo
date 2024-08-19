import 'package:sqflite/sqflite.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:path/path.dart';

class ImagesDB {
  static final ImagesDB _imagesDB = ImagesDB._internal();
  factory ImagesDB() => _imagesDB;

  static Database? _database;

  ImagesDB._internal();

  String imagesTable = 'KunChang_Picture';
  String colId = 'id';
  String colForeignKey = '0';
  String colFieldCardImage = 'fieldcardImage';
  String colFrontImage = 'frontImage';
  String colBackImage = 'backImage';
  String colLeftSide = 'leftSide';
  String colRightSide = 'rightSide';
  String colCarRegistrationPlate = 'carRegistrationPlate';
  String colChassis = 'chassis';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kunchangpicture.db');
    final kunChangDB = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return kunChangDB;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $imagesTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colFieldCardImage TEXT,
      $colFrontImage TEXT,
      $colBackImage TEXT,
      $colLeftSide TEXT,
      $colRightSide TEXT,
      $colCarRegistrationPlate TEXT,
      $colChassis TEXT
    )
  ''');
  }

  Future<int> insertImage(ImagesModel images) async {
    Database db = await database;
    // print('Inserting image: ${images.toMap()}'); // if not working delete this
    return await db.insert(imagesTable, images.toMap());
  }

  Future<List<ImagesModel>> getImageDB() async {
    
    Database db = await database;

    final List<Map<String, dynamic>> imagesMapList =
        await db.query(imagesTable);

    return List.generate(imagesMapList.length, (index) {
      return ImagesModel.fromMap(imagesMapList[index]);
    });
  }

  Future<int> deleteImage(String field, String filePath) async {
    Database db = await database;

    int result = await db.delete(
      imagesTable,
      where: '$field = ?',
      whereArgs: [filePath],
    );

    return result;
  }
}
