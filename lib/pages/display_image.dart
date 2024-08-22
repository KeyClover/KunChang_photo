import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kunchang_photo/models/images_model.dart'; // Ensure you import your ImagesModel class
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/take_picture_page.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';

class DisplayImagePage extends StatelessWidget {
  final ImagesModel imagesModel;

  const DisplayImagePage({super.key, required this.imagesModel});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ..._buildImageList(imagesModel.fieldcardImage, 'ใบฟิว'),
            ..._buildImageList(imagesModel.frontImage, 'ข้างหน้ารถ'),
            ..._buildImageList(imagesModel.backImage, 'ข้างหลังรถ'),
            ..._buildImageList(imagesModel.leftSide, 'ข้างซ้ายรถ'),
            ..._buildImageList(imagesModel.rightSide, 'ข้างขวารถ'),
            ..._buildImageList(imagesModel.carRegistrationPlate, 'ทะเบียนรถ'),
            ..._buildImageList(imagesModel.chassis, 'ตัวถังรถ'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImageList(List<String>? imagePaths, String labelText) {
    if (imagePaths == null || imagePaths.isEmpty) return [];

    return imagePaths.map((imagePath) => ImageDisplayField(
      labelText: labelText,
      imagePath: imagePath,
    )).toList();
  }
}


  List<Widget> _buildImageList(List<String>? imagePaths, String labelText) {
    if (imagePaths == null || imagePaths.isEmpty) return [];

    return imagePaths.map((imagePath) => ImageDisplayField(
      labelText: labelText,
      imagePath: imagePath,
    )).toList();
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

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:kunchang_photo/models/images_model.dart';
// import 'package:kunchang_photo/pages/take_picture_page.dart';
// import 'package:kunchang_photo/provider/images_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:hexcolor/hexcolor.dart';

// class DisplayImagePage extends StatefulWidget {
//   @override
//   _DisplayImagePageState createState() => _DisplayImagePageState();
// }

// class _DisplayImagePageState extends State<DisplayImagePage> {
//   late Future<List<ImagesModel>> _imagesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _imagesFuture = _fetchImages();
//   }

//   Future<List<ImagesModel>> _fetchImages() async {
//     final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
//     await imageProvider.fetchImages();
//     return imageProvider.images;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Display Images',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: HexColor("#2e3150"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TakePicturePage(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: FutureBuilder<List<ImagesModel>>(
//         future: _imagesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // if (snapshot.hasError) {
//           //   return Center(child: Text('Error: ${snapshot.error}'));
//           // }

//           final imagesList = snapshot.data ?? [];

//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ListView.builder(
//               itemCount: imagesList.length,
//               itemBuilder: (context, index) {
//                 final imagesModel = imagesList[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (imagesModel.fieldcardImage != null)
//                       ...imagesModel.fieldcardImage!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ใบฟิว',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.frontImage != null)
//                       ...imagesModel.frontImage!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ข้างหน้ารถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.backImage != null)
//                       ...imagesModel.backImage!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ข้างหลังรถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.leftSide != null)
//                       ...imagesModel.leftSide!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ข้างซ้ายรถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.rightSide != null)
//                       ...imagesModel.rightSide!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ข้างขวารถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.carRegistrationPlate != null)
//                       ...imagesModel.carRegistrationPlate!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ทะเบียนรถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     if (imagesModel.chassis != null)
//                       ...imagesModel.chassis!
//                           .map((imagePath) => ImageDisplayField(
//                                 labelText: 'ตัวถังรถ',
//                                 imagePath: imagePath,
//                               ))
//                           .toList(),
//                     const SizedBox(height: 20),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ImageDisplayField extends StatelessWidget {
//   final String labelText;
//   final String imagePath;

//   const ImageDisplayField({
//     super.key,
//     required this.labelText,
//     required this.imagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           labelText,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Image.file(File(imagePath)),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }
