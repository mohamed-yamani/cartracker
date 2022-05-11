import 'dart:convert';
import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;

class UtilisateursRepository {
  Future<UtilisateursModel> getUtilisateursFromWebService() async {
    try {
      TokenModel? tokenModel = await getToken();
      final response = await http.get(Uri.parse(utilisateursUrl), headers: {
        'Accept': 'application/json',
        "authorization": "Bearer ${tokenModel?.token}",
      });
      if (response.statusCode == 200) {
        return UtilisateursModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      // throw 'something went wrong';
      throw e.toString();
    }
  }
}
