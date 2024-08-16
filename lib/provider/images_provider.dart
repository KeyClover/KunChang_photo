import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:kunchang_photo/database/images_db_sqlite.dart';

class ImagesProvider with ChangeNotifier {
  List<ImagesModel> _images = [];

  late ImagesDB _imagesDB;
  Map<String, File?> _selectedImageFiles = {};

  List<ImagesModel> get images => _images;
  Map<String, File?> get selectedImageFiles => _selectedImageFiles;

  ImagesProvider() {
    _imagesDB = ImagesDB();
  }

  Future<void> addNewImages(ImagesModel images) async {
    await ImagesDB().insertImage(images);
    await fetchImages();
    notifyListeners();
  }

  Future<void> fetchImages() async {
    _images = await ImagesDB().getImageDB();
    notifyListeners();
  }

  void setSelectedImageFile(String field, File? file) async {
    _selectedImageFiles[field] = file;
    notifyListeners();
  }

  Future<void> deleteFromDatabase(String field) async {
    final imageFile = _selectedImageFiles[field];
    if (imageFile != null) {
      await imageFile.delete();

      final filePath = imageFile.path;
      await ImagesDB().deleteImage(field, filePath);

      _selectedImageFiles[field] = null;
      notifyListeners();
    }
  }
}
