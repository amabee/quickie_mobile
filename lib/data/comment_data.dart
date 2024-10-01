import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickie_mobile/utils/url.dart';

URL url = URL();

class Comment {
  final int id;
  final int userId;
  final String content;
  final String timestamp;
  final String firstName;
  final String lastName;
  final String username;
  final String profileImage;
  int likedByUser;
  List<Reply> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profileImage,
    this.likedByUser = 0,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['comment_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      profileImage: "${url.imageUrl}/${json['profile_image'] ?? ''}",
      likedByUser: json['liked_by_user'] ?? 0,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) => Reply.fromJson(reply))
              .toList() ??
          [],
    );
  }
}

class Reply {
  final int id;
  final int mainId;
  final int? parentId;
  final int userId;
  final String content;
  final String timestamp;
  final String firstName;
  final String lastName;
  final String username;
  final String profileImage;
  int likedByUser;
  List<Reply> replies;

  Reply({
    required this.id,
    required this.mainId,
    this.parentId,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profileImage,
    this.likedByUser = 0,
    this.replies = const [],
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] ?? 0,
      mainId: json['main_id'] ?? 0,
      parentId: json['parent_id'],
      userId: json['user_id'] ?? 0,
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      profileImage: "${url.imageUrl}/${json['profile_image'] ?? ''}",
      likedByUser: json['liked_by_user'] ?? 0,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) => Reply.fromJson(reply))
              .toList() ??
          [],
    );
  }
}

class CommentService {
  Future<List<Comment>> fetchComments(int postId, int userId) async {
    final Map<String, dynamic> jsonData = {
      "post_id": postId,
      "user_id": userId,
    };
    final Map<String, dynamic> queryParams = {
      "operation": "getComments",
      "json": jsonEncode(jsonData),
    };
    final response = await http.get(
        Uri.parse(url.postsApiURL).replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] != null &&
          jsonResponse['success'] is List) {
        final List<dynamic> commentList = jsonResponse['success'];
        return commentList.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('No comments found or invalid response format');
      }
    } else {
      throw Exception('Failed to load comments: ${response.reasonPhrase}');
    }
  }
}