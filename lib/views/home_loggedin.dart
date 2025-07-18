import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers.dart';
import 'profile_drawer.dart';

import '../features/home/view/home_screen.dart';
import '../features/feed/view/feed_screen.dart';
import '../features/messaging/view/messaging_screen.dart';
import '../features/profile/view/profile_screen.dart'; // adjust imports to your structure

class HomeLoggedIn extends ConsumerStatefulWidget {
  const HomeLoggedIn({super.key});

  @override
  ConsumerState<HomeLoggedIn> createState() => _HomeLoggedInState();
}

class _HomeLoggedInState extends ConsumerState<HomeLoggedIn> {
  int _selectedIndex = 0;

  final List<Map<String, Object?>> _navItems = [
    {'label': 'Home', 'icon': Icons.home, 'route': '/home'},
    {'label': 'Feed', 'icon': Icons.feed, 'route': '/feed'},
    {'label': 'Messages', 'icon': Icons.message, 'route': '/messaging'},
    {'label': 'Profile', 'icon': null, 'route': 'profile'},
  ];

  void _onItemTapped(int index, BuildContext context) {
    final route = _navItems[index]['route'] as String;
    if (route == 'profile') {
      Scaffold.of(context).openEndDrawer();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    // no context.go() or push here
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUserProvider).valueOrNull;

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // prevent default back, just switch tab
        }
        return true; // allow system back to exit app
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Welcome, ${user?.phoneNumber ?? 'User'}')),
        endDrawer: const ProfileDrawer(),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeScreen(),
            FeedScreen(),
            MessagingScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          items: _navItems.map((item) {
            final icon = item['route'] == 'profile'
                ? CircleAvatar(
                    radius: 12,
                    backgroundImage:
                        user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null ? const Icon(Icons.person, size: 16) : null,
                  )
                : Icon(item['icon'] as IconData?);
            return BottomNavigationBarItem(
              icon: icon,
              label: item['label'] as String,
            );
          }).toList(),
        ),
      ),
    );
  }
}
