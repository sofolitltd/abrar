import 'package:abrar/routes/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/models/user_model.dart';
import '/providers/notifiers/user_notifier.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final firebaseUser = snapshot.data;

        // ✅ Not logged in → show login button instantly
        if (firebaseUser == null) return _buildLoginPrompt(context);

        // ✅ Logged in → now watch provider for Firestore data
        final userAsync = ref.watch(userProvider);
        final userNotifier = ref.read(userProvider.notifier);

        return Scaffold(
          appBar: AppBar(title: const Text('Profile'), centerTitle: false),
          body: userAsync.when(
            data: (user) => _buildProfileContent(context, user, userNotifier),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(child: Text(err.toString())),
          ),
        );
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 64,
              backgroundColor: Colors.black12,
              child: Icon(Iconsax.personalcard, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Please login / Register first',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push(
                AppRoute.login.path,
                extra: AppRoute.profile.path,
              ),
              icon: const Icon(Iconsax.personalcard),
              label: const Text('Login / Register Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    UserModel user,
    UserNotifier notifier,
  ) {
    return ListView(
      children: [
        _buildProfileHeader(user),
        const SizedBox(height: 8),
        _buildSettingsSection(context),
        const SizedBox(height: 8),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _showSignOutDialog(context, notifier),
            child: const Text('Sign out'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(user.mobile),
                  Text(user.email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final List<Map<String, dynamic>> accountSettings = [
      {
        'title': 'My Orders',
        'subtitle': 'In-progress and Completed Products',
        'icon': Iconsax.bag,
        'route': AppRoute.orders.path,
      },
      {
        'title': 'My Address',
        'subtitle': 'Set shopping delivery address',
        'icon': Iconsax.home_wifi,
        'route': AppRoute.address.path,
      },
      {
        'title': 'My Cart',
        'subtitle': 'Manage cart products',
        'icon': Iconsax.shopping_bag,
        'route': AppRoute.cart.path,
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ...accountSettings.map(
            (setting) => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(left: 16, right: 10),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, setting['route']),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  setting['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(setting['subtitle']),
                leading: Icon(
                  setting['icon'],
                  size: 24,
                  color: Colors.blueAccent,
                ),
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, UserNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
            ),
            onPressed: () async {
              await notifier.signOut();
              context.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
