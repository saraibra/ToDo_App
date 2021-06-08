import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

 

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext conrext) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates states){
          if(states is AppInsertDataBaseState)
          Navigator.pop(context);
        },
        builder: (BuildContext context , AppStates states){
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body:cubit.newTasks.length == 0
              ? Center(child: CircularProgressIndicator())
              : cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                   cubit.insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                padding: const EdgeInsets.all(16.0),
                                color: Colors.white,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextFormField(
                                        icon: Icons.title,
                                        controller: titleController,
                                        type: TextInputType.text,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Title must not be empty ';
                                          }
                                          return null;
                                        },
                                        label: 'Task title',
                                      ),
                                      SizedBox(height: 16),
                                      defaultTextFormField(
                                        icon: Icons.watch,
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Time must not be empty ';
                                          }
                                          return null;
                                        },
                                        onTab: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text =
                                                value!.format(context).toString();
                                          });
                                        },
                                        label: 'Task Time',
                                      ),
                                      SizedBox(height: 16),
                                      defaultTextFormField(
                                        icon: Icons.calendar_today,
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Date must not be empty ';
                                          }
                                          return null;
                                        },
                                        onTab: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2021-12-30'),
                                                  firstDate: DateTime.now())
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd().format(value!);
                                          });
                                        },
                                        label: 'Task Date',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 16)
                      .closed
                      .then((value) {
                                cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

                  });
             cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
       
                }
              },
              child: Icon(cubit.fabIcon)),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) {
           cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived'),
            ],
          ),
        );
      
        },
       ),
    );
  }

 

}
