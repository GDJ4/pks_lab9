import 'package:supabase_flutter/supabase_flutter.dart';

/// Настройки Supabase, значения пробрасываются через --dart-define.
class SupabaseOptions {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  static void ensureConfigured() {
    final missingUrl = url.contains('your-project');
    final missingKey = anonKey == 'your-anon-key';
    if (missingUrl || missingKey) {
      throw StateError(
        'Supabase не сконфигурирован. Передайте SUPABASE_URL и SUPABASE_ANON_KEY через --dart-define.',
      );
    }
  }

  static Future<void> initialize() async {
    ensureConfigured();
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}
