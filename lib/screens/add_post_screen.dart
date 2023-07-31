import 'dart:typed_data';

import 'package:chatapp/models/user.dart';
import 'package:chatapp/providers/user_provider.dart';
import 'package:chatapp/resources/firestore_methods.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController textEditingController = TextEditingController();
  Uint8List? file;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () async {
                await _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: webBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('post To'),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.userName, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                if(isLoading) const LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'write a caption',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }

  Future<void> _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create A post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(15.0),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List fil = await pickImage(ImageSource.camera);
                setState(() {
                  file = fil;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(15.0),
              child: const Text('choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List fil = await pickImage(ImageSource.gallery);
                setState(() {
                  file = fil;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(15.0),
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FireStoreMethods().uploadPost(
          textEditingController.text, uid, username, profileImage, file!);
      if (res == "success") {
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }
}
