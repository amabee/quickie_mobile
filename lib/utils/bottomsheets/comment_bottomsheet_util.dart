import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/actions/actions.dart';
import 'package:quickie_mobile/data/comment_data.dart';
import 'package:quickie_mobile/providers/comments_provider.dart';
import 'package:quickie_mobile/utils/timeago.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;
  final int postUserID;
  const CommentBottomSheet({
    Key? key,
    required this.postId,
    required this.postUserID,
  }) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController commentController = TextEditingController();
  bool isSendingComment = false;
  CommentInterface? replyingTo;

  @override
  void initState() {
    super.initState();
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.postId);
  }

  Widget _buildCommentTree(CommentInterface comment, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FacebookStyleCommentCard(
          name: '${comment.firstName} ${comment.lastName}',
          comment_id: comment.id,
          comment: comment.content,
          commenterImage: comment.profileImage,
          likeCount: 0,
          timeAgo: timeAgo(comment.timestamp),
          depth: depth,
          replies: comment.replies,
          isLikedByCurrentUser: comment.likedByUser,
          isMainComment: comment is Comment,
          parentCommentId: comment is Reply ? (comment as Reply).id : null,
          onReply: () => _initiateReply(comment),
        ),
      ],
    );
  }

  void _initiateReply(CommentInterface comment) {
    setState(() {
      replyingTo = comment;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(FocusNode());
    });

     print(comment.firstName);
  }

  void _cancelReply() {
    setState(() {
      replyingTo = null;
    });
  }

  Future<void> _sendComment() async {
    if (commentController.text.isNotEmpty) {
      setState(() {
        isSendingComment = true;
      });

      try {
        final commentProvider =
            Provider.of<CommentProvider>(context, listen: false);
        if (replyingTo != null) {
          await commentProvider.addReply(widget.postId, replyingTo!.id,
              commentController.text, replyingTo!.userId);
        } else if (replyingTo != null) {
        } else {
          await commentProvider.addComment(
            widget.postId,
            commentController.text,
            widget.postUserID,
          );
        }
        commentController.clear();
        _cancelReply();
      } catch (e) {
        print('Error sending comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send comment. Please try again.')),
        );
      } finally {
        setState(() {
          isSendingComment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 60,
            child: const Center(
              child: Text(
                "Comments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
          ),
          const Divider(height: 1),
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
                    padding: const EdgeInsets.all(16),
                    children: commentProvider.allCommentList
                        .map<Widget>((comment) => _buildCommentTree(comment, 0))
                        .toList(),
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (replyingTo != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Replying to ${replyingTo!.firstName}",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: _cancelReply,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.blue[800]),
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: replyingTo != null
                              ? 'Write a reply...'
                              : 'Write a comment...',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: isSendingComment ? null : _sendComment,
                    ),
                  ],
                ),
                if (isSendingComment)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Sending comment...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
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
  final int comment_id;
  final String name;
  final String comment;
  final String commenterImage;
  final int likeCount;
  final String timeAgo;
  final int depth;
  final List<CommentInterface> replies;
  final int isLikedByCurrentUser;
  final bool isMainComment;
  final int? parentCommentId;
  final Function()? onReply;

  const FacebookStyleCommentCard({
    Key? key,
    required this.name,
    required this.comment_id,
    required this.comment,
    required this.commenterImage,
    required this.likeCount,
    required this.timeAgo,
    this.depth = 0,
    this.replies = const [],
    required this.isLikedByCurrentUser,
    required this.isMainComment,
    this.parentCommentId,
    this.onReply,
  }) : super(key: key);

  @override
  _FacebookStyleCommentCardState createState() =>
      _FacebookStyleCommentCardState();
}

class _FacebookStyleCommentCardState extends State<FacebookStyleCommentCard> {
  bool _showReplies = false;

  void _handleLike() {
    if (widget.isMainComment) {
      Provider.of<CommentProvider>(context, listen: false)
          .toggleCommentLike(widget.comment_id);
    } else {
      Provider.of<CommentProvider>(context, listen: false)
          .toggleReplyLike(widget.parentCommentId!, widget.comment_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
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
                          Text(
                            widget.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(widget.comment),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.timeAgo,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: _handleLike,
                                    icon: widget.isLikedByCurrentUser == 1
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(Icons.favorite_outline),
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
                        GestureDetector(
                          onTap: widget.onReply,
                          child: Text(
                            'Reply ${widget.comment_id}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.replies.isNotEmpty) ...[
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showReplies && widget.replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.replies
                  .map((reply) => FacebookStyleCommentCard(
                        name: '${reply.firstName} ${reply.lastName}',
                        comment_id: reply.id,
                        comment: reply.content,
                        commenterImage: reply.profileImage,
                        likeCount: reply.likedByUser,
                        timeAgo: timeAgo(reply.timestamp),
                        depth: widget.depth + 1,
                        replies: reply.replies,
                        isLikedByCurrentUser: reply.likedByUser,
                        isMainComment: false,
                        parentCommentId: widget.comment_id,
                        onReply: () => {widget.onReply?.call()},
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
