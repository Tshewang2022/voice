//** all routing config related to the app; **/

import 'package:go_router/go_router.dart';

// import all the screens;
import '../screens/auth/login.dart';
import '../screens/auth/completeRegister.dart';
import '../screens/auth/verifyOtpScreen.dart';
import '../screens/auth/emailInputScreen.dart';
import '../screens/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login',  builder: (context, state)=> Login()),
    GoRoute(path: '/verify-phone',  builder: (context, state)=> EmailInputScreen()),
    GoRoute(path: '/verify-otp',  builder: (context, state)=> VerifyOtpScreen()),
    GoRoute(path: '/register',  builder: (context, state)=> Register()),
    GoRoute(path: '/home',  builder: (context, state)=> HomeScreen()),
  ],
);