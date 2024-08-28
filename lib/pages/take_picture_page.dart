import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kunchang_photo/models/images_model.dart';
// import 'package:kunchang_photo/pages/blank_page.dart';
import 'package:kunchang_photo/pages/display_image.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/custom_ImageField/custom_ImageField.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedField = 'fieldcardImage';

  final Map<String, String> _fieldLabels = {
    'fieldcardImage': 'ใบฟิล',
    'frontImage': 'ข้างหน้ารถ',
    'backImage': 'ข้างหลังรถ',
    'leftSide': 'ข้างซ้ายรถ',
    'rightSide': 'ข้างขวารถ',
    'carRegistrationPlate': 'ทะเบียนรถ',
    'chassis': 'ตัวถังรถ',
  };

  void getImage(BuildContext context, String field) async {
    final ImagePicker _picker = ImagePicker();

    final selectedOption = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกแหล่งที่มาของภาพ'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('ถ่ายรูป'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('คลังรูปภาพ'),
            ),
          ],
        );
      },
    );

    if (selectedOption != null) {
      final selectedFile = await _picker.pickImage(source: selectedOption);

      if (selectedFile == null) return;

      final imageFile = File(selectedFile.path);
      Provider.of<ImagesProvider>(context, listen: false)
          .addSelectedImageFile(field, imageFile);
    }
  } // this is for getting the images

  void deleteImage(BuildContext context, String field, int index) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (imageProvider.selectedImageFiles[field] != null) {
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ลบรูปภาพ'),
            content: const Text('คุณแน่ใจไหมว่าต้องการลบภาพนี้?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );

      if (result == true) {
        await imageProvider.deleteFromDatabaseTakepicture(field, index);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ลบรูปภาพสำเร็จ'),
          ),
        );
      }
    }
  } // This is for deleting the images

  bool hasAnyImages(ImagesModel images) {
    return [
      images.fieldcardImage,
      images.frontImage,
      images.backImage,
      images.leftSide,
      images.rightSide,
      images.carRegistrationPlate,
      images.chassis,
    ].any((imageList) => imageList != null && imageList.isNotEmpty);
  }

  void saveImage(BuildContext context) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    final images = ImagesModel(
      fieldcardImage:
          _filterEmpty(imageProvider.selectedImageFiles['fieldcardImage']),
      frontImage: _filterEmpty(imageProvider.selectedImageFiles['frontImage']),
      backImage: _filterEmpty(imageProvider.selectedImageFiles['backImage']),
      leftSide: _filterEmpty(imageProvider.selectedImageFiles['leftSide']),
      rightSide: _filterEmpty(imageProvider.selectedImageFiles['rightSide']),
      carRegistrationPlate: _filterEmpty(
          imageProvider.selectedImageFiles['carRegistrationPlate']),
      chassis: _filterEmpty(imageProvider.selectedImageFiles['chassis']),
    );

    // Save images to the database
    await imageProvider.addNewImages(images);

    // Clear the image field after saving
    imageProvider.clearSelectedImageFile(_selectedField!);

    if (hasAnyImages(images)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกสำเร็จ')),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DisplayImagePage(),
      ),
    );
  }

  List<String>? _filterEmpty(List<File>? files) {
    if (files == null || files.isEmpty) return null;
    final nonEmptyPaths = files
        .map((file) => file.path)
        .where((path) => path.isNotEmpty)
        .toList();
    return nonEmptyPaths.isEmpty ? null : nonEmptyPaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor("#2e3150"),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  saveImage(context);
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
                'รูปภาพ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
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
                          color: HexColor("#2e3150")),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 35,
                      iconEnabledColor: Colors.white,
                    ),
                    value: _selectedField,
                    hint: const Text('Select Image Field'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedField = newValue;
                      });
                    },
                    items: _fieldLabels.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                CustomImageField(
                  field: _selectedField!,
                  labelText: _fieldLabels[_selectedField!]!,
                  getImage: getImage,
                  deleteImage: deleteImage,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        saveImage(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.bottomCenter,
                      minimumSize: const Size(100, 50),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text(
                      'บันทึก',
                      style: TextStyle(
                        fontSize:
                            20.0, // Adjust this value to increase or decrease the text size
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: HexColor("#e0e0e0"),
    );
  }
}
