import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Drawer menu untuk berpindah antar halaman aplikasi.
/// Drawer yang sama dipakai di halaman utama dan semua halaman formulir.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  /// Satu opsi drawer yang mengganti halaman saat ini dengan [page].
  /// Jika [requiresLogin], pengguna diarahkan ke login lebih dulu.
  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
    bool requiresLogin = false,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      iconColor: AppColors.accentDark,
      onTap: () async {
        if (requiresLogin && !await ensureLoggedIn(context)) return;
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

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
            requiresLogin: true,
          ),
          const Divider(color: AppColors.line),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              iconColor: AppColors.accentDark,
              onTap: () async {
                Navigator.pop(context);
                await performLogout(context);
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              iconColor: AppColors.accentDark,
              onTap: () async {
                if (await ensureLoggedIn(context) && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
    );
  }
}
