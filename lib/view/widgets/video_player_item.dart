import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool isVideoPaused = false;
  bool isVideoLoading = true; // Add a boolean to track video loading state

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isVideoLoading = false; // Update loading state when video is initialized
        });
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
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

  Widget videoPlayerWidget() {
    return InkWell(
      onTap: toggleVideoPlayback,
      child: VideoPlayer(videoPlayerController),
    );
  }

  Widget loadingIndicator() {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Center(
          child: CircularProgressIndicator(), // Changed to CircularProgressIndicator for loading
        ),
      ),
    );
  }

  Widget playIcon() {
    return const Center(
      child: Icon(
        Icons.play_arrow,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  Widget videoProgressIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: VideoProgressIndicator(
        videoPlayerController,
        allowScrubbing: true,
        colors: const VideoProgressColors(
          playedColor: Colors.red,
          bufferedColor: Colors.grey,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        children: [
          // Video Player Widget
          videoPlayerWidget(),
          // Loading Indicator
          if (isVideoLoading) loadingIndicator(),
          // Play Icon
          if (isVideoPaused && !isVideoLoading) playIcon(),
          // Video Progress Indicator
          if (!isVideoLoading) videoProgressIndicator(),
        ],
      ),
    );
  }

}
