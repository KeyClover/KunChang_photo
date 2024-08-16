import 'dart:io';

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
    final file = imageProvider.selectedImageFiles[field];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        
        

       
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: file == null
                        ? const Center(child: Text('ยังไม่มีรูปภาพ'))
                        : Image.file(file),
                  ),
                ),
                IconButton(
                  onPressed: () => getImage(context, field),
                  icon: const Icon(Icons.camera_alt),
                ),
                IconButton(
                  onPressed: () => deleteImage(context, field),
                  icon: const Icon(Icons.close_rounded, color: Colors.red),
                ),
              ],
            ),
             
            const SizedBox(height: 20),
          
      
      ],
    );
  }
}
