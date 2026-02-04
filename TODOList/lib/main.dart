import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
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

  List<String> tasks = [];
  List<bool> done = [];

  final TextEditingController controller = TextEditingController();

  void addTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add(controller.text);
        done.add(false);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index == 0 ? lista() : stats(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }

  /// SCHERMATA LISTA
  Widget lista() {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista Task')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(labelText: 'Nuovo task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                  title: Text(tasks[i]),
                  value: done[i],
                  onChanged: (v) {
                    setState(() => done[i] = v!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// SCHERMATA STATS
  Widget stats() {
    int total = tasks.length;
    int completed = done.where((e) => e).length;
    int pending = total - completed;
    double perc = total == 0 ? 0 : completed / total * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Totale task: $total'),
            Text('Completati: $completed'),
            Text('Da fare: $pending'),
            const SizedBox(height: 20),
            Text('Efficienza: ${perc.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

