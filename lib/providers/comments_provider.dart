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

  void likeComment(int index) {
    if (index < 0 || index >= _commentList.length) {
      print("Invalid index: $index");
      return;
    }

    _commentList[index].likedByUser =
        _commentList[index].likedByUser == 1 ? 0 : 1;
    notifyListeners();
  }
}
