import '../../data/models/task_model.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority; // 'Low', 'Medium', 'High'
  final DateTime dueDate;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromModel(TaskModel model) {
    return Task(
      id: model.id,
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      priority: model.priority,
      dueDate: model.dueDate,
      createdAt: model.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }
}
