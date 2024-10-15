import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickie_mobile/utils/url.dart';

class SearchItem {
  final String firstname;
  final String lastname;
  final String username;
  final String followers;
  final String image;
  final int userId;
  int isFollowing;

  SearchItem({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.image,
    required this.followers,
    required this.userId,
    this.isFollowing = 0,
  });
}

class UserService {
  final URL url = URL();

  Future<List<SearchItem>> fetchRecommendedUsers(int userID) async {
    final Map<String, dynamic> jsonData = {"user_id": userID};
    final Map<String, dynamic> queryParams = {
      "operation": "suggestUsersToFollow",
      "json": jsonEncode(jsonData),
    };

    final response = await http.get(
      Uri.parse(url.usersApiURL).replace(queryParameters: queryParams),
    );

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] != null && jsonResponse['success'] is List) {
        final List<dynamic> userList = jsonResponse['success'];
        return userList.map((userJson) {
          return SearchItem(
              firstname: userJson['first_name'] ?? "",
              lastname: userJson['last_name'] ?? "",
              username: userJson['username'],
              image: "${url.imageUrl}/${userJson['profile_image']}",
              followers: userJson['follower_count']?.toString() ?? 'N/A',
              userId: userJson['user_id'],
              isFollowing: userJson['is_following'] ?? 0);
        }).toList();
      } else {
        throw Exception('No users found or invalid response format');
      }
    } else {
      throw Exception(
          'Failed to load recommended users: ${response.statusCode}');
    }
  }

  Future<List<SearchItem>> fetchSearchedUsers(
      String searchedPerson, int current_ID) async {
    final Map<String, dynamic> jsonData = {
      "search_query": searchedPerson,
      "current_user_id": current_ID
    };
    final Map<String, dynamic> queryParams = {
      "operation": "searchUser",
      "json": jsonEncode(jsonData),
    };

    final response = await http.get(
      Uri.parse(url.usersApiURL).replace(queryParameters: queryParams),
    );

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] != null && jsonResponse['success'] is List) {
        final List<dynamic> userList = jsonResponse['success'];
        return userList.map((userJson) {
          return SearchItem(
              firstname: userJson['first_name'] ?? "",
              lastname: userJson['last_name'] ?? "",
              username: userJson['username'],
              image: "${url.imageUrl}/${userJson['profile_image']}",
              followers: userJson['follower_count']?.toString() ?? 'N/A',
              userId: userJson['user_id'],
              isFollowing: userJson['is_following']);
        }).toList();
      } else {
        throw Exception('No users found or invalid response format');
      }
    } else {
      throw Exception('Failed to load searched users: ${response.statusCode}');
    }
  }
}
