import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/widgets/form_inputs.dart';

/// Detail satu project; gambar hanya tampil jika server mengirim `images`.
class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  Widget _attribute(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.accentDark,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = [...project.images]
      ..sort((a, b) => a.order.compareTo(b.order));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeader(kicker: project.categoryLabel, title: project.title),
                _attribute('Period', project.period),
                _attribute(
                  'Description',
                  project.description.isEmpty ? '-' : project.description,
                ),
                for (final image in images)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        image.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
