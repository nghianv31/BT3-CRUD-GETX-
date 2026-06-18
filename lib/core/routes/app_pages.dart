import 'package:get/get.dart';
import '../../presentation/bindings/task_binding.dart';
import '../../presentation/pages/task/task_list_page.dart';
import '../../presentation/pages/task/task_form_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.tasks;

  static final routes = [
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListPage(),
      binding: TaskBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.taskForm,
      page: () => const TaskFormPage(),
      binding: TaskBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
