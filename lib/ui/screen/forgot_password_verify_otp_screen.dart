import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screen/reset_password_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key,  this.email});

  final String? email;
  static const name = 'forgot_password_verify_otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _getForgotPasswordVerifyOtpInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
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
                    'Pin Verification',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'A 6 digits of OTP has been sent to your email address',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  _buildPinCodeTextField(),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _getForgotPasswordVerifyOtpInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTapOtpVerifyButton();
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapOtpVerifyButton() {
    if(_formKey.currentState!.validate()){
      _forgotEmailPinVerification();
    }
  }

  Future<void> _forgotEmailPinVerification() async {
    _getForgotPasswordVerifyOtpInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.forgotVerifyEmailOtpUrl(widget.email.toString(), _otpTEController.text));
    if(response.responseData?['status']== 'success'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            otp: _otpTEController.text,
          ),
        ),
      );
    }
    else{
      showSnackBarMessage(context, 'Something went wrong');
    }
    _getForgotPasswordVerifyOtpInProgress = false;
    setState(() {

    });
  }

  PinCodeTextField _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.yellow,
        selectedFillColor: Colors.red,
        inactiveFillColor: Colors.green,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpTEController,
      appContext: context,
    );
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
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
