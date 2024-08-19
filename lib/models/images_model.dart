class ImagesModel {
  int? id;
  List<String>? fieldcardImage;
  List<String>? frontImage;
  List<String>? backImage;
  List<String>? leftSide;
  List<String>? rightSide;
  List<String>? carRegistrationPlate;
  List<String>? chassis;

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
         'fieldcardImage': fieldcardImage?.join(','),
      'frontImage': frontImage?.join(','),
      'backImage': backImage?.join(','),
      'leftSide': leftSide?.join(','),
      'rightSide': rightSide?.join(','),
      'carRegistrationPlate': carRegistrationPlate?.join(','),
      'chassis': chassis?.join(','),
    };
  }

  factory ImagesModel.fromMap(Map<String, dynamic> map) {
    return ImagesModel(
       fieldcardImage: map['fieldcardImage']?.split(','),
      frontImage: map['frontImage']?.split(','),
      backImage: map['backImage']?.split(','),
      leftSide: map['leftSide']?.split(','),
      rightSide: map['rightSide']?.split(','),
      carRegistrationPlate: map['carRegistrationPlate']?.split(','),
      chassis: map['chassis']?.split(','),
    );
  }
}
