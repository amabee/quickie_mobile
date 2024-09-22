import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/providers/post_provider.dart';

import '../data/threads_posts_data.dart';
import '../utils/bottomsheets/bottomsheet_util.dart';
import '../utils/text_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Image.asset(
                  "assets/logo.png",
                ),
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
                    letterSpacing: 2, // Adds some spacing between the letters
                    color:
                        Colors.white, // This will be overridden by the gradient
                  ),
                ),
              ),
            ],
          ),
          Consumer<PostProvider>(builder: (context, provider, child) {
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
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.2))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                post.image,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: TitleText(text: post.name)),
                                    Text(
                                      post.time,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showmoresheet(context);
                                      },
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10, top: 5),
                                  child: NormalText(text: post.content),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                post.contentimg == null
                                    ? Container()
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(post.contentimg!)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    provider.likedList.contains(index)
                                        ? GestureDetector(
                                            onTap: () {
                                              provider.likePost(index);
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(
                                                CupertinoIcons.heart_fill,
                                                color: Colors.red,
                                              ),
                                            ))
                                        : GestureDetector(
                                            onTap: () {
                                              provider.likePost(index);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                CupertinoIcons.heart,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Icon(
                                            CupertinoIcons.chat_bubble,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          showRepostsheet(context);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Icon(
                                            CupertinoIcons.repeat,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          showsharesheet(context);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Icon(
                                            CupertinoIcons.paperplane,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${post.reply} replies ",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${post.like} likes ",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 55),
                          alignment: Alignment.centerLeft,
                          child: const VerticalDivider(
                            thickness: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: Stack(
                          children: [
                            const SizedBox(
                              height: 35,
                              width: 35,
                            ),
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 9,
                                backgroundImage: AssetImage(
                                  post.endimages[0],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 20,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundImage: AssetImage(
                                  post.endimages[1],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundImage: AssetImage(
                                  post.endimages[2],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }),
        ],
      ),
    )));
  }
}
