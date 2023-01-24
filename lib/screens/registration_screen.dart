import 'package:chatting_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/components/input_textfield.dart';
import 'package:chatting_app/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email, password;
  bool showSpinner = false;

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
                  onChanged: (value) {
                    email = value;
                  }),
              SizedBox(
                height: 8.0,
              ),
              input_widget(hint: 'Enter your password', onChanged: (value) {
                password = value;
              }),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: rounded_corner_button(
                    text: 'Register',
                    color: Colors.blueAccent,
                    function: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final credential = await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if(credential!=null){
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          _showToast(context,'The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {

                          _showToast(context,'The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner=false;
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context,String msg) {
    var text=msg+'';
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}