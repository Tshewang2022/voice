import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/otpRequest.dart';
import 'package:frontend/screens/auth/verifyOtp.dart';
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
          case '/home':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case '/otp-request':
            return MaterialPageRoute(builder: (_) => OtpRequest());
          case '/verify-otp':
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => OtpVerification(
                email: args['email']!,
                phone: args['phone']!,
              ),
            );
          default:
            return MaterialPageRoute(builder: (_) => Login());
        }
      },
    );
  }
}
