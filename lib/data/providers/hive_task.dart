import 'package:bt2_getx/data/models/task_model.dart';
import 'package:hive/hive.dart';

class HiveTask {
  final boxTask = Hive.box<TaskModel>('tasks_box');

  List<TaskModel> getTasks() {
    return boxTask.values.toList();
  }

  TaskModel? getTaskById(String id) {
    return boxTask.get(id);
  }

  Future<void> addTask(TaskModel task) async {
    await boxTask.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await boxTask.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await boxTask.delete(id);
  }
}
