import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';
import '../widgets/task_card.dart';
import '../widgets/statistics_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = [];

  String selectedCategory = 'Lainnya';
  DateTime? selectedDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    loadTasks();
    _searchController.addListener(() {
      filterTasks(_searchController.text);
    });
  }

  void loadTasks() async {
    tasks = await LocalStorage.loadTasks();
    setState(() {
      filterTasks(_searchController.text);
    });
  }

  void saveTasks() {
    LocalStorage.saveTasks(tasks);
    filterTasks(_searchController.text);
  }

  void filterTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTasks = List.from(tasks);
      } else {
        filteredTasks = tasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addTask() {
    if (_controller.text.trim().isEmpty) return;
    TaskModel task = TaskModel(
      title: _controller.text.trim(),
      category: selectedCategory,
      deadline: selectedDate,
    );
    setState(() {
      tasks.add(task);
      _controller.clear();
      selectedDate = null;
      selectedCategory = 'Lainnya';
    });
    saveTasks();
    if (task.deadline != null) {
      NotificationService().scheduleNotification(task);
    }
  }

  void toggleDone(int index) {
    final task = filteredTasks[index];
    final originalIndex = tasks.indexOf(task);
    setState(() {
      tasks[originalIndex].isDone = !tasks[originalIndex].isDone;
    });
    saveTasks();
  }

  void deleteTask(int index) {
    final task = filteredTasks[index];
    setState(() {
      tasks.remove(task);
    });
    saveTasks();
  }

  void editTask(int index) {
    final task = filteredTasks[index];
    final originalIndex = tasks.indexOf(task);

    TextEditingController editController =
        TextEditingController(text: task.title);
    String editCategory = task.category;
    DateTime? editDate = task.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Tugas'),
          content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    TextField(
      controller: editController,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        labelText: 'Judul Tugas',
        labelStyle: TextStyle(color: Colors.black87),
      ),
    ),

              const SizedBox(height: 10),
              DropdownButton<String>(
  value: editCategory,
  dropdownColor: Colors.white,
  style: const TextStyle(color: Colors.black),
  items: ['Lainnya', 'Belajar', 'Kerja', 'Santai']
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList(),
  onChanged: (val) {
    setState(() {
      editCategory = val!;
    });
  },
),

              const SizedBox(height: 10),
              TextButton.icon(
  onPressed: () async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: editDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        editDate = picked;
      });
    }
  },
  icon: const Icon(Icons.date_range, color: Colors.indigo),
  label: Text(
    editDate != null
        ? 'Deadline: ${DateFormat('dd MMM yyyy').format(editDate!)}'
        : 'Pilih Tanggal',
    style: const TextStyle(color: Colors.black),
  ),
),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks[originalIndex].title = editController.text;
                  tasks[originalIndex].category = editCategory;
                  tasks[originalIndex].deadline = editDate;
                });
                saveTasks();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  List<TaskModel> _getTasksForDay(DateTime day) {
    return tasks.where((task) {
      return task.deadline != null &&
          task.deadline!.year == day.year &&
          task.deadline!.month == day.month &&
          task.deadline!.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  StatisticsBar(tasks: tasks),
                  const SizedBox(height: 16),
                  TableCalendar<TaskModel>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    eventLoader: _getTasksForDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                 Row(
  children: [
    Expanded(
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(color: Colors.black), 
        decoration: const InputDecoration(
          hintText: 'Tambahkan tugas...',
          border: OutlineInputBorder(),
          hintStyle: TextStyle(color: Colors.grey), 
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.date_range),
      onPressed: () async {
        selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        setState(() {});
      },
    ),
    DropdownButton<String>(
      value: selectedCategory,
      items: ['Lainnya', 'Belajar', 'Kerja', 'Santai']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) => setState(() => selectedCategory = val!),
    ),
    IconButton(
      icon: const Icon(Icons.add_circle, size: 30, color: Colors.indigo),
      onPressed: addTask,
    ),
  ],
),

                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari tugas...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedDay != null) ...[
                    const Text(
                      'Tugas di hari terpilih:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ..._getTasksForDay(_selectedDay!).map((task) {
                      return ListTile(
                        title: Text(task.title),
                        trailing: Icon(
                          task.isDone
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: task.isDone ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          int idx = tasks.indexOf(task);
                          setState(() {
                            tasks[idx].isDone = !tasks[idx].isDone;
                          });
                          saveTasks();
                        },
                      );
                    }).toList(),
                  ],
                  const Divider(),
                  const Text(
                    'Daftar Semua Tugas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          filteredTasks.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text('Tidak ada tugas ditemukan'),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return TaskCard(
                        key: ValueKey(filteredTasks[index].id),
                        task: filteredTasks[index],
                        onDone: () => toggleDone(index),
                        onDelete: () => deleteTask(index),
                        onEdit: () => editTask(index),
                      );
                    },
                    childCount: filteredTasks.length,
                  ),
                ),
        ],
      ),
    );
  }
}
