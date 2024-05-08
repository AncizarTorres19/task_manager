import 'package:flutter/material.dart';
import '../class/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

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

  List<Task> filteredTasks = []; // Lista de tareas filtradas
  TextEditingController searchController =
      TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    filteredTasks =
        tasks; // Al principio, las tareas filtradas serán las mismas que las tareas originales
    super.initState();
  }

  void _showAddTaskDialog({Task? task}) {
    String newTitle = task?.title ?? '';
    String newDescription = task?.description ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Agregar Tarea' : 'Actualizar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: newTitle),
                onChanged: (value) => newTitle = value,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: TextEditingController(text: newDescription),
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
                    if (task == null) {
                      // Agregar nueva tarea
                      tasks.add(Task(
                        title: newTitle,
                        description: newDescription,
                        isCompleted: false,
                      ));
                    } else {
                      // Actualizar tarea existente
                      task.title = newTitle;
                      task.description = newDescription;
                    }
                    _filterTasks(searchController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(task == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _filterTasks(String query) {
    List<Task> searchResult = tasks.where((task) {
      // Filtrar tareas basadas en el título o la descripción
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTasks = searchResult; // Actualizar la lista de tareas filtradas
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _filterTasks(
          searchController.text); // Filtrar tareas después de eliminar una
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas Pendientes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: _showAddTaskDialog,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterTasks,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.brown[100],
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(filteredTasks[index].title),
                    onDismissed: (direction) {
                      _removeTask(index);
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(filteredTasks[index].title),
                      subtitle: Text(filteredTasks[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: filteredTasks[index].isCompleted,
                            onChanged: (value) {
                              setState(() {
                                filteredTasks[index].isCompleted = value!;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showAddTaskDialog(task: filteredTasks[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeTask(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
