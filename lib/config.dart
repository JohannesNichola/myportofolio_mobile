/// Alamat dasar backend Django (tanpa garis miring di akhir).
/// Ubah saat build dengan: --dart-define=API_BASE_URL=https://...
/// 10.0.2.2 adalah alamat localhost komputer jika dilihat dari emulator Android.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);