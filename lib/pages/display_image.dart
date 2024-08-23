import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kunchang_photo/models/images_model.dart'; // Ensure you import your ImagesModel class
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/take_picture_page.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';

class DisplayImagePage extends StatefulWidget {
  const DisplayImagePage({super.key});

  @override
  State<DisplayImagePage> createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  String _selectedFilter = 'รูปภาพทั้งหมด';

  Future<List<ImagesModel>> fetchAllImagesFromDB(BuildContext context) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await imageProvider.fetchImages(); // Fetch images from the database
    // Assuming you're fetching the latest images from the database for display.
    return imageProvider.images; // Fetch last saved images
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Display Images',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#2e3150"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TakePicturePage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          //Dropdown for filtter options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: <String>[
                'รูปภาพทั้งหมด',
                'ใบฟิว',
                'ข้างหน้ารถ',
                'ข้างหลังรถ',
                'ข้างซ้ายรถ',
                'ข้างขวารถ',
                'ทะเบียนรถ',
                'ตัวถังรถ'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ImagesModel>>(
              future: fetchAllImagesFromDB(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading images'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No images available'));
                } else {
                  final allImages = snapshot.data!;

                  final imageWidgets = allImages.expand((imagesModel) {
                    return [
                      ..._buildImageList(imagesModel.fieldcardImage, 'ใบฟิว'),
                      ..._buildImageList(imagesModel.frontImage, 'ข้างหน้ารถ'),
                      ..._buildImageList(imagesModel.backImage, 'ข้างหลังรถ'),
                      ..._buildImageList(imagesModel.leftSide, 'ข้างซ้ายรถ'),
                      ..._buildImageList(imagesModel.rightSide, 'ข้างขวารถ'),
                      ..._buildImageList(
                          imagesModel.carRegistrationPlate, 'ทะเบียนรถ'),
                      ..._buildImageList(imagesModel.chassis, 'ตัวถังรถ'),
                    ];
                  }).toList();

                  if (imageWidgets.isEmpty) {
                    // No images to display
                    return const Center(child: Text('No images available'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: imageWidgets,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildImageList(List<String>? imagePaths, String labelText) {
    if (imagePaths == null || imagePaths.isEmpty) return [];

    if (_selectedFilter != 'รูปภาพทั้งหมด' && _selectedFilter != labelText){
      return[];
    }

    return imagePaths.map((imagePath) {
      if (imagePath.isEmpty || !File(imagePath).existsSync()) {
        // If the file path is empty or the file does not exist, handle it
        return const SizedBox.shrink();
      }

      return ImageDisplayField(
        labelText: labelText,
        imagePath: imagePath,
      );
    }).toList();
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
