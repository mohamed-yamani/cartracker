part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadUserMeEvent extends ProfileEvent {
  final String username;

  const LoadUserMeEvent(this.username);
  @override
  List<Object?> get props => [];
}
