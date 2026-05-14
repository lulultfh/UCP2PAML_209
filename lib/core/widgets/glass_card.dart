import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/constant/app_colors.dart';

class CustomGlassCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? price;
  final String? gambar;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomGlassCard({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.gambar,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 2, right: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),

              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ListTile(
              onTap: onTap,
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: gambar != null && gambar!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          gambar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.directions_car,
                                color: AppColors.primaryColor,
                              ),
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primaryColor,
                      ),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: (subtitle != null || price != null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        if (price != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            price!,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    )
                  : null,
              trailing: (onEdit != null || onDelete != null)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onEdit != null)
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        if (onDelete != null)
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                          ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
