import 'package:flutter/material.dart';
import 'package:niko_client/pages/account/login_page.dart';
import 'package:niko_client/pages/account/profile_page.dart';
import 'package:niko_client/pages/search_page.dart';

import '../service/session_service.dart';
import '../widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SessionService sessionService = SessionService();
  String userName = "";

  @override
  void initState() {
    super.initState();
    sessionService.getAuthData().then((value) {
      setState(() {
        userName = value.$1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                sessionService.logout();
                nextScreen(context, const SearchPage());
              },
            )
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            AppLocalizations.of(context)!.groups,
            style: const TextStyle(
                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: Drawer(
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 2,
                ),
                ListTile(
                  selectedColor: Theme.of(context).primaryColor,
                  onTap: () {},
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: Text(
                    AppLocalizations.of(context)!.groups,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(
                        context,
                        ProfilePage(
                          userName: userName,
                        ));
                  },
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: Text(
                    AppLocalizations.of(context)!.profile,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                        //barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(AppLocalizations.of(context)!
                                .areYouSureYouWantToLogout),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    sessionService.logout();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (Route<dynamic> route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.exit_to_app,
                                    color: Colors.green,
                                  ))
                            ],
                          );
                        });
                    //sessionService.logout();
                    //nextScreen(context, const LoginPage());
                  },
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ]),
        ));
  }
}
