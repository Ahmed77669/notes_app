import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  // Future addNote(Map<String, dynamic> noteInformation,String id)async {
  //   try {
  //     return await FirebaseFirestore.instance.collection("Notes").doc(id).set(
  //         noteInformation);
  //   } catch (e) {
  //     print("Error adding task: $e");
  //     throw e;
  //   }
  // }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNoteToFirestore(String title, String content, String image ){
    return firestore.collection('Notes').add({
      'title': title,
      'content': content,
      'image': image,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future deleteNote(String id)async{
    try{
      DocumentReference docRef = FirebaseFirestore.instance.collection("Notes").doc(id);
      await docRef.delete();
    }catch(e){
   print('error $e');
    }

  }

  Future<void> updateNote(String id, Map<String, dynamic> updatedTaskInformation) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection("Notes")
          .doc(id);
      await docRef.update(updatedTaskInformation);
      print("Task with ID $id updated successfully.");
    } catch (e) {
      print("Error updating task with ID $id: $e");
    }
  }}