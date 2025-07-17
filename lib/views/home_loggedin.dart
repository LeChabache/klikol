import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers.dart';
import 'profile_drawer.dart';

class HomeLoggedIn extends ConsumerStatefulWidget {
  const HomeLoggedIn({super.key});

  @override
  ConsumerState<HomeLoggedIn> createState() => _HomeLoggedInState();
}

class _HomeLoggedInState extends ConsumerState<HomeLoggedIn> {
  int _selectedIndex = 0;

  static const List<Map<String, Object?>> _navItems = [
    {'label': 'Home', 'icon': Icons.home, 'route': '/home'},
    {'label': 'Feed', 'icon': Icons.feed, 'route': '/feed'},
    {'label': 'Messages', 'icon': Icons.message, 'route': '/messaging'},
    {'label': 'Profile', 'icon': null, 'route': 'profile'},
  ];

  void _onItemTapped(int index, BuildContext context) {
    final route = _navItems[index]['route']! as String;

    if (route == 'profile') {
      Scaffold.of(context).openEndDrawer();
      return;
    }

    final currentRoute = GoRouter.of(context).state.location;

    if (currentRoute == route) {
      // Prevent navigating to the same route
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUserProvider).valueOrNull;

    final currentRoute = GoRouter.of(context).state.location;
    final foundIndex = _navItems.indexWhere((item) => (item['route'] as String) == currentRoute);
    _selectedIndex = foundIndex == -1 ? 0 : foundIndex;

    return WillPopScope(
      onWillPop: () async {
        if (currentRoute != '/home') {
          context.go('/home');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Welcome, ${user?.phoneNumber ?? 'User'}')),
        endDrawer: const ProfileDrawer(),
        body: const Center(child: Text('This is logged-in user home')),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          items: _navItems.map((item) {
            if (item['route'] == 'profile') {
              return BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 12,
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? const Icon(Icons.person, size: 16) : null,
                ),
                label: item['label'] as String,
              );
            } else {
              return BottomNavigationBarItem(
                icon: Icon(item['icon'] as IconData?),
                label: item['label'] as String,
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}
