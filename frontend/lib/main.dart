import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/password.dart';
import 'package:frontend/screens/chats/chat.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/auth/login.dart';


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
        '/chats':(context)=> Chats()
      }
    );
  }
}