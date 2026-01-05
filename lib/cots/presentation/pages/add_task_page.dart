import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../models/task_model.dart';      // Import Model
import '../../services/task_service.dart';  // Import Service

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Controller buat nangkep inputan teks
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Bikin objek Task dari inputan
      final newTask = Task(
        title: _titleController.text,
        course: _courseController.text,
        deadline: _deadlineController.text.isEmpty ? "2026-01-20" : _deadlineController.text, // Default tanggal kalau kosong
        status: "BERJALAN",
        note: _noteController.text,
        isDone: false,
      );

      // 2. Kirim ke API lewat Service
      await TaskService().addTask(newTask);

      // 3. Kalau sukses, balik ke Dashboard
      if (mounted) {
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal simpan: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
        title: Text("Tambah Tugas", style: AppTextStyles.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INPUT 1: JUDUL TUGAS
              _buildLabel("Judul Tugas"),
              _buildTextField(controller: _titleController, hint: "Masukkan judul tugas"),
              
              const SizedBox(height: 20),

              // INPUT 2: MATA KULIAH
              _buildLabel("Mata Kuliah"),
              _buildTextField(controller: _courseController, hint: "Pilih mata kuliah", icon: Icons.keyboard_arrow_down),

              const SizedBox(height: 20),

              // INPUT 3: DEADLINE
              _buildLabel("Deadline"),
              _buildTextField(controller: _deadlineController, hint: "YYYY-MM-DD (Contoh: 2026-01-20)", icon: Icons.calendar_today),

              const SizedBox(height: 20),

              // INPUT 4: CATATAN
              _buildLabel("Catatan"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Catatan tambahan (opsional)",
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // TOMBOL AKSI
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Text("Batal", style: AppTextStyles.button.copyWith(color: AppColors.text)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveTask, // Panggil fungsi simpan
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text("Simpan", style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.section.copyWith(fontSize: 14)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller, // Sambungin controller di sini
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
          suffixIcon: icon != null ? Icon(icon, color: AppColors.muted) : null,
        ),
      ),
    );
  }
}