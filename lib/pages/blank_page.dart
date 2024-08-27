import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:circular_menu/circular_menu.dart';
// import 'package:kunchang_photo/pages/take_picture_page.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:freestyle_speed_dial/freestyle_speed_dial.dart';
import 'package:kunchang_photo/pages/display_image.dart';

/* This page is for Test speeddial widget and any other feature in the application */

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('this is for test'),
      ),
      body: const Center(child: Text('content goes here')),
    
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              const SizedBox(width: 48.0), // Space for the FAB
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: SpeedDialBuilder(
        
        buttonBuilder: (context, isActive, toggle) => Container(
           width: 70.0,
          height: 80.0,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            onPressed: toggle,
              child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubicEmphasized,
              turns: isActive ? 0.125 : 0,
              child: isActive
                  ? const Icon(
                      Icons.add,
                      color: Colors.amber,
                    )
                  : const Icon(
                      Icons.menu_open_outlined,
                      color: Colors.amber,
                    ),
            ),
          ),
        ),
         // Adjust padding as needed
       
itemBuilder: (context, Widget item, i, animation) {
          // radius in relative units to each item
          const radius = 1.6;
          // angle in radians
          final angle = i * (pi / 4) + pi;

          final targetOffset = Offset(
            radius * cos(angle),
            radius * sin(angle),
          );

          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0, 0),
            end: targetOffset,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: item,
            ),
          );
        },
        items: [
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.search),
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.wallet),
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DisplayImagePage())),
            child: const Icon(Icons.camera_alt),
          ),
          // FloatingActionButton(
          //   shape: const CircleBorder(),
          //   onPressed: () {},
          //   child: const Icon(Icons.qr_code_scanner),
          // ),
        ],
         
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
    
  }
}
