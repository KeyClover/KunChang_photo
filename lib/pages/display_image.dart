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
              ImageDisplayField(
                labelText: 'ใบฟิว',
                imagePath: imagesModel.fieldcardImage!,
              ),
            if (imagesModel.frontImage != null)
              ImageDisplayField(
                labelText: 'ข้างหน้ารถ',
                imagePath: imagesModel.frontImage!,
              ),
            if (imagesModel.backImage != null)
              ImageDisplayField(
                labelText: 'ข้างหลลังรถ',
                imagePath: imagesModel.backImage!,
              ),
            if (imagesModel.leftSide != null)
              ImageDisplayField(
                labelText: 'ข้างซ้ายรถ',
                imagePath: imagesModel.leftSide!,
              ),
            if (imagesModel.rightSide != null)
              ImageDisplayField(
                labelText: 'ข้างขวารถ',
                imagePath: imagesModel.rightSide!,
              ),
            if (imagesModel.carRegistrationPlate != null)
              ImageDisplayField(
                labelText: 'ทะเบียนรถ',
                imagePath: imagesModel.carRegistrationPlate!,
              ),
            if (imagesModel.chassis != null)
              ImageDisplayField(
                labelText: 'ตัวถังรถ',
                imagePath: imagesModel.chassis!,
              ),
          ],
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
        Image.file(File(imagePath as String)),
        const SizedBox(height: 20),
      ],
    );
  }
}
