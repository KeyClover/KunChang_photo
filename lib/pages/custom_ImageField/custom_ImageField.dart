//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kunchang_photo/provider/images_provider.dart';

class CustomImageField extends StatelessWidget {
  const CustomImageField({
    Key? key,
    required this.field,
    required this.labelText,
    required this.getImage,
    required this.deleteImage,
  }) : super(key: key);

  final String field;
  final String labelText;
  final Function getImage;
  final Function deleteImage;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagesProvider>(context);
    // final files = imageProvider.selectedImageFiles[field] ?? [];
    final files = imageProvider.selectedImageFiles[field];
    final file = (files != null && files.isNotEmpty) ? files.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                getImage(context, field);
              },
              child: file != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            file,
                            height: 500,
                            width: double.infinity, // Adjust this if necessary
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () => deleteImage(context, field, 0),
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.red),
                            ))
                      ],
                    )
                  : const SizedBox(
                      height: 350,
                      child: Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
  // return Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       labelText,
  //       style: const TextStyle(
  //         fontSize: 20,
  //       ),
  //     ),
  //     const SizedBox(height: 10),
  //     files.isEmpty
  //         ? const Center(child: Text(' '))
  //         : SizedBox(
  //             height: 250,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: files.length,
  //               itemBuilder: (context, index) {
  //                 final file = files[index];
  //                 return Stack(
  //                   children: [
  //                     Container(
  //                       margin: const EdgeInsets.symmetric(horizontal: 5),
  //                       width: 250,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(30),
  //                         border: Border.all(color: Colors.grey),

  //                       ),
  //                       child: Image.file(file, fit: BoxFit.fill),
  //                     ),
  //                     Positioned(
  //                       right: 0,
  //                       child: IconButton(
  //                         onPressed: () => deleteImage(context, field, index),
  //                         icon: const Icon(Icons.close_rounded,
  //                             color: Colors.red),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //     IconButton(
  //       onPressed: () => getImage(context, field),
  //       icon: const Icon(Icons.camera_alt),
  //     ),
  //   ],
  // );
}
//}
