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

  static const List<Map<String, dynamic>> _navItems = [
    {'label': 'Guest Home', 'icon': Icons.home, 'route': '/guest'},
    {'label': 'Feed', 'icon': Icons.feed, 'route': '/feed'},
    {'label': 'Profile', 'icon': Icons.person, 'route': 'profile'},
  ];

  void _onItemTapped(int index, BuildContext context) {
    if (_navItems[index]['route'] == 'profile') {
      Scaffold.of(context).openEndDrawer();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    context.push(_navItems[index]['route']);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    _selectedIndex = _navItems.indexWhere((item) => item['route'] == currentRoute);
    if (_selectedIndex == -1) _selectedIndex = 0;

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
          items: _navItems
              .map((item) => BottomNavigationBarItem(
                    icon: Icon(item['icon']),
                    label: item['label'],
                  ))
              .toList(),
        ),
      ),
    );
  }
}