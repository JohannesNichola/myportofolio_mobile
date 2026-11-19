Nama : Johannes Nichola Simatupang

NPM : 2406495930

Kelas : PBP C

# My Portfolio Mobile

## Deskripsi Proyek
Aplikasi mobile portofolio pribadi berbasis Flutter yang dikembangkan sebagai proyek individu mata kuliah Pemrograman Berbasis Platform (PBP). Aplikasi ini adalah pendamping dari website portofolio Django saya (repositori terpisah: `myportofolio`).

## Cara Menjalankan Proyek
1. Pasang Flutter SDK (Dart SDK sudah ikut di dalamnya) dan pastikan `flutter --version` berjalan di terminal.
2. Clone repository `git clone https://github.com/JohannesNichola/myportofolio_mobile.git`
3. Masuk ke folder proyek `cd myportofolio_mobile`
4. Unduh dependensi `flutter pub get`
5. Jalankan aplikasi di Google Chrome `flutter run -d chrome`

## Progres Mingguan

### Tutorial 8

- Memasang Flutter SDK dan memverifikasi instalasi, lalu membuat proyek `myportofolio_mobile` pada repositori terpisah dan menjalankannya di Google Chrome.
- Memisahkan halaman menu ke `lib/menu.dart` dan mengubah `MyHomePage` menjadi `StatelessWidget`.
- Membuat widget `InfoCard` dan `ItemCard` beserta model `ItemHomepage`, dengan `SnackBar` ketika kartu ditekan.

### Tugas 7

- Menyesuaikan aplikasi dengan portofolio saya: `InfoCard` berisi data diri sendiri dan empat tombol aksi (Experience, Education, Project, Logout) dengan ikon dan warna berbeda lewat atribut `color` pada `ItemHomepage`.
- Menerapkan palet warna website Django ke tema aplikasi lewat `lib/palette.dart`.
- Menulis widget test dan memastikan `flutter analyze` bersih.
- Mengerjakan setiap perubahan pada branch terpisah dengan conventional commits, lalu menggabungkannya ke `main`.

### Tutorial 9

- Memigrasikan impor Material ke paket standalone `material_ui` sesuai petunjuk tutorial.
- Membuat `LeftDrawer` sebagai menu navigasi antarhalaman (Home dan Add Project) dengan `Navigator`.
- Membuat halaman `ProjectFormPage` berisi `Form` dan elemen input dengan validasi, serta dialog yang menampilkan data yang diisi.
- Menambahkan navigasi dari tombol Tambah Project ke halaman form.
- Merapikan struktur proyek ke direktori `lib/screens` dan `lib/widgets`.
- Mengerjakan setiap perubahan pada branch terpisah dengan conventional commits, lalu menggabungkannya ke `main`.

### Tugas 8

- Membuat halaman form Experience, Education, dan Project di `lib/screens` dengan `Form`, `GlobalKey<FormState>`, dan elemen input yang field serta aturan validasinya mengikuti model pada website Django.
- Membuat komponen input, validator, dan dialog ringkasan yang dipakai bersama oleh ketiga form.
- Menambahkan kartu aksi di halaman utama dan opsi pada `LeftDrawer` untuk membuka setiap form.
- Menyesuaikan tampilan halaman utama agar kartu informasi sama tinggi dan grid tidak menempel pada judul saat di-scroll.
- Memperbarui widget test dan memastikan `flutter analyze` bersih.

## Pertanyaan Reflektif

### Tugas 7

1. Widget tree adalah struktur pohon dari seluruh widget yang menyusun tampilan aplikasi Flutter, karena di Flutter hampir semuanya adalah widget, termasuk tata letak, teks, dan tema. Setiap widget berada di dalam widget lain sebagai parent, dan widget yang ada di dalamnya disebut child. Sebagian widget hanya punya satu child (seperti `Padding` atau `Center`), sedangkan yang lain punya banyak children (seperti `Column`, `Row`, dan `GridView`). Hubungan parent-child ini menentukan cara layout bekerja: parent memberikan batasan ukuran (constraints) ke bawah kepada child, child memilih ukurannya sendiri dalam batasan tersebut dan melaporkannya ke atas, lalu parent menentukan posisi child. 

2. Widget yang saya gunakan dalam proyek ini:
   - `MaterialApp`: widget root yang menyediakan tema, judul, dan halaman awal (`home`).
   - `Scaffold`: kerangka halaman Material yang menyediakan `appBar` dan `body`.
   - `AppBar`: bilah judul di bagian atas halaman.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column` dan `Row`: menyusun child secara vertikal dan horizontal.
   - `SizedBox`: memberi ruang kosong dengan ukuran tertentu.
   - `Center`: menempatkan child di tengah.
   - `Expanded`: membuat child mengisi sisa ruang yang tersedia pada `Column`.
   - `GridView.count`: menyusun kartu aksi dalam grid tiga kolom yang dapat di-scroll.
   - `Card` dan `Container`: membentuk kartu informasi dengan bayangan, lebar, dan padding (dipakai `InfoCard`) serta pembungkus isi `ItemCard`.
   - `Material` dan `InkWell`: memberi warna latar, sudut membulat, dan efek sentuhan pada `ItemCard`, serta menangani `onTap`.
   - `Icon` dan `Text`: menampilkan ikon dan teks.
   - `SnackBar`: pesan singkat di bagian bawah layar yang ditampilkan lewat `ScaffoldMessenger`.
   - Widget buatan sendiri: `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`, yang dibuat agar tampilan dapat dipakai ulang.

3. `MaterialApp` adalah widget yang membungkus aplikasi dengan fondasi Material Design. Widget ini menyediakan tema, judul aplikasi, halaman awal (`home`), `Navigator` untuk perpindahan halaman beserta routes-nya, `ScaffoldMessenger` untuk `SnackBar`, serta dukungan lokalisasi. Widget Material seperti `Scaffold`, `AppBar`, dan `SnackBar` bergantung pada hal-hal tersebut. Karena itu `MaterialApp` umumnya dipakai sebagai root, sehingga seluruh widget di bawahnya otomatis mendapat tema dan layanan yang sama tanpa perlu mengaturnya satu per satu. Tanpa `MaterialApp`, widget Material akan gagal mencari ancestor yang dibutuhkan dan memunculkan error.

4. `StatelessWidget` tidak menyimpan state yang berubah, sehingga tampilannya hanya ditentukan oleh data yang diterimanya lewat konstruktor dan akan sama selama data itu tidak berubah. `StatefulWidget` punya objek `State` terpisah yang menyimpan data yang dapat berubah selama aplikasi berjalan, dan tampilannya dibangun ulang ketika `setState()` dipanggil. Saya memilih `StatelessWidget` untuk `MyHomePage`, `InfoCard`, dan `ItemCard` karena isinya statis (identitas dan daftar tombol tetap) dan `SnackBar` dikelola oleh `ScaffoldMessenger`, bukan oleh state saya sendiri. `StatefulWidget` dipilih ketika tampilan harus berubah mengikuti data internal, misalnya penghitung, isian form, checkbox yang dicentang, animasi, atau daftar yang dimuat dari API dengan status loading. 

5. `BuildContext` adalah referensi ke posisi sebuah widget di dalam widget tree. Karena sebuah widget tidak mengetahui parent-nya secara langsung, `BuildContext` dipakai untuk mencari ancestor ke atas pohon, misalnya `Theme.of(context)`, `MediaQuery.of(context)`, `Navigator.of(context)`, dan `ScaffoldMessenger.of(context)`. Di dalam metode `build(BuildContext context)`, `context` adalah posisi widget itu sendiri, sehingga pencarian dimulai dari titik tersebut ke atas. Pada proyek saya, `InfoCard` memakai `MediaQuery.of(context).size.width / 3.5` untuk menentukan lebar kartu sesuai lebar layar, dan `ItemCard` memakai `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar`. Hal ini berhasil karena `context` tersebut berada di bawah `MaterialApp` dan `Scaffold`. 

6. Hot reload menyuntikkan kode terbaru ke aplikasi yang sedang berjalan lalu membangun ulang widget tree, sehingga perubahan tampilan terlihat dalam hitungan detik dan state yang ada tetap dipertahankan. Hot restart memuat ulang seluruh kode dan menjalankan `main()` dari awal, sehingga semua state kembali ke kondisi awal, dan prosesnya sedikit lebih lama daripada hot reload. Hot reload tidak cukup, dan kita harus melakukan hot restart atau full restart ketika perubahan pada `main()`, variabel global atau static, atau nilai awal yang hanya dihitung sekali (misalnya isi `initState`), perubahan struktur seperti mengubah enum atau mengubah `StatelessWidget` menjadi `StatefulWidget`, serta perubahan pada `pubspec.yaml` (dependensi atau aset). Untuk perubahan pada kode native (folder `android/` dan `ios/`, `AndroidManifest.xml`, atau `Info.plist`) dan penambahan plugin yang memakai kode native, kita harus melakukan full restart.

### Tugas 8

1. `Navigator.push()` menambahkan route baru di atas stack sehingga halaman sebelumnya tetap ada dan bisa dikembalikan. `Navigator.pushReplacement()` mengganti route teratas dengan route baru sehingga halaman lama hilang dari stack. `Navigator.pop()` membuang route teratas dan kembali ke route di bawahnya, misalnya untuk menutup `AlertDialog`. Untuk kartu aksi saya memakai `push()` agar pengguna bisa kembali ke halaman utama. Opsi Home pada drawer memakai `pushReplacement()` dengan `MyHomePage()`, sehingga halaman form diganti dan stack tidak menumpuk setiap kali berpindah lewat drawer.

2. `Scaffold` memberi kerangka tetap berisi `AppBar`, `drawer`, dan `body` pada setiap halaman (halaman utama dan ketiga form), dengan satu `LeftDrawer` yang sama, sehingga letak judul dan menu navigasi selalu konsisten dan pengguna tidak perlu beradaptasi ulang. Konsistensi warna dijaga melalui `AppColors` di `lib/palette.dart`, yang nilainya saya ambil dari variabel CSS website. Contohnya `AppColors.paper` dan `AppColors.ink` untuk latar dan teks, `AppColors.line` untuk garis bawah `AppBar`, serta `AppColors.accent` untuk tombol Simpan dan garis tepi field, yang dipakai di halaman utama maupun ketiga form.

3. Tata letak form saya pilih dengan kerangka `Scaffold` yang sama seperti halaman utama (`AppBar`, `LeftDrawer`, dan `body` berupa `Form`) agar konsisten dan mudah berpindah halaman. Isinya satu kolom vertikal dengan lebar maksimal 640 piksel yang berisi `TextFormField`, dropdown, pemilih tanggal, dan tombol Simpan sesuai urutan pengisian, karena paling mudah diisi dari atas ke bawah di ponsel maupun layar lebar. `Padding` dan `SizedBox` memberi jarak antar elemen agar tidak rapat dan mudah disentuh. Ketika ruang layar terbatas, `SingleChildScrollView` membuat seluruh isi bisa di-scroll karena `Column` tidak bisa di-scroll sendiri, sehingga field di bawah dan tombol Simpan tetap terjangkau dan tidak overflow.

4. `GlobalKey<FormState>` dipasang pada `Form` agar tombol Simpan, yang berada di luar field, bisa mengakses `FormState` lewat `_formKey.currentState`. `validator` pada tiap field mengembalikan pesan error jika input tidak sesuai aturan, atau `null` jika valid. `validate()` menjalankan semua validator sekaligus, menampilkan pesan di kolom terkait, dan mengembalikan `true` hanya jika semuanya valid, sehingga dialog ringkasan hanya muncul pada kondisi itu. Contoh nilai yang ditolak adalah judul yang hanya berisi spasi, field thumbnail yang hanya berisi nilai `abc` atau invalid URL, dan tanggal selesai yang lebih dahulu (secara tanggal) dari tanggal mulai. Jenis input atau papan ketik saja tidak cukup, karena `TextInputType.url` hanya mengubah susunan keyboard dan tidak mencegah teks yang ditempel. Pemilih tanggal juga tidak bisa memeriksa hubungan antarfield dan batas 255 karakter seperti pada model Django.

## AI Disclosure

### Tugas 7

Dalam pengerjaan tugas ini, saya menggunakan GenAI Claude untuk menyesuaikan project myportofolio_mobile dengan project myportofolio saya sebelumnya. Saya menyesuaikan agar menu aksi, atribut `color`, dan palet warna pada myportofolio_mobile dapat sesuai dengan yang ada pada project myportofolio. Selain itu, GenAI membantu saya dalam membuat widget test, menyusun alur branch dan commit, serta memperdalam pemahaman saya tentang dasar Flutter seperti widget tree, `StatelessWidget` dan `StatefulWidget`, `BuildContext`, dan hot reload. Meskipun demikian, saya sendiri yang menjalankan `flutter analyze`, `flutter test`, dan `flutter run` untuk tetap memastikan program berjalan dengan baik. Saya pun cek program perbaris dan melakukan perubahan agar tampilan sesuai dengan keinginan saya.

### Tugas 8

Dalam pengerjaan tugas ini, saya menggunakan GenAI Claude untuk menyesuaikan form Experience, Education, dan Project dengan model pada project myportofolio, yaitu field, pilihan kategori, dan aturan validasinya. GenAI juga membantu saya memisahkan komponen form agar kode tidak berulang, menyusun alur branch dan commit, serta memperdalam pemahaman saya tentang `Navigator`, `Form`, dan validasi. Meskipun demikian, saya sendiri yang menjalankan `flutter analyze`, `flutter test`, dan `flutter run`, lalu menguji semua form, validasi, dan navigasi secara manual di Chrome. Saya pun cek program perbaris, memperbaiki error overflow pada header drawer yang muncul saat tes, dan menyesuaikan tampilan halaman utama sesuai keinginan saya.