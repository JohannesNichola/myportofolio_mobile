import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_inputs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Halaman form untuk menambahkan Project (field mengikuti model Django).
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Pilihan kategori mengikuti PROJECT_CATEGORIES pada model Django.
  static const String _defaultCategory = 'academic';
  static const Map<String, String> _categories = {
    'academic': 'Academic',
    'professional': 'Professional',
    'personal': 'Personal',
  };

  String _title = '';
  String _description = '';
  String _category = _defaultCategory;
  DateTime? _startedAt;
  DateTime? _endedAt;

  bool _isSaving = false;

  /// Memvalidasi form, mengirim project ke backend dengan token, lalu
  /// menampilkan ringkasan jika berhasil (201).
  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);

    // Jaga-jaga jika pengguna sudah logout saat halaman ini terbuka.
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    setState(() {
      _isSaving = true;
    });
    try {
      await api.createProject(
        Project(
          title: _title.trim(),
          description: _description.trim(),
          category: _category,
          startedAt: formatDate(_startedAt!),
          endedAt: _endedAt == null ? null : formatDate(_endedAt!),
        ),
        token: auth.token!,
      );
      if (!mounted) return;

      await showSummaryDialog(
        context: context,
        title: 'Project berhasil ditambahkan!',
        data: {
          'Title': _title.trim(),
          'Description': orDash(_description),
          'Category': _categories[_category]!,
          'Start Date': formatDate(_startedAt!),
          'End Date': _endedAt == null ? 'Ongoing' : formatDate(_endedAt!),
        },
      );
      if (!mounted) return;
      _resetForm();
    } on ApiException catch (e) {
      messenger.hideCurrentSnackBar();
      if (e.statusCode == 401) {
        // Token ditolak: keluarkan pengguna dan minta login ulang.
        await auth.logout();
        messenger.showSnackBar(
          const SnackBar(content: Text('Sesi berakhir. Silakan login lagi.')),
        );
      } else {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _description = '';
      _category = _defaultCategory;
      _startedAt = null;
      _endedAt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormHeader(kicker: 'Project', title: 'Add New Project'),
                  FormTextField(
                    label: 'Project Title',
                    hint: 'Portfolio Website',
                    onChanged: (value) => _title = value,
                    validator: (value) =>
                        Validators.requiredText(value, 'Judul proyek'),
                  ),
                  FormTextField(
                    label: 'Project Description (optional)',
                    hint: 'Tell me about your project',
                    maxLines: 4,
                    onChanged: (value) => _description = value,
                  ),
                  FormDropdown(
                    label: 'Project Category',
                    options: _categories,
                    initialValue: _defaultCategory,
                    onChanged: (value) => _category = value,
                  ),
                  FormDateField(
                    label: 'Start Date',
                    onChanged: (date) => _startedAt = date,
                    validator: (date) =>
                        Validators.requiredDate(date, 'Tanggal mulai'),
                  ),
                  FormDateField(
                    label: 'End Date (optional)',
                    clearable: true,
                    onChanged: (date) => _endedAt = date,
                    validator: (date) => Validators.endDate(date, _startedAt),
                  ),
                  FormSaveButton(onPressed: _save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
