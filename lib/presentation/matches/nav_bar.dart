import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carlock/presentation/matches/bloc/bloc/matches_bloc.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/services/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MatchesBloc(RepositoryProvider.of<MatchesServices>(context))
            ..add(const LoadMatchesEvent('')),
      child: Drawer(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<MatchesBloc, MatchesState>(builder: (context, state) {
              if (state is MatchesLoadingState) {
                return onLoading(context);
              }

              if (state is MatchesLoadedState) {
                return drawerHeader(context, state);
              }
              if (state is MatchesErrorState) {
                return const Text('Error');
              }
              return const Text('Unknown');
            }),
            ListTile(
              leading: Icon(Icons.group, color: Theme.of(context).primaryColor),
              title: Text('Liste des utilisateurs',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorLight)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/utilisateurs');
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              leading:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              title: Text('Mon profil',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorLight)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              leading: Icon(Icons.info, color: Theme.of(context).primaryColor),
              title: Text('A propos',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorLight)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/about');
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text('Contact',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorLight)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/contact');
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
              endIndent: 20,
              indent: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  size: 30, color: Theme.of(context).primaryColor),
              title: Text('Déconnexion',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor)),
              onTap: () async {
                await deleteToken();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader onLoading(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: const Text(
        'carlock',
        style: TextStyle(color: Colors.transparent, fontSize: 20),
      ),
      arrowColor: Colors.black,
      accountEmail: const Text('_'),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/no_image.png'),
        key: ValueKey('no_image.png'),
        radius: 25,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: const DecorationImage(
          image: AssetImage('assets/images/sidebar.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  UserAccountsDrawerHeader drawerHeader(BuildContext context, state) {
    return UserAccountsDrawerHeader(
      accountName: const Text(
        'carlock',
        style: TextStyle(color: Colors.transparent, fontSize: 20),
      ),
      arrowColor: Colors.black,
      accountEmail: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 18,
        ),
        child: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
          TypewriterAnimatedText(
              'Salut ${state.user.user[0].toUpperCase() + state.user.user.substring(1)}'),
          TypewriterAnimatedText('carlock est un service de ...'),
        ]),
      ),
      currentAccountPicture: CircleAvatar(
        child: 1 == 3
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: state.user.user!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                  key: const ValueKey('user_image'),
                  cacheKey: 'user_image',
                ),
              )
            : const CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/images/no_image.png'),
                key: ValueKey('no_image.png'),
                radius: 42,
              ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: const DecorationImage(
          image: AssetImage('assets/images/sidebar.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
