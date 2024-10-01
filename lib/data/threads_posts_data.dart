import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/utils/url.dart';

URL url = URL();

class Post {
  final String name;
  final String time;
  final String image;
  final String content;
  final String? reply;
  int like;
  final String? contentimg;
  final List<String> endimages;

  Post({
    required this.name,
    required this.image,
    required this.time,
    required this.content,
    this.reply,
    required this.like,
    required this.endimages,
    this.contentimg,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Check if post_images is not null or empty, then split it
    List<String> postImages =
        json['post_images'] != null && json['post_images'].isNotEmpty
            ? [json['post_images']]
            : [];

    return Post(
      name: json['username'],
      image: url.imageUrl + json['profile_image'],
      time: json['timestamp'],
      content: json['content'],
      like: json['like_count'],
      endimages: postImages,
      contentimg: json['content_image'],
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

    // Log the entire response body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Log response body

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] != null && jsonResponse['success'] is List) {
        final List<dynamic> postList = jsonResponse['success'];
        if (postList.isNotEmpty) {
          // Check if there are any posts
          return postList.map((postJson) => Post.fromJson(postJson)).toList();
        } else {
          print('No posts found.');
          return []; // Return an empty list if no posts are found
        }
      } else {
        throw Exception('No posts found or invalid response format');
      }
    } else {
      throw Exception('Failed to load posts: ${response.reasonPhrase}');
    }
  }
}
