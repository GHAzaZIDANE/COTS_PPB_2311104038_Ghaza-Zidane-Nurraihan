import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../models/task_model.dart';     // Import Model
import '../../services/task_service.dart'; // Import Service
import 'add_task_page.dart';
import 'detail_task_page.dart';
import 'all_tasks_page.dart';

// Ubah jadi StatefulWidget biar bisa loading data
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Ambil data pas halaman dibuka
  }

  // Fungsi buat nembak API lewat Service
  Future<void> _fetchTasks() async {
    try {
      final tasks = await _taskService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung ringkasan otomatis
    int totalTasks = _tasks.length;
    int completedTasks = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) // Muncul loading kalau data belum siap
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // BAGIAN 1: JUDUL ATAS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tugas Besar", style: AppTextStyles.title),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AllTasksPage()),
                          );
                        },
                        child: Text(
                          "Daftar Tugas",
                          style: AppTextStyles.button.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // BAGIAN 2: RINGKASAN (ANGKA OTOMATIS)
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Total Tugas",
                          count: totalTasks.toString(), // Data Asli
                          color: AppColors.primary,
                          textColor: AppColors.surface,
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Selesai",
                          count: completedTasks.toString(), // Data Asli
                          color: AppColors.surface,
                          textColor: AppColors.text,
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // BAGIAN 3: JUDUL TUGAS TERDEKAT
                  Text("Tugas Terdekat", style: AppTextStyles.section),
                  const SizedBox(height: 15),

                  // BAGIAN 4: LIST KARTU TUGAS (DARI API)
                  // Kalau kosong, tampilkan teks "Belum ada tugas"
                  if (_tasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Belum ada tugas yang diambil dari API."),
                    )
                  else
                    // Mapping data dari API ke Widget Kartu
                    ..._tasks.map((task) => _buildTaskCard(task)).toList(),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
      
      // BAGIAN 5: TOMBOL TAMBAH TUGAS
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // Tunggu sampai balik dari halaman tambah, terus refresh data
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskPage()),
              );
              _fetchTasks(); // Refresh data setelah nambah
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: Text("Tambah Tugas", style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required Color color,
    required Color textColor,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: isPrimary ? Colors.white70 : AppColors.muted)),
          const SizedBox(height: 10),
          Text(count, style: AppTextStyles.title.copyWith(fontSize: 30, color: textColor)),
        ],
      ),
    );
  }

  // Widget Kartu Tugas (Sekarang terima Data Task asli)
  Widget _buildTaskCard(Task task) {
    // Tentukan warna status
    Color statusColor = AppColors.primary;
    if (task.status == 'SELESAI') statusColor = Colors.green;
    if (task.status == 'TERLAMBAT') statusColor = AppColors.danger;

    return Builder(builder: (context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: AppTextStyles.section), // Judul dari API
              const SizedBox(height: 5),
              Text(task.course, style: AppTextStyles.body.copyWith(color: AppColors.muted)), // Matkul dari API
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16, color: AppColors.muted),
                      const SizedBox(width: 5),
                      Text("Deadline: ${task.deadline}", style: AppTextStyles.caption), // Tanggal dari API
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.status, // Status dari API
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}