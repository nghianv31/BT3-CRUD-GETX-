// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/task.dart';
import '../../controllers/task_Controller.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  Task? _editingTask;
  bool get _isEditMode => _editingTask != null;

  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    // Lấy thông tin Task từ arguments (nếu đang ở chế độ chỉnh sửa)
    _editingTask = Get.arguments as Task?;

    _titleController = TextEditingController(text: _editingTask?.title ?? '');
    _descriptionController = TextEditingController(
      text: _editingTask?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027), // Deep Obsidian Blue
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button and Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isEditMode ? 'Chỉnh sửa công việc' : 'Tạo công việc mới',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Field Card
                        _buildInputFieldLabel('Tiêu đề công việc'),
                        const SizedBox(height: 8),
                        _buildTextFormField(
                          controller: _titleController,
                          hintText: 'Nhập tiêu đề...',
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Tiêu đề không được để trống';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Description Field Card
                        _buildInputFieldLabel('Mô tả chi tiết'),
                        const SizedBox(height: 8),
                        _buildTextFormField(
                          controller: _descriptionController,
                          hintText: 'Nhập mô tả chi tiết của công việc...',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Mô tả không được để trống';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 48),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00F2FE), // Teal
                                  Color(0xFF4FACFE), // Blue
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00F2FE,
                                  ).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _saveForm,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.save_rounded,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isEditMode
                                        ? 'LƯU THAY ĐỔI'
                                        : 'TẠO CÔNG VIỆC',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 13),
        ),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Vì là giao diện thuần chưa gắn logic controller, hiển thị thông báo rồi Back về danh sách
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final createdAt = DateTime.now();
      final isCompleted = false;

      if (_isEditMode) {
        await taskController.updateTask(
          _editingTask!.copyWith(title: title, description: description),
        );
      } else {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        await taskController.addTask(
          Task(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt,
            isCompleted: isCompleted,
          ),
        );
      }

      final message = _isEditMode
          ? 'Đã cập nhật công việc "$title" (Mock)'
          : 'Đã tạo công việc mới "$title" (Mock)';

      Get.back();

      Get.snackbar(
        'Thành công',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2C5364).withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF00F2FE)),
      );
    }
  }
}
