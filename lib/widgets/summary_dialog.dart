import 'package:material_ui/material_ui.dart';

/// Mengembalikan [value] yang sudah di-trim, atau `-` jika kosong.
String orDash(String value) {
  final text = value.trim();
  return text.isEmpty ? '-' : text;
}

/// Menampilkan ringkasan isian formulir dalam [AlertDialog].
/// Dialog ditutup dengan tombol OK, lalu pengguna kembali ke formulir.
Future<void> showSummaryDialog({
  required BuildContext context,
  required String title,
  required Map<String, String> data,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: entry.value),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
