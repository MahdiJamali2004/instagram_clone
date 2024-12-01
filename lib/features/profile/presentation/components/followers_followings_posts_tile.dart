import 'package:flutter/material.dart';

class FollowersFollowingsPostsTile extends StatefulWidget {
  final int postCount;
  final int followersCount;
  final int followingsCount;
  final void Function() onFollowingsClick;
  const FollowersFollowingsPostsTile(
      {super.key,
      required this.postCount,
      required this.followersCount,
      required this.followingsCount,
      required this.onFollowingsClick});

  @override
  State<FollowersFollowingsPostsTile> createState() =>
      _FollowersFollowingsPostsTileState();
}

class _FollowersFollowingsPostsTileState
    extends State<FollowersFollowingsPostsTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _columnItem(item: 'Posts', count: widget.postCount),
        // const SizedBox(
        //   width: 40,
        // ),
        GestureDetector(
            onTap: widget.onFollowingsClick,
            child:
                _columnItem(item: 'Followers', count: widget.followersCount)),
        // const SizedBox(
        //   width: 40,
        // ),
        GestureDetector(
            onTap: widget.onFollowingsClick,
            child:
                _columnItem(item: 'Following', count: widget.followingsCount)),
      ],
    );
  }

  Widget _columnItem({required String item, required int count}) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        Text(
          item,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 18),
        )
      ],
    );
  }
}
