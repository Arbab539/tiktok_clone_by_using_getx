
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../constants.dart';
import '../model/video.dart';

class UploadVideoController extends GetxController{

  var isUploading = false.obs;
  var isCompressing = false.obs;

  _compressVideo(String videoPath) async{

    final compressVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressVideo!.file;
  }



  Future<String> _uploadVideoToStorage(String id,String videoPath) async{
    Reference reference = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = reference.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    Get.back();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id,String videoPath) async{
    Reference reference = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = reference.putFile(await _getThumbnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }



  uploadVideo(String songName,String caption,String videoPath) async{
    try{
      isUploading.value = true; // Start uploading
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await fireStore.collection('users').doc(uid).get();
      //video id
      var allDoc = await fireStore.collection('videos').get();
      int len = allDoc.docs.length;

      String videoUrl = await _uploadVideoToStorage('Video $len',videoPath);
      String thumbnail = await _uploadImageToStorage('Video $len',videoPath);

      Video video = Video(
          id: 'Video $len',
          username: (userDoc.data()! as Map<String,dynamic>)['name'],
          uid: uid,
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePhoto: (userDoc.data() as Map<String,dynamic>)['profilePhoto']
      );
      await fireStore.collection('videos').doc('Video $len').set(video.toMap());

      isUploading.value = false; // Finish uploading
      Get.back();
    }
    catch(e){
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
      isUploading.value = false; // Stop uploading on error
    }
  }


}