import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeward_flutter_app/bloc/user_login_bloc.dart';
import 'package:homeward_flutter_app/models/login_token_response.dart';
import 'package:homeward_flutter_app/views/blog_list_screen.dart';

import 'constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  UserLoginBloc userLoginBloc = UserLoginBloc();

  Stream loginStream;

  String loginInfo = "";
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    loginStream = userLoginBloc.subject.stream;

    //LISTEN TO STREAM
    loginStream.listen((event) {
      LoginTokenResponse loginToken = event;
      String token = loginToken.token;

      //HANDLE THE RESULT
      handleLoginResponse(token);

    });
  }

  handleLoginResponse(String token){
    if (token.isNotEmpty) {
      if (token == "") {}
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlogListScreen(token);
      }));
      setState(() {
        loginInfo = "";
        showProgress = false;
      });
    } else {
      setState(() {
        loginInfo = "Error while login in";
        showProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(child: loginBuildComposer()),
    );
  }

  //BUILD LOGIN FORM
  Widget loginBuildComposer() {
    return customDeco(
        ListView(
          shrinkWrap: true,
          children: [
            customDeco(
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(context, ratio: 0.06)),
                    child: TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(hintText: "email"),
                    )),
                Colors.white,
                getWidth(context, ratio: .05)),
            customDeco(
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(context, ratio: 0.06)),
                    child: TextField(
                        controller: passwordTextController,
                        decoration: InputDecoration(hintText: "Password"))),
                Colors.white,
                getWidth(context, ratio: .05)),
            InkWell(
              child: textClick(
                  "Login", Colors.green, getWidth(context, ratio: .5)),
              onTap: () async {
                final email = emailTextController.text;
                final password = passwordTextController.text;

                //PASS THE CREDENTIALS TO THE STREAM EVENT WAIT FOR THE LISTENER
                userLoginBloc.getToken(email, password);
                FocusScope.of(context).unfocus();
                setState(() {
                  showProgress = true;
                });
              },
            ),
            showProgress ?Center(
              child: SizedBox(
                width: getWidth(context, ratio:.3),
                  child: LinearProgressIndicator()),
            ):Container(),
            Center(
              child: Text(loginInfo),
            )
          ],
        ),
        Colors.white70,
        30);
  }

  @override
  void dispose() {
    super.dispose();
    //CLOSE THE UserLoginBloc
    userLoginBloc.dispose();
  }
}
