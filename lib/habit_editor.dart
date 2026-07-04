import 'package:flutter/material.dart';
import 'main.dart';

class HabitEditorScreen extends StatefulWidget {
  final HabitPlant? habit;

  const HabitEditorScreen({
    super.key,
    this.habit,
  });

  @override
  State<HabitEditorScreen> createState() => _HabitEditorScreenState();
}

class _HabitEditorScreenState extends State<HabitEditorScreen> {
  late final TextEditingController titleController;
  late final TextEditingController noteController;
  late bool favorite;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.habit?.title ?? '');
    noteController = TextEditingController(text: widget.habit?.note ?? '');
    favorite = widget.habit?.favorite ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveHabit() {
    final title = titleController.text.trim();
    final note = noteController.text.trim();

    if (title.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid habit name')),
      );
      return;
    }

    final now = DateTime.now();

    Navigator.pop(
      context,
      HabitPlant(
        id: widget.habit?.id ?? now.microsecondsSinceEpoch.toString(),
        title: title,
        note: note,
        favorite: favorite,
        streak: widget.habit?.streak ?? 0,
        level: widget.habit?.level ?? 1,
        lastDoneDate: widget.habit?.lastDoneDate ?? '',
        createdAt: widget.habit?.createdAt ?? now,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewLevel = widget.habit?.level ?? 1;
    final previewEmoji = previewLevel <= 1
        ? '🌱'
        : previewLevel <= 3
        ? '🌿'
        : previewLevel <= 6
        ? '🪴'
        : '🌳';

    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kCream,
        foregroundColor: kLeafDark,
        title: Text(widget.habit == null ? 'Plant Habit' : 'Edit Habit'),
        actions: [
          IconButton(
            tooltip: 'Favorite',
            onPressed: () => setState(() => favorite = !favorite),
            icon: Icon(
              favorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: kLeaf,
            ),
          ),
          TextButton(
            onPressed: saveHabit,
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: kLeaf,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: kMint,
                shape: BoxShape.circle,
                border: Border.all(color: kLeaf.withOpacity(.3), width: 3),
              ),
              child: Center(
                child: Text(
                  previewEmoji,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Habit name',
              hintText: 'Reading, Workout, No Sugar...',
              prefixIcon: const Icon(Icons.eco_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: noteController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Note optional',
              hintText: 'Why this habit matters to you...',
              prefixIcon: const Icon(Icons.notes_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: kMint,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kLeaf.withOpacity(.18)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How growth works',
                  style: TextStyle(
                    color: kLeafDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text('🌱 Start as a seed'),
                Text('🌿 Grow into a sprout'),
                Text('🪴 Become a stronger plant'),
                Text('🌳 Turn into a tree with consistency'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kLeaf,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: saveHabit,
              child: const Text(
                'Save Habit',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}