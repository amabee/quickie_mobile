import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/actions/actions.dart';
import 'package:quickie_mobile/providers/comments_provider.dart';
import 'package:quickie_mobile/providers/post_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickie_mobile/utils/bottomsheets/comment_bottomsheet_util.dart';
import 'package:quickie_mobile/utils/instagram_carousel/instagram_carousel.dart';
import 'package:quickie_mobile/utils/timeago.dart';

import '../data/threads_posts_data.dart';
import '../utils/bottomsheets/bottomsheet_util.dart';
import '../utils/text_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    postProvider.fetchPosts();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 110,
                    child: Image.asset("assets/logo.png"),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      "uickie",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<PostProvider>(
                builder: (context, provider, child) {
                  if (provider.allPostList.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.allPostList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Post post = provider.allPostList[index];
                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(post.image),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TitleText(
                                              text:
                                                  "${post.firstname} ${post.lastname}",
                                            ),
                                          ),
                                          Text(
                                            timeAgo(post.time),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              showmoresheet(context);
                                            },
                                            child: const Icon(Icons.more_horiz,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 5),
                                        child: NormalText(text: post.content),
                                      ),
                                      const SizedBox(height: 10),
                                      if (post.endimages.isNotEmpty)
                                        InstagramStyleCarousel(
                                            images: post.endimages),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              post.isLiked == 0
                                                  ? likePost(post.postID)
                                                  : unlikePost(post.postID);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                post.isLiked == 1
                                                    ? CupertinoIcons.heart_fill
                                                    : CupertinoIcons.heart,
                                                color: post.isLiked == 1
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                  create: (_) =>
                                                      CommentProvider(),
                                                  child:
                                                      DraggableScrollableSheet(
                                                    initialChildSize: 0.9,
                                                    minChildSize: 0.5,
                                                    maxChildSize: 0.95,
                                                    builder: (_, controller) =>
                                                        CommentBottomSheet(
                                                      postId: post.postID,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                CupertinoIcons.chat_bubble,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showRepostsheet(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                CupertinoIcons.repeat,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showsharesheet(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                CupertinoIcons.paperplane,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text(
                                            "${post.reply ?? '0'} replies ",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "${post.like} likes ",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 55),
                              alignment: Alignment.centerLeft,
                              child: const VerticalDivider(thickness: 2),
                            ),
                          ),
                          const Positioned(
                            bottom: 5,
                            left: 5,
                            child: Stack(
                              children: [
                                SizedBox(height: 35, width: 35),
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 9,
                                    backgroundImage: NetworkImage(""),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 20,
                                  child: CircleAvatar(
                                    radius: 7,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
