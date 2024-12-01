import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class CreatePostPage extends StatefulWidget {
  final String currentUserId;

  const CreatePostPage({super.key, required this.currentUserId});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final postCubit = context.read<PostCubit>();
  File? postImage;
  bool isLoading = false;
  final descriptionController = TextEditingController();

  void selectImage() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    setState(() {
      postImage = File(xfile.path);
    });
  }

  void createPost() {
    if (mounted) {
      if (postImage == null) {
        context.showCustomSnackBar('Please select image for post');
        return;
      }
      if (descriptionController.text.isEmpty) {
        context.showCustomSnackBar('Please proivde description for post');
        return;
      }
      final String name = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        isLoading = true;
      });
      postCubit
          .createPost(
              post: Post(
                userId: widget.currentUserId,
                description: descriptionController.text,
                likes: [],
                imgPath: 'posts/$name',
                comments: [],
              ),
              postImage: postImage!)
          .whenComplete(
        () {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            context.showCustomSnackBar('Post created succefully');
            Navigator.pop(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(fontFamily: FontFamily.oswald),
        ),
        actions: [
          IconButton(
            onPressed: createPost,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  //image
                  postImage != null
                      ? AspectRatio(
                          aspectRatio: isLandscape == true ? 1.91 / 1 : 4 / 5,
                          child: Image.file(
                            postImage!,
                            fit: BoxFit.cover,
                          ))
                      : const SizedBox(),

                  //selectpic button & text
                  postImage == null
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        //descriptionHint
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Description',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                                fontFamily: FontFamily.oswald,
                                fontSize: 16),
                          ),
                        ),
                        //Descriptionfield
                        MyTextField(
                            obscureText: false,
                            controller: descriptionController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
