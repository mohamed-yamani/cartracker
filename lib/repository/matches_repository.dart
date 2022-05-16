import 'dart:convert';
import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class MatchesRepository {
  Future<MatchesModel> getMathesFromWe() async {
    try {
      TokenModel? tokenModel = await getToken();
      final response = await http.get(Uri.parse(urlMatches), headers: {
        'Accept': 'application/json',
        "authorization": "Bearer ${tokenModel?.token}",
      });
      if (response.statusCode == 200) {
        return MatchesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw 'please check your internet connection';
    }
  }

  Future<MatchesModel> searchByRegisterNumber(
      final String username, final String registerNumber) async {
    try {
      TokenModel? tokenModel = await getToken();
      final response = await http
          .get(Uri.parse('$myUrl/api/match/?search=$registerNumber'), headers: {
        'Accept': 'application/json',
        "authorization": "Bearer ${tokenModel?.token}",
      });
      if (response.statusCode == 200) {
        return MatchesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw 'please check your internet connection';
    }
  }

  Future<MatchesModel> searchByDate(
      final String username, final String date) async {
    try {
      TokenModel? tokenModel = await getToken();
      final response =
          await http.get(Uri.parse('$myUrl/api/match/?user=$date'), headers: {
        'Accept': 'application/json',
        "authorization": "Bearer ${tokenModel?.token}",
      });
      if (response.statusCode == 200) {
        return MatchesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw 'please check your internet connection';
    }
  }
}
