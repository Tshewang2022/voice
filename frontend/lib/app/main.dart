import 'package:flutter/material.dart';

// import the router
import 'package:frontend/app/route/router.dart';
void main() {
  runApp(VoiceApp());
}

class VoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Voice App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
