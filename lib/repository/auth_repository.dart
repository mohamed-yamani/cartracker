import 'dart:convert';
import 'package:carlock/constants/urls.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class AuthRepository {
  Future<bool> login(String username, String password) async {
    late final response;

    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username ou mot de passe vide');
    }

    if (username.length < 3 || password.length < 3) {
      throw Exception('Username ou mot de passe trop court');
    }

    try {
      Print.green('username: $username');
      Print.green('password: $password');
      response = await http.post(
        Uri.parse(urlLogin),
        headers: {},
        body: {
          'username': username,
          'password': password,
        },
      );
    } catch (e) {
      throw Exception('s\'il vous plait verifier votre connexion internet');
    }
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final token = responseJson['token'];
      await saveToken(token: token, user: username);
      return true;
    } else {
      // return false;
      Print.green('error ------------------------------------');
      Print.red(response.body);
      throw Exception(response.body);
    }
  }
}
