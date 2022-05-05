import 'package:bloc/bloc.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/matches_repository.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/matches.dart';
import 'package:equatable/equatable.dart';
part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final MatchesServices _todoService;
  final repo = MatchesRepository();

  MatchesBloc(this._todoService) : super(MatchesInitial()) {
    on<LoadMatchesEvent>((event, emit) async {
      emit(MatchesLoadingState());
      try {
        MatchesModel matches = await _todoService.getAll(event.username);
        TokenModel? user = await getToken();
        emit(MatchesLoadedState(matches, user));
      } catch (e) {
        emit(MatchesErrorState(e.toString()));
      }
    });
  }
}
