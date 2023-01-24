import 'package:chatting_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/constants.dart';
import 'package:chatting_app/components/round_button.dart';
import 'package:chatting_app/screens/login_screen.dart';
import 'package:chatting_app/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  @override
  void initState()  {
    super.initState();
    controller=AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
    );
    animation=CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        controller.reverse(from: 100);
      }
      else if(status==AnimationStatus.dismissed){
        controller.forward(from: 0);
      }
    });
    controller.forward();
    controller.addListener(() { 
      setState(() {});
    });
    // _auth=FirebaseAuth.instance;
    // var user=_auth.currentUser;
    // if(user!=null){
    //   Navigator.pushNamed(context, ChatScreen.id);
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value*100,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Flash Chat',
                    style: kLogoTextStyle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: rounded_corner_button(
                text: 'Log In',
                color: Colors.lightBlueAccent,
                function: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: rounded_corner_button(
                text: 'Register',
                color: Colors.blue.shade900,
                function: (){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}

