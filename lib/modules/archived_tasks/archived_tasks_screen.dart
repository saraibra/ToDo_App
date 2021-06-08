import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state){
        List tasks = AppCubit.get(context).archivedTasks;
        return tasks.length > 0
            ? ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) =>Container(
            width:double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          itemCount: tasks.length) : noTasksWidget();
   
      },
    );
  
  }
}