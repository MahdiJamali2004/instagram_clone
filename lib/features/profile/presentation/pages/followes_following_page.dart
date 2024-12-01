import 'package:flutter/material.dart';
import 'package:instagram_clone/features/profile/presentation/components/follower_following_widget.dart';

class FollowesFollowingPage extends StatefulWidget {
  final List<String> followers;
  final List<String> followings;

  const FollowesFollowingPage(
      {super.key, required this.followers, required this.followings});

  @override
  State<FollowesFollowingPage> createState() => _FollowesFollowingPageState();
}

class _FollowesFollowingPageState extends State<FollowesFollowingPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          labelColor: Theme.of(context).colorScheme.inversePrimary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          dividerColor: Theme.of(context).colorScheme.secondary,
          controller: tabController,
          tabs: [
            Tab(
              text: 'Following',
            ),
            Tab(
              text: 'Followers',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          //followings
          _buildList(widget.followings.length, widget.followings),
          //followers
          _buildList(widget.followers.length, widget.followers),
        ],
      ),
    );
  }

  Widget _buildList(int itemCount, List<String> userIds) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return FollowerFollowingWidget(
          userId: userIds[index],
        );
      },
    );
  }
}
