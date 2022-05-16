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

  ProfileBloc(this.userMeServices) : super(ProfileInitial()) {
    on<LoadUserMeEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        UserMeModel userMe = await userMeServices.getUserMe(event.username);
        TokenModel? user = await getToken();
        emit(ProfileLoadedState(userMe, user));
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });
  }
}
