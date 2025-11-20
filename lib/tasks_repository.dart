import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

/// Обертка вокруг таблицы `tasks` в Supabase.
class TasksRepository {
  TasksRepository({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _table = 'tasks';

  Future<List<Task>> fetchTasks() async {
    final data = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((row) => Task.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<Task> addTask(String title) async {
    final inserted = await _client
        .from(_table)
        .insert({'title': title})
        .select()
        .single();

    return Task.fromJson(inserted as Map<String, dynamic>);
  }

  Future<void> setDone(String id, bool done) async {
    await _client.from(_table).update({'done': done}).eq('id', id);
  }
}
