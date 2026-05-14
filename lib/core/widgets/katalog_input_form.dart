import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/api_config.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/custom_dropdown.dart';
import 'package:frontend/core/widgets/text_field_custom.dart';
import 'package:frontend/data/models/katalog_models.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';
import 'package:frontend/logic/bloc/kategori/kategori_bloc.dart';
import 'package:frontend/logic/bloc/kategori/kategori_state.dart';
import 'package:image_picker/image_picker.dart';

class KatalogFormWidget extends StatefulWidget {
  final KatalogModels? initialData;
  final String buttonLabel;
  final void Function(Map<String, dynamic> data) onSave;
  final bool isLoading;

  const KatalogFormWidget({
    super.key,
    this.initialData,
    required this.buttonLabel,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<KatalogFormWidget> createState() => _KatalogFormWidgetState();
}

class _KatalogFormWidgetState extends State<KatalogFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _namaKatController;
  late TextEditingController _tahunController;
  late TextEditingController _hargaController;
  late TextEditingController _kapasitasMesinController;
  late TextEditingController _jumlahKursiController;
  late TextEditingController _warnaController;
  late TextEditingController _gambarController;
  late TextEditingController _bahanBakarController;
  late TextEditingController _transmisiController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.initialData?.nama ?? '',
    );
    _namaKatController = TextEditingController(
      text: widget.initialData?.idKat.toString() ?? '',
    );
    _tahunController = TextEditingController(
      text: widget.initialData?.tahun.toString() ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.initialData?.harga.toString() ?? '',
    );
    _kapasitasMesinController = TextEditingController(
      text: widget.initialData?.kapasitasMesin.toString() ?? '',
    );
    _jumlahKursiController = TextEditingController(
      text: widget.initialData?.jumlahKursi.toString() ?? '',
    );
    _bahanBakarController = TextEditingController(
      text: widget.initialData?.bahanBakar ?? '',
    );
    _warnaController = TextEditingController(
      text: widget.initialData?.warna ?? '',
    );
    _gambarController = TextEditingController(
      text: widget.initialData?.gambar ?? '',
    );
    _transmisiController = TextEditingController(
      text: widget.initialData?.transmisi ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _namaKatController.dispose();
    _tahunController.dispose();
    _hargaController.dispose();
    _kapasitasMesinController.dispose();
    _jumlahKursiController.dispose();
    _bahanBakarController.dispose();
    _warnaController.dispose();
    _gambarController.dispose();
    _transmisiController.dispose();
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Tahun"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tahunController.text = picked.year.toString();
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _gambarController.text = image.path;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final submitData = {
        'nama': _namaController.text,
        'idKat': int.tryParse(_namaKatController.text) ?? 0,
        'tahun': int.tryParse(_tahunController.text) ?? 0,
        'harga': int.tryParse(_hargaController.text) ?? 0,
        'kapasitasMesin': int.tryParse(_kapasitasMesinController.text) ?? 0,
        'jumlahKursi': int.tryParse(_jumlahKursiController.text) ?? 0,
        'bahanBakar': _bahanBakarController.text,
        'warna': _warnaController.text,
        'gambar': _gambarController.text,
        'transmisi': _transmisiController.text,
      };
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
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Spesifikasi Armada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextFieldCustomWidget(
              controller: _namaController,
              label: 'Nama Mobil',
              icon: Icons.directions_car_outlined,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            // TextFieldCustomWidget(
            //   controller: _namaKatController,
            //   label: 'Kategori Mobil',
            //   icon: Icons.category_outlined,
            //   validator: _requiredValidator,
            // ),
            BlocBuilder<KategoriBloc, KategoriState>(
              builder: (context, state){
                if (state is KategoriLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if(state is KategoriLoaded){
                  final kategoriList = state.kategoriList;
                  final items = kategoriList.map((k) => k.nama).toList();

                  String? selectedName;
                  if (_namaKatController.text.isNotEmpty) {
                    try {
                      final selectedKat = kategoriList.firstWhere(
                        (k) => k.id.toString() == _namaKatController.text,
                      );
                      selectedName = selectedKat.nama;
                    } catch (e) {
                      selectedName = null;
                    }
                  }
                  return DropdownCustomWidget(
                    label: 'Kategori Mobil',
                    icon: Icons.category_outlined,
                    value: selectedName,
                    items: items.isEmpty ? ['Tidak ada kategori'] : items,
                    validator: _requiredValidator,
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != 'Tidak ada kategori') {
                        final selectedKat = kategoriList.firstWhere(
                          (k) => k.nama == newValue,
                        );
                        setState(() {
                          _namaKatController.text = selectedKat.id.toString();
                        });
                      }
                    },
                  );
                }
                return const Text("Gagal memuat daftar kategori", style: TextStyle(color: Colors.red));
              }),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectYear(context),
              child: AbsorbPointer(
                child: TextFieldCustomWidget(
                  controller: _tahunController,
                  label: 'Tahun Kendaraan',
                  icon: Icons.calendar_today_outlined,
                  validator: _requiredValidator,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFieldCustomWidget(
              controller: _hargaController,
              label: 'Harga',
              icon: Icons.monetization_on_outlined,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFieldCustomWidget(
              controller: _kapasitasMesinController,
              label: 'Kapasitas Mesin (CC)',
              icon: Icons.speed_outlined,
              keyboardType: TextInputType.number,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFieldCustomWidget(
                    controller: _jumlahKursiController,
                    label: 'Jumlah Kursi',
                    icon: Icons.event_seat_outlined,
                    keyboardType: TextInputType.number,
                    validator: _requiredValidator,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFieldCustomWidget(
                    controller: _warnaController,
                    label: 'Warna Mobil',
                    icon: Icons.event_seat_outlined,
                    // keyboardType: TextInputType.number,
                    validator: _requiredValidator,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownCustomWidget(
                    label: 'Bahan Bakar',
                    icon: Icons.local_gas_station_outlined,
                    value: _bahanBakarController.text.isNotEmpty
                        ? _bahanBakarController.text
                        : null,
                    items: const ['Bensin', 'Diesel', 'Hybrid', 'Listrik'],
                    validator: _requiredValidator,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _bahanBakarController.text = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownCustomWidget(
                    label: 'Transmisi',
                    icon: Icons.settings_outlined,
                    value: const ['Automatic', 'Manual'].contains(_transmisiController.text)
                              ? _transmisiController.text
                              : null,
                    items: const ['Automatic', 'Manual'],
                    validator: _requiredValidator,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _transmisiController.text = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TextFieldCustomWidget(
            //   controller: _gambarController,
            //   label: 'Link URL Gambar',
            //   icon: Icons.image_outlined,
            //   validator: _requiredValidator,
            // ),
            const Text(
              'Foto Kendaraan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        _imageFile != null || _gambarController.text.isNotEmpty
                        ? const Color(0xff8b5cf6)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                  : (_gambarController.text.isNotEmpty 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              // Cek apakah udah full URL atau belum, kalau belum tambahin ApiConfig
                              _gambarController.text.startsWith('http') 
                                  ? _gambarController.text 
                                  // Jangan lupa import ApiConfig-nya ya kak di atas!
                                  : "${ApiConfig.imgBaseUrl}${_gambarController.text}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tap untuk pilih gambar dari galeri',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )),
              ),
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
