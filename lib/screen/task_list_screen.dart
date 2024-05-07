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

  List<Task> filteredTasks = []; // Lista de tareas filtradas
  TextEditingController searchController = TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    filteredTasks = tasks; // Al principio, las tareas filtradas serán las mismas que las tareas originales
    super.initState();
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
                    _filterTasks(searchController.text); // Filtrar tareas después de agregar una nueva
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
      _filterTasks(searchController.text); // Filtrar tareas después de eliminar una
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
            child: TextButton(
              onPressed: _showAddTaskDialog,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 243, 240, 232),
                ),
              ),
              child: Text(
                'Agregar tarea',
                style: TextStyle(color: Colors.black87),
              ),
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
                    child: Card(
                      elevation: 4, // Añadir elevación para sombra
                      margin: EdgeInsets.all(8), // Espacio alrededor del Card
                      child: ListTile(
                        title: Text(filteredTasks[index].title),
                        subtitle: Text(filteredTasks[index].description),
                        trailing: Checkbox(
                          value: filteredTasks[index].isCompleted,
                          onChanged: (value) {
                            setState(() {
                              filteredTasks[index].isCompleted = value!;
                            });
                          },
                        ),
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
