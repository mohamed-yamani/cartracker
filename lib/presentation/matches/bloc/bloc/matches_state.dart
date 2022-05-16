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
  final List<dynamic> permissionList;
  final bool can_sync_location;

  const MatchesLoadedState(
    this.matches,
    this.user,
    this.permissionList,
    this.can_sync_location,
  );

  @override
  List<Object?> get props => [
        matches,
        user,
        permissionList,
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
