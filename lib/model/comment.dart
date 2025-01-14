import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  List likes;
  List dislikes;
  String profilePhoto;
  String uid;
  String id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.dislikes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });


  Map<String, dynamic> toJson() => {
    'username': username,
    'comment': comment,
    'datePublished': datePublished,
    'likes': likes,
    'dislikes': dislikes,
    'profilePhoto': profilePhoto,
    'uid': uid,
    'id': id,
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      dislikes: snapshot['dislikes'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }
}