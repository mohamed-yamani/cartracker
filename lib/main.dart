import 'package:carlock/model/token.dart';
import 'package:carlock/presentation/about/about_page.dart';
import 'package:carlock/presentation/contact/contact_page.dart';
import 'package:carlock/presentation/home/home.dart';
import 'package:carlock/presentation/map/map.dart';
import 'package:carlock/presentation/matches/bloc/bloc/matches_bloc.dart';
import 'package:carlock/presentation/matches/matches.dart';
import 'package:carlock/presentation/profile/profile_page.dart';
import 'package:carlock/presentation/utilisateurs/bloc/utilisateurs_bloc.dart';
import 'package:carlock/presentation/utilisateurs/user_live/user_live_page.dart';
import 'package:carlock/presentation/utilisateurs/user_map/user_map_page.dart';
import 'package:carlock/presentation/utilisateurs/utilisateurs.dart';
import 'package:carlock/repository/localisation.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/authentication.dart';
import 'package:carlock/services/initialize_background_jobs.dart';
import 'package:carlock/services/matches.dart';
import 'package:carlock/services/utilisateurs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:print_color/print_color.dart';

var notification_type_test = '';
//KQcYMgunQCuUh5W4PDVmVy0HnN0= facebook key
//flutter build apk --split-per-abi
//flutter build appbundle
// 18:E4:3E:0E:FA:C0:A8:09:D7:82:A0:DB:F5:0C:D7:B4:76:25:A1:C9  google play
// 29:07:18:32:0B:A7:40:2B:94:87:95:B8:3C:35:66:57:2D:07:9C:DD computer
//Receive message when app in background solution for on message
Future<String> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
  String notification_type = message.data["type_notification"].toString();
  print("type_notification : " + notification_type.toString());

  notification_type_test = notification_type;
  return notification_type;
}

Future<void> main() async {
  // bool hasPermissions = await FlutterBackground.hasPermissions;
  BackgroundJobs().initializeBackgroundJobs();
  // flutter splash
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  bool isLoggedIn = true;

  await Hive.initFlutter(); //!hive init
  Hive.registerAdapter(TokenModelAdapter()); //!hive register adapter
  // await Firebase.initializeApp();
  // // above firebase
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ! firebase init

  try {
    TokenModel? user = await getToken();
    if (user?.token == null) {
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

Future<FirebaseApp> initializeFirebaseApp() async {
  final FirebaseApp app = await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  return app;
}

class _MyAppState extends State<MyApp> {
  final MatchesBloc matchesBloc = MatchesBloc(MatchesServices());
  final UtilisateursBloc utilisateursBloc =
      UtilisateursBloc(UtilisateursServices());

  My_Localisation myLocalisation = My_Localisation();
  final Future<FirebaseApp> firebaseInit = initializeFirebaseApp();

  @override
  void initState() {
    myLocalisation.updateLocation();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseInit,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Print.red(snapshot.error.toString());
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider<AuthenticationService>(
                  create: (context) => AuthenticationService(),
                ),
                RepositoryProvider<MatchesServices>(
                  create: (context) => MatchesServices(),
                ),
                RepositoryProvider<UtilisateursServices>(
                  create: (context) => UtilisateursServices(),
                ),
              ],
              child: MaterialApp(
                title: 'carlock',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColorLight: Colors.white,
                  primaryColorDark: Colors.black,
                  primarySwatch: Colors.blueGrey,
                  fontFamily: 'Inconsolata',
                ),
                routes: {
                  '/': (context) => (widget.isLoggedIn == false)
                      ? HomePage()
                      : const MatchesPage(),
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
                        child: const MapSample(),
                      ),
                  '/utilisateurs': (context) => const UtilisateursPage(),
                  '/user_map_page': (context) => BlocProvider.value(
                        value: utilisateursBloc,
                        child: UserMapPage(),
                      ),
                  '/user_live_page': (context) => BlocProvider.value(
                        value: utilisateursBloc,
                        child: const UserLivePage(),
                      ),
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void dispose() {
    matchesBloc.close();
    super.dispose();
  }
}
