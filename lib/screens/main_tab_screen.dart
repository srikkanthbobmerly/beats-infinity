import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';
import 'home_screen.dart';
import 'songs_tab.dart';
import 'pairing_tab.dart';
import 'profile_tab.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _index = 0;

  static const _tabs = [
    HomeTabBody(),
    SongsTabBody(),
    PairingTabBody(),
    ProfileTabBody(),
  ];

  static const _titles = ['Welcome to Beats Infinity', 'Songs', 'My Pairings', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_index == 0) ...[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(gradient: gradientPrimary, borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                _titles[_index],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Songs'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_rounded), label: 'Pairing'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
