import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/history_item.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<HistoryItem> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final history = await _dbHelper.getHistory();
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  void _deleteEntry(int id) async {
    await _dbHelper.deleteHistory(id);
    _loadHistory();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('entry_deleted'),
          ),
        ),
      );
    }
  }

  void _editEntry(HistoryItem item) {
    final TextEditingController controller = TextEditingController(
      text: item.text,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('edit_entry')),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                final updatedItem = HistoryItem(
                  id: item.id,
                  text: controller.text,
                  type: item.type,
                  timestamp: item.timestamp,
                );
                await _dbHelper.updateHistory(updatedItem);
                _loadHistory();
                if (mounted) navigator.pop();
              }
            },
            child: Text(AppLocalizations.of(context)!.translate('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('history')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.translate('no_history'),
                style: const TextStyle(color: Colors.white60, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.isEmpty ? 0 : _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  color: Colors.grey[900]?.withValues(alpha: 0.8),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.type == 'voice'
                          ? Icons.mic
                          : item.type == 'translator'
                          ? Icons.translate
                          : Icons.keyboard,
                      color: item.type == 'voice'
                          ? Colors.blueAccent
                          : item.type == 'translator'
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                    ),
                    title: Text(
                      item.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(item.timestamp),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => _editEntry(item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteEntry(item.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
