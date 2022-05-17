part of 'matches_bloc.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();
}

class MatchesInitial extends MatchesState {
  @override
  List<Object> get props => [];
}

class MatchesLoadingState extends MatchesState {
  @override
  List<Object> get props => [];
}

class MatchesLoadedState extends MatchesState {
  final MatchesModel matches;
  final TokenModel? user;
  final bool canViewAllUsers;

  const MatchesLoadedState(
    this.matches,
    this.user,
    this.canViewAllUsers,
  );

  @override
  List<Object?> get props => [
        matches,
        user,
        canViewAllUsers,
      ];
}

class MatchesErrorState extends MatchesState {
  final String error;

  const MatchesErrorState(this.error);

  @override
  List<Object?> get props => [
        error,
      ];
}

class MatchesRefreshState extends MatchesState {
  final MatchesModel matches;
  final TokenModel? user;

  const MatchesRefreshState(
    this.matches,
    this.user,
  );

  @override
  List<Object?> get props => [
        matches,
      ];
}
