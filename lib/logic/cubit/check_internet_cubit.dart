import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carlock/constants/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../constants/enums.dart';

part 'check_internet_state.dart';

class CheckInternetCubit extends Cubit<CheckInternetState> {
  final Connectivity? connectivity;
  late StreamSubscription _subscription;

  CheckInternetCubit({@required this.connectivity})
      : super(CheckInternetInitial()) {
    _subscription =
        connectivity!.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectivityInfo.mobile);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectivityInfo.wifi);
      } else {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectivityInfo? connectivityInfo) {
    emit(InternetConnected(connectivityInfo: connectivityInfo));
  }

  void emitInternetDisconnected() {
    emit(InternetDisconnected());
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
