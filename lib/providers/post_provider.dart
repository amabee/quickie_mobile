import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/threads_posts_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostProvider extends ChangeNotifier {
  List<Post> _postList = [];
  List<int> _likedList = [];

  List<Post> get allPostList => _postList;
  List<int> get likedList => _likedList;

  Future<void> fetchPosts() async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);
    PostService postService = PostService();

    try {
      _postList = await postService.fetchPosts(userId);
      print('Fetched posts: $_postList');
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

    if (_likedList.contains(index)) {
      _postList[index].like--;
      _likedList.remove(index);
    } else {
      _postList[index].like++;
      _likedList.add(index);
    }

    notifyListeners();
  }
}
