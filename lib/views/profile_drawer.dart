import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider).valueOrNull;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.phoneNumber ?? 'No phone number'),
            currentAccountPicture: CircleAvatar(
              child: Text(user?.phoneNumber?.substring(0, 1) ?? 'U'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Settings'),
            onTap: () {
              // TODO: Navigate to profile settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
                context.go('/guest');
              }
            },
          ),
        ],
      ),
    );
  }
}