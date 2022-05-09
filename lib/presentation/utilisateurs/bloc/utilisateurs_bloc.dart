import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'utilisateurs_event.dart';
part 'utilisateurs_state.dart';

class UtilisateursBloc extends Bloc<UtilisateursEvent, UtilisateursState> {
  UtilisateursBloc() : super(UtilisateursInitial()) {
    on<UtilisateursEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
