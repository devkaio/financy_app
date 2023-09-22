import 'dart:convert';

class BalancesModel {
  final double totalIncome;
  final double totalOutcome;
  final double totalBalance;
  BalancesModel({
    required this.totalIncome,
    required this.totalOutcome,
    required this.totalBalance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_income': totalIncome,
      'total_outcome': totalOutcome,
      'total_balance': totalBalance,
    };
  }

  factory BalancesModel.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('__typename')) {
      return BalancesModel(
        totalIncome: double.tryParse(
                map['totalIncome']['aggregate']['sum']['value'].toString()) ??
            0,
        totalOutcome: double.tryParse(
                map['totalOutcome']['aggregate']['sum']['value'].toString()) ??
            0,
        totalBalance: double.tryParse(
                map['totalBalance']['aggregate']['sum']['value'].toString()) ??
            0,
      );
    }

    if (map.containsKey('data')) {
      final localMap = (map['data'] as List).first;
      return BalancesModel(
        totalIncome: double.tryParse(localMap['total_income'].toString()) ?? 0,
        totalOutcome:
            double.tryParse(localMap['total_outcome'].toString()) ?? 0,
        totalBalance:
            double.tryParse(localMap['total_balance'].toString()) ?? 0,
      );
    }

    return BalancesModel(
      totalIncome: double.tryParse(map['total_income'].toString()) ?? 0,
      totalOutcome: double.tryParse(map['total_outcome'].toString()) ?? 0,
      totalBalance: double.tryParse(map['total_balance'].toString()) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BalancesModel.fromJson(String source) =>
      BalancesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  BalancesModel copyWith({
    double? totalIncome,
    double? totalOutcome,
    double? totalBalance,
  }) {
    return BalancesModel(
      totalIncome: totalIncome ?? this.totalIncome,
      totalOutcome: totalOutcome ?? this.totalOutcome,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }
}
