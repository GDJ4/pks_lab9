import 'package:flutter/material.dart';
import 'models.dart';
import 'tasks_repository.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _repo = TasksRepository();
  final List<Task> _tasks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks({bool withLoader = true}) async {
    if (withLoader) setState(() => _loading = true);
    try {
      final items = await _repo.fetchTasks();
      if (!mounted) return;
      setState(() {
        _tasks
          ..clear()
          ..addAll(items);
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Не удалось загрузить задачи: $e');
    } finally {
      if (!mounted) return;
      if (withLoader) setState(() => _loading = false);
    }
  }

  Future<void> _toggle(Task t, bool v) async {
    setState(() => t.done = v);
    try {
      await _repo.setDone(t.id, v);
    } catch (e) {
      if (!mounted) return;
      setState(() => t.done = !v);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось обновить задачу: $e')),
      );
    }
  }

  void _openAdd() {
    Navigator.pushNamed(context, '/add').then((v) {
      if (v is Task) setState(() => _tasks.insert(0, v));
    });
  }

  Widget _buildBody() {
    if (_loading && _tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _loadTasks, child: const Text('Повторить')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadTasks(withLoader: false),
      child: _tasks.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: Text('Задач пока нет')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 22),
              itemBuilder: (context, i) {
                final t = _tasks[i];
                return Row(
                  children: [
                    CircleCheckbox(value: t.done, onChanged: (v) => _toggle(t, v)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(t.title, style: const TextStyle(fontSize: 18))),
                  ],
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Задачи')), // без const у AppBar
      body: _buildBody(),
      // квадратный FAB
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Material(
            color: AppColors.pinkLight.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _openAdd,
              child: const Center(child: Icon(Icons.add, size: 34, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
