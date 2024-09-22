import 'package:flutter/foundation.dart';
import '../data/threads_posts_data.dart';

class PostProvider extends ChangeNotifier {
  List<int> _likedList = [];

  get allPostList => postlist;
  get likedList => _likedList;

  void likePost(int id) {
    if (_likedList.contains(id)) {
      postlist[id].like = postlist[id].like - 1;
      _likedList.remove(id);
    } else {
      postlist[id].like = postlist[id].like + 1;
      _likedList.add(id);
    }

    notifyListeners();
  }
}
