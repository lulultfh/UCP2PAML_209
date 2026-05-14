import 'package:flutter/material.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/text_field_custom.dart';
import 'package:frontend/data/models/kategori_models.dart';

class KategoriFormWidget extends StatefulWidget {
  final KategoriModels? initialData;
  final String buttonLabel;
  final void Function(Map<String, dynamic> data) onSave;
  final bool isLoading;

  const KategoriFormWidget({
    super.key,
    this.initialData,
    required this.buttonLabel,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<KategoriFormWidget> createState() => _KategoriFormWidgetState();
}

class _KategoriFormWidgetState extends State<KategoriFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.initialData?.nama ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final submitData = {'nama': _namaController.text};
      widget.onSave(submitData);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kategori Mobil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFieldCustomWidget(
              controller: _namaController,
              label: 'Nama Kategori',
              icon: Icons.directions_car_outlined,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.buttonLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
