import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/utilisateurs_repository.dart';
import 'package:print_color/print_color.dart';

class UtilisateursServices {
  Future<UtilisateursModel> getAll(final String username) {
    Future<UtilisateursModel> matches =
        UtilisateursRepository().getUtilisateursFromWebService();

    // return matches;
    Print.red('youssra test');
    try {
      return matches;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
