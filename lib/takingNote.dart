import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'takingNote.g.dart';

@HiveType(typeId: 1)
class TakingNote {
  TakingNote(
      {required this.title,
      required this.note,
      this.imageBase64,
      required this.background,
      this.firestoreId});

  @HiveField(0)
  String title;

  @HiveField(1)
  String note;

  @HiveField(2)
  String? imageBase64;

  @HiveField(3)
  String? background;

  @HiveField(4)
  String? firestoreId;
}
