import 'package:bloc/bloc.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/model/user_me_model.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/user_me_services.dart';
import 'package:equatable/equatable.dart';
import 'package:print_color/print_color.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserMeServices userMeServices;

  ProfileBloc(this.userMeServices) : super(ProfileInitial());

  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    Print.red('LoadUserMeEvent here');
    if (event is LoadUserMeEvent) {
      Print.red('LoadUserMeEvent here');
      yield ProfileLoadingState();
      try {
        UserMeModel userMe = await userMeServices.getUserMe(event.username);
        TokenModel? token = await getToken();
        yield ProfileLoadedState(userMe, token);
      } catch (e) {
        yield ProfileErrorState(e.toString());
      }
    }
  }
}
