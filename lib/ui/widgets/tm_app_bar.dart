import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TMAppBar({
    super.key,
    this.formUpdateProfile=false,
  });

  final bool formUpdateProfile;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColors.themeColors,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: MemoryImage(base64Decode(AuthController.userModel?.photo ?? '')),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                if(formUpdateProfile==false){
                  Navigator.pushNamed(context, UpdateProfileScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                   AuthController.userModel?.email ?? '',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async{
                await AuthController.clearUserData();
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=> false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}