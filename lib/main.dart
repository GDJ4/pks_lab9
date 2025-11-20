import 'package:flutter/material.dart';
import 'models.dart';
import 'tasks_page.dart';
import 'supabase_options.dart';
import 'tasks_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SupabaseOptions.initialize();
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Ошибка инициализации Supabase: $e')),
      ),
    ));
    return;
  }
  runApp(const PrototypeApp());
}

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  // Палитра
  static const Color kBg        = Color(0xFF241E35); // <-- твой фон
  static const Color kPanel     = Color(0xFF1A1829);
  static const Color kPurple    = Color(0xFF5B1285);
  static const Color kPink      = Color(0xFFFF4F8A);
  static const Color kPinkLight = Color(0xFFFF6A9E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: kPink,
          surface: kPanel,
          background: kBg,
        ),
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPurple,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false, // контур как в макете
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2.2),
          ),
          hintStyle: const TextStyle(color: Colors.white70),
          labelStyle: const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 16, height: 1.25),
        ),
      ),
      routes: {
        '/':     (_) => const LoginPage(),
        '/tasks':(_) => const TasksPage(),
        '/add':  (_) => const AddTaskPage(),
      },
    );
  }
}

/// ---------- Кастомная иконка блокнота (ОДНА, 3 пружины)
class NotebookIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  const NotebookIcon({
    super.key,
    this.size = 140,
    this.color = PrototypeApp.kPink,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _NotebookPainter(color, strokeWidth));
  }
}
class _NotebookPainter extends CustomPainter {
  final Color color; final double w;
  _NotebookPainter(this.color, this.w);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Одинарный блокнот
    final rect = Rect.fromLTWH(s.width * .22, s.height * .24, s.width * .56, s.height * .56);
    final r = RRect.fromRectAndRadius(rect, Radius.circular(s.width * .10));
    c.drawRRect(r, p);

    // 3 пружины
    final top = r.outerRect.top;
    final left = r.outerRect.left;
    final step = r.outerRect.width / 4; // 3 кольца
    for (int i = 0; i < 3; i++) {
      final x = left + step * (i + .7);
      c.drawCircle(Offset(x, top - s.height * .06), w / 1.6, p);
      c.drawLine(Offset(x, top - s.height * .03), Offset(x, top + s.height * .03), p);
    }

    // Линии-текст
    final startX = left + s.width * .06;
    final endX   = left + r.outerRect.width - s.width * .06;
    double y = r.outerRect.top + s.height * .12;
    for (int i = 0; i < 4; i++) {
      c.drawLine(Offset(startX, y), Offset(endX, y), p);
      y += s.height * .11;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// ---------- Экран входа
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const pink = PrototypeApp.kPink;
    const pinkLight = PrototypeApp.kPinkLight;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.fromLTRB(32, 36, 32, 28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: pink, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NotebookIcon(),
                const SizedBox(height: 28),
                const Text(
                  'Добро пожаловать!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 26),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: SizedBox(
                    width: double.infinity, height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [pink, pinkLight],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/tasks'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Text('Войти', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
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
}

/// ---------- Экран добавления задачи
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}
class _AddTaskPageState extends State<AddTaskPage> {
  final _ctrl = TextEditingController();
  final _repo = TasksRepository();
  bool _saving = false;
  String? _error;

  Future<void> _submit() async {
    final t = _ctrl.text.trim();
    if (t.isEmpty || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final task = await _repo.addTask(t);
      if (!mounted) return;
      Navigator.pop(context, task);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Не удалось создать задачу: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новая задача')), // <-- без const у AppBar
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ctrl,
                  autofocus: true,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Текст', hintText: 'Введите описание задачи…'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ],
              ],
            ),
          ),
          Positioned(
            right: 24, bottom: 24,
            child: OutlinedButton(
              onPressed: _saving ? null : _submit,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Готово'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
}
