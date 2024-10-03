import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/data/comment_data.dart';
import 'package:quickie_mobile/providers/comments_provider.dart';
import 'package:quickie_mobile/utils/timeago.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;

  const CommentBottomSheet({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.postId);
  }

  Widget _buildCommentTree(dynamic comment, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FacebookStyleCommentCard(
          name: '${comment.firstName} ${comment.lastName}',
          comment: comment.content,
          commenterImage: comment.profileImage,
          likeCount: 0,
          timeAgo: timeAgo(comment.timestamp),
          depth: depth,
          replies: comment.replies,
          isLikedByCurrentUser: comment.likedByUser,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 60,
            child: Center(
              child: Text(
                "Comments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Consumer<CommentProvider>(
              builder: (context, commentProvider, child) {
                if (commentProvider.allCommentList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No comments yet. Be the first to comment!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: commentProvider.allCommentList
                        .map<Widget>((comment) => _buildCommentTree(comment, 0))
                        .toList(),
                  );
                }
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(""), // Replace with user's avatar
                  radius: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                    child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      // Add border
                      borderRadius: BorderRadius.circular(
                          12.0), // Optional: rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Normal state border
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color:
                            Colors.grey, // Color when textfield is not focused
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Focused state border
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Color when textfield is focused
                        width: 2.0,
                      ),
                    ),
                  ),
                )),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    // Add your send comment functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacebookStyleCommentCard extends StatefulWidget {
  final String name;
  final String comment;
  final String commenterImage;
  final int likeCount;
  final String timeAgo;
  final int depth;
  final List<dynamic> replies;
  final int isLikedByCurrentUser;

  const FacebookStyleCommentCard({
    Key? key,
    required this.name,
    required this.comment,
    required this.commenterImage,
    required this.likeCount,
    required this.timeAgo,
    this.depth = 0,
    this.replies = const [],
    required this.isLikedByCurrentUser,
  }) : super(key: key);

  @override
  _FacebookStyleCommentCardState createState() =>
      _FacebookStyleCommentCardState();
}

class _FacebookStyleCommentCardState extends State<FacebookStyleCommentCard> {
  bool _showReplies = false;

  Widget _buildReply(dynamic reply) {
    return FacebookStyleCommentCard(
      name: '${reply.firstName} ${reply.lastName}',
      comment: reply.content,
      commenterImage: reply.profileImage,
      likeCount: reply.likedByUser,
      timeAgo: '2h',
      depth: widget.depth + 1,
      replies: reply.replies,
      isLikedByCurrentUser: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.commenterImage),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            widget.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text(widget.comment),
                              ),
                              SizedBox(width: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: widget.isLikedByCurrentUser == 1
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_outline),
                                    iconSize: 15,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                  Text(
                                    widget.isLikedByCurrentUser.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.timeAgo,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (widget.replies.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showReplies = !_showReplies;
                          });
                        },
                        child: Text(
                          _showReplies
                              ? 'Hide Replies'
                              : 'Show ${widget.replies.length} ${widget.replies.length == 1 ? 'Reply' : 'Replies'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showReplies)
          Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.replies
                  .map<Widget>((reply) => _buildReply(reply))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
