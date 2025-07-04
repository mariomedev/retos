/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Semana2Dia1 extends StatefulWidget {
  const Semana2Dia1({super.key});

  @override
  State<Semana2Dia1> createState() => _Semana2Dia1State();
}

class _Semana2Dia1State extends State<Semana2Dia1> {
  final TextEditingController controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskProvider>();
    final state = context.watch<TaskProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Semana 2 día 1 '),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: controllerDescription,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              if (state.tasks.isEmpty)
                const _CustomTitle(title: 'Aún no tienes Tareas'),

              if (state.isNotCompleted.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.isNotCompleted.length,
                    itemBuilder: (context, index) {
                      final task = state.isNotCompleted[index];
                      return CardTask(
                        task: task,
                        onChanged: (value) => controller.onChageStatus(task.id),
                      );
                    },
                  ),
                ),

              if (state.isCompleted.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.isCompleted.length,
                    itemBuilder: (context, index) {
                      final task = state.isCompleted[index];
                      return CardTask(
                        task: task,
                        onChanged: (value) => controller.onChageStatus(task.id),
                      );
                    },
                  ),
                ),

              ElevatedButton(
                onPressed: () => controller.addTask(controllerDescription.text),
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

//Codigo de widgets
class CardTask extends StatelessWidget {
  final Task task;
  final void Function(bool?)? onChanged;
  const CardTask({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            task.id.toString(),
          ),
        ),
        title: Text(
          task.title,
        ),
        trailing: Checkbox(
          value: task.completed,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CustomTitle extends StatelessWidget {
  final String title;
  const _CustomTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//Codigo de Modelo
class Task {
  int id;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  Task copyWith({
    String? title,
    bool? completed,
  }) => Task(
    id: id,
    title: title ?? this.title,
    completed: completed ?? this.completed,
  );
}

/* //Codigo de Provider
class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> isCompleted = [];
  List<Task> isNotCompleted = [];
  int _id = 0;

  addTask(String title) {
    tasks.add(
      Task(id: _id, completed: false, title: title),
    );
    _id++;
    _checkListOfTask();
    notifyListeners();
  }

  onChageStatus(int id) {
    final newlist = tasks.map(
      (task) {
        if (task.id == id) {
          return task.copyWith(completed: !task.completed);
        }
        return task;
      },
    ).toList();

    tasks = newlist;
    _checkListOfTask();
  }

  _checkListOfTask() {
    isNotCompleted = tasks.where((task) => !task.completed).toList();
    isCompleted = tasks.where((task) => task.completed).toList();
    notifyListeners();
  }
}
 */
 */
