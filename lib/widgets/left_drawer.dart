import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

/// Drawer menu untuk berpindah antar halaman aplikasi.
/// Drawer yang sama dipakai di halaman utama dan semua halaman formulir.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  /// Satu opsi drawer yang mengganti halaman saat ini dengan [page].
  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      iconColor: AppColors.accentDark,
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.paper,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.accent),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.paper,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: AppColors.paper),
                  ),
                ],
              ),
            ),
          ),
          _buildItem(
            context,
            icon: Icons.home_outlined,
            title: 'Home',
            page: MyHomePage(),
          ),
          _buildItem(
            context,
            icon: Icons.folder_outlined,
            title: 'Projects',
            page: const ProjectListScreen(),
          ),
          const Divider(color: AppColors.line),
          _buildItem(
            context,
            icon: Icons.add_circle_outline,
            title: 'Add Experience',
            page: const ExperienceFormPage(),
          ),
          _buildItem(
            context,
            icon: Icons.add_circle_outline,
            title: 'Add Education',
            page: const EducationFormPage(),
          ),
          _buildItem(
            context,
            icon: Icons.add_circle_outline,
            title: 'Add Project',
            page: const ProjectFormPage(),
          ),
        ],
      ),
    );
  }
}
