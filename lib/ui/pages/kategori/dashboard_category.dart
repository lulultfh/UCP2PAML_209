import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/confirm_dialog.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/data/repositories/kategori_repositori.dart';
import 'package:frontend/logic/bloc/kategori/kategori_bloc.dart';
import 'package:frontend/logic/bloc/kategori/kategori_event.dart';
import 'package:frontend/logic/bloc/kategori/kategori_state.dart';
import 'package:frontend/ui/pages/katalog/dashboard_catalog.dart';
import 'package:frontend/ui/pages/kategori/add_category_page.dart';
import 'package:frontend/ui/pages/kategori/edit_kategori_page.dart';
import 'package:lottie/lottie.dart';

class DashboardCategory extends StatelessWidget {
  final bool isAdmin;

  const DashboardCategory({super.key, required this.isAdmin});

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KategoriBloc(repository: KategoriRepositori())..add(FetchKategori()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "List Kategori",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundColor,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.backgroundColor,
            ),
            tooltip: 'Kembali',
          ),
          actions: [],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.backgroundColor),
            ),
            BlocListener<KategoriBloc, KategoriState>(
              listener: (context, state) {
                if (state is KategoriCreatedSuccess) {
                  CustomToast.show(context, "Operasi Berhasil!");
                } else if (state is KategoriError) {
                  CustomToast.show(
                    context,
                    'Gagal: ${state.message}',
                    isError: true,
                  );
                }
              },
              child: BlocBuilder<KategoriBloc, KategoriState>(
                builder: (context, state) {
                  if (state is KategoriLoading) {
                    return Center(
                      child: Lottie.asset('assets/gif/loading.json', width: 200),
                    );
                  } else if (state is KategoriLoaded) {
                    if (state.kategoriList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada kategori",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      );
                    }
                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        context.read<KategoriBloc>().add(FetchKategori());
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      builder: (context, child, controller) {
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (!controller.isIdle)
                                  Positioned(
                                    top: 50 * controller.value,
                                    child: Lottie.asset(
                                      'assets/gif/loading.json',
                                      height: 80,
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(0, 100 * controller.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
                        itemCount: state.kategoriList.length,
                        itemBuilder: (context, index) {
                          final katkat = state.kategoriList[index];
                          return CustomGlassCard(
                            title: katkat.nama,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardCatalog(
                                    filterIdKategori: katkat.id,
                                    filterNamaKategori: katkat.nama,
                                  ),
                                ),
                              );
                            },
                            onEdit: isAdmin
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (innerContext) =>
                                            BlocProvider.value(
                                              value: context
                                                  .read<KategoriBloc>(),
                                              child: EditCategoryPage(
                                                kategori: katkat,
                                              ),
                                            ),
                                      ),
                                    );
                                  }
                                : null,
                            onDelete: isAdmin
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => ConfirmDeleteDialog(
                                        title: "Hapus Kategori?",
                                        confirmText: "Hapus",
                                        content:
                                            "Yakin ingin menghapus kategori '${katkat.nama}'?",
                                        onConfirm: () {
                                          context.read<KategoriBloc>().add(
                                            DeleteKategori(katkat.id),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                : null,
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text("Gagal memuat data"));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: isAdmin
            ? Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (innerContext) => BlocProvider.value(
                          value: context.read<KategoriBloc>(),
                          child: const AddCategoryPage(),
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: AppColors.primaryColor),
                ),
              )
            : null,
      ),
    );
  }
}
