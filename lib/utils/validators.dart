class Validators {
  Validators._();

  /// Batas panjang `CharField` pada model Django (`max_length=255`).
  static const int maxLength = 255;

  /// Menolak isian kosong atau hanya berisi spasi.
  static String? notBlank(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    return null;
  }

  /// Seperti [notBlank], tetapi juga menolak isian lebih dari [maxLength] karakter.
  static String? requiredText(String? value, String fieldName) {
    final error = notBlank(value, fieldName);
    if (error != null) return error;
    if (value!.trim().length > maxLength) {
      return '$fieldName maksimal $maxLength karakter!';
    }
    return null;
  }

  /// URL bersifat opsional: kosong diperbolehkan, tetapi jika diisi harus
  /// berupa URL http/https yang valid.
  static String? optionalUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    final isValid = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return isValid
        ? null
        : 'Masukkan URL yang valid (diawali http:// atau https://)';
  }

  /// Tanggal wajib dipilih.
  static String? requiredDate(DateTime? value, String fieldName) {
    return value == null ? '$fieldName wajib dipilih!' : null;
  }

  /// Tanggal selesai bersifat opsional, tetapi tidak boleh sebelum tanggal mulai.
  static String? endDate(DateTime? end, DateTime? start) {
    if (end != null && start != null && end.isBefore(start)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }
}