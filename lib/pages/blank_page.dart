import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: const Text('this is for test'),)
    );
  
    
  }
}