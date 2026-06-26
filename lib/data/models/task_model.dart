import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends Task {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final String description;

  @HiveField(3)
  @override
  final bool isCompleted;

  @HiveField(4)
  @override
  final DateTime createdAt;

  @HiveField(5)
  @override
  final String priority;

  @HiveField(6)
  @override
  final DateTime dueDate;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
  }) : super(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         priority: priority,
         dueDate: dueDate,
         createdAt: createdAt,
       );

  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      priority: entity.priority,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
    );
  }
}
