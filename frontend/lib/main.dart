import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/completeRegister.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/auth/login.dart';

void main() {
  runApp(VoiceApp());
}

class VoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Voice App",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => Login());
          case '/register':
            return MaterialPageRoute(builder: (_)=> Register());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          default:
            return MaterialPageRoute(builder: (_) => Login());
        }
      },
    );
  }
}
