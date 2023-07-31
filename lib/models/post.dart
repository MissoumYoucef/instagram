import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String profileImage;
  final List likes;

  const Post( 
      {required this.description,
      required this.uid,
      required this.userName,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImage,
      required this.likes,
      });

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': userName,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes,
        'postUrl': postUrl
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      userName: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
    );
  }
}
