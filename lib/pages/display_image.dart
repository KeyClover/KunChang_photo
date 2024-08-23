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
  String _selectedFilter = 'รูปภาพทั้งหมด'; //use for filter

  final Map<String, String> labelToColumnMap = {
    'ใบฟิล': 'fieldcardImage',
    'ข้างหน้ารถ': 'frontImage',
    'ข้างหลังรถ': 'backImage',
    'ข้างซ้ายรถ': 'leftSide',
    'ข้างขวารถ': 'rightSide',
    'ทะเบียนรถ': 'carRegistrationPlate',
    'ตัวถังรถ': 'chassis',
  };

  Future<List<ImagesModel>> fetchAllImagesFromDB(BuildContext context) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await imageProvider.fetchImages(); // Fetch images from the database
    // Assuming you're fetching the latest images from the database for display.
    return imageProvider.images; // Fetch last saved images
  }

  void _deleteImage(
      BuildContext context, String labelText, String imagePath) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    final String? columnName = labelToColumnMap[labelText];

    final bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure to delete the image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmDelete) {
      await imageProvider.deleteFromDatabaseDisplay(columnName!, imagePath);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TakePicturePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'คลังเก็บรูปภาพ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: HexColor("#2e3150"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Dropdown for filtter options
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedFilter,
                items: <String>[
                  'รูปภาพทั้งหมด',
                  'ใบฟิล',
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
                        ..._buildImageList(imagesModel.fieldcardImage, 'ใบฟิล'),
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
      ),
    );
  }

  List<Widget> _buildImageList(List<String>? imagePaths, String labelText) {
    if (imagePaths == null || imagePaths.isEmpty) return [];

    if (_selectedFilter != 'รูปภาพทั้งหมด' && _selectedFilter != labelText) {
      return [];
    }

    return imagePaths.map((imagePath) {
      if (imagePath.isEmpty || !File(imagePath).existsSync()) {
        // If the file path is empty or the file does not exist, handle it
        return const SizedBox.shrink();
      }

      return ImageDisplayField(
        labelText: labelText,
        imagePath: imagePath,
        onDelete: () => _deleteImage(context, labelText, imagePath),
      );
    }).toList();
  }
}

class ImageDisplayField extends StatelessWidget {
  final String labelText;
  final String imagePath;
  final VoidCallback onDelete;

  const ImageDisplayField({
    super.key,
    required this.labelText,
    required this.imagePath,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: AspectRatio(
              aspectRatio: 2/ 3,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}
