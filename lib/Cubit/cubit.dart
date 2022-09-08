import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toodoo/Cubit/states.dart';
import 'package:toodoo/modules/done_tasks/done_tasks.dart';
import 'package:toodoo/modules/new_tasks/new_tasks.dart';
import '../modules/archived_tasks/archived_tasks.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoIntialState());
  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];
  bool toglleOpen = false;
  IconData floatingicon = Icons.add;
  void ChangeButtomNavState(int index) {
    currentIndex = index;
    emit(TodoBottomNavChangeState());
  }

  Database database;
  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDB());
    });
    this.database = database;
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        emit(TodoInsertDB());
        print('$value inserted successfully');
        getDataFromDataBase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    newtasks = [];
    archivedtasks = [];
    donetasks = [];

    emit(TodoLoadingGetDB());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element["status"] == "new")
          newtasks.add(element);
        else if (element["status"] == "done")
          donetasks.add(element);
        else if (element["status"] == "archive") archivedtasks.add(element);
      });
      emit(TodoGetDB());
    });
    ;
  }

  void updatedata({
    @required String status,
    @required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(TodoUpdateDB());
    });
  }

  void deletedata({
    @required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(TodoDeleteDB());
    });
  }

  void ChangeBottomSheetState(bool isOpen, IconData icon) {
    toglleOpen = isOpen;
    floatingicon = icon;
    emit(TodoChangeBottomSheetState());
  }
}
