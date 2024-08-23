import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Widgets/BottomToTop.dart';
import 'package:notes/note_bloc.dart';
import 'package:notes/note_state.dart';
import 'package:notes/note_event.dart';

import 'package:notes/note_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/main.dart';
import 'package:notes/takingNote.dart';
import 'package:notes/Boxes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final noteBox = await Hive.openBox<TakingNote>('noteBox');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NoteBloc(noteBox)),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const notes(
        title: 'Add Note',
        theme: "hearts.jpg",
      ),
    );
  }
}

class notes extends StatefulWidget {
  const notes({super.key, required this.title, required this.theme});

  final String title;
  final String theme;

  @override
  State<notes> createState() => _MyNotesState();
}

class _MyNotesState extends State<notes> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController noteDescriptionController =
      TextEditingController();
  String? imageBase64;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = File(pickedFile.path).readAsBytesSync();
      setState(() {
        imageBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
        ),

              body:SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: widget.theme != null
                      ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/${widget.theme}'),
                      fit: BoxFit.cover,
                    ),
                  )
                      : null,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 25,
                              color: widget.theme == "heartsTree.jpg" ||
                                      widget.theme == "hearts.jpg" ||
                                      widget.theme == ""
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: TextFormField(
                          controller: noteController,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: 'Enter Title',
                            filled: true,
                            fillColor: Colors.blue[50],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 25,
                              color: widget.theme == "heartsTree.jpg" ||
                                      widget.theme == "hearts.jpg" ||
                                      widget.theme == ""
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[50],
                        ),
                        child: TextFormField(
                          controller: noteDescriptionController,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter description...',
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Attach a photo:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.theme == "heartsTree.jpg" ||
                                  widget.theme == "hearts.jpg" ||
                                  widget.theme == ""
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      if (imageBase64 != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.memory(
                            base64Decode(imageBase64!),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            BlocProvider.of<NoteBloc>(context).add(
                              AddNote(
                                noteController.text,
                                noteDescriptionController.text,
                                imageBase64,
                                widget.theme,
                              ),
                            );
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                  title: 'Notes',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 2, 120, 205),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),
              ),
        //     }
        //   },
        // ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 255, 172, 81),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          onPressed: _pickImage,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      // ),
    );
  }
}
