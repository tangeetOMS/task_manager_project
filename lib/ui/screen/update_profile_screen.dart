import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const name = '/update_profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? pickedImage;
 bool _getUpdateProfileInProgress = false;

 @override
  void initState() {
   _emailTEController.text = AuthController.userModel?.email ?? '';
   _firstNameTEController.text = AuthController.userModel?.firstName?? '';
   _lastNameTEController.text = AuthController.userModel?.lastName ?? '';
   _mobileTEController.text = AuthController.userModel?.mobile ?? '';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TMAppBar(
        formUpdateProfile: true,
      ),
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
                    height: 48,
                  ),
                  Text(
                    'Update Profile',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildPhotoPicker(),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _getUpdateProfileInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabUpdateButton();
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photos',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
             Expanded(
               child: Text(
                 pickedImage == null?
                'No item selected': pickedImage!.name,
                maxLines: 1,
                           ),
             ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage()async{
    ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.camera);
    if(image != null){
      pickedImage = image;
      setState(() {});
    }
  }

  void _onTabUpdateButton(){
    if(_formKey.currentState!.validate()){
      _updateProfile();
    }
  }

  Future<void> _updateProfile()async{
   _getUpdateProfileInProgress = true;
   setState(() {});
   Map<String, dynamic> requestBody = {
     "email": _emailTEController.text.trim(),
     "firstName": _firstNameTEController.text.trim(),
     "lastName": _lastNameTEController.text.trim(),
     "mobile": _mobileTEController.text.trim(),
   };
   if(pickedImage != null){
     List<int> imageBytes = await pickedImage!.readAsBytes();
     requestBody['photo'] = base64Encode(imageBytes);

   }
   if(_passwordTEController.text.isNotEmpty){
      requestBody ['password'] = _passwordTEController.text;
   }
   final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.updateProfileUrl,
   body: requestBody,);
   _getUpdateProfileInProgress = false;
   setState(() {});
   if(response.isSuccess){
     _passwordTEController.clear();
     showSnackBarMessage(context, 'profile updated !');
   }
   else{
     showSnackBarMessage(context, response.errorMessage);
   }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
