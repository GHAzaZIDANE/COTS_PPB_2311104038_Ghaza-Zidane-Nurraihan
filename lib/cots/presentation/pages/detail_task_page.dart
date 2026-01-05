import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';

class DetailTaskPage extends StatelessWidget {
  const DetailTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("Detail Tugas", style: AppTextStyles.title),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Edit", style: AppTextStyles.body.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL & MATA KULIAH
              Text(
                "Perancangan MVC + Services", // Nanti ini diganti data dinamis
                style: AppTextStyles.title.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                "Pemrograman Lanjut",
                style: AppTextStyles.body.copyWith(color: AppColors.muted),
              ),
              
              const SizedBox(height: 25),

              // DEADLINE & STATUS
              Row(
                children: [
                  _buildDetailItem(
                    label: "Deadline",
                    value: "18 Jan 2026",
                    icon: Icons.calendar_today_rounded,
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status", style: AppTextStyles.caption),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Berjalan",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BAGIAN PENYELESAIAN
              Text("Penyelesaian", style: AppTextStyles.section),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    // Checkbox manual biar mirip desain
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tugas sudah selesai", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        Text("Centang jika tugas sudah final", style: AppTextStyles.caption),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // BAGIAN CATATAN
              Text("Catatan", style: AppTextStyles.section),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  "Pisahkan Controller, Service, dan Config untuk konsumsi API.",
                  style: AppTextStyles.body,
                ),
              ),

              const SizedBox(height: 50),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("Simpan Perubahan", style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.muted),
            const SizedBox(width: 8),
            Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
} 