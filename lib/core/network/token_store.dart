import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _roleKey = 'user_role';
  static const _nameKey = 'user_name';

  String? accessToken;
  String? refreshToken;
  String? role;
  String? name;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessKey);
    refreshToken = prefs.getString(_refreshKey);
    role = prefs.getString(_roleKey);
    name = prefs.getString(_nameKey);
  }

  Future<void> setProfile({String? role, String? name}) async {
    this.role = role;
    this.name = name;
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      role == null ? prefs.remove(_roleKey) : prefs.setString(_roleKey, role),
      name == null ? prefs.remove(_nameKey) : prefs.setString(_nameKey, name),
    ]);
  }

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    final results = await Future.wait([
      prefs.setString(_accessKey, accessToken),
      prefs.setString(_refreshKey, refreshToken),
    ]);
    if (results.any((ok) => !ok)) {
      throw StateError('토큰 저장에 실패했습니다');
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final results = await Future.wait([
      prefs.remove(_accessKey),
      prefs.remove(_refreshKey),
      prefs.remove(_roleKey),
      prefs.remove(_nameKey),
    ]);
    if (results.any((ok) => !ok)) {
      throw StateError('토큰 삭제에 실패했습니다');
    }
    accessToken = null;
    refreshToken = null;
    role = null;
    name = null;
  }
}
