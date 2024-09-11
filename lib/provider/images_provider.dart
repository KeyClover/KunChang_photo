import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:kunchang_photo/models/images_retrieve_model.dart';
import 'package:kunchang_photo/models/images_upload_model.dart';
import 'package:kunchang_photo/database/images_db_sqlite.dart';
import 'package:kunchang_photo/database/data_result_api.dart';

class ImagesProvider with ChangeNotifier {
  List<ImageRetrieveModel> _images = [];
  Map<String, List<File>> _selectedImageFiles = {};
  final RestDataSource _apiService = RestDataSource();

  List<ImageRetrieveModel> get images => _images;
  Map<String, List<File>> get selectedImageFiles => _selectedImageFiles;

  void addSelectedImageFile(String field, File imageFile) {
    if (_selectedImageFiles[field] == null) {
      _selectedImageFiles[field] = [];
    }
    _selectedImageFiles[field]!.add(imageFile);
    notifyListeners();
  }

  void clearSelectedImageFile(String field) {
    _selectedImageFiles[field]?.clear();
    notifyListeners();
  }

  Future<void> uploadImagesToAPI(FileUploadPost fileUploadPost) async {
    try {
      await _apiService.uploadImageToAPI(fileUploadPost);
    } catch (e) {
      print('Error uploading images to API: $e');
      throw e;
    }
  }

  Future<List<ImageRetrieveModel>> fetchImagesFromAPI() async {
    try {
      _images = await _apiService.fetchImagesFromAPI(953698391);
      notifyListeners();
      return _images;
    } catch (e) {
      print('Error fetching images from API: $e');
      throw e;
    }
  }
}

// TO-DO create a delete function 