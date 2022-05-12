part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final UserMeModel userMe;
  final TokenModel? user;

  const ProfileLoadedState(
    this.userMe,
    this.user,
  );

  @override
  List<Object?> get props => [
        userMe,
      ];
}

class ProfileErrorState extends ProfileState {
  final String error;

  const ProfileErrorState(this.error);

  @override
  List<Object?> get props => [
        error,
      ];
}
