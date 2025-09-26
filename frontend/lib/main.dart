import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/register.dart';
import 'package:frontend/screens/onboarding.dart';
import 'package:frontend/screens/chats/chat.dart';
import 'package:frontend/screens/chats/groupchat.dart';
import 'package:frontend/screens/contacts/addperson.dart';
import 'package:frontend/screens/contacts/creategroup.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/auth/login.dart';
import 'package:frontend/screens/setting/setting.dart';


void main(){
  runApp(VoiceApp());
}
// for when the first they install the app, it should display the onboarding screen
class VoiceApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Voice App",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes:{
        '/onboarding':(context)=>Onboarding(), // onboarding screen
        '/home':(context)=> HomeScreen(),
        '/login': (context) => Login(),
        '/register':(context)=>Register(),
        '/chats':(context)=> Chats(),
        '/groupchat':(context)=>GroupchatScreen(),
        '/addperson':(context)=>Addperson(),
        '/creategroup':(context)=> CreateGroup(),
        '/setting':(context)=> SettingScreen()
      }
    );
  }
}