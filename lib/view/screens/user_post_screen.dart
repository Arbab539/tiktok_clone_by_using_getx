import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../../constants.dart';
import '../../controller/vedio_controller.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_item.dart';
import 'comment_screen.dart';


class UserPostScreen extends StatefulWidget {
  final String id;  // This is the user id
  final int initialIndex;

  const UserPostScreen({Key? key, required this.id, required this.initialIndex}) : super(key: key);

  @override
  State<UserPostScreen> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {
  final VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    // Fetch only the user's videos
    videoController.getUserVideos(widget.id);
  }

  buildProfilePhoto(String profilePhoto){
    return SizedBox(
      height: 55,
      width: 55,
      child: Container(
        height: 45,
        width: 45,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image(image: NetworkImage(profilePhoto),fit: BoxFit.cover,)),
      ),
    );
  }
  buildMusicProfile(String profilePhoto){
    return SizedBox(
      height: 55,
      width: 55,
      child: Container(
        height: 45,
        width: 45,
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image(image: NetworkImage(profilePhoto),fit: BoxFit.cover,)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // If user-specific video list is empty, show a loading indicator
        if (videoController.userVideoList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return PageView.builder(
          itemCount: videoController.userVideoList.length,
          controller: PageController(initialPage: widget.initialIndex, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.userVideoList[index];
            return Stack(
              children: [
                VideoPlayerItem(videoUrl: data.videoUrl),
                Column(
                  children: [
                    SizedBox(height: 100,),
                    Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(

                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      data.username,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      data.caption,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white
                                      ),
                                    ),
                                    if(data.songName.isNotEmpty)
                                      Row(
                                        children: [
                                          Icon(Icons.music_note,size: 15,color: Colors.white,),
                                          Text(
                                            data.songName,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfilePhoto(data.profilePhoto),
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            videoController.likeVideo(data.id);
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            size: 40,
                                            color: data.likes.contains(authController.user.uid)
                                                ? Colors.pinkAccent:Colors.white,
                                          )),
                                      SizedBox(height: 7,),
                                      Text(data.likes.length.toString(),
                                        style: TextStyle(fontSize: 20,color: Colors.white),),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context)=>CommentScreen(id: data.id,)));
                                          },
                                          child: Icon(Icons.comment,size: 40,)),
                                      SizedBox(height: 7,),
                                      Text(data.commentCount.toString(),style: TextStyle(fontSize: 20,color: Colors.white),),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: () async{
                                            await Share.share(data.videoUrl);
                                          },
                                          child: Icon(Icons.share,size: 40,)),
                                      SizedBox(height: 7,),
                                      Text('Share',style: TextStyle(fontSize: 15,color: Colors.white),),
                                    ],
                                  ),
                                  CircleAnimation(child: buildMusicProfile(data.profilePhoto))
                                ],
                              ),
                            )
                          ],
                        )
                    )
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }
}

