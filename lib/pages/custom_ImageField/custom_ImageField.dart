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
    final files = imageProvider.selectedImageFiles[field] ?? [];

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
        files.isEmpty
            ? const Center(child: Text('ยังไม่มีรูปภาพ'))
            : SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Image.file(file, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () => deleteImage(context, field, index),
                            icon: const Icon(Icons.close_rounded, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
        IconButton(
          onPressed: () => getImage(context, field),
          icon: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }
}
