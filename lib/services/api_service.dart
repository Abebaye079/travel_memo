import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/memo.dart';

class ApiService {
  static const String _baseUrl =
      'https://jsonplaceholder.typicode.com';

  Future<List<Memo>> getMemos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/posts'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .take(10)
          .map((json) => Memo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load memos');
    }
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
    final response = await http.put(
      Uri.parse('$_baseUrl/posts/${memo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode == 200) {
      return Memo.fromJson(jsonDecode(response.body));
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