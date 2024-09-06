// To parse this JSON data, do
//
//     final fileUploadPost = fileUploadPostFromJson(jsonString);

import 'dart:convert';

FileUploadPost fileUploadPostFromJson(String str) => FileUploadPost.fromJson(json.decode(str));

String fileUploadPostToJson(FileUploadPost data) => json.encode(data.toJson());

class FileUploadPost {
    int? docId;
    String? imageType;
    int? createBy;
    List<dynamic>? files;

    FileUploadPost({
        this.docId,
        this.imageType,
        this.createBy,
        this.files,
    });

    factory FileUploadPost.fromJson(Map<String, dynamic> json) => FileUploadPost(
        docId: json["docID"],
        imageType: json["imageType"],
        createBy: json["createBy"],
        files: json["files"] == null ? [] : List<dynamic>.from(json["files"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "docID": docId,
        "imageType": imageType,
        "createBy": createBy,
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
    };
}
