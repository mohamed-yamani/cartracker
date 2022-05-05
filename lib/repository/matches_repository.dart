import 'dart:convert';
import 'package:carlock/model/matches_model.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class MatchesRepository {
  Future<MatchesModel> getMathesFromWe() async {
    late MatchesModel matches;
    var myUrl = Uri.parse("https://matricule.icebergtech.net/api/match/");

    try {
      final response = await http.get(myUrl, headers: {
        'Accept': 'application/json',
        "authorization": "Bearer " "babcc1fef4eada4129bc0976367ffaba84a30fb8",
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
