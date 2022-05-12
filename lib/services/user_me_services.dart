import 'package:carlock/model/user_me_model.dart';
import 'package:carlock/repository/user_me_repository.dart';

class UserMeServices {
  Future<UserMeModel> getUserMe(final String username) {
    Future<UserMeModel> userMe = UserMeRepository().getUserMeFromWebService();
    try {
      return userMe;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}