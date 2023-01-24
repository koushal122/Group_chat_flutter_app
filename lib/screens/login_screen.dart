import 'package:chatting_app/constants.dart';
import 'package:chatting_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/components/input_textfield.dart';
import 'package:chatting_app/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id='login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              input_widget(
                hint: 'Enter your Email',
                onChanged: (value){email=value;},
              ),
              SizedBox(
                height: 8.0,
              ),
              input_widget(
                hint: 'Enter your password',
                onChanged: (value){
                    password=value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: rounded_corner_button(
                  text: 'Log in',
                  color: Colors.lightBlueAccent,
                  function: () async {
                    setState(() {
                      showSpinner=true;
                    });
                    try {
                      final loginststus=await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password
                      );
                      if(loginststus!=null){
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      else{
                        _showToast(context);
                        setState(() {
                          showSpinner=false;
                        });
                      }

                    }
                    catch(e){
                    _showToast(context);
                      setState(() {
                        showSpinner=false;
                      });
                    }
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Something went wrong'),
      ),
    );
  }
}

