import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/response/user_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static const _userKey = 'current_user';
  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refresh_token';
  static const _fcmToken = 'fcm_token';
  static const _seenFcmIds = 'seen_fcm_message_ids';
  static const _seenFcmIdsMap = 'seen_fcm_message_ids_map';

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

  /// ======================================= FCM Token ======================================
  String? getFcmToken() {
    return _prefs.getString(_fcmToken);
  }

  Future<void> saveFcmToken(String token) async {
    await _prefs.setString(_fcmToken, token);
  }

  Future<void> clearFcmToken() async {
    await _prefs.remove(_fcmToken);
  }

  /// ======================================= Notifications (Legacy list) ======================================
  Future<List<String>> getSeenFcmMessageIds() async {
    return _prefs.getStringList(_seenFcmIds) ?? <String>[];
  }

  Future<bool> hasSeenFcmMessageId(String id) async {
    final list = _prefs.getStringList(_seenFcmIds) ?? <String>[];
    return list.contains(id);
  }

  Future<void> addSeenFcmMessageId(String id, {int max = 200}) async {
    final List<String> list = _prefs.getStringList(_seenFcmIds) ?? <String>[];
    if (!list.contains(id)) {
      list.add(id);
    }
    if (list.length > max) {
      list.removeRange(0, list.length - max);
    }
    await _prefs.setStringList(_seenFcmIds, list);
  }

  /// ======================================= Notifications (Timestamped map) ======================================
  Future<Map<String, int>> getSeenFcmIdsWithTimestamps() async {
    final String? jsonStr = _prefs.getString(_seenFcmIdsMap);
    if (jsonStr == null || jsonStr.isEmpty) return <String, int>{};
    final Map<String, dynamic> raw =
        json.decode(jsonStr) as Map<String, dynamic>;
    return raw.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  Future<void> saveSeenFcmIdsWithTimestamps(Map<String, int> map) async {
    await _prefs.setString(_seenFcmIdsMap, json.encode(map));
  }

  Future<void> migrateLegacySeenIdsToTimestamps() async {
    final legacy = _prefs.getStringList(_seenFcmIds);
    if (legacy == null || legacy.isEmpty) return;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final existing = await getSeenFcmIdsWithTimestamps();
    for (final id in legacy) {
      existing[id] = nowMs;
    }
    await saveSeenFcmIdsWithTimestamps(existing);
    // Optionally clear legacy list to avoid duplication
    // await _prefs.remove(_seenFcmIds);
  }
}
