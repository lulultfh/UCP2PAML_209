import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/confirm_dialog.dart';
import 'package:frontend/logic/bloc/auth/auth_bloc.dart';
import 'package:frontend/logic/bloc/auth/auth_event.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/katalog/dashboard_catalog.dart';
import 'package:frontend/ui/pages/kategori/dashboard_category.dart';

class HomePage extends StatelessWidget {
  final bool isAdmin;
  const HomePage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return const DashboardCatalog(isAdmin: false);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Admin Panel",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
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
            icon: const Icon(Icons.logout_outlined, color: Colors.redAccent),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: AppColors.backgroundColor),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAdminMenu(
                    context,
                    title: "Manajemen Katalog",

                    icon: Icons.directions_car_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DashboardCatalog(isAdmin: true),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildAdminMenu(
                    context,
                    title: "Manajemen Kategori",
                    icon: Icons.category_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DashboardCategory(isAdmin: true),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenu(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 40),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
