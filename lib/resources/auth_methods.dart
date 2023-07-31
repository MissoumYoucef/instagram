import 'dart:typed_data';

import 'package:chatapp/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'some error occur';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        //
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // add profilePicture to database

        String photoUrl = await StorageMethods().uploadImageToStorage(
            childName: 'profilepics', file: file, isPost: false);

        // add user to database

        model.User user = model.User(
            userName: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl);

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'succes';
      }
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occur';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // register user
        //
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'succes';
      }
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
