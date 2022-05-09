import 'package:carlock/model/match.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/matches_repository.dart';
import 'package:carlock/repository/utilisateurs_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UtilisateursServices {
  Future<UtilisateursModel> getAll(final String username) {
    Future<UtilisateursModel> matches =
        UtilisateursRepository().getUtilisateursFromWebService();

    // return matches;
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
