import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/kategori_input_form.dart';
import 'package:frontend/data/models/kategori_models.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';
import 'package:frontend/logic/bloc/kategori/kategori_bloc.dart';
import 'package:frontend/logic/bloc/kategori/kategori_event.dart';
import 'package:frontend/logic/bloc/kategori/kategori_state.dart';

class EditCategoryPage extends StatelessWidget {
  final KategoriModels kategori;
  const EditCategoryPage({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Kategori',
          style: TextStyle(color: AppColors.backgroundColor),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor
            ),
          ),
          SafeArea(
            child: BlocConsumer<KategoriBloc, KategoriState>(
              listener: (context, state) {
                if (state is KategoriCreatedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kategori berhasil diupdate!'),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is KategoriError) {
                  CustomToast.show(context, state.message, isError: true);
                }
              },
              builder: (context, state){
                final isLoading = state is KatalogLoading;

                return KategoriFormWidget(
                  isLoading: isLoading,
                  initialData: kategori,
                  buttonLabel: 'Edit Data', 
                  onSave: (data){
                    context.read<KategoriBloc>().add(UpdateKategori(kategori.id, data));
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
