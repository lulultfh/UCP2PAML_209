import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/katalog_input_form.dart';
import 'package:frontend/core/widgets/kategori_input_form.dart';
import 'package:frontend/logic/bloc/katalog/katalog_bloc.dart';
import 'package:frontend/logic/bloc/katalog/katalog_event.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';
import 'package:frontend/logic/bloc/kategori/kategori_bloc.dart';
import 'package:frontend/logic/bloc/kategori/kategori_event.dart';
import 'package:frontend/logic/bloc/kategori/kategori_state.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tambah Kategori',
          style: TextStyle(color: AppColors.backgroundColor),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.backgroundColor),
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
                  CustomToast.show(context, "Kategori Berhasil ditambahkan!");
                  Navigator.pop(context);
                } else if (state is KategoriError) {
                  CustomToast.show(context, state.message, isError: true);
                }
              },
              builder: (context, state){
                final isLoading = state is KategoriLoading;

                return KategoriFormWidget(
                  isLoading: isLoading,
                  buttonLabel: 'Tambah Data', 
                  onSave: (data){
                    context.read<KategoriBloc>().add(CreateKategori(data));
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
