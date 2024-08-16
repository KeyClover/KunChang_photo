import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:kunchang_photo/pages/blank_page.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  final _formKey = GlobalKey<FormState>();

  // void getImage(BuildContext context, String field) async {
  //   final ImagePicker _picker = ImagePicker();
    
  //   final selectedFile = await _picker.pickImage(source: ImageSource.camera);

  //   if (selectedFile == null) return;

  //   final imageFile = File(selectedFile.path);
  //   Provider.of<ImagesProvider>(context, listen: false)
  //       .setSelectedImageFile(field, imageFile);
  // }

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
        .setSelectedImageFile(field, imageFile);
  }
}


  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagesProvider>(context);
  
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#2e3150"),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlankPage(),
                    ),
                  );
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
                  const Text('ใบฟิว',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          getImage(context, 'fieldCardImage');
                        },
                        child: imageProvider
                                    .selectedImageFiles['fieldCardImage'] !=
                                null
                            ? Image.file(imageProvider
                                .selectedImageFiles['fieldCardImage']!)
                            : const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'ข้างหน้ารถ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          getImage(context, 'frontImage');
                        },
                        child: imageProvider.selectedImageFiles['frontImage'] !=
                                null
                            ? Image.file(
                                imageProvider.selectedImageFiles['frontImage']!)
                            : const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'ข้างหลลังรถ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          getImage(context, 'backImage');
                        },
                        child: imageProvider.selectedImageFiles['backImage'] !=
                                null
                            ? Image.file(
                                imageProvider.selectedImageFiles['backImage']!)
                            : const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'ข้างซ้ายรถ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            getImage(context, 'leftSideImage');
                          },
                          child: imageProvider
                                      .selectedImageFiles['leftSideImage'] !=
                                  null
                              ? Image.file(imageProvider
                                  .selectedImageFiles['leftSideImage']!)
                              : const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'ข้างขวารถ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                          onTap: () {
                            getImage(context, 'rightSideImage');
                          },
                          child: imageProvider
                                      .selectedImageFiles['rightSideImage'] !=
                                  null
                              ? Image.file(imageProvider
                                  .selectedImageFiles['rightSideImage']!)
                              : const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.camera_alt),
                                  ),
                                )),
                    ),
                  ),  
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'ทะเบียนรถ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                          onTap: () {
                            getImage(context, 'carRegistrationPlateImage');
                          },
                          child: imageProvider.selectedImageFiles[
                                      'carRegistrationPlateImage'] !=
                                  null
                              ? Image.file(imageProvider.selectedImageFiles[
                                  'carRegistrationPlateImage']!)
                              : const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.camera_alt),
                                  ),
                                )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('คัซซี', style: TextStyle(fontSize: 18)),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          getImage(context, 'chassis');
                        },
                        child: imageProvider.selectedImageFiles['chassis'] !=
                                null
                            ? Image.file(
                                imageProvider.selectedImageFiles['chassis']!)
                            : const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final fieldCardImage = imageProvider
                              .selectedImageFiles['fieldCardImage'];
                          final frontImage =
                              imageProvider.selectedImageFiles['frontImage'];
                          final backImage =
                              imageProvider.selectedImageFiles['backImage'];
                          final leftSideImage =
                              imageProvider.selectedImageFiles['leftSideImage'];
                          final rightSideImage = imageProvider
                              .selectedImageFiles['rightSideImage'];
                          final carRegistrationPlateImage = imageProvider
                              .selectedImageFiles['carRegistrationPlateImage'];
                          final chassis =
                              imageProvider.selectedImageFiles['chassis'];

                          if (fieldCardImage != null &&
                              frontImage != null &&
                              backImage != null &&
                              leftSideImage != null &&
                              rightSideImage != null &&
                              carRegistrationPlateImage != null &&
                              chassis != null) {
                            final images = ImagesModel(
                              fieldcardImage: fieldCardImage.path,
                              frontImage: frontImage.path,
                              backImage: backImage.path,
                              leftSide: leftSideImage.path,
                              rightSide: rightSideImage.path,
                              carRegistrationPlate:
                                  carRegistrationPlateImage.path,
                              chassis: chassis.path,
                            );

                            await Provider.of<ImagesProvider>(context,
                                    listen: false)
                                .addNewImages(images);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('บันทึกสำเร็จ'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            100, 50), 
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text('บันทึก'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
