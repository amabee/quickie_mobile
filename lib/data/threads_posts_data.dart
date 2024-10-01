import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/utils/url.dart';

URL url = URL();

class Post {
  final int postID;
  final String firstname;
  final String lastname;
  final String username;
  final String time;
  final String image;
  final String content;
  final String? reply;
  int like;
  final String? contentimg;
  final List<String> endimages;
  int isLiked;

  Post(
      {required this.postID,
      required this.firstname,
      required this.lastname,
      required this.username,
      required this.image,
      required this.time,
      required this.content,
      this.reply,
      required this.like,
      required this.endimages,
      this.contentimg,
      required this.isLiked});

  factory Post.fromJson(Map<String, dynamic> json) {
    List<String> postImages = (json['post_images'] as String?) != null &&
            json['post_images'].isNotEmpty
        ? (json['post_images'] as String)
            .split(',')
            .map((img) => "${url.postsImageURL}/$img")
            .toList()
        : [];

    return Post(
      postID: json['post_id'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      username: json['username'],
      image: "${url.imageUrl}/" + json['profile_image'],
      time: json['timestamp'],
      content: json['content'],
      like: json['like_count'],
      endimages: postImages,
      contentimg: json['content_image'],
      isLiked: json['liked_by_user'] ?? 0,
    );
  }
}

class PostService {
  Future<List<Post>> fetchPosts(int userId,
      {int limit = 10, int offset = 0}) async {
    final Map<String, dynamic> jsonData = {"userId": userId};
    final Map<String, dynamic> queryParams = {
      "operation": "getPosts",
      "json": jsonEncode(jsonData),
    };

    http.Response response = await http
        .get(Uri.parse(url.postsApiURL).replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] != null && jsonResponse['success'] is List) {
        final List<dynamic> postList = jsonResponse['success'];
        if (postList.isNotEmpty) {
          return postList.map((postJson) => Post.fromJson(postJson)).toList();
        } else {
          print('No posts found.');
          return [];
        }
      } else {
        throw Exception('No posts found or invalid response format');
      }
    } else {
      throw Exception('Failed to load posts: ${response.reasonPhrase}');
    }
  }
}
