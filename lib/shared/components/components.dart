import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType type,
        onSubmitted,
        onChanged,
        onTab,
        required validate,
        required String label,
        required IconData icon}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validate,
      onTap: onTab,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
          )),
    );
Widget noTasksWidget() => Center(
      child: Text(
        "No Tasks yet, Please add some tasks",
        style: TextStyle(fontSize: 22, color: Colors.grey),
      ),
    );
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['data']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(Icons.check_box)),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archived', id: model['id']);
                },
                icon: Icon(Icons.archive)),
          ],
        ),
      ),
    );
