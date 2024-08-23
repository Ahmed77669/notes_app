import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'note_event.dart';
import 'note_state.dart';
import 'package:notes/takingNote.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final Box<TakingNote> noteBox;

  NoteBloc(this.noteBox) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final notes = noteBox.values.toList();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to load notes'));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final docRef = await firestore.collection('Notes').add({
        'title': event.title,
        'note': event.description,
        'imageBase64': event.imageBase64,
        'background': event.theme,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final note = TakingNote(
        title: event.title,
        note: event.description,
        imageBase64: event.imageBase64,
        background: event.theme,
        firestoreId: docRef.id,
      );

      await noteBox.add(note);

      final notes = noteBox.values.toList();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to add note'));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      final note = noteBox.get(event.index) as TakingNote;

      // Update the note in Hive
      final updatedNote = TakingNote(
        title: event.title,
        note: event.description,
        imageBase64: event.imageBase64,
        background: event.theme,
        firestoreId: note.firestoreId,
      );

      await noteBox.put(event.index, updatedNote);

      final notes = noteBox.values.toList();
      emit(NoteLoaded(notes));

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('Notes').doc(updatedNote.firestoreId).update({
        'title': event.title,
        'note': event.description,
        'imageBase64': event.imageBase64,
        'background': event.theme,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(NoteError('Failed to update note: $e'));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await noteBox.deleteAt(event.index);

      if (event.firestoreId != null) {
        final firestore = FirebaseFirestore.instance;
        await firestore.collection('Notes').doc(event.firestoreId).delete();
      }

      final notes = noteBox.values.toList();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to delete note: $e'));
    }
  }
}
