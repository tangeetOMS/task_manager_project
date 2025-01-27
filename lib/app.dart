import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/bottom_screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screen/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screen/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screen/reset_password_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/screen/task_screen/add_new_task_screen.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColors,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColors,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            foregroundColor: Colors.white,
          ),
        )
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;
        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();
        }
        else if(settings.name == SignInScreen.name){
          widget = const SignInScreen();
        }
        else if(settings.name == SignUpScreen.name){
          widget =const SignUpScreen();
        }
        else if(settings.name == ForgotPasswordVerifyEmailScreen.name){
          widget = const ForgotPasswordVerifyEmailScreen();
        }
        else if(settings.name == ForgotPasswordVerifyOtpScreen.name){
          widget = const ForgotPasswordVerifyOtpScreen();
        }
        else if(settings.name == ResetPasswordScreen.name){
          widget = const ResetPasswordScreen();
        }
        else if(settings.name == MainBottomNavScreen.name){
          widget = const MainBottomNavScreen();
        }
        else if(settings.name == AddNewTaskScreen.name){
          widget = const AddNewTaskScreen();
        }
        else if(settings.name == UpdateProfileScreen.name){
          widget = const UpdateProfileScreen();
        }
        return MaterialPageRoute(
          builder: (context) => widget,
        );
      },
    );
  }
}
