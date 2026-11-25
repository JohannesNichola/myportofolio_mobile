import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Mengembalikan `true` jika pengguna sudah login. Jika belum, membuka
/// [LoginScreen] dan mengembalikan hasilnya (`false` jika dibatalkan).
/// Pemanggil wajib mengecek `context.mounted` setelah `await`.
Future<bool> ensureLoggedIn(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (auth.isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return loggedIn ?? false;
}

/// Logout dari kartu Logout maupun drawer; memberi umpan balik lewat SnackBar.
Future<void> performLogout(BuildContext context) async {
  final auth = context.read<AuthState>();
  final messenger = ScaffoldMessenger.of(context);
  final wasLoggedIn = auth.isLoggedIn;

  messenger.hideCurrentSnackBar();
  if (!wasLoggedIn) {
    messenger.showSnackBar(const SnackBar(content: Text('Kamu belum login.')));
    return;
  }

  await auth.logout();
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(content: Text('Berhasil logout.')));
}
