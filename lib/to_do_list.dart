import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:week_1_project/sqlhelper.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TextEditingController title = TextEditingController();
  TextEditingController newtitle = TextEditingController();
  List<Map<String, dynamic>> _data = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await SqlHelper.readData();
    setState(() {
      _data = data;
    });
  }

  Future<void> _addData() async {
    await SqlHelper.createData(title.text);
    title.clear();
    _loadData();
  }

  Future<void> _updateData(int id, bool isCompleted) async {
    await SqlHelper.updateData(id, !isCompleted, newtitle.text);
    _loadData();
  }

  Future<void> _deleteTask(int id) async {
    await SqlHelper.deleteData(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: title,
                    decoration: InputDecoration(
                      hintText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addData(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final task = _data[index];
                return ListTile(
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      decoration: task['isCompleted'] == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task['isCompleted'] == 1
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () =>
                            _updateData(task['id'], task['isCompleted'] == 1),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task['id']),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("update the title"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: newtitle,
                                            decoration: InputDecoration(
                                                hintText: "enter tilte",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _updateData(
                                                      _data[index]["id"],
                                                      _data[index]
                                                              ["isCompleted"] ==
                                                          0);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text("done"))
                                        ],
                                      ),
                                    ));
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
