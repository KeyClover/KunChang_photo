import 'dart:io';

import 'package:kunchang_photo/pages/display_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:path/path.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
     int   result = await db.insert(imagesTable, images.toMap());

    // Save the images to the gallery
    await _saveImagesToGallery(images);

    return result;
  }

  Future<void> _saveImagesToGallery(ImagesModel images) async {
    // A list to hold all the image paths
    List<String?> allImagePaths = [
      ...?images.fieldcardImage,
      ...?images.frontImage,
      ...?images.backImage,
      ...?images.leftSide,
      ...?images.rightSide,
      ...?images.carRegistrationPlate,
      ...?images.chassis,
    ];

    // Save each image to the gallery
    for (String? imagePath in allImagePaths) {
      if (imagePath != null && imagePath.isNotEmpty) {
        await GallerySaver.saveImage(imagePath);
      }
    }
  }
  

  Future<List<ImagesModel>> getImageDB() async {
    
    Database db = await database;

    final List<Map<String, dynamic>> imagesMapList =  
        await db.query(imagesTable);

    return List.generate(imagesMapList.length, (index) {
      return ImagesModel.fromMap(imagesMapList[index]);
    });
  }
  
  Future<List<String>> fetchImagesFromGallery() async {
    final PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    if (permissionState.isAuth) {
      // Fetch images from the gallery
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );

      final List<AssetEntity> images = await albums[0].getAssetListPaged( page: 0, size: 100);

      // Retrieve file paths
      List<String> imagePaths = [];
      for (var image in images) {
        final File? file = await image.file;
        if (file != null) {
          imagePaths.add(file.path);
        }
      }
      return imagePaths;
    } else {
      // Handle permission denial
      return [];
    }
  }
  


  Future<int> deleteImage(String field, String filePath) async {
    Database db = await database;

    // Delete the image from the gallery
    //await File(filePath).delete();

    int result = await db.delete(
      imagesTable,
      where: '$field = ?',
      whereArgs: [filePath],
    );

    return result;
  }
}
