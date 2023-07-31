import 'package:chatapp/resources/auth_methods.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
