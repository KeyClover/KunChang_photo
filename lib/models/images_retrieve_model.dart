// To parse this JSON data, do
//
//     final imageRetrieveModel = imageRetrieveModelFromJson(jsonString);

import 'dart:convert';

List<ImageRetrieveModel> imageRetrieveModelFromJson(String str) => List<ImageRetrieveModel>.from(json.decode(str).map((x) => ImageRetrieveModel.fromJson(x)));

String imageRetrieveModelToJson(List<ImageRetrieveModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageRetrieveModel {
    int? id;
    String? fileName;
    String? fileData;
    int? fileType;
    int? docId;
    String? imageType;
    DateTime? createDate;
    int? createBy;

    ImageRetrieveModel({
        this.id,
        this.fileName,
        this.fileData,
        this.fileType,
        this.docId,
        this.imageType,
        this.createDate,
        this.createBy,
    });

    factory ImageRetrieveModel.fromJson(Map<String, dynamic> json) => ImageRetrieveModel(
        id: json["ID"],
        fileName: json["FileName"],
        fileData: json["FileData"],
        fileType: json["FileType"],
        docId: json["DocId"],
        imageType: json["ImageType"],
        createDate: json["CreateDate"] == null ? null : DateTime.parse(json["CreateDate"]),
        createBy: json["CreateBy"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "FileName": fileName,
        "FileData": fileData,
        "FileType": fileType,
        "DocId": docId,
        "ImageType": imageType,
        "CreateDate": createDate?.toIso8601String(),
        "CreateBy": createBy,
    };
}
