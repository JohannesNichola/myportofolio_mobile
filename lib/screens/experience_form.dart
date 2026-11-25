import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_inputs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman form untuk menambahkan Experience (field mengikuti model Django).
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Pilihan kategori mengikuti EXPERIENCE_CHOICES pada model Django.
  static const String _defaultCategory = 'full-time';
  static const Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  String _title = '';
  String _company = '';
  String _description = '';
  String _category = _defaultCategory;
  String _thumbnail = '';
  DateTime? _startedAt;
  DateTime? _endedAt;

  /// Memvalidasi form; jika lolos, tampilkan ringkasan lalu kosongkan form.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await showSummaryDialog(
      context: context,
      title: 'Experience berhasil ditambahkan!',
      data: {
        'Title': _title.trim(),
        'Company': _company.trim(),
        'Description': _description.trim(),
        'Category': _categories[_category]!,
        'Thumbnail': orDash(_thumbnail),
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
      _company = '';
      _description = '';
      _category = _defaultCategory;
      _thumbnail = '';
      _startedAt = null;
      _endedAt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
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
                    kicker: 'Experience',
                    title: 'Add New Experience',
                  ),
                  FormTextField(
                    label: 'Experience Title',
                    hint: 'Backend Developer Intern',
                    onChanged: (value) => _title = value,
                    validator: (value) =>
                        Validators.requiredText(value, 'Judul pengalaman'),
                  ),
                  FormTextField(
                    label: 'Company',
                    hint: 'PT Contoh Sejahtera',
                    onChanged: (value) => _company = value,
                    validator: (value) =>
                        Validators.requiredText(value, 'Nama perusahaan'),
                  ),
                  FormTextField(
                    label: 'Description',
                    hint: 'Tell me about this experience',
                    maxLines: 4,
                    onChanged: (value) => _description = value,
                    validator: (value) =>
                        Validators.notBlank(value, 'Deskripsi'),
                  ),
                  FormDropdown(
                    label: 'Category',
                    options: _categories,
                    initialValue: _defaultCategory,
                    onChanged: (value) => _category = value,
                  ),
                  FormTextField(
                    label: 'Thumbnail URL (optional)',
                    hint: 'https://drive.google.com/thumbnail?id=...',
                    keyboardType: TextInputType.url,
                    onChanged: (value) => _thumbnail = value,
                    validator: Validators.optionalUrl,
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
