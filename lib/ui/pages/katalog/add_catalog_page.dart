import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/katalog_input_form.dart';
import 'package:frontend/logic/bloc/katalog/katalog_bloc.dart';
import 'package:frontend/logic/bloc/katalog/katalog_event.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';

class AddCatalogPage extends StatelessWidget {
  const AddCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tambah Katalog',
          style: TextStyle(color: AppColors.backgroundColor),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.backgroundColor),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.backgroundColor),
          ),
          SafeArea(
            child: BlocConsumer<KatalogBloc, KatalogState>(
              listener: (context, state) {
                if (state is KatalogCreatedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Katalog berhasil ditambahkan!'),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is KatalogError) {
                  CustomToast.show(context,'Gagal: ${state.message}',isError: true,);
                }
              },
              builder: (context, state) {
                final isLoading = state is KatalogLoading;

                return KatalogFormWidget(
                  isLoading: isLoading,
                  buttonLabel: 'Tambah Data',
                  onSave: (data) {
                    context.read<KatalogBloc>().add(CreateKatalog(data));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
