import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/notes.dart';

import 'Widgets/noteTheame.dart';
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const home(title: 'Notes'),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key, required this.title});

  final String title;

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTheme(context, "studying.jpg", "Studying Theme", "", "studying.jpg"),
                  buildTheme(context, "hearts.jpg", "Hearts Theme", "", "hearts.jpg"),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTheme(context, "matrix.png", "Matrix Theme", "", "matrix.png"),
                  buildTheme(context, "blackTriangle.png", "Black Triangle", "", "blackTriangle.png"),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTheme(context, "binary.jpg", "Binary Theme", "", "binary.jpg"),
                  buildTheme(context, "heartsTree.jpg", "Hearts Tree", "", "heartsTree.jpg"),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTheme(context, "", "Empty", "Empty", ""),
                ],
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255, 255, 172, 81),
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => notes(title: "Add Note", theme)),
      //     );
      //   },
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}
