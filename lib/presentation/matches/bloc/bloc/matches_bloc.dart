import 'package:bloc/bloc.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/localisation.dart';
import 'package:carlock/repository/matches_repository.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/matches.dart';
import 'package:equatable/equatable.dart';
import 'package:print_color/print_color.dart';
part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final MatchesServices _todoService;
  final repo = MatchesRepository();
  My_Localisation myLocalisation = My_Localisation();

  MatchesBloc(this._todoService) : super(MatchesInitial()) {
    on<LoadMatchesEvent>((event, emit) async {
      emit(MatchesLoadingState());
      try {
        MatchesModel matches = await _todoService.getAll(event.username);
        TokenModel? user = await getToken();
        // myLocalisation.updateLocation();
        emit(MatchesLoadedState(matches, user));
      } catch (e) {
        emit(MatchesErrorState(e.toString()));
      }
    });
    on<MatchesRefreshEvent>((event, emit) async {
      emit(MatchesLoadingState());
      try {
        MatchesModel matches = await _todoService.getAll(event.username);
        TokenModel? user = await getToken();
        // myLocalisation.updateLocation();
        emit(MatchesLoadedState(matches, user));
      } catch (e) {
        emit(MatchesErrorState(e.toString()));
      }
    });
    on<MatchesSearchDateEvent>((event, emit) async {
      emit(MatchesLoadingState());
      Print.red('MatchesSearchEvent here');
      try {
        MatchesModel matches =
            await _todoService.getByDate(event.username, event.searchDate);
        TokenModel? user = await getToken();
        // myLocalisation.updateLocation();
        emit(MatchesLoadedState(matches, user));
      } catch (e) {
        emit(MatchesErrorState(e.toString()));
      }
    });
    on<MatchesSearchRegisterNumberEvent>((event, emit) async {
      emit(MatchesLoadingState());
      Print.red('MatchesSearchRegisterNumberEvent here');
      try {
        MatchesModel matches = await _todoService.getByRegisterNumber(
            event.username, event.searchRegisterNumber);
        TokenModel? user = await getToken();
        // myLocalisation.updateLocation();
        emit(MatchesLoadedState(matches, user));
      } catch (e) {
        emit(MatchesErrorState(e.toString()));
      }
    });
  }
}
