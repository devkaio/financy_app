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
      'totalIncome': totalIncome,
      'totalOutcome': totalOutcome,
      'totalBalance': totalBalance,
    };
  }

  factory BalancesModel.fromMap(Map<String, dynamic> map) {
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

  String toJson() => json.encode(toMap());

  factory BalancesModel.fromJson(String source) =>
      BalancesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
