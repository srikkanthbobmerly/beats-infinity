import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';
import 'admin_home_tab.dart';
import 'singers_tab.dart';
import 'songs_tab.dart';
import 'profile_tab.dart';

/// The admin's dedicated app shell. Admins land here after login and never
/// see the singer's Home/Songs/Pairing tabs — they get Dashboard/Singers/
/// Songs/Profile instead, with an "ADMIN" badge always visible so it's
/// never ambiguous which mode they're in.
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});
  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _index = 0;

  static const _tabs = [
    AdminHomeTabBody(),
    SingersTabBody(),
    SongsTabBody(),
    ProfileTabBody(showAdminEntry: false),
  ];

  static const _titles = ['Dashboard', 'Singers', 'Songs', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_titles[_index], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Text('ADMIN', style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 2),
              child: GestureDetector(
                onTap: () => setState(() => _index = 3),
                child: InitialsAvatar(name: user.name, radius: 16),
              ),
            ),
        ],
      ),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Singers'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Songs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
