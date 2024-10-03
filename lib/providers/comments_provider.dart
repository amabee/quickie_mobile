import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/data/comment_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentProvider extends ChangeNotifier {
  List<Comment> _commentList = [];

  List<Comment> get allCommentList => _commentList;

  Future<void> fetchComments(int postId) async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);
    CommentService commentService = CommentService();

    try {
      _commentList = await commentService.fetchComments(postId, userId);
      notifyListeners();
    } catch (error) {
      print("Failed to fetch comments for PostID: $postId, Error: $error");
    }
  }

  // Like/unlike a comment
  void likeComment(int commentIndex) {
    if (commentIndex < 0 || commentIndex >= _commentList.length) {
      print("Invalid index: $commentIndex");
      return;
    }

    _commentList[commentIndex].likedByUser =
        _commentList[commentIndex].likedByUser == 1 ? 0 : 1;
    notifyListeners();
  }

  // Like/unlike a reply
  void likeReply(int commentIndex, int replyIndex) {
    if (commentIndex < 0 || commentIndex >= _commentList.length) {
      print("Invalid comment index: $commentIndex");
      return;
    }

    if (replyIndex < 0 ||
        replyIndex >= _commentList[commentIndex].replies.length) {
      print("Invalid reply index: $replyIndex");
      return;
    }

    _commentList[commentIndex].replies[replyIndex].likedByUser =
        _commentList[commentIndex].replies[replyIndex].likedByUser == 1 ? 0 : 1;
    notifyListeners();
  }
}
