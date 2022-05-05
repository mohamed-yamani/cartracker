import 'package:carlock/presentation/home/bloc/bloc/home_bloc.dart';
import 'package:carlock/services/authentication.dart';
import 'package:carlock/services/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_color/print_color.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc(
          RepositoryProvider.of<AuthenticationService>(context),
          RepositoryProvider.of<MatchesServices>(context),
        )..add(RegisteringServiceEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessfulLoginState) {
              Navigator.pushReplacementNamed(context, '/matches',
                  arguments: state.username);
            }
            if (state is FailedLoginState) {
              Print.red(state.error);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error.replaceAll('Exception: ', '')),
              ));
            }
          },
          builder: (context, state) {
            if (state is HomeInitial || state is FailedLoginState) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        controller: userNameController,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.security),
                          hintText: 'Mot de passe',
                        ),
                        controller: passwordController,
                      ),
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('Login'),
                        ),
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context).add(
                            LoginEvent(
                              userNameController.text,
                              passwordController.text,
                            ),
                          );

                          // Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
