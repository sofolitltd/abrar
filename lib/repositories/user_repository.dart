import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not authenticated';

    final snapshot = await _db.collection('users').doc(user.uid).get();
    if (!snapshot.exists) throw 'User document not found';

    return UserModel.fromQuerySnapshot(snapshot.data()!);
  }
}
