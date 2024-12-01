import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();
  late final profieCubit = context.read<ProfileuserCubit>();
  File? image;

  String getUrlFromImgPath({required String imgpath}) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(imgpath);
  }

  Future<void> selectImage() async {
    final fileImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (fileImage == null) return;
    setState(() {
      image = File(fileImage.path);
    });
  }

  Future<void> updateProfile({required ProfileUser profileUser}) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();

    if (bioController.text.isEmpty && image == null) {
      context.showCustomSnackBar('There is nothing to update.');
    } else {
      await profieCubit
          .updateProfileUser(
              userId: profileUser.userId,
              file: image,
              bio: bioController.text.isNotEmpty
                  ? bioController.text
                  : profileUser.bio,
              profilePicPath: image != null
                  ? 'profilepicture/$imageName'
                  : profileUser.profilePicPath)
          .whenComplete(
        () {
          if (mounted) {
            context.showCustomSnackBar('Profile updated succecfully.');
          }
        },
      );
    }
  }

  @override
  void initState() {
    profieCubit.getProfilebyUserId(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileuserCubit, ProfileuserStates>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          final profileUser = state.profileuser;
          bioController.text = profileUser.bio;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontFamily: FontFamily.oswald),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    updateProfile(profileUser: profileUser);
                  },
                  icon: const Icon(
                    Icons.check,
                  ),
                )
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profileUser.profilePicPath == null && image == null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Theme.of(context).colorScheme.secondary),
                            child: Center(
                                child: Icon(
                              Icons.person,
                              size: 90,
                              color: Theme.of(context).colorScheme.primary,
                            )))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: profileUser.profilePicPath != null
                                ? CachedNetworkImage(
                                    imageUrl: getUrlFromImgPath(
                                        imgpath: profileUser.profilePicPath!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    image!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                    image == null
                        ? const Text(
                            'Select image from device...',
                            style: TextStyle(
                                fontFamily: FontFamily.oswald, fontSize: 18),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: selectImage,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Select image',
                          style: TextStyle(
                              fontFamily: FontFamily.oswald,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //bioHint
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Bio',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            fontFamily: FontFamily.oswald,
                            fontSize: 16),
                      ),
                    ),
                    //biofield
                    MyTextField(obscureText: false, controller: bioController),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileUserErrorState) {
          return Scaffold(
            body: Center(
              child: Text('error ${state.error}'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
