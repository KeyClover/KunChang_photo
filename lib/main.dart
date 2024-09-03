import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kunchang_photo/pages/display_image.dart';
import 'package:kunchang_photo/pages/take_picture_page.dart';
// import 'package:kunchang_photo/pages/blank_page.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:kunchang_photo/provider/images_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider(
            create: (BuildContext context) => ImagesProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'KunChang',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MyHomePage(title: 'KunChang'),
        ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const TabBarView(
          children: [
            TakePicturePage(),
            DisplayImagePage(),
          ],
        ),
        backgroundColor: HexColor("#2e3150"),

        bottomNavigationBar: 
          
          
             TabBar(
              labelStyle: const TextStyle(fontSize: 20.0),
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(60), color: HexColor("#2e3150")),
              tabs: [
                Tab(
                  child: Container(
                
                    
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("รูปภาพ"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                 
                  
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("ถัดไป"),
                    ),
                  ),
                ),
              ],
            
                    ),
         
      ),
    );
  }
}
