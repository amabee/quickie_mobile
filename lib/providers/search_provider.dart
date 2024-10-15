import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/actions/actions.dart';
import 'package:quickie_mobile/data/search_data.dart';

class SearchProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  List<SearchItem> _recommendedUsers = [];
  List<SearchItem> _searchedUsers = [];
  bool _isLoading = false;
  String _error = '';

  List<SearchItem> get recommendedUsers => _recommendedUsers;
  List<SearchItem> get searchedUsers => _searchedUsers;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> initializeRecommendedUsers() async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);

    if (_recommendedUsers.isEmpty) {
      _isLoading = true;
      notifyListeners();

      try {
        _recommendedUsers = await _userService.fetchRecommendedUsers(userId);
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchRecommendedUsers() async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _recommendedUsers = await _userService.fetchRecommendedUsers(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUsers(String query) async {
    int userId = await Hive.box('myBox').get('userId', defaultValue: 0);
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _searchedUsers = await _userService.fetchSearchedUsers(query, userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchedUsers() {
    _searchedUsers = [];
    _error = '';
    notifyListeners();
  }

  void toggleFollowStatus(int userId) {
    void updateUser(List<SearchItem> userList) {
      final userIndex = userList.indexWhere((user) => user.userId == userId);
      if (userIndex != -1) {
        final user = userList[userIndex];
        user.isFollowing = user.isFollowing == 1 ? 0 : 1;

        if (user.isFollowing == 1) {
          followUser(userId);
        } else {
          unfollowUser(userId);
        }
      }
    }

    updateUser(_recommendedUsers);
    updateUser(_searchedUsers);

    notifyListeners();
  }
}
