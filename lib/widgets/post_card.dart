import 'package:chatapp/providers/user_provider.dart';
import 'package:chatapp/resources/firestore_methods.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:chatapp/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../screens/comment_screen.dart';

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLenght = 0;

  @override
  void initState() {
    super.initState();
    getCommentLen();
  }

  void getCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLenght = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://plus.unsplash.com/premium_photo-1690164161383-f5ff30a790bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=900&q=60'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.all(8.0),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.snap['postId'].toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList()),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.menu),
                )
              ],
            ),
          ),

          //Image Section

          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  'https://plus.unsplash.com/premium_photo-1690164161383-f5ff30a790bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=900&q=60',
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isChild: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(seconds: 1),
                  smallLike: true,
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),

          //Like Comment Section

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                duration: const Duration(seconds: 1),
                isChild: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.snap['likes'].contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ));
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              )
            ],
          ),

          //Description and number of comment

          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '${widget.snap['description']} f',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                  ),
                ),

                //
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text('View all $commentLenght comments',
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(widget.snap['datePublished'],
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
