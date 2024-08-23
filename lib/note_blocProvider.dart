import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Boxes.dart';
import 'package:notes/home.dart';
import 'package:notes/note_bloc.dart';
import 'package:notes/takingNote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final noteBox = await Hive.openBox<TakingNote>('noteBox');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NoteBloc(noteBox)),
      ],
      child: MyApp(),
    ),
  );
}