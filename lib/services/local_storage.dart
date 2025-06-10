import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class LocalStorage {
  static const _key = 'todo_tasks';

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  static Future<List<TaskModel>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(_key);
    return data?.map((e) => TaskModel.fromJson(jsonDecode(e))).toList() ?? [];
  }
}