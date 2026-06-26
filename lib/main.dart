import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_pages.dart';
import 'data/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Hive cục bộ
  await Hive.initFlutter();
  
  // Đăng ký Adapter được sinh bởi build_runner
  Hive.registerAdapter(TaskModelAdapter());
  
  // Mở box chứa các Task để sẵn sàng cho nghiệp vụ sau này
  await Hive.openBox<TaskModel>('tasks_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2575FC),
          primary: const Color(0xFF2575FC),
          secondary: const Color(0xFF6A11CB),
        ),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}

