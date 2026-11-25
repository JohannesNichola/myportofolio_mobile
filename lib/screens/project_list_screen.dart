import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Daftar project dari backend. Dapat dilihat tanpa login.
class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = context.read<ApiClient>().getProjects();
  }

  /// Memuat ulang data; dipakai oleh tarik-untuk-refresh dan tombol Retry.
  Future<void> _refresh() async {
    final future = context.read<ApiClient>().getProjects();
    setState(() {
      _projects = future;
    });
    try {
      await future;
    } catch (_) {
      // Kesalahan ditampilkan oleh FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Project>>(
        future: _projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.paper,
                      ),
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final projects = snapshot.data!;
          if (projects.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: Text('No projects found.')),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  color: AppColors.paper,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: AppColors.line),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      project.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        Text(
                          '${project.categoryLabel} · ${project.period}',
                          style: const TextStyle(color: AppColors.accentDark),
                        ),
                        if (project.description.isNotEmpty) ...[
                          const SizedBox(height: 8.0),
                          Text(
                            project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailScreen(project: project),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
