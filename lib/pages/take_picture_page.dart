import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kunchang_photo/models/images_model.dart';
import 'package:kunchang_photo/pages/blank_page.dart';
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

  String? _selectedField = 'fieldCardImage';

  final Map<String, String> _fieldLabels = {
    'fieldCardImage': 'ใบฟิว',
    'frontImage': 'ข้างหน้ารถ',
    'backImage': 'ข้างหลลังรถ',
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
          .setSelectedImageFile(field, imageFile);
    }
  } // this is for getting the images

  void deleteImage(BuildContext context, String field) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (imageProvider.selectedImageFiles[field] != null ) {
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
        await imageProvider.deleteFromDatabase(field);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image deleted'),
          ),
        );
      }
    }
  } // This is for deleting the images

  @override
  Widget build(BuildContext context) {
    // final imageProvider = Provider.of<ImagesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: HexColor("#2e3150"),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                           const BlankPage(), // put the page you want it to redirect you to
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

                  // const SizedBox(height: 20),

                  //CustomImageField(field: 'fieldCardImage', labelText: 'ใบฟิว', getImage: getImage, deleteImage: deleteImage), // this one use the custom__image to create a image field // external file

                  // _buildImageField(
                  //     context, imageProvider, 'fieldCardImage', 'ใบฟิว'),
                  // _buildImageField(
                  //     context, imageProvider, 'frontImage', 'ข้างหน้ารถ'),
                  // _buildImageField(
                  //     context, imageProvider, 'backImage', 'ข้างหลลังรถ'),
                  // _buildImageField(
                  //     context, imageProvider, 'leftSideImage', 'ข้างซ้ายรถ'),
                  // _buildImageField(
                  //     context, imageProvider, 'rightSideImage', 'ข้างขวารถ'),
                  // _buildImageField(context, imageProvider,
                  //     'carRegistrationPlateImage', 'ทะเบียนรถ'),
                  // _buildImageField(
                  //     context, imageProvider, 'chassisImage', 'ตัวถังรถ'), // this one is use Widget _buildImageField to create a image field // in this file

                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         // _formKey.currentState!.save();
                          final imageProvider = Provider.of<ImagesProvider>(
                              context,
                              listen: false);

                          final images = ImagesModel(
                          fieldcardImage: imageProvider.selectedImageFiles['fieldCardImage']?.path,
                          frontImage: imageProvider.selectedImageFiles['frontImage']?.path,
                          backImage: imageProvider.selectedImageFiles['backImage']?.path,
                          leftSide: imageProvider.selectedImageFiles['leftSideImage']?.path,
                          rightSide: imageProvider.selectedImageFiles['rightSideImage']?.path,
                          carRegistrationPlate: imageProvider.selectedImageFiles['carRegistrationPlateImage']?.path,
                          chassis: imageProvider.selectedImageFiles['chassisImage']?.path,
                          );

                          

                          await Provider.of<ImagesProvider>(context,
                                  listen: false)
                              .addNewImages(images);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('บันทึกสำเร็จ'),
                            ),
                          );
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayImagePage(imagesModel: images),
                          ),
                        );
                        }
                      },
                      style: ElevatedButton.styleFrom(
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

  // Widget _buildImageField(BuildContext context, ImagesProvider imageProvider,
  //     String field, String labelText) {
  //   final file = imageProvider.selectedImageFiles[field];
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         labelText,
  //         style: const TextStyle(
  //           fontSize: 20,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               height: 200,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               child: file == null
  //                   ? const Center(
  //                       child: Text(
  //                         'ยังไม่มีรูปภาพ',
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                     )
  //                   : Image.file(file),
  //             ),
  //           ),
  //           IconButton(
  //             onPressed: () => getImage(context, field),
  //             icon: const Icon(Icons.camera_alt),
  //           ),
  //           IconButton(
  //             onPressed: () => deleteImage(context, field),
  //             icon: const Icon(Icons.close_rounded),
  //           ),
  //           const SizedBox(height: 20),
  //         ],
  //       ),
  //     ],
  //   );
  // } //this one use to create a image field
}
