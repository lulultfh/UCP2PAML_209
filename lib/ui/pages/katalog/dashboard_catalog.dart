import 'dart:ui';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/api_config.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/constant/currency_format.dart';
import 'package:frontend/core/widgets/confirm_dialog.dart';
import 'package:frontend/core/widgets/custom_search.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/data/repositories/katalog_repository.dart';
import 'package:frontend/data/repositories/kategori_repositori.dart';
import 'package:frontend/logic/bloc/auth/auth_bloc.dart';
import 'package:frontend/logic/bloc/auth/auth_event.dart';
import 'package:frontend/logic/bloc/katalog/katalog_bloc.dart';
import 'package:frontend/logic/bloc/katalog/katalog_event.dart';
import 'package:frontend/logic/bloc/katalog/katalog_state.dart';
import 'package:frontend/logic/bloc/kategori/kategori_bloc.dart';
import 'package:frontend/logic/bloc/kategori/kategori_event.dart';
import 'package:frontend/logic/bloc/kategori/kategori_state.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/katalog/add_catalog_page.dart';
import 'package:frontend/ui/pages/katalog/detail_catalog_page.dart';
import 'package:frontend/ui/pages/katalog/edit_katalog_page.dart';
import 'package:lottie/lottie.dart';

class DashboardCatalog extends StatefulWidget {
  final int? filterIdKategori;
  final String? filterNamaKategori;
  final bool isAdmin;

  const DashboardCatalog({
    super.key,
    this.filterIdKategori,
    this.filterNamaKategori,
    this.isAdmin = false,
  });

  @override
  State<DashboardCatalog> createState() => _DashboardCatalogState();
}

class _DashboardCatalogState extends State<DashboardCatalog> {
  String _searchQuery = '';
  int? _selectedCategoryId;

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = KatalogBloc(repository: KatalogRepository());
            if (widget.filterIdKategori != null) {
              bloc.add(FetchKatalogByKategori(widget.filterIdKategori!));
            } else {
              bloc.add(FetchKatalog());
            }
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) =>
              KategoriBloc(repository: KategoriRepositori())
                ..add(FetchKategori()),
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            widget.filterNamaKategori != null
                ? "Katalog: ${widget.filterNamaKategori}"
                : "List Katalog",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: widget.isAdmin
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColors.backgroundColor,
                  ),
                  tooltip: 'Kembali',
                )
              : null,
          actions: [
            if (!widget.isAdmin)
              IconButton(
                onPressed: () {
                  showDialog(
                context: context,
                builder: (dialogContext) => ConfirmDeleteDialog(
                  title: "Konfirmasi Logout",
                  content: "Apakah Anda yakin ingin keluar dari Admin Panel?",
                  confirmText: "Logout", 
                  onConfirm: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    Navigator.pop(dialogContext);
                    Future.microtask(() {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      }
                    });
                  },
                ),
              );
                },
                icon: Icon(Icons.logout_outlined, color: Colors.redAccent),
                tooltip: 'Logout',
              ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [Color(0xff1a237e), Color(0xffad1457)],
                // ),
                color: AppColors.backgroundColor,
              ),
            ),
            BlocListener<KatalogBloc, KatalogState>(
              listener: (context, state) {
                if (state is KatalogCreatedSuccess) {
                  CustomToast.show(context, "Operasi Berhasil!");
                } else if (state is KatalogError) {
                  CustomToast.show(
                    context,
                    'Gagal: ${state.message}',
                    isError: true,
                  );
                }
              },
              child: BlocBuilder<KatalogBloc, KatalogState>(
                builder: (context, state) {
                  if (state is KatalogLoading) {
                    return Center(
                      child: Lottie.asset('assets/gif/loading.json', width: 200),
                    );
                  } else if (state is KatalogLoaded) {
                    if (state.katalogList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada katalog",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    final filteredKatalog = state.katalogList.where((katalog) {
                      final matchName = katalog.nama.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                      final matchCategory =
                          _selectedCategoryId == null ||
                          katalog.idKat == _selectedCategoryId;

                      return matchName && matchCategory;
                    }).toList();
                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        context.read<KatalogBloc>().add(FetchKatalog());
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
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          KatalogSearchBar(
                            query: _searchQuery,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                          BlocBuilder<KategoriBloc, KategoriState>(
                            builder: (context, kategoriState) {
                              if (kategoriState is KategoriLoaded &&
                                  kategoriState.kategoriList.isNotEmpty) {
                                return SizedBox(
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: ChoiceChip(
                                          label: const Text("Semua"),
                                          selected: _selectedCategoryId == null,
                                          onSelected: (selected) {
                                            setState(
                                              () => _selectedCategoryId = null,
                                            );
                                          },
                                          pressElevation: 0,
                                          showCheckmark: false,
                                          selectedColor: AppColors.primaryColor,
                                          backgroundColor:
                                              AppColors.backgroundColor,
                                          labelStyle: TextStyle(
                                            color: _selectedCategoryId == null
                                                ? AppColors
                                                      .backgroundColor // Warna teks saat terpilih
                                                : AppColors
                                                      .primaryColor, // Warna teks saat tidak terpilih
                                            fontWeight: FontWeight.bold,
                                          ),
                                          side: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      ...kategoriState.kategoriList.map((kat) {
                                        final isSelected =
                                            _selectedCategoryId == kat.id;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: ChoiceChip(
                                            label: Text(kat.nama),
                                            selected: isSelected,
                                            onSelected: (selected) {
                                              setState(
                                                () => _selectedCategoryId =
                                                    selected ? kat.id : null,
                                              );
                                            },
                                            pressElevation: 0,
                                            showCheckmark: false,
                                            selectedColor:
                                                AppColors.primaryColor,
                                            backgroundColor:
                                                AppColors.backgroundColor,
                                            labelStyle: TextStyle(
                                              color: isSelected
                                                  ? AppColors.backgroundColor
                                                  : AppColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            side: BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: BlocBuilder<KategoriBloc, KategoriState>(
                              builder: (context, kategoriState) {
                                if (filteredKatalog.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "Kendaraan tidak ditemukan",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                    right: 16,
                                    bottom: 100,
                                  ),
                                  itemCount: filteredKatalog.length,
                                  itemBuilder: (context, index) {
                                    final katkat = filteredKatalog[index];
                                    String namaKategori = "Loading...";
                                    if (kategoriState is KategoriLoaded) {
                                      try {
                                        final matchedKategori = kategoriState
                                            .kategoriList
                                            .firstWhere(
                                              (k) => k.id == katkat.idKat,
                                            );
                                        namaKategori = matchedKategori.nama;
                                      } catch (e) {
                                        namaKategori =
                                            "Kategori tidak ditemukan";
                                      }
                                    }
                                    return CustomGlassCard(
                                      title: katkat.nama,
                                      subtitle: namaKategori,
                                      price: CurrencyFormat.convertToIdr(
                                        katkat.harga,
                                        0,
                                      ),
                                      gambar:
                                          "${ApiConfig.imgBaseUrl}${katkat.gambar}",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailKatalogPage(data: katkat),
                                          ),
                                        );
                                      },
                                      onEdit: widget.isAdmin
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (innerContext) => MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider.value(
                                                        value: context.read<KatalogBloc>(),
                                                      ),
                                                      BlocProvider.value(
                                                        value: context.read<KategoriBloc>(),
                                                      ),
                                                    ],
                                                    child: EditCatalogPage(katalog: katkat),
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      onDelete: widget.isAdmin
                                          ? () {
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) =>
                                                    ConfirmDeleteDialog(
                                                      confirmText: "Hapus",
                                                      title: "Hapus Mobil?",
                                                      content:
                                                          "Yakin ingin menghapus ${katkat.nama} dari katalog?",
                                                      onConfirm: () {
                                                        context
                                                            .read<KatalogBloc>()
                                                            .add(
                                                              DeleteKatalog(
                                                                katkat.id,
                                                              ),
                                                            );
                                                      },
                                                    ),
                                              );
                                            }
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text("Gagal memuat data"));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (innerContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<KatalogBloc>(),
                            ),
                            BlocProvider.value(
                              value: context.read<KategoriBloc>(),
                            ),
                          ],
                          child: const AddCatalogPage(),
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
