import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  String? accessToken;
  String? refreshToken;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessKey);
    refreshToken = prefs.getString(_refreshKey);
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
    ]);
    if (results.any((ok) => !ok)) {
      throw StateError('토큰 삭제에 실패했습니다');
    }
    accessToken = null;
    refreshToken = null;
  }
}
