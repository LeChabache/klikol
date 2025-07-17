import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'profile_drawer.dart';

class HomeGuest extends ConsumerStatefulWidget {
  const HomeGuest({super.key});

  @override
  ConsumerState<HomeGuest> createState() => _HomeGuestState();
}

class _HomeGuestState extends ConsumerState<HomeGuest> {
  int _selectedIndex = 0;

  static const List<Map<String, Object?>> _navItems = [
    {'label': 'Guest Home', 'icon': Icons.home, 'route': '/guest'},
    {'label': 'Feed', 'icon': Icons.feed, 'route': '/feed'},
    {'label': 'Profile', 'icon': Icons.person, 'route': 'profile'},
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
    final currentRoute = GoRouter.of(context).state.location;

    final foundIndex = _navItems.indexWhere((item) => (item['route'] as String) == currentRoute);
    _selectedIndex = foundIndex == -1 ? 0 : foundIndex;

    return WillPopScope(
      onWillPop: () async {
        if (currentRoute != '/guest') {
          context.go('/guest');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Welcome Guest')),
        endDrawer: const ProfileDrawer(),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.push('/login'),
            child: const Text('Login'),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          items: _navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item['icon'] as IconData?),
              label: item['label'] as String,
            );
          }).toList(),
        ),
      ),
    );
  }
}
