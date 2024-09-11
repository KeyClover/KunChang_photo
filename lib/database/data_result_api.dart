import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kunchang_photo/models/images_retrieve_model.dart';
import 'package:kunchang_photo/models/images_upload_model.dart';

class RestDataSource {
  String baseAPI = 'http://203.150.53.11:9001/CSCPlusAPIdev/api/';

  String GetFile({required int id}) {
    return '${baseAPI}FileUpload/GetFile?id=$id';
  }

  String GetListFile({required int docId}) {
    return '${baseAPI}FileUpload/GetListFile?docId=$docId';
  }

  String PostMultiFiles() {
    return '${baseAPI}FileUpload/PostMultiFiles';
  }

  Future<void> uploadImageToAPI(FileUploadPost fileUploadPost) async {
    final String baseUrl = PostMultiFiles();
    final Uri apiUrl = Uri.parse('$baseUrl?docId=${fileUploadPost.docId}&imageType=${fileUploadPost.imageType}&createBy=${fileUploadPost.createBy}');

    var request = http.MultipartRequest('POST', apiUrl);
    
    if (fileUploadPost.files != null) {
      for (var filePath in fileUploadPost.files!) {
        var file = await http.MultipartFile.fromPath('files', filePath);
        request.files.add(file);
      }
    }

    try {
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        print('Response: $responseBody');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        print('Response: $responseBody');
        throw Exception('Failed to upload images: ${response.statusCode}\nResponse: $responseBody');
      }
    } catch (e) {
      print('Error during image upload: $e');
      throw Exception('Error during image upload: $e');
    }
  }

  Future<List<ImageRetrieveModel>> fetchImagesFromAPI(int docId) async {
    final response = await http.get(Uri.parse(GetListFile(docId: docId)));

    if (response.statusCode == 200) {
      final List<dynamic> imageList = jsonDecode(response.body);
      return imageList.map((json) => ImageRetrieveModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}

