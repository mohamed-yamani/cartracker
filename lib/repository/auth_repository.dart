import 'dart:convert';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class AuthRepository {
  Future<bool> login(String username, String password) async {
    late final response;

    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username or password is empty');
    }

    if (username.length < 3 || password.length < 3) {
      throw Exception('Username or password is too short');
    }

    try {
      response = await http.post(
        Uri.parse('https://matricule.icebergtech.net/api/token-auth/'),
        headers: {},
        body: {
          'username': username,
          'password': password,
        },
      );
    } catch (e) {
      throw Exception('please check your internet connection');
    }
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final token = responseJson['token'];
      await saveToken(token: token, user: username);
      return true;
    } else {
      // return false;
      Print.green('error ------------------------------------');
      throw Exception('Invalid username or password');
    }
  }
}
