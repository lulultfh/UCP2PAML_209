import 'package:flutter/material.dart';
import 'package:frontend/core/constant/api_config.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/constant/currency_format.dart';
import 'package:frontend/data/models/katalog_models.dart';

class DetailKatalogPage extends StatelessWidget {
  final KatalogModels data;
  const DetailKatalogPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Detail Kendaraan',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.backgroundColor),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.backgroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Hero(
                      tag: 'katalog_${data.idKat}_${data.nama}',
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(24),
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                          child: data.gambar != null && data.gambar!.isNotEmpty
                              ? Image.network(
                                  "${ApiConfig.imgBaseUrl}${data.gambar}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.directions_car,
                                        size: 100,
                                        color: AppColors.primaryColor,
                                      ),
                                )
                              : const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 100,
                                  color: AppColors.primaryColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.nama,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            CurrencyFormat.convertToIdr(data.harga, 0),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Spesifikasi Kendaraan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),

                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              children: [
                                  _buildSpecItem(Icons.calendar_month_outlined, "Tahun", data.tahun.toString()),
                                  _buildSpecItem(Icons.settings_outlined, "Transmisi", data.transmisi),
                                  _buildSpecItem(Icons.local_gas_station_outlined, "Bensin", data.bahanBakar),
                                  _buildSpecItem(Icons.speed_outlined, "Kapasitas", "${data.kapasitasMesin} CC"),
                                  _buildSpecItem(Icons.event_seat_outlined, "Kursi", "${data.jumlahKursi} Seat"),
                                  _buildSpecItem(Icons.color_lens_outlined, "Warna", data.warna),
                                ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primaryColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
