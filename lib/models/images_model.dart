class ImagesModel {
  int? id;
  String? fieldcardImage;
  String? frontImage;
  String? backImage;
  String? leftSide;
  String? rightSide;
  String? carRegistrationPlate;
  String? chassis;

  ImagesModel(
      {this.id,
      this.fieldcardImage,
      this.frontImage,
      this.backImage,
      this.leftSide,
      this.rightSide,
      this.carRegistrationPlate,
      this.chassis});

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
