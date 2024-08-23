// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'takingNote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TakingNoteAdapter extends TypeAdapter<TakingNote> {
  @override
  final int typeId = 1;

  @override
  TakingNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TakingNote(
      title: fields[0] as String,
      note: fields[1] as String,
      imageBase64: fields[2] as String?,
      background: fields[3] as String?,
      firestoreId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TakingNote obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.imageBase64)
      ..writeByte(3)
      ..write(obj.background)
      ..writeByte(4)
      ..write(obj.firestoreId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TakingNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
