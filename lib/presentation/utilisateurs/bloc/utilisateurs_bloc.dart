import 'package:bloc/bloc.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/api_permission_repo.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/repository/utilisateurs_repository.dart';
import 'package:carlock/services/utilisateurs.dart';
import 'package:equatable/equatable.dart';
import 'package:print_color/print_color.dart';

part 'utilisateurs_event.dart';
part 'utilisateurs_state.dart';

class UtilisateursBloc extends Bloc<UtilisateursEvent, UtilisateursState> {
  final UtilisateursServices utilisatorService;
  final repo = UtilisateursRepository();

  UtilisateursBloc(this.utilisatorService) : super(UtilisateursInitial()) {
    on<LoadUtilisateursEvent>((event, emit) async {
      emit(UtilisateursLoadingState());
      try {
       
      List<dynamic> permissionList = await PermisionRepository().getPermissionRepo();
      Print.green(permissionList.toString());
  
    


        UtilisateursModel utilisateurs =
            await utilisatorService.getAll(event.username);
        TokenModel? user = await getToken();
        emit(UtilisateursLoadedState(utilisateurs, user));
      } catch (e) {
        emit(UtilisateursErrorState(e.toString()));
      }
    });
    on<UtilisateursRefreshEvent>((event, emit) async {
      // emit(UtilisateursLoadingState());
      try {
        UtilisateursModel utilisateurs =
            await utilisatorService.getAll(event.username);
        TokenModel? user = await getToken();
        emit(UtilisateursLoadedState(utilisateurs, user));
      } catch (e) {
        emit(UtilisateursErrorState(e.toString()));
      }
    });
  }
}
