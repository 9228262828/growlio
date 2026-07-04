import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habit_editor.dart';
import 'settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GrowlioApp());
}

const kLeaf = Color(0xFF3E9F4F);
const kLeafDark = Color(0xFF145C32);
const kCream = Color(0xFFFFF8EA);
const kSoil = Color(0xFF7A4A27);
const kMint = Color(0xFFE8F7DF);

const habitsKey = 'growlio.habits.v1';
const darkKey = 'growlio.dark.v1';

class GrowlioApp extends StatefulWidget {
  const GrowlioApp({super.key});

  @override
  State<GrowlioApp> createState() => _GrowlioAppState();
}

class _GrowlioAppState extends State<GrowlioApp> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => darkMode = prefs.getBool(darkKey) ?? false);
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkKey, value);
    setState(() => darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growlio',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kLeaf,
        scaffoldBackgroundColor: kCream,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: kLeaf,
      ),
      home: SplashScreen(
        darkMode: darkMode,
        onDarkModeChanged: setDarkMode,
      ),
    );
  }
}

class HabitPlant {
  final String id;
  final String title;
  final String note;
  final bool favorite;
  final int streak;
  final int level;
  final String lastDoneDate;
  final DateTime createdAt;

  const HabitPlant({
    required this.id,
    required this.title,
    required this.note,
    required this.favorite,
    required this.streak,
    required this.level,
    required this.lastDoneDate,
    required this.createdAt,
  });

  bool get doneToday {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    return lastDoneDate == today;
  }

  String get plantEmoji {
    if (level <= 1) return '🌱';
    if (level <= 3) return '🌿';
    if (level <= 6) return '🪴';
    return '🌳';
  }

  String get plantStage {
    if (level <= 1) return 'Seed';
    if (level <= 3) return 'Sprout';
    if (level <= 6) return 'Plant';
    return 'Tree';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'favorite': favorite,
    'streak': streak,
    'level': level,
    'lastDoneDate': lastDoneDate,
    'createdAt': createdAt.toIso8601String(),
  };

  factory HabitPlant.fromJson(Map<String, dynamic> json) {
    return HabitPlant(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      favorite: json['favorite'] ?? false,
      streak: json['streak'] is int ? json['streak'] : 0,
      level: json['level'] is int ? json['level'] : 1,
      lastDoneDate: json['lastDoneDate'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  HabitPlant copyWith({
    String? id,
    String? title,
    String? note,
    bool? favorite,
    int? streak,
    int? level,
    String? lastDoneDate,
    DateTime? createdAt,
  }) {
    return HabitPlant(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      favorite: favorite ?? this.favorite,
      streak: streak ?? this.streak,
      level: level ?? this.level,
      lastDoneDate: lastDoneDate ?? this.lastDoneDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SplashScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            darkMode: widget.darkMode,
            onDarkModeChanged: widget.onDarkModeChanged,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(75),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/logo.png',
                width: 170,
                height: 170,
                errorBuilder: (_, __, ___) => const Text(
                  '🌱',
                  style: TextStyle(fontSize: 120),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Growlio',
                style: TextStyle(
                  color: kLeafDark,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Grow better habits daily.',
                style: TextStyle(
                  color: kLeaf,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 26),
              const CircularProgressIndicator(color: kLeaf),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum HabitFilter { all, favorites }

class HomeScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const HomeScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HabitPlant> habits = [];
  String search = '';
  HabitFilter filter = HabitFilter.all;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(habitsKey);

    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw) as List;
      setState(() {
        habits = decoded
            .map((e) => HabitPlant.fromJson(Map<String, dynamic>.from(e)))
            .where((e) => e.title.trim().isNotEmpty)
            .toList();
        sortHabits();
      });
    } catch (_) {
      setState(() => habits = []);
    }
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      habitsKey,
      jsonEncode(habits.map((e) => e.toJson()).toList()),
    );
  }

  void sortHabits() {
    habits.sort((a, b) {
      if (a.favorite != b.favorite) return a.favorite ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  List<HabitPlant> get visibleHabits {
    final q = search.toLowerCase();

    final list = habits.where((habit) {
      final matchesSearch =
          habit.title.toLowerCase().contains(q) ||
              habit.note.toLowerCase().contains(q);
      final matchesFilter = filter == HabitFilter.all || habit.favorite;
      return matchesSearch && matchesFilter;
    }).toList();

    list.sort((a, b) {
      if (a.favorite != b.favorite) return a.favorite ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return list;
  }

  Future<void> openEditor([HabitPlant? habit]) async {
    final result = await Navigator.push<HabitPlant>(
      context,
      MaterialPageRoute(
        builder: (_) => HabitEditorScreen(habit: habit),
      ),
    );

    if (result == null) return;

    setState(() {
      final index = habits.indexWhere((e) => e.id == result.id);
      if (index == -1) {
        habits.add(result);
      } else {
        habits[index] = result;
      }
      sortHabits();
    });

    saveHabits();
  }

  Future<void> deleteHabit(HabitPlant habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('Remove "${habit.title}" from your garden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final index = habits.indexWhere((e) => e.id == habit.id);

    setState(() => habits.removeWhere((e) => e.id == habit.id));
    await saveHabits();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              habits.insert(index < 0 ? 0 : index, habit);
              sortHabits();
            });
            saveHabits();
          },
        ),
      ),
    );
  }

  Future<void> toggleFavorite(HabitPlant habit) async {
    setState(() {
      final index = habits.indexWhere((e) => e.id == habit.id);
      habits[index] = habit.copyWith(favorite: !habit.favorite);
      sortHabits();
    });
    saveHabits();
  }

  Future<void> markDone(HabitPlant habit) async {
    if (habit.doneToday) return;

    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    setState(() {
      final index = habits.indexWhere((e) => e.id == habit.id);
      habits[index] = habit.copyWith(
        streak: habit.streak + 1,
        level: (habit.level + 1).clamp(1, 10),
        lastDoneDate: today,
      );
      sortHabits();
    });

    saveHabits();
  }

  Future<void> undoToday(HabitPlant habit) async {
    if (!habit.doneToday) return;

    setState(() {
      final index = habits.indexWhere((e) => e.id == habit.id);
      habits[index] = habit.copyWith(
        streak: habit.streak > 0 ? habit.streak - 1 : 0,
        level: habit.level > 1 ? habit.level - 1 : 1,
        lastDoneDate: '',
      );
      sortHabits();
    });

    saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    final visible = visibleHabits;
    final completedToday = habits.where((e) => e.doneToday).length;

    return Scaffold(
      backgroundColor: kCream,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kLeaf,
        foregroundColor: Colors.white,
        onPressed: () => openEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Plant Habit'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: kMint,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: kLeaf.withOpacity(.25)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 58,
                        height: 58,
                        errorBuilder: (_, __, ___) => const Text(
                          '🌱',
                          style: TextStyle(fontSize: 46),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Growlio',
                          style: TextStyle(
                            color: kLeafDark,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Settings',
                        icon: const Icon(Icons.settings_rounded),
                        color: kLeafDark,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsScreen(
                              darkMode: widget.darkMode,
                              onDarkModeChanged: widget.onDarkModeChanged,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your habit garden',
                      style: TextStyle(
                        color: kLeafDark,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$completedToday/${habits.length} completed today',
                      style: const TextStyle(
                        color: kLeaf,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => search = v),
                      decoration: InputDecoration(
                        hintText: 'Search habits...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: search.isEmpty
                            ? null
                            : IconButton(
                          onPressed: () => setState(() => search = ''),
                          icon: const Icon(Icons.close_rounded),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: filter == HabitFilter.favorites
                          ? kLeaf
                          : Colors.white,
                      foregroundColor: filter == HabitFilter.favorites
                          ? Colors.white
                          : kLeafDark,
                    ),
                    onPressed: () {
                      setState(() {
                        filter = filter == HabitFilter.favorites
                            ? HabitFilter.all
                            : HabitFilter.favorites;
                      });
                    },
                    icon: const Icon(Icons.star_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? EmptyGardenState(onAdd: () => openEditor())
                  : GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 96),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .58,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: visible.length,
                itemBuilder: (_, index) {
                  final habit = visible[index];
                  return HabitPlantCard(
                    habit: habit,
                    onTap: () => openEditor(habit),
                    onDone: () => markDone(habit),
                    onUndo: () => undoToday(habit),
                    onFavorite: () => toggleFavorite(habit),
                    onDelete: () => deleteHabit(habit),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitPlantCard extends StatelessWidget {
  final HabitPlant habit;
  final VoidCallback onTap;
  final VoidCallback onDone;
  final VoidCallback onUndo;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  const HabitPlantCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onDone,
    required this.onUndo,
    required this.onFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kLeaf.withOpacity(.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onFavorite,
                  child: Icon(
                    habit.favorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: kLeaf,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.close_rounded, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(habit.plantEmoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 6),
            Text(
              habit.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kLeafDark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              habit.plantStage,
              style: const TextStyle(
                color: kLeaf,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '🔥 ${habit.streak} day streak',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: habit.doneToday ? kSoil : kLeaf,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                onPressed: habit.doneToday ? onUndo : onDone,
                child: Text(
                  habit.doneToday ? 'Undo' : 'Done Today',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),    );
  }
}

class EmptyGardenState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyGardenState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 90)),
          const SizedBox(height: 18),
          const Text(
            'Your garden is empty',
            style: TextStyle(
              color: kLeafDark,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Plant your first habit and grow it with daily progress.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Plant First Habit'),
          ),
        ],
      ),
    );
  }
}