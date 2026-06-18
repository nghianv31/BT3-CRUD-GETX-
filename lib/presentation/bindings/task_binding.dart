import 'package:get/get.dart';

import '../../domain/repositories/task_repository.dart';
import '../../data/providers/hive_task.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/task_usecases.dart';
import '../controllers/task_Controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký Repository Implementation cho Interface tương ứng
    Get.lazyPut<HiveTask>(HiveTask.new);
    Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl(Get.find<HiveTask>()));
    Get.lazyPut<TaskUseCases>(() => TaskUseCases(Get.find<TaskRepository>()));
    // Đăng ký Controller phụ thuộc vào Repository vừa đăng ký
    Get.lazyPut<TaskController>(() => TaskController(Get.find<TaskUseCases>()));
  }
}
