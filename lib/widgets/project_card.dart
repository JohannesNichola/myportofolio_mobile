import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

/// Kartu tombol aksi; warna latar diambil dari [ItemHomepage.color].
/// Jika [ItemHomepage.page] terisi, kartu membuka halaman tersebut
/// (setelah login bila [ItemHomepage.requiresLogin]).
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _handleTap(BuildContext context) async {
    // Memunculkan SnackBar ketika diklik
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
      );

    final action = item.onTap;
    if (action != null) {
      await action(context);
      return;
    }

    final page = item.page;
    if (page == null) return;

    if (item.requiresLogin && !await ensureLoggedIn(context)) return;
    if (!context.mounted) return;

    // Navigate ke halaman yang sesuai
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const SizedBox(height: 3),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
