// all routing config related to the app;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// import all the screens;
import '../screens/auth/login.dart';
import '../screens/auth/completeRegister.dart';
import '../screens/auth/verifyOtpScreen.dart';
import '../screens/auth/verifyPhoneScreen.dart';
import '../screens/home.dart';

final GoRouter router = GoRouter(
  initialExtra: '/login',
  routes: [
    GoRoute(path: '/login',  builder: (context, state)=> Login()),
    GoRoute(path: '/verify-phone',  builder: (context, state)=> VerifyPhoneScreen()),
    GoRoute(path: '/verify-otp',  builder: (context, state)=> Verifyoptscreen()),
    GoRoute(path: '/complete-register',  builder: (context, state)=> Register()),
    GoRoute(path: '/home',  builder: (context, state)=> HomeScreen()),




  ],
);