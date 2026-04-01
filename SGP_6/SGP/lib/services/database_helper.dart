import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

/// Web-compatible history storage using SharedPreferences (JSON list).
/// Works on Flutter Web, Android, iOS, and Desktop.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const _key = 'awaaz_history';

  // ── Read all ─────────────────────────────────────────────────
  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> list = json.decode(raw);
    return list
        .map((e) => HistoryItem.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // ── Insert ───────────────────────────────────────────────────
  Future<int> insertHistory(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getRawList(prefs);
    final newId = DateTime.now().millisecondsSinceEpoch;
    list.add({
      'id': newId,
      'text': item.text,
      'type': item.type,
      'timestamp': item.timestamp.toIso8601String(),
    });
    await prefs.setString(_key, json.encode(list));
    return newId;
  }

  // ── Update ───────────────────────────────────────────────────
  Future<int> updateHistory(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getRawList(prefs);
    final idx = list.indexWhere((e) => e['id'] == item.id);
    if (idx != -1) {
      list[idx] = {
        'id': item.id,
        'text': item.text,
        'type': item.type,
        'timestamp': item.timestamp.toIso8601String(),
      };
      await prefs.setString(_key, json.encode(list));
      return 1;
    }
    return 0;
  }

  // ── Delete ───────────────────────────────────────────────────
  Future<int> deleteHistory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getRawList(prefs);
    list.removeWhere((e) => e['id'] == id);
    await prefs.setString(_key, json.encode(list));
    return 1;
  }

  // ── Helper ───────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> _getRawList(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> list = json.decode(raw);
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
