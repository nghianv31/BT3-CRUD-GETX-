import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../../core/values/AppStrings.dart';
import '../controllers/task_controller.dart';
import '../pages/task/task_form_page.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;

  const TaskCardWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final priorityColor = _getPriorityColor();
    final formattedDate = DateFormat('MMM dd, yyyy').format(task.dueDate);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await taskController.deleteTask(task.id);
        Get.snackbar(
          AppStrings.success,
          AppStrings.taskDeleted(task.title),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          mainButton: TextButton(
            child: const Text('UNDO', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await taskController.addTask(task);
              if (Get.isSnackbarOpen) Get.back();
            },
          ),
        );
      },
      background: _buildDismissibleBackground(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildPriorityBar(priorityColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndCheckbox(context, taskController),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildDescription(),
                        ],
                        const SizedBox(height: 12),
                        _buildBottomRow(context, taskController, formattedDate),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.amber;
      case 'Low':
      default:
        return Colors.green;
    }
  }

  Widget _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildPriorityBar(Color priorityColor) {
    return Container(
      width: 6,
      color: priorityColor,
    );
  }

  Widget _buildTitleAndCheckbox(BuildContext context, TaskController taskController) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
              color: task.isCompleted
                  ? Colors.grey
                  : Colors.black87,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await taskController.updateTask(
              task.copyWith(isCompleted: !task.isCompleted),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted
                  ? const Color(0xFF2575FC)
                  : Colors.transparent,
              border: Border.all(
                color: task.isCompleted
                    ? const Color(0xFF2575FC)
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: task.isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
        decoration: task.isCompleted
            ? TextDecoration.lineThrough
            : null,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBottomRow(BuildContext context, TaskController taskController, String formattedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(
                  () => const TaskFormPage(),
                  arguments: task,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2575FC).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFF2575FC),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await taskController.deleteTask(task.id);
                Get.snackbar(
                  AppStrings.success,
                  AppStrings.taskDeleted(task.title),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
