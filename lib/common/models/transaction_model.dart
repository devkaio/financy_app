import 'dart:convert';

class TransactionModel {
  final String description;
  final String category;
  final double value;
  final int date;
  final bool status;
  final String? id;
  TransactionModel({
    required this.category,
    required this.description,
    required this.value,
    required this.date,
    required this.status,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'category': category,
      'value': value,
      'date': date,
      'status': status,
      'id': id,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      description: map['description'] as String,
      category: map['category'] as String,
      value: double.tryParse(map['value'].toString()) ?? 0,
      date: DateTime.parse(map['date'] as String).millisecondsSinceEpoch,
      status: map['status'] as bool,
      id: map['id'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.category == category &&
        other.value == value &&
        other.date == date &&
        other.status == status &&
        other.id == id;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        category.hashCode ^
        value.hashCode ^
        date.hashCode ^
        status.hashCode ^
        id.hashCode;
  }
}
