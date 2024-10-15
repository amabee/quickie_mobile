import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/data/comment_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quickie_mobile/utils/url.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _commentList = [];
  CommentService _commentService = CommentService();

  List<Comment> get allCommentList => _commentList;

  Future<void> fetchComments(int postId) async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);

    try {
      _commentList = await _commentService.fetchComments(postId, userId);
      notifyListeners();
    } catch (error) {
      print("Failed to fetch comments for PostID: $postId, Error: $error");
    }
  }

  Future<void> addComment(int postId, String content, int targetID) async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);

    try {
      Comment newComment =
          await _commentService.sendComment(postId, content, userId, targetID);
      _commentList.insert(0, newComment);
      notifyListeners();
      fetchComments(postId);
    } catch (error) {
      print("Failed to add comment: $error");
      rethrow;
    }
  }

  Future<void> addReply(int postId, int commentId, String content, int targetID,
      {int? parentReplyId}) async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);

    try {
      Reply newReply = await _commentService.sendReply(
          parentReplyId, postId, commentId, content, userId, targetID);

      int commentIndex =
          _commentList.indexWhere((comment) => comment.id == commentId);
      if (commentIndex != -1) {
        if (parentReplyId != null) {
          _addNestedReply(
              _commentList[commentIndex].replies, parentReplyId, newReply);
        } else {
          // This is a direct reply to the main comment
          _commentList[commentIndex].replies.insert(0, newReply);
        }
        notifyListeners();
      }
      fetchComments(postId);
    } catch (error) {
      print("Failed to add reply: $error");
      rethrow;
    }
  }

  void _addNestedReply(List<Reply> replies, int parentReplyId, Reply newReply) {
    for (var reply in replies) {
      if (reply.id == parentReplyId) {
        reply.replies.insert(0, newReply);
        return;
      }
      if (reply.replies.isNotEmpty) {
        _addNestedReply(reply.replies, parentReplyId, newReply);
      }
    }
  }

  Future<void> toggleCommentLike(int commentId) async {
    URL url = URL();
    var userBox = await Hive.openBox('myBox');
    int userId = userBox.get('userId');

    int index = _commentList.indexWhere((comment) => comment.id == commentId);
    if (index == -1) {
      print("Comment not found");
      return;
    }

    bool isLiked = _commentList[index].likedByUser == 1;
    String operation = isLiked ? "unlikeComment" : "likeComment";

    final Map<String, dynamic> jsonData = {
      "user_id": userId,
      "comment_id": commentId
    };

    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(jsonData)
    };

    try {
      http.Response res = await http.post(
        Uri.parse(url.postsApiURL),
        body: queryParams,
      );

      if (res.statusCode != 200) {
        print("Status Error: ${res.statusCode}");
        return;
      }

      var response = jsonDecode(res.body);

      if (response.containsKey('error')) {
        print("Error: ${response['error']}");
      } else {
        print("Comment ${isLiked ? 'unliked' : 'liked'} successfully");
        _commentList[index].likedByUser = isLiked ? 0 : 1;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleReplyLike(int commentId, int replyId) async {
    URL url = URL();
    var userBox = await Hive.openBox('myBox');
    int userId = userBox.get('userId');

    int commentIndex =
        _commentList.indexWhere((comment) => comment.id == commentId);
    if (commentIndex == -1) {
      print("Comment not found");
      return;
    }

    Reply? reply = _findReply(_commentList[commentIndex].replies, replyId);
    if (reply == null) {
      print("Reply not found");
      return;
    }

    bool isLiked = reply.likedByUser == 1;
    String operation = isLiked ? "unlikeReply" : "likeReply";

    final Map<String, dynamic> jsonData = {
      "user_id": userId,
      "comment_id": commentId,
      "reply_id": replyId
    };

    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(jsonData)
    };

    try {
      http.Response res = await http.post(
        Uri.parse(url.postsApiURL),
        body: queryParams,
      );

      if (res.statusCode != 200) {
        print("Status Error: ${res.statusCode}");
        return;
      }

      var response = jsonDecode(res.body);

      if (response.containsKey('error')) {
        print("Error: ${response['error']}");
      } else {
        print("Reply ${isLiked ? 'unliked' : 'liked'} successfully");
        reply.likedByUser = isLiked ? 0 : 1;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Reply? _findReply(List<Reply> replies, int replyId) {
    for (var reply in replies) {
      if (reply.id == replyId) {
        return reply;
      }
      Reply? nestedReply = _findReply(reply.replies, replyId);
      if (nestedReply != null) {
        return nestedReply;
      }
    }
    return null;
  }
}
