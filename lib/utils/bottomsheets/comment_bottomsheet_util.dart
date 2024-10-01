import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/data/comment_data.dart';
import 'package:quickie_mobile/providers/comments_provider.dart';

class DraggableBottomSheet extends StatefulWidget {
  final int postId;

  const DraggableBottomSheet({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _DraggableBottomSheetState createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.postId);
  }

  Widget _buildCommentTree(Comments comment, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstagramCommentCard(
          username:
              comment.commenter_firstname + ' ' + comment.commenter_lastname,
          comment: comment.comment_content,
          commenterImage: comment.commenter_profileImage,
          depth: depth,
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16.0 * depth),
            child: Column(
              children: comment.replies
                  .map((reply) => _buildCommentTree(reply, depth + 1))
                  .toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 80,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 30,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                const SizedBox(height: 5),
                const Center(
                  child: Text(
                    "Comments",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Consumer<CommentProvider>(
              builder: (context, commentProvider, child) {
                if (commentProvider.allCommentList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No comments yet.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Text(
                          "Start the conversation.",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: commentProvider.allCommentList
                          .map((comment) => _buildCommentTree(comment, 0))
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(""),
                  maxRadius: 24,
                  minRadius: 24,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                // Add your send comment functionality here
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InstagramCommentCard extends StatelessWidget {
  final String username;
  final String comment;
  final String commenterImage;
  final int depth;

  const InstagramCommentCard({
    Key? key,
    required this.username,
    required this.comment,
    required this.commenterImage,
    required this.depth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin:
          EdgeInsets.only(left: 8.0 * depth, right: 8.0, top: 4.0, bottom: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(commenterImage),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Wrap(
                    children: [
                      Text(
                        comment,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add reply functionality here
                        },
                        child: Text('Reply'),
                      ),
                      IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {
                          // Add like functionality here
                        },
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '0', // Replace with actual like count
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
