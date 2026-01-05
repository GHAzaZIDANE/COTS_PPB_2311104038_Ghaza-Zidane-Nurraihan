import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
  static const String baseUrl = 'https://rpblbedyqmnzpowbumzd.supabase.co/rest/v1/tasks';

  
  static const String token = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwYmxiZWR5cW1uenBvd2J1bXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYsImV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUpImZAynz3o2l0xDfq_exf2wUrTs';

  static const Map<String, String> headers = {
    'apikey': token,
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  // 1. GET: Ambil Semua Tugas
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl?select=*'), headers: headers);
    
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil data: ${response.body}');
    }
  }

  // 2. POST: Tambah Tugas Baru
  Future<void> addTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Server Error: ${response.body}');
    }
  }

  // 3. PATCH: Update Tugas
  Future<void> updateTaskStatus(String id, bool isDone) async {
    final response = await http.patch(
      Uri.parse('$baseUrl?id=eq.$id'),
      headers: headers,
      body: jsonEncode({
        'is_done': isDone,
        'status': isDone ? 'SELESAI' : 'BERJALAN',
      }),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Gagal update: ${response.body}');
    }
  }
}