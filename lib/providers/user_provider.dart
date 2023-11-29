import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:coffee/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(
    id: '',
    name: '',
    email:'',
    password: '',
    address:'',
    type:'',
    token:'',
    cart: [],
  );
  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}