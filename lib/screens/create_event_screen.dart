import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _theme = TextEditingController();
  final _eventDate = TextEditingController();
  final _deadline = TextEditingController();

  void _create() {
    if (_theme.text.trim().isEmpty || _eventDate.text.trim().isEmpty || _deadline.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }
    context.read<AppState>().createEvent(_theme.text.trim(), _eventDate.text.trim(), _deadline.text.trim());
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('🎉 Event created. Singers can now submit songs.')));
    Navigator.of(context).pop();
  }

  String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.card,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => controller.text = _format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Create New Event'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _theme,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Theme (e.g. 90s Bollywood)', prefixIcon: Icon(Icons.celebration_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _eventDate,
              readOnly: true,
              onTap: () => _pickDate(_eventDate),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Event date (YYYY-MM-DD)', prefixIcon: Icon(Icons.event_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _deadline,
              readOnly: true,
              onTap: () => _pickDate(_deadline),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Submission deadline (YYYY-MM-DD)', prefixIcon: Icon(Icons.timer_outlined)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _create,
                icon: const Icon(Icons.campaign_rounded),
                label: const Text('Create Event & Notify Singers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}