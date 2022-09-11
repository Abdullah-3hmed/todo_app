import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget buildTasksItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteFromDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: const Icon(Icons.archive),
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );

Widget buildBottomSheet({
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController timeController,
  required TextEditingController dateController,
  required BuildContext context,
}) =>
    Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(
                20.0,
              ),
              color: Colors.grey[100],
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text('Task Title'),
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(25.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Task\'s Title Required';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              color: Colors.grey[100],
              child: TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  label: Text('Task Time'),
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  hintText: 'Enter Time',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(25.0),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Task\'s Time Required';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    timeController.text = value!.format(context).toString();
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(
                20.0,
              ),
              color: Colors.grey[100],
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                controller: dateController,
                decoration: const InputDecoration(
                  label: Text('Task Date'),
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'Enter Date',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(25.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Task\'s Date Required';
                  }
                  return null;
                },
                onTap: () async {
                  var nowDate = DateTime.now();
                  FocusScope.of(context).requestFocus(FocusNode());
                  await showDatePicker(
                    context: context,
                    initialDate: nowDate,
                    firstDate: nowDate,
                    lastDate: nowDate.add(
                      const Duration(days: 365),
                    ),
                  ).then((value) {
                    dateController.text = DateFormat.yMMMd().format(value!);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasks}) {
  return tasks.isNotEmpty
      ? ListView.separated(
          itemBuilder: (context, index) =>
              buildTasksItem(tasks[index], context),
          separatorBuilder: (context, index) => const Divider(
                indent: 20.0,
                endIndent: 20.0,
                thickness: 2.5,
              ),
          itemCount: tasks.length)
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet , Insert Some Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
}
