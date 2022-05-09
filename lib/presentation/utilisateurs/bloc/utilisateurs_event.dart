part of 'utilisateurs_bloc.dart';

abstract class UtilisateursEvent extends Equatable {
  const UtilisateursEvent();
}

class LoadUtilisateursEvent extends UtilisateursEvent {
  final String username;

  const LoadUtilisateursEvent(this.username);
  @override
  List<Object> get props => [];
}

class UtilisateursRefreshEvent extends UtilisateursEvent {
  final String username;

  const UtilisateursRefreshEvent(this.username);
  @override
  List<Object> get props => [];
}
