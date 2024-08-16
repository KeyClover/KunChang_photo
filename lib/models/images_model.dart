class ImagesModel {
  int? id;
  late String fieldcardImage;
  late String frontImage;
  late String backImage;
  late String leftSide;
  late String rightSide;
  late String carRegistrationPlate;
  late String chassis;

  ImagesModel(
      {this.id,
      required this.fieldcardImage,
      required this.frontImage,
      required this.backImage,
      required this.leftSide,
      required this.rightSide,
      required this.carRegistrationPlate,
      required this.chassis});

  Map<String, dynamic> toMap() {
    return {
      'fieldcardImage': fieldcardImage,
      'frontImage': frontImage,
      'backImage': backImage,
      'leftSide': leftSide,
      'rightSide': rightSide,
      'carRegistrationPlate': carRegistrationPlate,
      'chassis': chassis,
    };
  }

  factory ImagesModel.fromMap(Map<String, dynamic> map) {
    return ImagesModel(
      fieldcardImage: map['fieldcardImage'],
      frontImage: map['frontImage'],
      backImage: map['backImage'],
      leftSide: map['leftSide'],
      rightSide: map['rightSide'],
      carRegistrationPlate: map['carRegistrationPlate'],
      chassis: map['chassis'],
    );
  }
}
