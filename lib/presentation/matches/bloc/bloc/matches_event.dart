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
