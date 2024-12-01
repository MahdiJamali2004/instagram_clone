import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/home/presentation/component/drawer_item.dart';
import 'package:instagram_clone/features/post/presentation/pages/posts_pages.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDrawer extends StatefulWidget {
  final String currentUserId;
  final void Function()? onNavigateBackFromPostPage;
  const HomeDrawer({
    super.key,
    required this.currentUserId,
    this.onNavigateBackFromPostPage,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileuserCubit>();
  ProfileUser? profileUser;
  String getUrlFromPath(String path) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(path);
  }

  Future<void> navigateToPost() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostsPages(currentUserId: widget.currentUserId),
        ));

    if (widget.onNavigateBackFromPostPage != null) {
      widget.onNavigateBackFromPostPage!();
    }
  }

  @override
  void initState() {
    profileCubit.getProfilebyUserId(widget.currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileuserCubit, ProfileuserStates>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          profileUser = state.profileuser;
        }
        return Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      profileUser?.profilePicPath == null
                          ? const Icon(
                              Icons.person,
                              size: 80,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                imageUrl: getUrlFromPath(
                                    profileUser!.profilePicPath!),
                              ),
                            ),

                      const SizedBox(
                        height: 10,
                      ),
                      //user name
                      profileUser != null
                          ? Text(
                              profileUser!.username,
                              style: const TextStyle(
                                  fontFamily: FontFamily.oswald),
                            )
                          : const SizedBox(),

                      //email
                      profileUser != null
                          ? Text(
                              profileUser!.email,
                              style: const TextStyle(
                                  fontFamily: FontFamily.oswald),
                            )
                          : const SizedBox(),
                    ],
                  ),
                )),
              ),

              //Profile
              DrawerItem(
                  text: 'Profile',
                  icon: Icons.person_2,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userId: widget.currentUserId,
                        ),
                      ),
                    );
                  }),

              //Posts
              DrawerItem(
                  text: 'Posts',
                  icon: Icons.image,
                  onTap: () {
                    Navigator.pop(context);
                    navigateToPost();
                  }),

              //Home
              DrawerItem(
                  text: 'Home',
                  icon: Icons.home,
                  onTap: () {
                    Navigator.pop(context);
                  }),

              //editProfile
              DrawerItem(
                  text: 'EditProfile',
                  icon: Icons.edit_sharp,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            userId: widget.currentUserId,
                          ),
                        ));
                  }),

              const Spacer(),

              //Logout
              DrawerItem(
                  text: 'Logout', icon: Icons.logout, onTap: authCubit.logout),
            ],
          ),
        );
      },
    );
  }
}
