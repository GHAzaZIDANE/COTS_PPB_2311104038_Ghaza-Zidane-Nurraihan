import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import 'add_task_page.dart';
import 'detail_task_page.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

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
        title: Text("Daftar Tugas", style: AppTextStyles.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskPage()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KOLOM PENCARIAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30), // Bulat kayak kapsul
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari tugas atau mata kuliah...",
                    hintStyle: AppTextStyles.caption,
                    prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),

            // FILTER KATEGORI (Semua, Berjalan, Selesai, Terlambat)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildFilterChip("Semua", true),
                  _buildFilterChip("Berjalan", false),
                  _buildFilterChip("Selesai", false),
                  _buildFilterChip("Terlambat", false),
                ],
              ),
            ),

            // LIST TUGAS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildTaskItem(context, "Integrasi API HoReCa", "Supply Chain", "20 Jan 2026", "Berjalan", AppColors.primary),
                  _buildTaskItem(context, "UI Mobile Slicing", "UI Engineering", "17 Jan 2026", "Berjalan", AppColors.primary),
                  _buildTaskItem(context, "Laporan Pengabdian", "KKN Tematik", "12 Jan 2026", "Selesai", Colors.green),
                  _buildTaskItem(context, "Bab Metodologi", "Metodologi Penelitian", "08 Jan 2026", "Terlambat", AppColors.danger),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Filter
  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isActive ? Colors.white : AppColors.muted,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget Item Tugas
  Widget _buildTaskItem(BuildContext context, String title, String course, String date, String status, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailTaskPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bagian Kiri (Icon Bulat + Teks)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.assignment_outlined, color: color, size: 20),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.section.copyWith(fontSize: 14)),
                    Text(course, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            // Bagian Kanan (Tanggal)
            Row(
              children: [
                Text(date.substring(0, 6), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)), // Ambil tgl doang
                const SizedBox(width: 5),
                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.muted),
              ],
            )
          ],
        ),
      ),
    );
  }
}