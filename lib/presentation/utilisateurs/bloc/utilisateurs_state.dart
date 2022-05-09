part of 'utilisateurs_bloc.dart';

abstract class UtilisateursState extends Equatable {
  const UtilisateursState();
}

class UtilisateursInitial extends UtilisateursState {
  @override
  List<Object> get props => [];
}

class UtilisateursLoadingState extends UtilisateursState {
  @override
  List<Object> get props => [];
}

class UtilisateursLoadedState extends UtilisateursState {
  final UtilisateursModel utilisateurs;
  final TokenModel? user;

  const UtilisateursLoadedState(
    this.utilisateurs,
    this.user,
  );

  @override
  List<Object?> get props => [
        utilisateurs,
      ];
}

class UtilisateursErrorState extends UtilisateursState {
  final String error;

  const UtilisateursErrorState(this.error);

  @override
  List<Object?> get props => [
        error,
      ];
}

class UtilisateursRefreshState extends UtilisateursState {
  final UtilisateursModel utilisateurs;
  final TokenModel? user;

  const UtilisateursRefreshState(
    this.utilisateurs,
    this.user,
  );

  @override
  List<Object?> get props => [
        utilisateurs,
      ];
}
