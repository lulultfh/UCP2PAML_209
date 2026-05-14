import 'package:flutter/material.dart';
import 'package:frontend/core/constant/app_colors.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = "Hapus",
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm(); 
            Navigator.pop(context); // Tutup dialog
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmText == "Logout" 
                ? AppColors.primaryColor 
                : Colors.redAccent,    
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}