import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/memo.dart';

class ApiService {
  static const String _baseUrl =
      'https://jsonplaceholder.typicode.com';

  Future<List<Memo>> getMemos() async {
    await Future.delayed(const Duration(seconds: 3));
    return [];
  }

  Future<Memo> createMemo(Memo memo) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode == 201) {
      return Memo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create memo');
    }
  }

  Future<Memo> updateMemo(Memo memo) async {
    final validId = memo.id > 100 ? 1 : memo.id;
    final response = await http.put(
      Uri.parse('$_baseUrl/posts/$validId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode == 200) {
      return memo;
    } else {
      throw Exception('Failed to update memo');
    }
  }

  Future<void> deleteMemo(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/posts/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete memo');
    }
  }
}