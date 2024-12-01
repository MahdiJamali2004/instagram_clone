import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowerFollowingWidget extends StatefulWidget {
  final String userId;

  const FollowerFollowingWidget({super.key, required this.userId});

  @override
  State<FollowerFollowingWidget> createState() =>
      _FollowerFollowingWidgetState();
}

class _FollowerFollowingWidgetState extends State<FollowerFollowingWidget> {
  late final ProfileuserCubit profileCubit = context.read<ProfileuserCubit>();

  String getUrlFromPath(String path) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(path);
  }

  @override
  void initState() {
    profileCubit.getProfilebyUserId(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocBuilder<ProfileuserCubit, ProfileuserStates>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          final profileUser = state.profileuser;
          return Row(
            children: [
              //image
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userId: widget.userId),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Colors.black,
                              width: 3.0,
                            )),
                        child: profileUser.profilePicPath == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) {
                                    return const CircularProgressIndicator();
                                  },
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  imageUrl: getUrlFromPath(
                                      profileUser.profilePicPath!),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      profileUser.username,
                      style: const TextStyle(
                          fontFamily: FontFamily.oswald,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.person,
                size: 40,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
