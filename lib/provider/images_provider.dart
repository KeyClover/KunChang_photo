import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:kunchang_photo/database/images_db_sqlite.dart';

class ImagesProvider with ChangeNotifier {
  List<ImagesModel> _images = [];
  late ImagesDB _imagesDB;
  Map<String, List<File>> _selectedImageFiles = {};

  List<ImagesModel> get images => _images;
  Map<String, List<File>> get selectedImageFiles => _selectedImageFiles;

  ImagesProvider() {
    _imagesDB = ImagesDB();
  }

  Future<void> addNewImages(ImagesModel images) async {
    await _imagesDB.insertImage(images);
    await fetchImages();
    notifyListeners();
  }

  Future<void> fetchImages() async {
    List<ImagesModel> imagesFromDB = await _imagesDB.getImageDB();
    _images = imagesFromDB;
    notifyListeners();
  }

  void addSelectedImageFile(String field, File imageFile) async {
     if (_selectedImageFiles[field] == null) {
        _selectedImageFiles[field] = [];
      }
      _selectedImageFiles[field]!.add(imageFile);
      notifyListeners();
  }

  Future<void> deleteFromDatabase(String field, int index) async {
    final imageFile = _selectedImageFiles[field]?[index];
    if (imageFile != null) {
      await imageFile.delete();

      final filePath = imageFile.path;
      await ImagesDB().deleteImage(field, filePath);

      _selectedImageFiles[field]?.removeAt(index);
      notifyListeners();
    }
  }

  void clearSelectedImageFile(String field) {
    _selectedImageFiles[field]?.clear();
    notifyListeners();
  }
}
