import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niko_client/pages/account/register_page.dart';
import 'package:niko_client/widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/account_service.dart';
import '../../service/session_service.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  AccountService accountService = AccountService();
  SessionService sessionService = SessionService();

  String id = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.title,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(AppLocalizations.of(context)!.loginSubTitle,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                    Image.asset("assets/images/login.png"),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: AppLocalizations.of(context)!.iD,
                          prefixIcon: Icon(Icons.account_box,
                              color: Theme.of(context).primaryColor)),
                      validator: (val) {
                        if (val!.length < 4) {
                          return AppLocalizations.of(context)!.idLength;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          id = val;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: AppLocalizations.of(context)!.passWord,
                          prefixIcon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColor)),
                      validator: (val) {
                        if (val!.length < 4) {
                          return AppLocalizations.of(context)!.passWordLength;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      //check the validation
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.signIn,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          login();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: AppLocalizations.of(context)!.dontHaveAnAccount,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!.registerhere,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const ResisterPage());
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        accountService.loginUser(id, password).then((value) {
          setState(() {
            _isLoading = false;
          });
          if (value != null) {
            showSnackBar(context, AppLocalizations.of(context)!.loginSuccessful,
                Colors.green);
            sessionService.set(id, value.nickName, value.eMail, value.authData);
            nextScreen(context, const HomePage());
          } else {
            showSnackBar(context,
                AppLocalizations.of(context)!.passwordDoesNotMatch, Colors.red);
          }
        });
      }
    }
  }
}
