import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = true;

  AuthController() {
    // Initial demo user: Day 16 as referenced in project.md ("Bugün 16. gününüz")
    _currentUser = UserModel(
      id: 'user_1',
      name: 'Deniz Yılmaz',
      email: 'deniz@habipet.app',
      joinedDate: DateTime.now().subtract(const Duration(days: 15)),
      isGuest: false,
    );
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated && _currentUser != null;

  void login(String email, String password, {String? name}) {
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? (email.split('@').first),
      email: email,
      joinedDate: DateTime.now().subtract(const Duration(days: 15)),
      isGuest: false,
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  void loginAsGuest() {
    _currentUser = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Doğa Dostu',
      email: 'misafir@habipet.app',
      joinedDate: DateTime.now().subtract(const Duration(days: 15)),
      isGuest: true,
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  void updateName(String newName) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: newName);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
