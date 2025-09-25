import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A widget that displays [child] only if the logged-in user's email
/// exists in the `admin` collection.
class AdminWidget extends StatelessWidget {
  final Widget child;

  const AdminWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ✅ Not logged in → hide child
    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        // 🔄 Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        // ✅ Show child only if at least one matching admin doc exists
        final isAdmin = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
        return isAdmin ? child : const SizedBox.shrink();
      },
    );
  }
}
