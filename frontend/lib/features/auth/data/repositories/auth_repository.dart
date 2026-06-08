import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // For offline/mock development if Firebase is not configured yet
  static bool useMock = false;
  static UserModel? _mockUser;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 800));
      _mockUser = UserModel(
        uid: 'mock_uid_123',
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );
      return _mockUser;
    }

    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser != null) {
        final UserModel newUser = UserModel(
          uid: firebaseUser.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      // If Firebase app is not initialized or fails due to lack of config, fallback to mock automatically for demo
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        useMock = true;
        return signUp(email: email, password: password, name: name, role: role);
      }
      rethrow;
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (_mockUser != null && _mockUser!.email == email) {
        return _mockUser;
      }
      _mockUser = UserModel(
        uid: 'mock_uid_123',
        email: email,
        name: 'Demo User',
        role: UserRole.both,
        createdAt: DateTime.now(),
      );
      return _mockUser;
    }

    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser != null) {
        return await getUserProfile(firebaseUser.uid);
      }
      return null;
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        useMock = true;
        return signIn(email: email, password: password);
      }
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    if (useMock) {
      return _mockUser;
    }

    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (useMock) return _mockUser;
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (useMock) {
      _mockUser = null;
      return;
    }
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // Ignore
    }
  }

  Future<UserModel?> getCurrentUser() async {
    if (useMock) {
      return _mockUser;
    }
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        return await getUserProfile(firebaseUser.uid);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
