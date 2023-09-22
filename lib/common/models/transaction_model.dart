import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../extensions/extensions.dart';

enum SyncStatus {
  none,
  synced,
  create,
  update,
  delete,
}

class TransactionModel {
  TransactionModel({
    required this.category,
    required this.description,
    required this.value,
    required this.date,
    required this.status,
    required this.createdAt,
    this.id,
    this.userId,
    this.syncStatus = SyncStatus.synced,
  });

  final String description;
  final String category;
  final double value;
  final int date;
  final bool status;
  final int createdAt;
  final String? id;
  final String? userId;
  final SyncStatus? syncStatus;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'category': category,
      'value': value,
      'date': DateTime.fromMillisecondsSinceEpoch(date).formatISOTime,
      'created_at':
          DateTime.fromMillisecondsSinceEpoch(createdAt).formatISOTime,
      'status': status,
      'id': id ?? const Uuid().v4(),
      'user_id': userId,
    };
  }

  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'description': description,
      'category': category,
      'value': value,
      'date': DateTime.fromMillisecondsSinceEpoch(date).toIso8601String(),
      'created_at':
          DateTime.fromMillisecondsSinceEpoch(createdAt).toIso8601String(),
      'status': status.toInt(),
      'id': id ?? const Uuid().v4(),
      'user_id': userId,
      'sync_status': syncStatus!.name,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    bool parsedStatus = false;
    if (map['status'] is int) {
      parsedStatus = map['status'] == 0 ? false : true;
    }
    return TransactionModel(
      description: map['description'] as String,
      category: map['category'] as String,
      value: double.tryParse(map['value'].toString()) ?? 0,
      date: DateTime.parse(map['date'] as String).millisecondsSinceEpoch,
      createdAt:
          DateTime.parse(map['created_at'] as String).millisecondsSinceEpoch,
      status: map['status'] is int ? parsedStatus : map['status'] as bool,
      id: map['id'] as String?,
      userId: map['user_id'] as String?,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['sync_status'],
        orElse: () => SyncStatus.none,
      ),
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
        other.id == id &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        category.hashCode ^
        value.hashCode ^
        date.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        syncStatus.hashCode;
  }

  TransactionModel copyWith({
    String? description,
    String? category,
    double? value,
    int? date,
    bool? status,
    int? createdAt,
    String? id,
    String? userId,
    SyncStatus? syncStatus,
  }) {
    return TransactionModel(
      description: description ?? this.description,
      category: category ?? this.category,
      value: value ?? this.value,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id ?? const Uuid().v4(),
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
