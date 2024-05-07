import 'package:flutter/material.dart';
import '../class/task.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
      title: 'Comprar leche',
      description: 'Ir al supermercado',
      isCompleted: false,
    ),
    Task(
      title: 'Hacer ejercicio',
      description: '30 minutos de cardio',
      isCompleted: true,
    ),
    Task(
      title: 'Llamar a mamá',
      description: 'Confirmar hora de visita',
      isCompleted: false,
    ),
  ];

  void _showAddTaskDialog() {
    String newTitle = '';
    String newDescription = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTitle = value,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                onChanged: (value) => newDescription = value,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTitle.isNotEmpty && newDescription.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(
                      title: newTitle,
                      description: newDescription,
                      isCompleted: false,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas Pendientes'),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          titlePadding: EdgeInsets.only(left: 200),
          title: TextButton(
            onPressed: _showAddTaskDialog,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 243, 240, 232)),
            ),
            child: Text(
              'Agregar tarea',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.brown[100],
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(tasks[index].title),
              onDismissed: (direction) {
                _removeTask(index);
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(tasks[index].title),
                subtitle: Text(tasks[index].description),
                trailing: Checkbox(
                  value: tasks[index].isCompleted,
                  onChanged: (value) {
                    setState(() {
                      tasks[index].isCompleted = value!;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
