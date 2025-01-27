import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screen/bottom_screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const name='/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    moveToNextScreen();
    super.initState();
  }
  Future<void> moveToNextScreen()async{
   await Future.delayed(const Duration(seconds: 2));
    bool isUserLoggedIn = await AuthController.isUserLoggedIn();
    if(isUserLoggedIn){
      Navigator.pushReplacementNamed(context,MainBottomNavScreen.name);
    }
    else{
      Navigator.pushReplacementNamed(context,SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:ScreenBackground(
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}
