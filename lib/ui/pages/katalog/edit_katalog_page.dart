import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/katalog_input_form.dart';
import 'package:frontend/data/models/katalog_models.dart';
import 'package:frontend/logic/bloc/katalog/katalog_bloc.dart';
import 'package:frontend/logic/bloc/katalog/katalog_event.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';

class EditCatalogPage extends StatelessWidget {
  final KatalogModels katalog;
  const EditCatalogPage({super.key, required this.katalog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Katalog',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff1a237e), Color(0xffad1457)],
              ),
            ),
          ),
          SafeArea(
            child: BlocConsumer<KatalogBloc, KatalogState>(
              listener: (context, state) {
                if (state is KatalogCreatedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Katalog berhasil diupdate!'),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is KatalogError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: ${state.message}')),
                  );
                }
              },
              builder: (context, state){
                final isLoading = state is KatalogLoading;

                return KatalogFormWidget(
                  isLoading: isLoading,
                  initialData: katalog,
                  buttonLabel: 'Edit Data', 
                  onSave: (data){
                    context.read<KatalogBloc>().add(UpdateKatalog(katalog.id, data));
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
