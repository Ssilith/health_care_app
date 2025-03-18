import 'package:cloud_firestore/cloud_firestore.dart';

class Notebook {
  final String? id;
  final String? userId;
  final String creationDate;
  final String noteTitle;
  final String noteContent;

  Notebook({
    this.id,
    this.userId,
    required this.creationDate,
    required this.noteTitle,
    required this.noteContent,
  });

  factory Notebook.fromSnaphot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Notebook(
      id: snapshot.id,
      userId: data['userId'] as String?,
      creationDate: data['creationDate'] as String,
      noteTitle: data['noteTitle'] as String,
      noteContent: data['noteContent'] as String,
    );
  }

  Map<String, dynamic> toDTOMap(String userId) {
    return {
      'userId': userId,
      'creationDate': creationDate,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'creationDate': creationDate,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
    };
  }

}
