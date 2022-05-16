part of 'matches_bloc.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();
}

class LoadMatchesEvent extends MatchesEvent {
  final String username;

  const LoadMatchesEvent(this.username);
  @override
  List<Object?> get props => [];
}

class MatchesRefreshEvent extends MatchesEvent {
  final String username;

  const MatchesRefreshEvent(this.username);
  @override
  List<Object?> get props => [];
}

class MatchesSearchDateEvent extends MatchesEvent {
  final String username;
  String searchDate;

  MatchesSearchDateEvent(this.username, this.searchDate);
  @override
  List<Object?> get props => [];
}

class MatchesSearchRegisterNumberEvent extends MatchesEvent {
  final String username;
  final String searchRegisterNumber;

  const MatchesSearchRegisterNumberEvent(
      this.username, this.searchRegisterNumber);
  @override
  List<Object?> get props => [];
}
