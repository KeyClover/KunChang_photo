// To parse this JSON data, do
//
//     final fileUploadPost = fileUploadPostFromJson(jsonString);

import 'dart:convert';

FileUploadPost fileUploadPostFromJson(String str) => FileUploadPost.fromJson(json.decode(str));

String fileUploadPostToJson(FileUploadPost data) => json.encode(data.toJson());

class FileUploadPost {
    final int docId;
    final String imageType;
    final int createBy;
    final List<dynamic> files;

    FileUploadPost({
        required this.docId,
        required this.imageType,
        required this.createBy,
        required this.files,
    });

    factory FileUploadPost.fromJson(Map<String, dynamic> json) => FileUploadPost(
        docId: json["docID"] is int ? json["docID"] : int.parse(json["docID"]),
        imageType: json["imageType"],
        createBy: json["createBy"],
        files: json["files"] ?? [],
    );

    Map<String, dynamic> toJson() => {
        "docID": docId, // Convert to string to ensure it's handled correctly by the API
        "imageType": imageType,
        "createBy": createBy,
        "files": files,
    };
}
