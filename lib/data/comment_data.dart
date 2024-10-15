import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickie_mobile/utils/url.dart';

URL url = URL();

abstract class CommentInterface {
  int get id;
  int get userId;
  String get content;
  String get timestamp;
  String get firstName;
  String get lastName;
  String get username;
  String get profileImage;
  int get likedByUser;
  List<CommentInterface> get replies;
}

class Comment implements CommentInterface {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String content;
  @override
  final String timestamp;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String username;
  @override
  final String profileImage;
  @override
  int likedByUser;
  @override
  List<Reply> replies; // Update to List<Reply>

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
    this.replies = const [], // Initialize with empty Reply list
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
          [], // Ensure it's a List<Reply>
    );
  }
}

class Reply implements CommentInterface {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String content;
  @override
  final String timestamp;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String username;
  @override
  final String profileImage;
  @override
  int likedByUser;
  @override
  List<Reply> replies; // Update to List<Reply>

  final int mainId;
  final int? parentId;

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
    this.replies = const [], // Initialize with empty Reply list
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
          [], // Ensure it's a List<Reply>
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
    final response = await http
        .get(Uri.parse(url.postsApiURL).replace(queryParameters: queryParams));

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] != null && jsonResponse['success'] is List) {
        final List<dynamic> commentList = jsonResponse['success'];
        return commentList.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('No comments found or invalid response format');
      }
    } else {
      throw Exception('Failed to load comments: ${response.reasonPhrase}');
    }
  }

  Future<Comment> sendComment(
      int postId, String content, int userId, int targetId) async {
    final Map<String, dynamic> jsonData = {
      "post_id": postId,
      "user_id": userId,
      "target_id": targetId,
      "content": content,
    };
    final Map<String, dynamic> queryParams = {
      "operation": "sendComment",
      "json": jsonEncode(jsonData),
    };
    final response = await http
        .post(Uri.parse(url.postsApiURL).replace(queryParameters: queryParams));

    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('error')) {
        throw Exception('Failed to add comment: ${jsonResponse['error']}');
      } else if (jsonResponse['success'] == "Comment posted successfully") {
        // Create a minimal Comment object with available information
        return Comment(
          id: DateTime.now().millisecondsSinceEpoch,
          userId: userId,
          content: content,
          timestamp: DateTime.now().toIso8601String(),
          firstName: "User",
          lastName: "",
          username: "",
          profileImage: "",
          likedByUser: 0,
          replies: [],
        );
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to add comment: ${response.reasonPhrase}');
    }
  }

  Future<Reply> sendReply(int? parentId, int postId, int commentId,
      String content, int userId, int targetId) async {
    final Map<String, dynamic> jsonData = {
      "parent_id": parentId,
      "user_id": userId,
      "post_id": postId,
      "main_id": commentId,
      "content": content,
      "target_id": targetId,
    };
    final Map<String, dynamic> queryParams = {
      "operation": "addCommentReply",
      "json": jsonEncode(jsonData),
    };
    final response = await http
        .post(Uri.parse(url.postsApiURL).replace(queryParameters: queryParams));

    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('error')) {
        throw Exception('Failed to add reply: ${jsonResponse['error']}');
      } else if (jsonResponse['success'] == "Reply posted successfully" ||
          jsonResponse['success'] == "Comment added successfully") {
        return Reply(
          id: DateTime.now().millisecondsSinceEpoch,
          mainId: commentId,
          parentId: parentId,
          userId: userId,
          content: content,
          timestamp: DateTime.now().toIso8601String(),
          firstName: "User",
          lastName: "",
          username: "",
          profileImage: "",
          likedByUser: 0,
          replies: [],
        );
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to add reply: ${response.reasonPhrase}');
    }
  }
}
