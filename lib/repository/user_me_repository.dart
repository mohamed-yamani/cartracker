import 'dart:convert';

import 'package:carlock/model/token.dart';
import 'package:carlock/model/user_me_model.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class UserMeRepository {
  Future<UserMeModel> getUserMeFromWebService() async {
    Print.green('bloc working');
    try {
      TokenModel? tokenModel = await getToken();
      final response = await http.get(
          Uri.parse('https://platereader.icebergtech.net/api/user/me'),
          headers: {
            'Accept': 'application/json',
            "authorization": "Bearer ${tokenModel?.token}",
          });
      if (response.statusCode == 200) {
        Print.green(
            'UserMeRepository: data from web service is ${response.body}');
        return UserMeModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
