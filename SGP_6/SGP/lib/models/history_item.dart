class HistoryItem {
  final int? id;
  final String text;
  final String type; // 'voice' or 'text'
  final DateTime timestamp;

  HistoryItem({
    this.id,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'],
      text: map['text'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
