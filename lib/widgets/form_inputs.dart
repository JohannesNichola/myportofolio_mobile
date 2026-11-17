import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/palette.dart';

/// Memformat tanggal menjadi `yyyy-MM-dd` (format yang sama dengan Django).
String formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// Dekorasi input yang seragam (mengikuti palet website) untuk semua field.
InputDecoration formDecoration({required String label, String? hint}) {
  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: color),
    );
  }

  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.textMuted),
    hintStyle: const TextStyle(color: AppColors.textMuted),
    border: border(AppColors.accent),
    enabledBorder: border(AppColors.accent),
    focusedBorder: border(AppColors.accentDark),
    errorBorder: border(AppColors.danger),
    focusedErrorBorder: border(AppColors.danger),
  );
}

/// Judul halaman formulir: kicker kecil di atas judul besar, seperti di website.
class FormHeader extends StatelessWidget {
  final String kicker;
  final String title;

  const FormHeader({super.key, required this.kicker, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kicker.toUpperCase(),
            style: const TextStyle(
              color: AppColors.accentDark,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Field teks dengan jarak dan dekorasi yang seragam.
class FormTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const FormTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: formDecoration(label: label, hint: hint),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

/// Dropdown pilihan kategori; [options] berisi pasangan nilai -> label.
class FormDropdown extends StatelessWidget {
  final String label;
  final Map<String, String> options;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const FormDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: formDecoration(label: label),
        initialValue: initialValue,
        items: options.entries
            .map((entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ))
            .toList(),
        onChanged: (String? newValue) {
          if (newValue != null) onChanged(newValue);
        },
      ),
    );
  }
}

/// Field tanggal: menampilkan `showDatePicker()` ketika disentuh.
/// Jika [clearable] true, tanggal yang sudah dipilih dapat dihapus lagi.
class FormDateField extends FormField<DateTime> {
  FormDateField({
    super.key,
    required String label,
    required ValueChanged<DateTime?> onChanged,
    super.validator,
    bool clearable = false,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<DateTime> field) {
            final value = field.value;

            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: field.context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime(2100),
              );
              if (picked == null || !field.mounted) return;
              field.didChange(picked);
              onChanged(picked);
            }

            void clear() {
              field.didChange(null);
              onChanged(null);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(5.0),
                onTap: pickDate,
                child: InputDecorator(
                  isEmpty: value == null,
                  decoration: formDecoration(label: label).copyWith(
                    errorText: field.errorText,
                    suffixIcon: clearable && value != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: clear,
                          )
                        : const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    value == null ? '' : formatDate(value),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            );
          },
        );
}

/// Tombol Simpan berlebar penuh untuk semua formulir.
class FormSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FormSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.paper,
            padding: const EdgeInsets.symmetric(vertical: 14.0),
          ),
          onPressed: onPressed,
          child: const Text(
            'Simpan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}