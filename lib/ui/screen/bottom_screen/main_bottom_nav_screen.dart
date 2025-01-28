import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/bottom_screen/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screen/bottom_screen/completed_task_list_screen.dart';
import 'package:task_manager/ui/screen/bottom_screen/new_task_list_screen.dart';
import 'package:task_manager/ui/screen/bottom_screen/progress_task_list_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});
  static const String name='/home';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectIndex=0;
  final List<Widget> _screen= const[
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectIndex,
        onDestinationSelected: (int index){
          _selectIndex = index;
          setState(() {

          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.new_label_outlined), label: 'New'),
          NavigationDestination(
              icon: Icon(Icons.refresh), label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(
              icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
        ],
      ),
    );
  }
}
