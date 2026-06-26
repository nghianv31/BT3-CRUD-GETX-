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
  
  RxString searchQuery = ''.obs;
  RxString priorityFilter = 'All'.obs;
  RxString sortBy = 'CreatedAt'.obs;
  RxBool sortAscending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void changeStatus(String newStatus) {
    status.value = newStatus;
    fetchTasks();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchTasks();
  }

  void setPriorityFilter(String filter) {
    priorityFilter.value = filter;
    fetchTasks();
  }

  void setSortBy(String criteria, bool ascending) {
    sortBy.value = criteria;
    sortAscending.value = ascending;
    fetchTasks();
  }

  void fetchTasks() {
    try {
      errorMessage.value = '';
      isLoading.value = true;
      final result = taskUseCases.getTasks();
      
      // Lọc danh sách
      final filtered = result.where((task) {
        final matchesStatus = status.value == AppStrings.statusAll ||
            (status.value == AppStrings.statusCompleted && task.isCompleted) ||
            (status.value == AppStrings.statusUncompleted && !task.isCompleted);
            
        final matchesPriority = priorityFilter.value == 'All' ||
            task.priority == priorityFilter.value;
            
        final matchesSearch = task.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            task.description.toLowerCase().contains(searchQuery.value.toLowerCase());
            
        return matchesStatus && matchesPriority && matchesSearch;
      }).toList();

      // Sắp xếp danh sách
      filtered.sort((a, b) {
        int comparison = 0;
        switch (sortBy.value) {
          case 'DueDate':
            comparison = a.dueDate.compareTo(b.dueDate);
            break;
          case 'Priority':
            final weightA = _getPriorityWeight(a.priority);
            final weightB = _getPriorityWeight(b.priority);
            comparison = weightB.compareTo(weightA); // mặc định Cao -> Thấp
            break;
          case 'Title':
            comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
            break;
          case 'CreatedAt':
          default:
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
        }
        return sortAscending.value ? comparison : -comparison;
      });

      tasksStatus.assignAll(filtered);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  int _getPriorityWeight(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
      default:
        return 1;
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
