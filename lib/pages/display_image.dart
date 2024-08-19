import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kunchang_photo/models/images_model.dart'; // Ensure you import your ImagesModel class
import 'package:hexcolor/hexcolor.dart';

class DisplayImagePage extends StatelessWidget {
  final ImagesModel imagesModel;

  const DisplayImagePage({super.key, required this.imagesModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Images'),
        backgroundColor: HexColor("#2e3150"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (imagesModel.fieldcardImage != null)
              ...imagesModel.fieldcardImage!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ใบฟิว',
                    imagePath: imagePath,
                  )). toList(),
            if (imagesModel.frontImage != null)
              ...imagesModel.frontImage!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ข้างหน้ารถ',
                    imagePath: imagePath,
                  )).toList(),
            if (imagesModel.backImage != null)
              ...imagesModel.backImage!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ข้างหลลังรถ',
                    imagePath: imagePath,
                  )).toList(),
            if (imagesModel.leftSide != null)
              ...imagesModel.leftSide!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ข้างซ้ายรถ',
                    imagePath: imagePath,
                  )).toList(),
            if (imagesModel.rightSide != null)
              ...imagesModel.rightSide!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ข้างขวารถ',
                    imagePath: imagePath,
                  )).toList(),
            if (imagesModel.carRegistrationPlate != null)
              ...imagesModel.carRegistrationPlate!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ทะเบียนรถ',
                    imagePath: imagePath,
                  )).toList(),
            if (imagesModel.chassis != null)
              ...imagesModel.chassis!.map((imagePath) =>
                  ImageDisplayField(
                    labelText: 'ตัวถังรถ',
                    imagePath: imagePath,
              
              ),
        ).toList()],
        ),
      ),
    );
  }
}

class ImageDisplayField extends StatelessWidget {
  final String labelText;
  final String imagePath;

  const ImageDisplayField({
    super.key,
    required this.labelText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Image.file(File(imagePath)),
        const SizedBox(height: 20),
      ],
    );
  }
}
