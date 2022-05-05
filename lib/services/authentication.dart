import 'package:carlock/model/user.dart';
import 'package:carlock/repository/auth_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthenticationService {
  late Box<User> _userBox;

  Future<void> init() async {
    try {
      Hive.registerAdapter(UserAdapter());
    } catch (e) {
      print(e.toString());
    }
    _userBox = await Hive.openBox('user');
    await _userBox.clear();

    await _userBox.add(User('user', 'password'));
    await _userBox.add(User('user2', 'password2'));
  }

  Future<String?> authenticate(String username, String password) async {
    try {
      await AuthRepository().login(username, password);

      return username;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
