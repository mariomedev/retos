import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Semana2Dia4 extends StatefulWidget {
  const Semana2Dia4({super.key});

  @override
  State<Semana2Dia4> createState() => _Semana2Dia4State();
}

class _Semana2Dia4State extends State<Semana2Dia4> {
  final TextEditingController controllerTask = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskProvider>();
    final state = context.watch<TaskProvider>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              TextFormField(
                controller: controllerTask,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  const _CustomTitle(title: 'Prioridad'),
                  const Spacer(),
                  DropdownMenu<TypePriotity>(
                    dropdownMenuEntries: [
                      const DropdownMenuEntry(
                        value: TypePriotity.baja,
                        label: 'Baja',
                      ),
                      const DropdownMenuEntry(
                        value: TypePriotity.media,
                        label: 'Media',
                      ),
                      const DropdownMenuEntry(
                        value: TypePriotity.alta,
                        label: 'Alta',
                      ),
                    ],
                    onSelected: (value) => controller.changeType(
                      value ?? TypePriotity.baja,
                    ),
                  ),
                ],
              ),
              if (state.tasks.isEmpty)
                const Expanded(
                  child: Center(
                    child: _CustomTitle(
                      title: 'Aún no has agregado Tareas',
                    ),
                  ),
                ),
              if (state.tasks.isNotEmpty)
                Expanded(
                  child: AnimatedList(
                    key: state.listKey,
                    initialItemCount: state.tasks.length,
                    itemBuilder: (context, index, animation) {
                      final task = state.tasks[index];
                      return CardTask(task: task);
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  controller.add(
                    title: controllerTask.text,
                  );
                  controllerTask.clear();
                },
                child: const Text('Crear Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//widgets
class CardTask extends StatelessWidget {
  final Task task;
  const CardTask({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: controller.colorValue(task.priority),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) => controller.toggle(task.id),
        ),
        trailing: IconButton(
          onPressed: () => controller.remove(task.id),
          icon: const Icon(Icons.remove),
        ),
        title: Text(
          task.title,
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
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
// Task Provider

class TaskProvider extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TypePriotity type = TypePriotity.baja;
  List<Task> tasks = [];

  changeType(TypePriotity newType) {
    type = newType;
    notifyListeners();
  }

  add({
    required String title,
  }) {
    final index = tasks.length;
    tasks.insert(
      index,
      Task(
        id: index,
        isDone: false,
        priority: type,
        title: title,
      ),
    );
    listKey.currentState?.insertItem(index);
    notifyListeners();
  }

  remove(int id) {
    final index = tasks.indexWhere((task) => id == task.id);
    final removeTask = tasks[index];
    tasks.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CardTask(
          task: removeTask,
        ),
      ),
    );
    notifyListeners();
  }

  toggle(int id) {
    final newList = tasks.map(
      (element) {
        if (element.id == id) {
          return element = element.copyWith(isDone: !element.isDone);
        }
        return element;
      },
    ).toList();
    tasks = newList;
    notifyListeners();
  }

  Color colorValue(TypePriotity type) {
    if (TypePriotity.baja == type) return Colors.green;
    if (TypePriotity.media == type) return Colors.yellow;
    if (TypePriotity.alta == type) return Colors.red;
    return Colors.transparent;
  }
}

// Modelo de Task
class Task {
  final int id;
  final String title;
  final TypePriotity priority;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.isDone,
  });

  Task copyWith({
    String? title,
    TypePriotity? priority,
    bool? isDone,
  }) => Task(
    id: id,
    title: title ?? this.title,
    priority: priority ?? this.priority,
    isDone: isDone ?? this.isDone,
  );
}

enum TypePriotity { baja, media, alta }
