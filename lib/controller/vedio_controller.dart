import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../model/video.dart';




class VideoController extends GetxController {
  static VideoController instance = Get.find();

  // Observable list of all videos
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  // Observable list for user-specific videos
  final Rx<List<Video>> _userVideoList = Rx<List<Video>>([]);
  List<Video> get userVideoList => _userVideoList.value;

  @override
  void onInit() {
    super.onInit();
    // Automatically fetch and bind all videos when initialized
    _videoList.bindStream(fetchAllVideos());
  }

  // Stream to fetch all videos
  Stream<List<Video>> fetchAllVideos() {
    return fireStore.collection('videos').snapshots().map((QuerySnapshot snapshot) {
      List<Video> returnValue = [];
      for (var element in snapshot.docs) {
        returnValue.add(Video.fromSnap(element));
      }
      return returnValue;
    });
  }

  // Fetch user-specific videos based on the uid
  void getUserVideos(String uid) {
    _userVideoList.bindStream(fireStore
        .collection('videos')
        .where('uid', isEqualTo: uid)  // Query to get only videos of the specific user
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Video> returnValue = [];
      for (var element in snapshot.docs) {
        returnValue.add(Video.fromSnap(element));
      }
      return returnValue;
    }));
  }

  // Like or unlike a video
  likeVideo(String id) async {
    DocumentSnapshot snapshot = await fireStore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((snapshot.data() as dynamic)['likes'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
