class ImagesModel {
  int? id;
  List<String>? FieldcardImage;
  List<String>? FrontImage;
  List<String>? BackImage;
  List<String>? LeftSide;
  List<String>? RightSide;
  List<String>? CarRegistrationPlate;
  List<String>? Chassis;
  

  ImagesModel(
      {this.id,
      this.FieldcardImage,
      this.FrontImage,
      this.BackImage,
      this.LeftSide,
      this.RightSide,
      this.CarRegistrationPlate,
      this.Chassis});

  Map<String, dynamic> toMap() {
    return {
         'fieldcardImage': FieldcardImage?.join(','),
      'frontImage': FrontImage?.join(','),
      'backImage': BackImage?.join(','),
      'leftSide': LeftSide?.join(','),
      'rightSide': RightSide?.join(','),
      'carRegistrationPlate': CarRegistrationPlate?.join(','),
      'chassis': Chassis?.join(','),
    };
  }

  factory ImagesModel.fromMap(Map<String, dynamic> map) {
    return ImagesModel(
       FieldcardImage: map['fieldcardImage']?.split(','),
      FrontImage: map['frontImage']?.split(','),
      BackImage: map['backImage']?.split(','),
      LeftSide: map['leftSide']?.split(','),
      RightSide: map['rightSide']?.split(','),
      CarRegistrationPlate: map['carRegistrationPlate']?.split(','),
      Chassis: map['chassis']?.split(','),
    );
  }
}
