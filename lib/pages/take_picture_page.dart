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

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedField = 'fieldcardImage';

  final Map<String, String> _fieldLabels = {
    'fieldcardImage': 'ใบฟิว',
    'frontImage': 'ข้างหน้ารถ',
    'backImage': 'ข้างหลังรถ',
    'leftSideImage': 'ข้างซ้ายรถ',
    'rightSideImage': 'ข้างขวารถ',
    'carRegistrationPlateImage': 'ทะเบียนรถ',
    'chassisImage': 'ตัวถังรถ',
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
        await imageProvider.deleteFromDatabase(field, index);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image deleted'),
          ),
        );
      }
    }
  } // This is for deleting the images

  void saveImage(BuildContext context) async {
  final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
  
  final images = ImagesModel(
    fieldcardImage: imageProvider.selectedImageFiles['fieldcardImage']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    frontImage: imageProvider.selectedImageFiles['frontImage']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    backImage: imageProvider.selectedImageFiles['backImage']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    leftSide: imageProvider.selectedImageFiles['leftSide']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    rightSide: imageProvider.selectedImageFiles['rightSide']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    carRegistrationPlate: imageProvider.selectedImageFiles['carRegistrationPlate']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
    chassis: imageProvider.selectedImageFiles['chassis']?.map((file) => file.path).where((path) => path.isNotEmpty).toList(),
  );

  // Save images to the database
  await imageProvider.addNewImages(images);

  // Clear the image field after saving
  imageProvider.clearSelectedImageFile(_selectedField!);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('บันทึกสำเร็จ')),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DisplayImagePage(),
    ),
  );
}


 
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: HexColor("#2e3150"),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  final imageProvider = Provider.of<ImagesProvider>(
                              context,
                              listen: false);
                  saveImage(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'รูปภาพ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
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
                  DropdownButton<String>(
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
                        child: Text(entry.value),
                      );
                    }).toList(),
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
                         // _formKey.currentState!.save();
                      

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
        ));
  }
}
