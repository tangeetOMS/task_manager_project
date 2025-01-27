import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.email, this.otp});
  static const name = '/forgot_password/reset_password';
  final String? email;
  final String? otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController=TextEditingController();
  final TextEditingController _confirmPasswordTEController=TextEditingController();
  final GlobalKey <FormState> _formKey=GlobalKey<FormState>();
  bool _resetPasswordInProgress = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Text(
                    'Set Password',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Minimum length of password should be more than 8 letters.',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),

                  ),
                  const SizedBox(
                    height: 26,
                  ),
                    TextFormField(
                      controller: _newPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your new password';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your confirm password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _resetPasswordInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTapResetButton();
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: _buildSignInSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapResetButton(){
    if(_formKey.currentState!.validate()){
      _resetPassword();
    }
  }

  Future<void> _resetPassword()async{
    _resetPasswordInProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "email": widget.email.toString(),
      "OTP": widget.otp.toString(),
      "password": _newPasswordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.resetPasswordUrl,body: requestBody);
    if(response.isSuccess){
      showSnackBarMessage(context, 'New password added !');
    }
    else{
      showSnackBarMessage(context, 'invalid password ! Try again');
    }
    _resetPasswordInProgress = false;
    setState(() {});
  }
  
  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an account?",
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(
              color: AppColors.themeColors,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (value)=>false);
            },
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
