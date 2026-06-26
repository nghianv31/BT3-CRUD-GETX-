import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:bt2_getx/main.dart';
import 'package:bt2_getx/data/models/task_model.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    // Khởi tạo Hive trong thư mục tạm thời của hệ thống
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    
    // Đăng ký Adapter và mở box để sẵn sàng cho chạy thử
    try {
      Hive.registerAdapter(TaskModelAdapter());
    } catch (_) {
      // Bỏ qua lỗi nếu adapter đã được đăng ký trước đó
    }
    await Hive.openBox<TaskModel>('tasks_box');
  });

  tearDown(() async {
    // Đóng toàn bộ các box và xóa thư mục tạm
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('Task CRUD UI navigation and display test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Xác nhận tiêu đề màn hình chính hiển thị đúng
    expect(find.text('Quản lý công việc'), findsOneWidget);
    
    // Tìm và nhấn vào nút FloatingActionButton (+)
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.tap(fabFinder);
    
    // Đợi GetX hoàn thành chuyển động chuyển màn hình sang TaskFormPage
    await tester.pumpAndSettle();

    // Xác nhận đã điều hướng sang trang Form bằng cách tìm tiêu đề
    expect(find.text('Tạo công việc mới'), findsOneWidget);

    // Tìm nút quay lại và nhấn vào để quay về danh sách
    final backButtonFinder = find.byType(BackButton);
    expect(backButtonFinder, findsOneWidget);
    await tester.tap(backButtonFinder);
    
    // Đợi hiệu ứng quay lại kết thúc
    await tester.pumpAndSettle();

    // Xác nhận đã quay về màn hình danh sách
    expect(find.text('Quản lý công việc'), findsOneWidget);
  });
}
