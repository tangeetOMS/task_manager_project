import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/task_screen/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import '../../../data/models/task_count_by_status_model.dart';
import '../../../data/models/task_list_by_status_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_item_widget.dart';
import '../../widgets/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
             // _buildTaskSummaryStatus(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Visibility(
                    visible: _getTaskListInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: _buildTaskListView()),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItems(
          taskModel: newTaskListModel!.taskList![index],
          onDeleteTask: _deleteTask,
          onUpdateTaskStatus: _updateTaskStatus,
        );
      },
    );
  }

  Future<void> _fetchAllData() async {
    try {
      await _getProgressTaskList();
    } catch (e) {
      showSnackBarMessage(context, e.toString());
    }
  }

  Future<void> _deleteTask(String id) async {
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.deleteTaskUrl(id));
    if (response.isSuccess) {
      _fetchAllData();
      showSnackBarMessage(context, 'task delete successful');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    final String url = Urls.updateTaskUrl(taskId, newStatus);
    final NetworkResponse response = await NetworkCaller.getRequest(url: url);

    if (response.isSuccess) {
      _fetchAllData();
      showSnackBarMessage(context, 'task status updated successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }



  Future<void> _getProgressTaskList() async {
    _getTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      newTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskListInProgress = false;
    setState(() {});
  }
}

