import 'package:carlock/model/match.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/repository/matches_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:print_color/print_color.dart';

class MatchesServices {
  late Box<MatchModel> _matchBox;

  Future<MatchesModel> getAll(final String username) {
    Future<MatchesModel> matches = MatchesRepository().getMathesFromWe();

    // return matches;
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MatchesModel> getByDate(final String username, final String date) {
    Future<MatchesModel> matches = MatchesRepository().getMathesFromWe();
    Print.yellow('wow $date $matches');

    // return matches;
    throw Exception('wow');
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
