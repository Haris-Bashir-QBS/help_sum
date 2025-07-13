import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/response/user_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static const _userKey = 'current_user';
  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refresh_token';

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ======================================= User ======================================
  Future<bool> saveUser(UserModel user) async {
    return await _prefs.setString(_userKey, json.encode(user.toJson()));
  }

  UserModel? get user {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<bool> clearUser() async {
    if (_prefs.containsKey(_userKey)) {
      return await _prefs.remove(_userKey);
    } else {
      return false;
    }
  }

  bool get hasUser => _prefs.containsKey(_userKey);

  /// ======================================= Tokens ======================================
  String? getAccessToken() {
    return _prefs.getString(_accessToken);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshToken);
  }

  Future<void> saveAccessAndRefreshTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessToken, accessToken);
    await _prefs.setString(_refreshToken, refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _prefs.setString(_accessToken, accessToken);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessToken);
    await _prefs.remove(_refreshToken);
  }

  Future<void> clearAccessToken() async {
    await _prefs.remove(_accessToken);
  }

  Future<bool> updateUser(UserModel newUser) async => saveUser(newUser);

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
