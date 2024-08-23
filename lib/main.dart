import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/note_bloc.dart';
import 'package:notes/note_state.dart';
import 'package:notes/notes.dart';
import 'package:notes/takingNote.dart';
import 'package:notes/Widgets/BottomToTop.dart';
import 'package:notes/update.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(TakingNoteAdapter());

  final boxNotes = await Hive.openBox<TakingNote>('boxNotes');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoteBloc(boxNotes),
        ),
      ],
      child: MyApp(),
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
      home: const MyHomePage(title: 'Notes'),
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
  Box<TakingNote>? boxNotes;
  List<TakingNote> notes = [];

  final List<Color> colors = [
    Color.fromARGB(255, 142, 213, 244),
    Color.fromARGB(255, 40, 49, 53),
    Color.fromARGB(242, 0, 255, 227),
    Color.fromARGB(255, 250, 218, 104),
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotes();
  }

  Future<void> _initializeNotes() async {
    boxNotes = Hive.box<TakingNote>('boxNotes');
    // Optionally load notes here
    // _loadNotes();
  }

  // Future<void> _loadNotes() async {
  //   setState(() {
  //     notes = boxNotes?.values.toList() ?? [];
  //     for (var note in notes) {
  //       print(
  //           'Title: ${note.title}, Note: ${note.note}, ImageBase64: ${note.imageBase64}');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TakingNote>('boxNotes').listenable(),
        builder: (context, Box<TakingNote> box, _) {
          final notes = box.values.toList();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              Color itemColor = colors[index % colors.length];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => update(
                              title: "Add Note",
                              note: note.title,
                              noteDescription: note.note,
                              theme: note.background ?? '',
                              imageBase64: note.imageBase64,
                              index: index,
                              firestoreId: note.firestoreId
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: itemColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          child: Text(
                            note.note,
                            maxLines: 1, // Display only one line of text
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (note.imageBase64 != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.memory(
                            base64Decode(note.imageBase64!),
                            fit: BoxFit.cover,
                            width: 70,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 172, 81),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onPressed: () {
          Navigator.push(
            context,
            BottomToTopPageRoute(page: const home(title: "Add Note")),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
