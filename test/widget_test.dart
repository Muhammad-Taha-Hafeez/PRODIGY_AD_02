import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO-LIST APPLICATION',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Low';
  ThemeMode _themeMode = ThemeMode.dark;

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          "task": _taskController.text,
          "isCompleted": false,
          "priority": _selectedPriority,
        });
        _taskController.clear();
        _selectedPriority = 'Low';
      });
    }
  }

  void _editTask(int index) {
    _taskController.text = _tasks[index]["task"];
    _selectedPriority = _tasks[index]["priority"];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(hintText: "Enter task"),
            ),
            DropdownButton<String>(
              value: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              items: ['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _tasks[index]["task"] = _taskController.text;
                _tasks[index]["priority"] = _selectedPriority;
                _taskController.clear();
                _selectedPriority = 'Low';
                Navigator.of(context).pop();
              });
            },
            child: Text("Save Task"),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index]["isCompleted"] = !_tasks[index]["isCompleted"];
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _selectAllTasks() {
    setState(() {
      bool allCompleted = _tasks.isNotEmpty && _tasks.every((task) => task["isCompleted"]);
      _tasks.forEach((task) {
        task["isCompleted"] = !allCompleted;
      });
    });
  }

  void _deleteAllTasks() {
    setState(() {
      _tasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: _toggleTheme,
            ),
          ],
          title: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'TO-DO-LIST APP',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 400.0, // Adjust width as needed
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _taskController,
                            decoration: InputDecoration(
                              hintText: "Enter Task",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedPriority,
                          dropdownColor: Colors.grey[800],
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                          items: ['Low', 'Medium', 'High']
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(color: Colors.white)),
                              ))
                              .toList(),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: _addTask,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  _tasks[index]["task"],
                                  style: TextStyle(
                                    decoration: _tasks[index]["isCompleted"]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: _tasks[index]["isCompleted"]
                                        ? Colors.white54
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'Priority: ${_tasks[index]["priority"]}',
                                  style: TextStyle(
                                    color: _tasks[index]["isCompleted"]
                                        ? Colors.white54
                                        : Colors.white,
                                  ),
                                ),
                                leading: Checkbox(
                                  value: _tasks[index]["isCompleted"],
                                  onChanged: (value) {
                                    _toggleComplete(index);
                                  },
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.orange),
                                      onPressed: () {
                                        _editTask(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteTask(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: _selectAllTasks,
              icon: Icon(Icons.check_box_outlined),
              label: Text('Select All'),
              backgroundColor: Colors.amber,
            ),
            SizedBox(width: 20),
            FloatingActionButton.extended(
              onPressed: _deleteAllTasks,
              icon: Icon(Icons.delete_outline),
              label: Text('Delete All'),
              backgroundColor: Colors.lightBlue,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}