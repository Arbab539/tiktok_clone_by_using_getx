import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tago;
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controller/comment_controller.dart';


// ignore: must_be_immutable
class CommentScreen extends StatefulWidget {
  final String id;
  CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  CommentController commentController = Get.put(CommentController());

  final Map<String,TextEditingController> _editController = {};

  // Show Delete Confirmation Dialog
  showDeleteDialog(String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                commentController.deleteComment(commentId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Show Edit Comment Dialog
  showEditDialog(String commentId, String currentText) {
    if (!_editController.containsKey(commentId)) {
      _editController[commentId] = TextEditingController(text: currentText);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextFormField(
            controller: _editController[commentId],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Edit your comment',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                final newText = _editController[commentId]!.text.trim();
                if (newText.isNotEmpty) {
                  commentController.editComment(commentId, newText);
                }
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(widget.id);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Comments'
      //   ),
      // ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (commentController.isLoading) {
                    // Show linear loading indicator while posting comment
                    return const Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            minHeight: 2, // Set the minimum height of the loading indicator
                          ),
                        ),
                      ],
                    );
                  }
                  else{
                    return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return Card(
                          elevation: 3,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(comment.profilePhoto),
                                ),
                                title:Text(
                                  comment.username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tago.format(
                                        comment.datePublished.toDate(),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                trailing: comment.uid == authController.user.uid
                                    ? PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      showEditDialog(comment.id, comment.comment); // Pass commentId and currentText
                                    } else if (value == 'Delete') {
                                      showDeleteDialog(comment.id); // Pass commentId
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'Edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Delete',
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  },
                                )
                                    : null,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                title: Text(
                                  comment.comment,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        commentController.likeComment(comment.id);
                                      },
                                      icon: const Icon(Icons.thumb_up),
                                      color: comment.likes.contains(authController.user.uid)
                                          ?
                                      Colors.blue // User already liked this comment
                                          : Colors.grey,
                                    ),
                                    Text(comment.likes.length.toString()), // Display like count
                                    IconButton(
                                      onPressed: () {
                                        // Change the dislike button color to blue only when clicked

                                        commentController.dislikeComment(comment.id);

                                      },
                                      icon: Icon(Icons.thumb_down,
                                          color: comment.dislikes.contains(authController.user.uid)
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
              ),

              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  ),
                ),
                trailing: // Send Comment Button
                TextButton(
                  onPressed: () async {
                    // Show linear loading indicator when sending comment
                    commentController.startLoading();

                    // Post comment
                    await commentController.postComment(_commentController.text);

                    // Clear text field after posting comment
                    _commentController.clear();
                    // Hide linear loading indicator after comment is posted
                    commentController.stopLoading();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: buttonColor
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
