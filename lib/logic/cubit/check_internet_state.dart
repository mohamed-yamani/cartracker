part of 'check_internet_cubit.dart';

abstract class CheckInternetState extends Equatable {
  const CheckInternetState();

  @override
  List<Object> get props => [];
}

class CheckInternetInitial extends CheckInternetState {}

class InternetConnected extends CheckInternetState {
  final ConnectivityInfo? connectivityInfo;

  const InternetConnected({@required this.connectivityInfo});

  @override
  List<Object> get props => [];
}

class InternetDisconnected extends CheckInternetState {}
