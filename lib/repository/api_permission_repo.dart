import 'dart:convert';

import 'package:carlock/model/permission_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class PermisionRepository {
  Future<List<dynamic>> getPermissionRepo() async {
    try {
      TokenModel? tokenModel = await getToken();
      final response = await http.get(
          Uri.parse('https://matricule.icebergtech.net/api/permission'),
          headers: {
            'Accept': 'application/json',
            "authorization": "Bearer ${tokenModel?.token}",
          });
      if (response.statusCode == 200) {
        return response.body.isNotEmpty
            ? json.decode(response.body)
            : throw Exception('Failed to load Permission');
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      Print.red(e);
      throw '$e';
    }
  }
}
