import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toodoo/Cubit/states.dart';

import '../Cubit/cubit.dart';
import '../shared/compnontes/compnontes.dart';

class HomeLayOut extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var _formValidate = GlobalKey<FormState>();
  var _textControler = TextEditingController();
  var _timeControler = TextEditingController();
  var _dateControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is TodoInsertDB) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              title: Text(
                  TodoCubit.get(context)
                      .title[TodoCubit.get(context).currentIndex],
                  style: TextStyle(fontSize: 27)),
              backgroundColor: Color(0x00252525),
            ),
            body: ConditionalBuilder(
              condition: state is! TodoLoadingGetDB,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (cubit.toglleOpen) {
                    if (_formValidate.currentState.validate() &&
                        cubit.database != null) {
                      cubit.insertToDatabase(
                          title: _textControler.text,
                          time: _timeControler.text,
                          date: _dateControler.text);
                      //     insertToDatabase(date: _dateControler.text , time: _timeControler.text , title: _textControler.text).then((value){
                      //       getDataFromDataBase(database).then((value) {Navigator.pop(context);
                      //       //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                      // // setState(() {
                      // //   toglleOpen = false;
                      // //   floatingicon = Icons.add;

                      // //   tasks = value;
                      // // });
                      //  });
                      //       });
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet((context) {
                          return Container(
                            padding: EdgeInsets.all(13),
                            color: Color(0x1a666464),
                            child: Form(
                              key: _formValidate,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controller: _textControler,
                                      type: TextInputType.text,
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return "Where is task? 0_0";
                                        }
                                      },
                                      label: "Task Title",
                                      prefix: Icons.add_task),
                                  SizedBox(height: 10),
                                  defaultFormField(
                                      controller: _timeControler,
                                      type: TextInputType.datetime,
                                      onTap: () {
                                        showTimePicker(
                                                context: (context),
                                                initialTime: TimeOfDay.now())
                                            .then((value) =>
                                                (_timeControler.text = value
                                                    .format(context)
                                                    .toString()));
                                      },
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return "Where is time? 0_0";
                                        }
                                      },
                                      label: "Task Time",
                                      prefix: Icons.watch_outlined),
                                  SizedBox(height: 10),
                                  defaultFormField(
                                      controller: _dateControler,
                                      type: TextInputType.datetime,
                                      onTap: () {
                                        showDatePicker(
                                                context: (context),
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2040-12-30'))
                                            .then((value) {
                                          return _dateControler.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return "Where is date? 0_0";
                                        }
                                      },
                                      label: "Task Time",
                                      prefix: Icons.calendar_month_outlined),
                                ],
                              ),
                            ),
                          );
                        }, elevation: 25)
                        .closed
                        .then((value) {
                          cubit.ChangeBottomSheetState(false, Icons.add);
                        });
                    cubit.ChangeBottomSheetState(true, Icons.done);
                  }
                },
                child: Icon(cubit.floatingicon)),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: ((index) {
                  cubit.ChangeButtomNavState(index);
                }),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task),
                      label: "tasks",
                      tooltip: "here is the new tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done),
                      label: "done",
                      tooltip: "here is the done tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive),
                      label: "archived",
                      tooltip: "here is the archived tasks"),
                ]),
          );
        },
      ),
    );
  }
}
