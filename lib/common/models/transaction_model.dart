import 'dart:convert';

class TransactionModel {
  final String description;
  final double value;
  final int date;
  TransactionModel({
    required this.description,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'value': value,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      description: map['description'] as String,
      value: double.tryParse(map['value'].toString()) ?? 0,
      date: DateTime.parse(map['date'] as String).millisecondsSinceEpoch,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
