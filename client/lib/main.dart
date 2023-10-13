import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:niko_client/pages/account/login_page.dart';
import 'package:niko_client/pages/home_page.dart';
import 'package:niko_client/service/session_service.dart';
import 'package:niko_client/shared/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  if (kIsWeb) {
    // running on the web
  } else {
    // running on mobile
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  SessionService sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    sessionService.get().then((value) {
      if (value.$1.isNotEmpty) {
        _isSignedIn = true;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
            primaryColor: Constants().primaryColor,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? const HomePage() : const LoginPage());
  }
}
