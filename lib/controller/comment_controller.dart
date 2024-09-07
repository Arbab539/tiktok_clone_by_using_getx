import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../model/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;


  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;



  String _postId = '';


  startLoading() {
    _isLoading.value = true;
  }

  stopLoading() {
    _isLoading.value = false;
  }

  void clearCommentTextField() {
    _commentController.clear();
  }


  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Comment> retValue = [];
      for (var element in snapshot.docs) {
        retValue.add(Comment.fromSnap(element));
      }
      return retValue;
    }));
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await fireStore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          dislikes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',

        );
        await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(
          comment.toJson(),
        );
        DocumentSnapshot doc =
        await fireStore.collection('videos').doc(_postId).get();
        await fireStore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
        'dislikes': FieldValue.arrayRemove([uid]),
      });
    }
  }


  // Function to dislike a comment

  dislikeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['dislikes'].contains(uid)) {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'dislikes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
        'dislikes': FieldValue.arrayUnion([uid]),
      });
    }
  }



  deleteComment(String id) async {
    await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .delete();
    DocumentSnapshot documentSnapshot =
    await fireStore.collection('videos').doc(_postId).get();
    await fireStore.collection('videos').doc(_postId).update({
      'commentCount': (documentSnapshot.data()! as dynamic)['commentCount'] - 1,
    });
  }

  editComment(String id, String newText) async {
    try {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({'comment': newText});
    } catch (e) {
      Get.snackbar(
        'Error While Editing Comment',
        e.toString(),
      );
    }
  }

}
