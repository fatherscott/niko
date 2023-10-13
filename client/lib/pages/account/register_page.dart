import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niko_client/pages/account/login_page.dart';
import 'package:niko_client/pages/home_page.dart';

import '../../service/session_service.dart';
import '../../service/account_service.dart';
import '../../widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResisterPage extends StatefulWidget {
  const ResisterPage({super.key});

  @override
  State<ResisterPage> createState() => _ResisterPageState();
}

class _ResisterPageState extends State<ResisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String id = "";
  String password = "";
  String confirm = "";
  String eMail = "";
  String nickName = "";

  AccountService accountService = AccountService();
  SessionService sessionService = SessionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.title,
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.registerSubTitle,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                          Image.asset("assets/images/register.png"),
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
                                labelText:
                                    AppLocalizations.of(context)!.passWord,
                                prefixIcon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor)),
                            validator: (val) {
                              if (val!.length < 4) {
                                return AppLocalizations.of(context)!
                                    .passWordLength;
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
                          const SizedBox(height: 15),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: AppLocalizations.of(context)!
                                    .passwordConfirm,
                                prefixIcon: Icon(Icons.confirmation_num_sharp,
                                    color: Theme.of(context).primaryColor)),
                            validator: (val) {
                              if (val!.length < 4) {
                                return AppLocalizations.of(context)!
                                    .passWordLength;
                              } else if (val != password) {
                                return AppLocalizations.of(context)!
                                    .passwordDoesNotMatch;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                confirm = val;
                              });
                            },
                            //check the validation
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: AppLocalizations.of(context)!.eMail,
                                prefixIcon: Icon(Icons.email,
                                    color: Theme.of(context).primaryColor)),
                            validator: (val) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!);

                              if (emailValid == false) {
                                return AppLocalizations.of(context)!.validEMail;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                eMail = val;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText:
                                    AppLocalizations.of(context)!.nickName,
                                prefixIcon: Icon(Icons.add_reaction_outlined,
                                    color: Theme.of(context).primaryColor)),
                            validator: (val) {
                              if (val!.length < 4) {
                                return AppLocalizations.of(context)!
                                    .nickNameLength;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                nickName = val;
                              });
                            },
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
                                AppLocalizations.of(context)!.register,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .alreadyHaveAnAccount,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              children: [
                                TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.loginNow,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ))),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      accountService
          .registerUserWithIdandPassword(id, password, nickName, eMail)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value != null && value.errorMesage.isNotEmpty) {
          showSnackBar(context, AppLocalizations.of(context)!.idAlreadyExists,
              Colors.red);
        } else if (value != null) {
          showSnackBar(context, AppLocalizations.of(context)!.accountCreated,
              Colors.green);
          sessionService.set(id, nickName, eMail, value.authData);
          nextScreen(context, const HomePage());
        }
      });
    }
  }
}
