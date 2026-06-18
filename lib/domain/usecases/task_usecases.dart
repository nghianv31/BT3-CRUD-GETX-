import '../entities/task.dart';
import '../repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository repository;

  TaskUseCases(this.repository);

  List<Task> getTasks() => repository.getTasks();

  Future<void> addTask(Task task) => repository.addTask(task);

  Future<void> updateTask(Task task) => repository.updateTask(task);

  Future<void> deleteTask(String id) => repository.deleteTask(id);

  Task? getTaskById(String id) => repository.getTaskById(id);
}
