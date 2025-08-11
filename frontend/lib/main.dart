import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/password.dart';
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

class VoiceApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Voice App",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes:{
        '/home':(context)=> HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/password':(context)=> PasswordScreen(),
        '/chats':(context)=> Chats(),
        '/groupchat':(context)=>GroupchatScreen(),
        '/addperson':(context)=>Addperson(),
        '/creategroup':(context)=> CreateGroup(),
        '/setting':(context)=> SettingScreen()
      }
    );
  }
}