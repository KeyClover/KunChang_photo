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
    //required this.deleteImage,
  }) : super(key: key);

  final String field;
  final String labelText;
  final Function getImage;
  //final Function deleteImage;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagesProvider>(context);
    // final files = imageProvider.selectedImageFiles[field] ?? [];
    final files = imageProvider.selectedImageFiles[field];
    final file = (files != null && files.isNotEmpty) ? files.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),
          ),
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
                            height: 550,
                            width: double.infinity, // Adjust this if necessary
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Positioned(
                        //     right: 0,
                        //     child: IconButton(
                        //       onPressed: () => deleteImage(context, field, 0),
                        //       icon: const Icon(Icons.close_rounded,
                        //           color: Colors.red),
                        //     ))

                       // TO-DO create a delete function 
                      ],
                    )
                  : const SizedBox(
                      height: 400,
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
  }}