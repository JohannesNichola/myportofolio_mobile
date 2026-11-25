import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  test('login menyimpan token, logout selalu menghapusnya', () async {
    final api = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'abc'}), 200);
        }
        // Server menolak logout (token kedaluwarsa), status lokal tetap bersih.
        return http.Response(jsonEncode({'detail': 'Invalid token.'}), 401);
      }),
    );
    final auth = AuthState(api);
    var notified = 0;
    auth.addListener(() => notified++);

    expect(auth.isLoggedIn, isFalse);

    await auth.login('admin', 'secret');
    expect(auth.isLoggedIn, isTrue);
    expect(auth.token, 'abc');

    await auth.logout();
    expect(auth.isLoggedIn, isFalse);
    expect(notified, 2);
  });
}
