import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

/// Halaman utama aplikasi MyPortfolio Mobile.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2406495930";
  final String nama = "Johannes Nichola Simatupang";
  final String kelas = "PBP C";

  final List<ItemHomepage> items = [
    ItemHomepage("Experience", Icons.work, AppColors.experience),
    ItemHomepage("Education", Icons.school, AppColors.education),
    ItemHomepage(
      "Project",
      Icons.folder,
      AppColors.project,
      page: const ProjectListScreen(),
    ),
    ItemHomepage(
      "Add Experience",
      Icons.add_circle,
      AppColors.addExperience,
      page: const ExperienceFormPage(),
    ),
    ItemHomepage(
      "Add Education",
      Icons.add_circle,
      AppColors.addEducation,
      page: const EducationFormPage(),
    ),
    ItemHomepage(
      "Add Project",
      Icons.add_circle,
      AppColors.addProject,
      page: const ProjectFormPage(),
      requiresLogin: true,
    ),
    ItemHomepage(
      "Logout",
      Icons.logout,
      AppColors.logout,
      onTap: performLogout,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoCard(title: 'NPM', content: npm),
                  InfoCard(title: 'Name', content: nama),
                  InfoCard(title: 'Class', content: kelas),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Center(
              child: Text(
                'Selamat datang di MyPortfolio Mobile!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: AppColors.accentDark,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: items
                    .map((ItemHomepage item) => ItemCard(item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu informasi profil (NPM, nama, kelas).
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.ink,
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.line,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.paper),
            ),
          ],
        ),
      ),
    );
  }
}

/// Model data untuk satu kartu aksi di halaman utama.
/// [page] bersifat opsional: jika diisi, kartu membuka halaman tersebut.
/// [requiresLogin] mewajibkan login sebelum [page] dibuka.
/// [onTap] bersifat opsional: aksi khusus (mis. Logout) yang menggantikan navigasi.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final Widget? page;
  final bool requiresLogin;
  final Future<void> Function(BuildContext context)? onTap;

  ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.page,
    this.requiresLogin = false,
    this.onTap,
  });
}
