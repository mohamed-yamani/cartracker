import 'package:carlock/model/match.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/repository/matches_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
}
