import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/constant/app_colors.dart';

class KatalogSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const KatalogSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: TextField(
              // Inisialisasi query awal jika ada
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: query,
                  selection: TextSelection.collapsed(offset: query.length),
                ),
              ),
              style: const TextStyle(
                color: AppColors.primaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Cari mobil...',
                hintStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}