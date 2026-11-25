import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Status login aplikasi. Token hanya disimpan di memori.
class AuthState extends ChangeNotifier {
  AuthState(this._api);

  final ApiClient _api;
  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;
  bool get isLoggedIn => _token != null;

  /// Melempar [ApiException] jika kredensial salah atau server tidak terjangkau.
  Future<void> login(String username, String password) async {
    final token = await _api.obtainToken(username, password);
    _token = token;
    _username = username;
    notifyListeners();
  }

  /// Selalu menghapus token lokal, walaupun server menolak permintaan logout
  Future<void> logout() async {
    final token = _token;
    try {
      if (token != null) {
        await _api.logout(token: token);
      }
    } on ApiException {
      // Token mungkin sudah tidak valid di server; tetap keluar secara lokal.
    } finally {
      _token = null;
      _username = null;
      notifyListeners();
    }
  }
}
