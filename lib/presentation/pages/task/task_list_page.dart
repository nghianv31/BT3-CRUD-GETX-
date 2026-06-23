// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/task.dart';
import '../../controllers/task_Controller.dart';
import '../../../core/values/AppStrings.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // Dữ liệu Mock tạm thời (Chưa áp dụng state management của GetX hoặc Hive thực tế)
  final TaskController taskController = Get.find<TaskController>();
  final String _filterStatus = 'All';
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
              _buildHeader(),
              _buildFilterChipsSection(),
              const SizedBox(height: 8),
              _buildTaskList(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.taskManagement,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  AppStrings.taskCount(taskController.tasksStatus.length),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          // Counter Quick Shortcut Button
          IconButton(
            icon: const Icon(
              Icons.bolt,
              color: Colors.amberAccent,
              size: 28,
            ),
            onPressed: () => Get.toNamed('/counter'),
            tooltip: AppStrings.viewCounterScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipsSection() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(AppStrings.statusAllVi, AppStrings.statusAll),
              const SizedBox(width: 12),
              _buildFilterChip(AppStrings.statusUncompletedVi, AppStrings.statusUncompleted),
              const SizedBox(width: 12),
              _buildFilterChip(AppStrings.statusCompletedVi, AppStrings.statusCompleted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00F2FE),
            ),
          );
        }

        if (taskController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                taskController.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (taskController.tasksStatus.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noTasks,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          );
        }

        // Lọc danh sách theo trạng thái
        final filteredTasks = taskController.tasksStatus.where((task) {
          if (_filterStatus == AppStrings.statusCompleted) return task.isCompleted;
          if (_filterStatus == AppStrings.statusUncompleted) return !task.isCompleted;
          return true;
        }).toList();

        if (filteredTasks.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noTasksMatchFilter,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return _buildTaskCard(task);
          },
        );
      }),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(AppRoutes.taskForm),
      backgroundColor: const Color(0xFF00F2FE), // Bright Teal
      foregroundColor: Colors.black87,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add_rounded, size: 30),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Status Indicator Bar
              Container(
                width: 6,
                color: task.isCompleted
                    ? const Color(0xFF00F2FE)
                    : Colors.amberAccent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom Checkbox UI
                          GestureDetector(
                            onTap: () async {
                              await taskController.updateTask(
                                task.copyWith(isCompleted: !task.isCompleted),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(
                                right: 12.0,
                                top: 2.0,
                              ),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? const Color(0xFF00F2FE)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: task.isCompleted
                                      ? const Color(0xFF00F2FE)
                                      : Colors.white54,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: task.isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.black87,
                                    )
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                              _formatDate(task.createdAt),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Edit Button
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Chuyển sang form chỉnh sửa, truyền dữ liệu Task hiện tại
                                  Get.toNamed(
                                    AppRoutes.taskForm,
                                    arguments: task,
                                  );
                                },
                              ),
                              // Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () => _showDeleteConfirmDialog(task),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF203A43),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            AppStrings.confirmDelete,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppStrings.confirmDeleteTask(task.title),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.white54)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                AppStrings.delete,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await taskController.deleteTask(task.id);
                Navigator.of(context).pop();
                Get.snackbar(
                  AppStrings.success,
                  AppStrings.taskDeleted(task.title),
                  backgroundColor: Colors.greenAccent,
                  borderRadius: 12,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF00F2FE),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String statusValue) {
    final isSelected = taskController.status.value == statusValue;
    return GestureDetector(
      onTap: () {
        taskController.changeStatus(statusValue);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00F2FE)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00F2FE)
                : Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.white.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
