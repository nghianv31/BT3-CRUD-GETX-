import 'package:bt2_getx/data/models/task_model.dart';
import 'package:bt2_getx/data/providers/hive_task.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final HiveTask hiveTask;
  TaskRepositoryImpl(this.hiveTask);
  @override
  Future<void> addTask(Task task) {
    return hiveTask.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    return await hiveTask.deleteTask(id);
  }

  @override
  List<Task> getTasks() {
    return hiveTask.getTasks();
  }

  @override
  Task? getTaskById(String id) {
    return hiveTask.getTaskById(id);
  }

  @override
  Future<void> updateTask(Task task) async {
    return await hiveTask.updateTask(TaskModel.fromEntity(task));
  }
}
