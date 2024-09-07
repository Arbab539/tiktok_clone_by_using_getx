import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../../controller/upload_vedio_controller.dart';
import '../widgets/text_input_field.dart';


class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController videoPlayerController;
  bool isVideoPaused = false;
  Timer? _resetTimer;
  bool _singleTapMessageShown = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.videoFile);
    videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    videoPlayerController.play();
    videoPlayerController.setVolume(1);
    //videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  void toggleVideoPlayback() {
    setState(() {
      if (isVideoPaused) {
        videoPlayerController.play();
      } else {
        videoPlayerController.pause();
      }
      isVideoPaused = !isVideoPaused;
    });
  }

  void _handleDoubleTap(
      UploadVideoController uploadVideoController,
      TextEditingController songController,
      TextEditingController captionController
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Obx(() {
          if (uploadVideoController.isUploading.value) {
            return const AlertDialog(
              title: Text("Uploading Video..."),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please wait while the video is being uploaded..."),
                  SizedBox(height: 13),
                  LinearProgressIndicator(
                    minHeight: 2,
                  ),
                ],
              ),
            );
          } else {
            // Close the dialog if uploading is complete
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });

            uploadVideoController.uploadVideo(
              songController.text,
              captionController.text,
              widget.videoPath,
            ).then((_) {
              // Show Snackbar after successful upload
              Get.snackbar(
                'Successfully Uploaded',
                'Congratulations! Video Successfully Uploaded',
              );
            });

            return Container(); // or any other widget when not uploading
          }
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final TextEditingController songController = TextEditingController();
    final TextEditingController captionController = TextEditingController();

    UploadVideoController uploadVideoController = Get.put(UploadVideoController());

    void _handleSingleTap() {
      if (!_singleTapMessageShown) {
        Get.snackbar(
          'Upload Video',
          'Please tap again to confirm upload',
        );
        _singleTapMessageShown = true;

        _handleDoubleTap(uploadVideoController, songController, captionController);



        //Reset the single tap message flag after a short duration
        _resetTimer?.cancel(); // Cancel any previous timer
        _resetTimer = Timer(const Duration(seconds: 2), () {
          _singleTapMessageShown = false;
        });
      }
    }



    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  InkWell(
                    onTap: toggleVideoPlayback,
                    child: VideoPlayer(videoPlayerController),
                  ),
                  if (isVideoPaused)
                    const Center(
                      child: Icon(
                        Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextInputField(
                          controller: songController,
                          iconData: Icons.music_note,
                          labelText: 'Song Name',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextInputField(
                          controller: captionController,
                          iconData: Icons.closed_caption,
                          labelText: 'Caption',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: _handleSingleTap,
                          // onDoubleTap: () {
                          //   _handleDoubleTap(uploadVideoController, songController, captionController);
                          // },
                          child: Container(
                            height: 60,
                            width: 120,
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Upload!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
