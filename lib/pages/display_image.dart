import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kunchang_photo/models/images_retrieve_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/take_picture_page.dart';
import 'package:kunchang_photo/provider/images_provider.dart';
import 'package:provider/provider.dart';

class DisplayImagePage extends StatefulWidget {
  const DisplayImagePage({super.key});

  @override
  State<DisplayImagePage> createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  String _selectedFilter = 'รูปภาพทั้งหมด';

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
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0.0),
        child: FutureBuilder<List<ImageRetrieveModel>>(
          future: Provider.of<ImagesProvider>(context, listen: false).fetchImagesFromAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาดในการโหลดรูปภาพ: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('ไม่มีรูป'));
            } else {
              final allImages = snapshot.data!;
              final imageTypes = allImages.map((img) => img.imageType).toSet().toList();
              imageTypes.insert(0, 'รูปภาพทั้งหมด');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 1.0),
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
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 35,
                          iconEnabledColor: Colors.white,
                        ),
                        isExpanded: true,
                        value: _selectedFilter,
                        items: imageTypes.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value ?? '',
                            child: Text(
                              value ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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

  List<Widget> _buildFilteredImages(List<ImageRetrieveModel> allImages) {
    final List<Widget> imageWidgets = [];

    for (final image in allImages) {
      if (_selectedFilter == 'รูปภาพทั้งหมด' || _selectedFilter == image.imageType) {
        imageWidgets.add(
          ImageDisplayField(
            labelText: image.imageType ?? 'Unknown',
            imageData: image.fileData ?? '',
          ),
        );
      }
    }

    return imageWidgets;
  }
}

class ImageDisplayField extends StatelessWidget {
  final String labelText;
  final String imageData;

  const ImageDisplayField({
    super.key,
    required this.labelText,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              aspectRatio: 9 / 14,
              child: Image.memory(
                base64Decode(imageData),
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
