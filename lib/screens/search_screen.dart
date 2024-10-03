import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/actions/actions.dart';
import 'package:quickie_mobile/data/search_data.dart';
import 'package:quickie_mobile/providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false)
          .initializeRecommendedUsers();
    });

    _searchController.addListener(() {
      String query = _searchController.text;
      if (query.isNotEmpty) {
        Provider.of<SearchProvider>(context, listen: false).searchUsers(query);
      } else {
        Provider.of<SearchProvider>(context, listen: false)
            .clearSearchedUsers();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 120.0,
              elevation: 0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                title: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      icon: Icon(
                        CupertinoIcons.search,
                        color: Colors.grey.shade600,
                      ),
                      hintText: "Search...",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                background: Container(
                  height: 20,
                  width: 100,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            if (searchProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (searchProvider.error.isNotEmpty) {
              return const Center(
                child: Text(
                  "No user found",
                  style: TextStyle(fontSize: 24),
                ),
              );
            } else if (searchProvider.searchedUsers.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: searchProvider.searchedUsers.length,
                itemBuilder: (context, index) {
                  final user = searchProvider.searchedUsers[index];
                  return buildUserTile(context, user);
                },
              );
            } else if (searchProvider.recommendedUsers.isEmpty) {
              return const Center(child: Text("No recommended users found"));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: searchProvider.recommendedUsers.length,
                itemBuilder: (context, index) {
                  final user = searchProvider.recommendedUsers[index];
                  return buildUserTile(context, user);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildUserTile(BuildContext context, SearchItem user) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.image),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.only(bottom: 10),
              height: 85,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${user.firstname} ${user.lastname}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "@${user.username}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          "${user.followers} followers",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Call the provider to toggle follow status
                        Provider.of<SearchProvider>(context, listen: false)
                            .toggleFollowStatus(user.userId);
                      },
                      child: Row(
                        children: [
                          Icon(
                            user.isFollowing == 1
                                ? Icons.check
                                : Icons.person_add,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.isFollowing == 1 ? "Following" : "Follow",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
