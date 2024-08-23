import 'package:equatable/equatable.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String description;
  final String? imageBase64;
  final String theme;

  const AddNote (this.title, this.description, this.imageBase64, this.theme);

  @override
  List<Object?> get props => [title, description, imageBase64, theme];
}

class UpdateNote extends NoteEvent {
  final int index;
  final String title;
  final String description;
  final String? imageBase64;
  final String theme;

  const UpdateNote(this.index, this.title, this.description, this.imageBase64, this.theme);

  @override
  List<Object?> get props => [index, title, description, imageBase64, theme];
}
class DeleteNote extends NoteEvent {
  final int index;
  final String? firestoreId;

  DeleteNote({
    required this.index,
    this.firestoreId,
  });
}