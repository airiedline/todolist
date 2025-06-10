import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  String title;
  bool isDone;
  String category;
  DateTime? deadline;

  TaskModel({
    String? id,
    required this.title,
    this.isDone = false,
    this.category = 'Lainnya',
    this.deadline,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'category': category,
        'deadline': deadline?.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        isDone: json['isDone'],
        category: json['category'],
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      );
}
