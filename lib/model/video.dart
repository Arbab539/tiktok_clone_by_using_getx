
import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;

  Video({
    required this.id,
    required this.username,
    required this.uid,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap()=>{
    'id':id,
    'username':username,
    'uid':uid,
    'likes':likes,
    'commentCount':commentCount,
    'shareCount':shareCount,
    'songName':songName,
    'caption':caption,
    'videoUrl':videoUrl,
    'thumbnail':thumbnail,
    'profilePhoto':profilePhoto,
  };

  static Video fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String,dynamic>;
    return Video(
        id: snap['id'] ?? '',
        username:  snap['username'] ?? '',
        uid: snap['uid'] ?? '',
        likes: snap['likes'] ?? '',
        commentCount: snap['commentCount'] ?? '0',
        shareCount: snap['shareCount'] ?? '0',
        songName: snap['songName'] ?? '',
        caption: snap['caption'] ?? '',
        videoUrl: snap['videoUrl'] ?? '',
        thumbnail: snap['thumbnail'] ?? '',
        profilePhoto: snap['profilePhoto'] ?? ''
    );
  }

}