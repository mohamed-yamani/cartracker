import 'package:carlock/model/token.dart';
import 'package:carlock/presentation/about/about_page.dart';
import 'package:carlock/presentation/contact/contact_page.dart';
import 'package:carlock/presentation/home/home.dart';
import 'package:carlock/presentation/map/map.dart';
import 'package:carlock/presentation/matches/bloc/bloc/matches_bloc.dart';
import 'package:carlock/presentation/matches/matches.dart';
import 'package:carlock/presentation/profile/profile_page.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/authentication.dart';
import 'package:carlock/services/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {

  bool isLoggedIn = true;
  await Hive.initFlutter(); //!hive init
  Hive.registerAdapter(TokenModelAdapter()); //!hive register adapter
  try {
    TokenModel? user = await getToken();
    if (user!.token == null) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
    }
  } catch (e) {
    isLoggedIn = false;
  }
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatefulWidget {
  late bool? isLoggedIn;
  MyApp({Key? key, this.isLoggedIn}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MatchesBloc matchesBloc = MatchesBloc(MatchesServices());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationService>(
          create: (context) => AuthenticationService(),
        ),
        RepositoryProvider<MatchesServices>(
          create: (context) => MatchesServices(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColorLight: Colors.white,
          primaryColorDark: Colors.black,
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Inconsolata',
        ),
        routes: {
          '/': (context) =>
              (widget.isLoggedIn == false) ? HomePage() : const MatchesPage(),
          '/home': (context) => HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/about': (context) => const AboutPage(),
          '/contact': (context) => const ContactPage(),
          '/matches': (context) => BlocProvider.value(
                value: matchesBloc,
                child: const MatchesPage(),
              ),
          '/map_page': (context) => BlocProvider.value(
                value: matchesBloc,
                child: MapSample(),
              ),
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    matchesBloc.close();
    super.dispose();
  }
}
