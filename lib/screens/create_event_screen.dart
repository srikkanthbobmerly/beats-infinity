import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _posterPath;

  Future<void> _pickPoster() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() => _posterPath = picked.path);
    }
  }

  void _create() {
    if (_theme.text.trim().isEmpty || _eventDate.text.trim().isEmpty || _deadline.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }
    context.read<AppState>().createEvent(
      _theme.text.trim(),
      _eventDate.text.trim(),
      _deadline.text.trim(),
      posterPath: _posterPath,
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('🎉 Event created. Singers can now submit songs.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Create New Event'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickPoster,
              child: Container(
                width: double.infinity,
                height: 160,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: _posterPath == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded, color: AppColors.textMuted, size: 32),
                    SizedBox(height: 8),
                    Text('Upload event poster (optional)', style: TextStyle(color: AppColors.textMuted)),
                  ],
                )
                    : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(_posterPath!), fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _posterPath = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _theme,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Theme (e.g. 90s Bollywood)', prefixIcon: Icon(Icons.celebration_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _eventDate,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Event date (YYYY-MM-DD)', prefixIcon: Icon(Icons.event_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _deadline,
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