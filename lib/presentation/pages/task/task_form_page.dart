import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/task.dart';
import '../../controllers/task_controller.dart';
import '../../../core/values/AppStrings.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late String _priority;
  late bool _isCompleted;

  Task? _editingTask;
  bool get _isEditMode => _editingTask != null;

  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _editingTask = Get.arguments as Task?;
    _title = _editingTask?.title ?? '';
    _description = _editingTask?.description ?? '';
    _dueDate = _editingTask?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = _editingTask?.priority ?? AppStrings.priorityMedium;
    _isCompleted = _editingTask?.isCompleted ?? false;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2575FC),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      final taskId = _editingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final newTask = Task(
        id: taskId,
        title: _title,
        description: _description,
        isCompleted: _isCompleted,
        priority: _priority,
        dueDate: _dueDate,
        createdAt: _editingTask?.createdAt ?? DateTime.now(),
      );

      if (_isEditMode) {
        await taskController.updateTask(newTask);
      } else {
        await taskController.addTask(newTask);
      }

      final message = _isEditMode
          ? 'Đã cập nhật công việc "$_title"'
          : 'Đã tạo công việc mới "$_title"';

      Get.back();

      Get.snackbar(
        AppStrings.success,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF2575FC)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM dd, yyyy').format(_dueDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: _buildAppBar(_isEditMode),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildDateSelector(context, formattedDate),
                const SizedBox(height: 16),
                _buildPrioritySelector(),
                const SizedBox(height: 40),
                _buildSaveButton(_isEditMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isEditing) {
    return AppBar(
      title: Text(isEditing ? AppStrings.editTask : AppStrings.newTask, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildTitleField() {
    return _buildCardSection(
      child: TextFormField(
        initialValue: _title,
        decoration: const InputDecoration(
          labelText: AppStrings.taskTitle,
          hintText: AppStrings.taskTitleHint,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.title_rounded, color: Color(0xFF2575FC)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return AppStrings.taskTitleEmpty;
          }
          return null;
        },
        onSaved: (value) => _title = value?.trim() ?? '',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return _buildCardSection(
      child: TextFormField(
        initialValue: _description,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: AppStrings.taskDescription,
          hintText: AppStrings.taskDescriptionHint,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF2575FC)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return AppStrings.taskDescriptionEmpty;
          }
          return null;
        },
        onSaved: (value) => _description = value?.trim() ?? '',
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, String formattedDate) {
    return GestureDetector(
      onTap: () => _selectDueDate(context),
      child: _buildCardSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: Color(0xFF2575FC)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.dueDate,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            AppStrings.priority,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildPriorityChip(AppStrings.priorityLow, Colors.green, 'Thấp')),
            const SizedBox(width: 8),
            Expanded(child: _buildPriorityChip(AppStrings.priorityMedium, Colors.amber, 'Trung bình')),
            const SizedBox(width: 8),
            Expanded(child: _buildPriorityChip(AppStrings.priorityHigh, Colors.redAccent, 'Cao')),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFF2575FC).withOpacity(0.4),
          elevation: 8,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              isEditing ? AppStrings.saveChanges : AppStrings.createTask,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPriorityChip(String level, Color color, String displayName) {
    final isSelected = _priority == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = level;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            displayName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
