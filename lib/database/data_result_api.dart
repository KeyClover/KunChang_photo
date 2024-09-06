import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestDataSource {
  String baseAPI = 'http://203.150.53.11:9001/CSCPlusAPIdev/swagger/';

  String GetFile({required int id}) {
    String url = '${baseAPI}FileUpload/GetFile?id=$id';
    return url;
  }

  String GetListFile({required int docId}){
    String url = '${baseAPI}FileUpload/GetListFile?docId=$docId';
    return url;
  }

  String PostMultiFiles({required int docId, required String imageType, required int createBy}){
    String url = '${baseAPI}FileUpload/PostMultiFiles';
    return url;
  }

Future<void> uploadImageToAPI({
    required int docId,
    required String imageType,
    required int createBy,
    required File imageFile,
  }) async {
    final String apiUrl = '${baseAPI}FileUpload/PostMultiFiles';

    final bytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'docid': docId,
        'imagetype': imageType,
        'createby': createBy,
        'file': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image: ${response.body}');
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
  




