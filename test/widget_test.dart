import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  /// Menjalankan aplikasi di layar besar dengan server palsu.
  Future<void> pumpApp(WidgetTester tester, {MockClientHandler? handler}) {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final client = MockClient(
      handler ?? (request) async => http.Response('[]', 200),
    );
    return tester.pumpWidget(MyApp(apiClient: ApiClient(client: client)));
  }

  testWidgets('menampilkan identitas dan semua kartu aksi', (tester) async {
    await pumpApp(tester);

    expect(find.text('2406495930'), findsOneWidget);
    expect(find.text('Johannes Nichola Simatupang'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);

    for (final name in [
      'Experience',
      'Education',
      'Project',
      'Add Experience',
      'Add Education',
      'Add Project',
      'Logout',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('menampilkan SnackBar saat kartu ditekan', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Experience'));
    await tester.pump();

    expect(find.text('Kamu telah menekan tombol Experience!'), findsOneWidget);
  });

  // Setiap kartu Add membuka formulir yang sesuai.
  const forms = {
    'Add Experience': 'Add New Experience',
    'Add Education': 'Add New Education',
    'Add Project': 'Add New Project',
  };
  forms.forEach((card, header) {
    testWidgets('kartu $card membuka formulir yang sesuai', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text(card));
      await tester.pumpAndSettle();

      expect(find.text(header), findsOneWidget);
    });
  });

  testWidgets('menampilkan pesan error saat Simpan dengan input kosong', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('Judul pengalaman tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Nama perusahaan tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai wajib dipilih!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('drawer membuka formulir dan Home kembali ke halaman utama', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Add Education'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add New Education'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(Drawer), matching: find.text('Home')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  test('setiap kartu aksi punya warna yang berbeda', () {
    final colors = MyHomePage().items.map((item) => item.color).toSet();
    expect(colors.length, MyHomePage().items.length);
  });
}
