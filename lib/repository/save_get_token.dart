import 'package:carlock/model/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum UserHive { user, token }

Future<void> saveToken({@required token, @required user}) async {
  await Hive.openBox('myTokenBox'); //!hive open box
  var box = Hive.box('myTokenBox'); //!hive box
  box.put('token', token); //!hive put token
  box.put('user', user); //!hive put user
}

Future<TokenModel?> getToken() async {
  await Hive.openBox('myTokenBox'); //!hive open box
  var box = Hive.box('myTokenBox'); //!hive box
  try {
    return TokenModel(box.get('token'), box.get('user')); //!hive get token and user
  } catch (e) {
    Exception('Failed to get token'); //! exception
  }
  return null;
}

Future<void> deleteToken() async {
  await Hive.openBox('myTokenBox'); //!hive open box
  var box = Hive.box('myTokenBox'); //!hive box
  box.delete('token'); //!hive delete token
  box.delete('user'); //!hive delete user
}
