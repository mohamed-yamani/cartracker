// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:carlock/repository/patch_reg_id_to_webserver.dart';
import 'package:carlock/services/authentication.dart';
import 'package:carlock/services/matches.dart';
import 'package:carlock/services/reg_id/firebase_conf.dart';
import 'package:equatable/equatable.dart';
import 'package:print_color/print_color.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationService _auth;
  final MatchesServices _matchesService;

  HomeBloc(this._auth, this._matchesService)
      : super(RegisteringServiceState()) {
    on<LoginEvent>((event, emitter) async {
      try {
        final user = await _auth.authenticate(event.username, event.password);
        String? regId = await FirbaseConfiguration().get_reg_id();
        Print.red(regId);
        await RegIdToWebserver().PatchRegIdToWS(regId);

        emit(SuccessfulLoginState(user!));
        emit(const HomeInitial());
      } catch (e) {
        emit(FailedLoginState(e.toString()));
        emit(const HomeInitial());
      }
    });

    on<RegisteringServiceEvent>((event, emitter) async {
      await _auth.init();
      emit(const HomeInitial());
    });
  }
}
