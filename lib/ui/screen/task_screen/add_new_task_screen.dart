import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const name = '/add_new_task_screen';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TMAppBar(),
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
                    height: 38,
                  ),
                  Text(
                    'Add New Task',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(
                      hintText: 'title',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your title here';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your description here';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createNewTask();
                        }
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

  Future<void> createNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, 'New task added!');
    }
    else{
      showSnackBarMessage(context, response.errorMessage);
    }
  }
    void _clearTextFields(){
      _titleTEController.clear();
      _descriptionTEController.clear();
    }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
