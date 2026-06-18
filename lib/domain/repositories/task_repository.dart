import '../entities/task.dart';

abstract class TaskRepository {
  List<Task> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Task? getTaskById(String id);
}
