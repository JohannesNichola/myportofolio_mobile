import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_inputs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Halaman form untuk menambahkan Education (field mengikuti model Django).
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Pilihan kategori mengikuti EDUCATION_CHOICES pada model Django.
  static const String _defaultCategory = 'formal-edu';
  static const Map<String, String> _categories = {
    'formal-edu': 'Formal-Edu',
    'certification': 'Certification',
    'course-bootcamp': 'Course-Bootcamp',
    'academic-project': 'Academic-project',
    'award-honor': 'Award-Honor',
  };

  String _title = '';
  String _institution = '';
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
      title: 'Education berhasil ditambahkan!',
      data: {
        'Title': _title.trim(),
        'Institution': _institution.trim(),
        'Description': orDash(_description),
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
      _institution = '';
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
          'Add Education Form',
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
                    kicker: 'Education',
                    title: 'Add New Education',
                  ),
                  FormTextField(
                    label: 'Education Title',
                    hint: 'S1 Sistem Informasi',
                    onChanged: (value) => _title = value,
                    validator: (value) =>
                        Validators.requiredText(value, 'Judul pendidikan'),
                  ),
                  FormTextField(
                    label: 'Institution',
                    hint: 'Universitas Indonesia',
                    onChanged: (value) => _institution = value,
                    validator: (value) =>
                        Validators.requiredText(value, 'Nama institusi'),
                  ),
                  FormTextField(
                    label: 'Description (optional)',
                    hint: 'Tell me about this education',
                    maxLines: 4,
                    onChanged: (value) => _description = value,
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
