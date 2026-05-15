import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../services/api_service.dart';

class MemoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Memo> _memos = [];
  bool _isLoading = false;
  String? _error;

  List<Memo> get memos => _memos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> fetchMemos() async {
    _setLoading(true);
    _setError(null);
    try {
      _memos = await _apiService.getMemos();
    } catch (e) {
      _setError('Failed to load memos. Check your connection.');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createMemo(Memo memo) async {
    _setLoading(true);
    _setError(null);
    try {
      final newMemo = await _apiService.createMemo(memo);
      _memos.insert(0, newMemo);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create memo. Try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMemo(Memo memo) async {
    _setLoading(true);
    _setError(null);
    try {
      final updatedMemo = await _apiService.updateMemo(memo);
      final index = _memos.indexWhere((m) => m.id == memo.id);
      if (index != -1) {
        _memos[index] = updatedMemo;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update memo. Try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteMemo(int id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _apiService.deleteMemo(id);
      _memos.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete memo. Try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}