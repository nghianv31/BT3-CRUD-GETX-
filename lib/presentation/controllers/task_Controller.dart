// ignore_for_file: file_names

import 'package:get/get.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../core/values/AppStrings.dart';

class TaskController extends GetxController {
  final TaskUseCases taskUseCases;
  TaskController(this.taskUseCases);

  RxString errorMessage = ''.obs;
  RxString status = AppStrings.statusAll.obs;
  RxBool isLoading = false.obs;
  RxList<Task> tasksStatus = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void changeStatus(String newStatus) {
    status.value = newStatus;
    fetchTasks();
  }

  void fetchTasks() {
    try {
      errorMessage.value = '';
      isLoading.value = true;
      final result = taskUseCases.getTasks();
      if (status.value == AppStrings.statusAll) {
        tasksStatus.assignAll(result);
      } else if (status.value == AppStrings.statusCompleted) {
        tasksStatus.assignAll(result.where((task) => task.isCompleted));
      } else {
        tasksStatus.assignAll(result.where((task) => !task.isCompleted));
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      errorMessage.value = '';
      await taskUseCases.addTask(task);
      fetchTasks();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      errorMessage.value = '';
      await taskUseCases.updateTask(task);
      fetchTasks();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      errorMessage.value = '';
      await taskUseCases.deleteTask(id);
      fetchTasks();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
