part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class SuccessfulLoginState extends HomeState {
  final String username;

  SuccessfulLoginState(this.username);
  @override
  // TODO: implement props
  List<Object?> get props => [username];
}

class RegisteringServiceState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FailedLoginState extends HomeState {
  final String error;

  const FailedLoginState(this.error);

  @override
  List<Object?> get props => [error];
}
