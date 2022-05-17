import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/model/user_me_model.dart';
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
            ..add(const LoadMatchesEvent('', false)),
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<MatchesBloc, MatchesState>(builder: (context, state) {
              if (state is MatchesLoadingState) {
                return Column(
                  children: [
                    onLoading(context),
                    NavList(context, null),
                  ],
                );
              }

              if (state is MatchesLoadedState) {
                return Column(
                  children: [
                    drawerHeader(context, state),
                    NavList(context, state),
                  ],
                );
              }
              if (state is MatchesErrorState) {
                return Text(state.error);
              }
              return const Text('Unknown');
            }),
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader onLoading(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: const DecorationImage(
          image: AssetImage('assets/images/sidebar.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountEmail: null,
      accountName: null,
      currentAccountPicture: const CircularProgressIndicator(),
      otherAccountsPictures: null,
      onDetailsPressed: null,
    );
  }

  UserAccountsDrawerHeader drawerHeader(BuildContext context, state) {
    Results matches = state.matches.results![0];
    TokenModel user = state.user;

    String? imageUrl = matches.userPicture;
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
        child: Text('salut ' + user.user,
            style: const TextStyle(color: Colors.black)),
      ),
      currentAccountPicture: CircleAvatar(
        child: imageUrl != null && imageUrl != ''
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                  key: const ValueKey('user_image1'),
                  cacheKey: 'user_image1',
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

class NavList extends StatelessWidget {
  BuildContext context;
  dynamic state;
  NavList(this.context, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state == null || state.canViewAllUsers)
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.group, color: Colors.orange[700]),
                title: Text('Liste des utilisateurs',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/utilisateurs');
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
                endIndent: 20,
                indent: 20,
              )
            ],
          ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.blue[400]),
          title: Text('Mon profil',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
          endIndent: 20,
          indent: 20,
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.green[400]),
          title: Text('A propos',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/about');
          },
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
          endIndent: 20,
          indent: 20,
        ),
        ListTile(
          leading: Icon(Icons.phone, color: Colors.red[400]),
          title: Text('Contact',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/contact');
          },
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
          endIndent: 20,
          indent: 20,
        ),
        SizedBox(
          height: (state == null || state.canViewAllUsers)
              ? MediaQuery.of(context).size.height * 0.38
              : MediaQuery.of(context).size.height * 0.453,
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
    );
  }
}
