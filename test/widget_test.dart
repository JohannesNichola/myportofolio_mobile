import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

void main() {
  void useLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('menampilkan identitas dan semua tombol aksi', (tester) async {
    useLargeScreen(tester);
    await tester.pumpWidget(const MyApp());

    expect(find.text('2406495930'), findsOneWidget);
    expect(find.text('Johannes Nichola Simatupang'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);

    for (final name in [
      'Experience',
      'Education',
      'Project',
      'Add Project',
      'Logout',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('menampilkan SnackBar saat tombol ditekan', (tester) async {
    useLargeScreen(tester);
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Experience'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Experience!'),
      findsOneWidget,
    );
  });

  testWidgets('membuka halaman form saat Add Project ditekan',
      (tester) async {
    useLargeScreen(tester);
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
  });

  test('setiap tombol aksi punya warna yang berbeda', () {
    final colors = MyHomePage().items.map((item) => item.color).toSet();
    expect(colors.length, MyHomePage().items.length);
  });
}