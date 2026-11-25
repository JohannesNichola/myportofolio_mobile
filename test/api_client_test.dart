import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  ApiClient clientWith(MockClientHandler handler) =>
      ApiClient(client: MockClient(handler), baseUrl: 'http://test');

  test('getProjects mengurai daftar project', () async {
    final api = clientWith((request) async {
      expect(request.url.toString(), 'http://test/api/v1/projects/');
      return http.Response(
        jsonEncode([
          {
            'id': 'abc',
            'title': 'Portfolio',
            'description': '',
            'category': 'academic',
            'category_display': 'Academic',
            'started_at': 'November 2026',
            'ended_at': null,
            'is_ongoing': true,
            'images': [
              {'url': 'https://x.test/a.png', 'order': 0},
            ],
          },
        ]),
        200,
      );
    });

    final projects = await api.getProjects();

    expect(projects.single.title, 'Portfolio');
    expect(projects.single.isOngoing, isTrue);
    expect(projects.single.images.single.url, 'https://x.test/a.png');
  });

  test(
    'createProject mengirim token dan hanya field yang boleh ditulis',
    () async {
      final api = clientWith((request) async {
        expect(request.headers['Authorization'], 'Token abc');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body.keys, containsAll(['title', 'category', 'started_at']));
        expect(body.containsKey('is_ongoing'), isFalse);
        return http.Response(
          jsonEncode({
            'id': 'x',
            'title': 'T',
            'description': '',
            'category': 'personal',
            'started_at': 'Januari 2026',
            'ended_at': null,
          }),
          201,
        );
      });

      final created = await api.createProject(
        const Project(
          title: 'T',
          category: 'personal',
          startedAt: '2026-01-01',
        ),
        token: 'abc',
      );

      expect(created.id, 'x');
    },
  );

  test('respons 401 menjadi ApiException berisi pesan server', () async {
    final api = clientWith(
      (request) async =>
          http.Response(jsonEncode({'detail': 'Invalid token.'}), 401),
    );

    expect(
      api.logout(token: 'bad'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.message, 'message', 'Invalid token.'),
      ),
    );
  });

  test('obtainToken mengembalikan token', () async {
    final api = clientWith(
      (request) async => http.Response(jsonEncode({'token': 'abc'}), 200),
    );

    expect(await api.obtainToken('admin', 'secret'), 'abc');
  });
}
