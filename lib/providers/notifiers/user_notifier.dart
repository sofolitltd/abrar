import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/user_model.dart';
import '/repositories/user_repository.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, UserModel>(
  () => UserNotifier(),
);

class UserNotifier extends AsyncNotifier<UserModel> {
  final UserRepository _repo = UserRepository();

  @override
  Future<UserModel> build() async {
    // Called automatically when provider is first watched
    return fetchUser();
  }

  Future<UserModel> fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not authenticated';

    try {
      state = const AsyncValue.loading();
      final fetchedUser = await _repo.getUser();
      state = AsyncValue.data(fetchedUser);
      return fetchedUser;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = AsyncValue.data(UserModel.empty());
  }
}
