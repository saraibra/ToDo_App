import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(
      context); // to take object from AppCubit to use it in all pages
  int currentIndex = 0;
  var database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    database = openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating a table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title, data, time,status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        print('insert successfully');
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error when insert data ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?', ['$status', id]).then((value){
      getDataFromDataBase(database);
    emit(AppUpdateDataBaseState());

    });
  }
  void deleteData({ required int id}) {
    database.rawDelete('DELETE Tasks SET id = ?', [ id]).then((value){
      getDataFromDataBase(database);
    emit(AppDeleteDataBaseState());

    });
  }
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
