import 'package:flutter/material.dart';
import 'package:chatting_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


late FirebaseAuth _auth ;
late FirebaseFirestore firestore;
class ChatScreen extends StatefulWidget {
  static String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late User? loggedInUser;
  late String message;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    firestore=FirebaseFirestore.instance;
    loggedInUser=_auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController controller=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            messageStream(firestore: firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Implement send functionality
                      controller.clear();
                      final send=await firestore.collection('messages')
                          .add({'Text':message,'user':loggedInUser?.email});
                      if(send==null){
                        print('failed to send');
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageStream extends StatelessWidget {
  const messageStream({
    Key? key,
    required this.firestore,
  }) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').snapshots(),
        builder:(context,snapshots){
          List<customWidget> widgets=[];
          if(snapshots.hasData){
            final messages=snapshots.data?.docs.reversed;
            for(var message in messages!){
              if(message.exists) {
                final text = message.get('Text');
                final sender = message.get('user');
                final widget = customWidget(
                  user: sender,
                  message: text,
                );
                widgets.add(widget);
              }
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: widgets,
            ),
          );
        }
    );
  }
}

class customWidget extends StatelessWidget {
  String user;
  String message;
  bool isMe=false;
  customWidget({required this.message,required this.user}){
    if(user==_auth.currentUser?.email)
      isMe=true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            user,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54
            ),
          ),
          Material(
            color: isMe?Colors.lightBlueAccent:Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.only(
                bottomLeft:Radius.circular(30),
                bottomRight: Radius.circular(30),
              topLeft: isMe?Radius.circular(30):Radius.circular(0),
              topRight: isMe?Radius.circular(0):Radius.circular(30)
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe?Colors.white:Colors.black54
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
