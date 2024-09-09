import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> uploadImageToAPI({
    required int docId,
    required String imageType,
    required int createBy,
    required File imageFile,
  }) async {
    final String apiUrl = PostMultiFiles();

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['docid'] = docId.toString();
    request.fields['imageType'] = imageType;
    request.fields['createBy'] = createBy.toString();
    
    var file = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image: ${await response.stream.bytesToString()}');
      throw Exception('Failed to upload image');
    }
  }

  Future<List<Image>> fetchImagesFromAPI(int docId) async {
    final response = await http.get(Uri.parse(GetListFile(docId: docId)));

    if (response.statusCode == 200) {
      final List<dynamic> imageList = jsonDecode(response.body);
      return imageList.map((imageData) {
        final String base64Image = imageData['file']; // Adjust key based on API response
        final Uint8List bytes = base64Decode(base64Image);
        return Image.memory(bytes);
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}

