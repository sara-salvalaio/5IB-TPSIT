import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// MODELLO LISTA
class TaskList {
  String name;
  List<String> tasks;
  List<bool> done;

  TaskList({required this.name})
      : tasks = [],
        done = [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  int selectedListIndex = 0;

  List<TaskList> lists = [
    TaskList(name: 'Generale'),
  ];

  final TextEditingController taskController = TextEditingController();
  final TextEditingController listController = TextEditingController();

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        lists[selectedListIndex].tasks.add(taskController.text);
        lists[selectedListIndex].done.add(false);
        taskController.clear();
      });
    }
  }

  void deleteTask(int i) {
    setState(() {
      lists[selectedListIndex].tasks.removeAt(i);
      lists[selectedListIndex].done.removeAt(i);
    });
  }

  void addList() {
    final name = listController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      lists.add(TaskList(name: name));
      selectedListIndex = lists.length - 1;
      listController.clear();
    });
  }

  void deleteList() {
    if (lists.length == 1) return;

    setState(() {
      lists.removeAt(selectedListIndex);
      selectedListIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index == 0 ? lista() : stats(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Liste'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }

  /// SCHERMATA LISTE
  Widget lista() {
    final currentList = lists[selectedListIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: lists.length == 1
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Elimina lista'),
                        content: Text(
                            'Vuoi eliminare la lista "${currentList.name}"?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Annulla')),
                          ElevatedButton(
                              onPressed: () {
                                deleteList();
                                Navigator.pop(context);
                              },
                              child: const Text('Elimina')),
                        ],
                      ),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Nuova lista'),
                  content: TextField(
                    controller: listController,
                    decoration:
                        const InputDecoration(labelText: 'Nome lista'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annulla')),
                    ElevatedButton(
                        onPressed: () {
                          addList();
                          Navigator.pop(context);
                        },
                        child: const Text('Crea')),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<int>(
              value: selectedListIndex,
              isExpanded: true,
              items: List.generate(
                lists.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(lists[i].name),
                ),
              ),
              onChanged: (i) => setState(() => selectedListIndex = i!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration:
                        const InputDecoration(labelText: 'Nuovo task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentList.tasks.length,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                  title: Text(currentList.tasks[i]),
                  value: currentList.done[i],
                  onChanged: (v) {
                    setState(() => currentList.done[i] = v!);
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTask(i),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// SCHERMATA STATISTICHE
  Widget stats() {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: lists.length,
        itemBuilder: (context, i) {
          final list = lists[i];
          final total = list.tasks.length;
          final completed = list.done.where((e) => e).length;
          final pending = total - completed;
          final perc = total == 0 ? 0 : completed / total * 100;

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Totale task: $total'),
                  Text('Completati: $completed'),
                  Text('Da fare: $pending'),
                  const SizedBox(height: 8),
                  Text(
                    'Efficienza: ${perc.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
