import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/threads_posts_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostProvider extends ChangeNotifier {
  List<Post> _postList = [];

  List<Post> get allPostList => _postList;

  Future<void> fetchPosts() async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);
    PostService postService = PostService();

    try {
      _postList = await postService.fetchPosts(userId);
      notifyListeners();
    } catch (error) {
      print("Current UserID: $userId");
      print('Failed to fetch posts: $error');
    }
  }

  void likePost(int index) {
    if (index < 0 || index >= _postList.length) {
      print("Invalid index: $index");
      return;
    }

    if (_postList[index].isLiked == 1) {
      _postList[index].like--;
      _postList[index].isLiked = 0;
      
    } else {
      _postList[index].like++;
      _postList[index].isLiked = 1;
    }

    notifyListeners();
  }
}