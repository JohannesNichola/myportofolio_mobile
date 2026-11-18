import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_inputs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

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

  /// Memvalidasi form; jika lolos, tampilkan ringkasan lalu kosongkan form.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

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
                  const FormHeader(
                    kicker: 'Project',
                    title: 'Add New Project',
                  ),
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