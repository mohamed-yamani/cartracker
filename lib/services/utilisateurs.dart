import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/utilisateurs_repository.dart';

class UtilisateursServices {
  Future<UtilisateursModel> getAll(final String username) {
    Future<UtilisateursModel> matches =
        UtilisateursRepository().getUtilisateursFromWebService();

    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
