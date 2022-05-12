import 'package:carlock/model/matches_model.dart';
import 'package:carlock/repository/matches_repository.dart';

class MatchesServices {
  Future<MatchesModel> getAll(final String username) {
    Future<MatchesModel> matches = MatchesRepository().getMathesFromWe();
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MatchesModel> getByDate(final String username, final String date) {
    Future<MatchesModel> matches = MatchesRepository().getMathesFromWe();
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MatchesModel> getByRegisterNumber(
      final String username, final String registerNumber) {
    Future<MatchesModel> matches =
        MatchesRepository().searchByRegisterNumber(username, registerNumber);
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
