import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Kesalahan dari server atau jaringan; [message] siap ditampilkan ke pengguna.
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Klien HTTP untuk backend Django (`/api/v1/`).
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl/api/v1/$path');

  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Token $token',
  };

  Future<List<Project>> getProjects() async {
    final response = await _send(
      () => _client.get(_uri('projects/'), headers: _headers()),
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _send(
      () => _client.post(
        _uri('projects/'),
        headers: _headers(token: token),
        body: jsonEncode(project.toJson()),
      ),
    );
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  /// Menukar username dan password dengan token.
  Future<String> obtainToken(String username, String password) async {
    final response = await _send(
      () => _client.post(
        _uri('auth/token/'),
        headers: _headers(),
        body: jsonEncode({'username': username, 'password': password}),
      ),
    );
    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> logout({required String token}) async {
    await _send(
      () => _client.post(_uri('auth/logout/'), headers: _headers(token: token)),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      _ensureSuccess(response);
      return response;
    } on http.ClientException {
      throw const ApiException('Tidak dapat terhubung ke server.');
    }
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw ApiException(_messageFrom(response), statusCode: response.statusCode);
  }

  /// Mengambil pesan error DRF (`detail`, `non_field_errors`, atau per field).
  String _messageFrom(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map<String, dynamic>) {
        final parts = body.entries.map((entry) {
          final value = entry.value is List
              ? (entry.value as List).join(' ')
              : '${entry.value}';
          final plain =
              entry.key == 'detail' || entry.key == 'non_field_errors';
          return plain ? value : '${entry.key}: $value';
        });
        if (parts.isNotEmpty) return parts.join('\n');
      }
    } on FormatException {
      // Isi respons bukan JSON; pakai pesan bawaan di bawah.
    }
    return 'Permintaan gagal (${response.statusCode}).';
  }
}
