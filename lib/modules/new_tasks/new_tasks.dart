import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodoo/Cubit/states.dart';

import '../../Cubit/cubit.dart';
import '../../shared/compnontes/compnontes.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = TodoCubit.get(context).newtasks;

          return ConditionalBuilder(
            condition: tasks.length > 0,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    BuildTask(tasks[index], context),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey),
                    ),
                itemCount: tasks.length),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    color: Color(0xaaffffff),
                  ),
                  Text(
                    "There Is No Tasks Yet , Please Add Some Tasks",
                    style: TextStyle(
                      color: Color(0xaaffffff),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
