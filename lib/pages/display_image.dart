import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/take_picture_page.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/utils/utils.dart';

class DisplayImagePage extends StatefulWidget {
  const DisplayImagePage({super.key});

  @override
  State<DisplayImagePage> createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  String _selectedFilter = 'รูปภาพทั้งหมด'; // Use for filter

  final List<String> predefinedOrder = [
    'ใบฟิล',
    'ข้างหน้ารถ',
    'ข้างหลังรถ',
    'ข้างซ้ายรถ',
    'ข้างขวารถ',
    'ทะเบียนรถ',
    'ตัวถังรถ'
  ];

  final Map<String, String> labelToColumnMap = {
    'ใบฟิล': 'fieldcardImage',
    'ข้างหน้ารถ': 'frontImage',
    'ข้างหลังรถ': 'backImage',
    'ข้างซ้ายรถ': 'leftSide',
    'ข้างขวารถ': 'rightSide',
    'ทะเบียนรถ': 'carRegistrationPlate',
    'ตัวถังรถ': 'chassis',
  };

  @override
  void initState() {
    super.initState();
    // Recalculate when returning to the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<List<ImagesModel>> fetchAllImagesFromDB(BuildContext context) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await imageProvider.fetchImages(); // Fetch images from the database
    return imageProvider.images; // Fetch last saved images
  }

  void _deleteImage(
      BuildContext context, String labelText, String imagePath) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final String? columnName = labelToColumnMap[labelText];

    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ลบรูปภาพ'),
          content: const Text('คุณแน่ใจหรือว่าต้องการลบรูปภาพ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      await imageProvider.deleteFromDatabaseDisplay(columnName!, imagePath);
      final updatedImages = await fetchAllImagesFromDB(context);
      final fieldHasImages = _checkFieldsWithImages(updatedImages);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบรูปสำเร็จ')),
        );
      });
    }
  } // has error

  Map<String, bool> _checkFieldsWithImages(List<ImagesModel> allImages) {
    final Map<String, bool> fieldHasImages = {
      'รูปภาพทั้งหมด': false,
      'ใบฟิล': false,
      'ข้างหน้ารถ': false,
      'ข้างหลังรถ': false,
      'ข้างซ้ายรถ': false,
      'ข้างขวารถ': false,
      'ทะเบียนรถ': false,
      'ตัวถังรถ': false,
    };

    for (final imagesModel in allImages) {
      if (imagesModel.fieldcardImage != null &&
          imagesModel.fieldcardImage!.isNotEmpty) {
        fieldHasImages['ใบฟิล'] = true;
      }
      if (imagesModel.frontImage != null &&
          imagesModel.frontImage!.isNotEmpty) {
        fieldHasImages['ข้างหน้ารถ'] = true;
      }
      if (imagesModel.backImage != null && imagesModel.backImage!.isNotEmpty) {
        fieldHasImages['ข้างหลังรถ'] = true;
      }
      if (imagesModel.leftSide != null && imagesModel.leftSide!.isNotEmpty) {
        fieldHasImages['ข้างซ้ายรถ'] = true;
      }
      if (imagesModel.rightSide != null && imagesModel.rightSide!.isNotEmpty) {
        fieldHasImages['ข้างขวารถ'] = true;
      }
      if (imagesModel.carRegistrationPlate != null &&
          imagesModel.carRegistrationPlate!.isNotEmpty) {
        fieldHasImages['ทะเบียนรถ'] = true;
      }
      if (imagesModel.chassis != null && imagesModel.chassis!.isNotEmpty) {
        fieldHasImages['ตัวถังรถ'] = true;
      }
    }

    // If every field has images, set 'รูปภาพทั้งหมด' to true // Will appear the check mark

    bool allFieldHaveImages = fieldHasImages['ใบฟิล'] == true &&
        fieldHasImages['ข้างหน้ารถ'] == true &&
        fieldHasImages['ข้างหลังรถ'] == true &&
        fieldHasImages['ข้างซ้ายรถ'] == true &&
        fieldHasImages['ข้างขวารถ'] == true &&
        fieldHasImages['ทะเบียนรถ'] == true &&
        fieldHasImages['ตัวถังรถ'] == true;

    if (allFieldHaveImages) {
      fieldHasImages['รูปภาพทั้งหมด'] = true;
    }

    return fieldHasImages;
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
        child: FutureBuilder<List<ImagesModel>>(
          future: fetchAllImagesFromDB(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดรูปภาพ'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('ไม่มีรูป'));
            } else {
              final allImages = snapshot.data!;
              final fieldHasImages = _checkFieldsWithImages(allImages);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Padding(
                    padding: const EdgeInsets.only(left:8.0, top: 8.0, bottom: 1.0),

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400,
                          width: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: HexColor("#2e3150"),
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                          height: 45,
                          width: 240,
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black),
                            color: HexColor("#2e3150"),
                          ),
                          elevation: 2,
                        ),
                        
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_drop_down, ),
                            iconSize: 35,
                            iconEnabledColor: Colors.white
                            ),

                        isExpanded: true,
                        value: _selectedFilter,
                        items: fieldHasImages.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                        
                                if (fieldHasImages[value] == true)
                                  const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFilter = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: _buildFilteredImages(allImages),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      backgroundColor: HexColor("#e0e0e0"),
    );
  }

  // Build the filtered images based on the selected filter
  List<Widget> _buildFilteredImages(List<ImagesModel> allImages) {
    final List<Widget> imageWidgets = [];

    for (final label in predefinedOrder) {
      if (_selectedFilter == 'รูปภาพทั้งหมด' || _selectedFilter == label) {
        for (final imagesModel in allImages) {
          final imagePaths = _getImagePathsByLabel(imagesModel, label);
          if (imagePaths != null && imagePaths.isNotEmpty) {
            imageWidgets.addAll(
              imagePaths.map((imagePath) {
                if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
                  return ImageDisplayField(
                    labelText: label,
                    imagePath: imagePath,
                    onDelete: () => _deleteImage(context, label, imagePath),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            );
          }
        }
      }
    }

    return imageWidgets;
  }

  List<String>? _getImagePathsByLabel(ImagesModel imagesModel, String label) {
    switch (label) {
      case 'ใบฟิล':
        return imagesModel.fieldcardImage;
      case 'ข้างหน้ารถ':
        return imagesModel.frontImage;
      case 'ข้างหลังรถ':
        return imagesModel.backImage;
      case 'ข้างซ้ายรถ':
        return imagesModel.leftSide;
      case 'ข้างขวารถ':
        return imagesModel.rightSide;
      case 'ทะเบียนรถ':
        return imagesModel.carRegistrationPlate;
      case 'ตัวถังรถ':
        return imagesModel.chassis;
      default:
        return null;
    }
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
                size: 25,
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
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
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
