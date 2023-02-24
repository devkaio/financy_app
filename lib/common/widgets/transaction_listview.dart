import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/transaction_model.dart';

class TransactionListView extends StatelessWidget {
  const TransactionListView({
    super.key,
    required this.transactionList,
    this.itemCount,
  });

  final List<TransactionModel> transactionList;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount ?? transactionList.length,
      itemBuilder: (context, index) {
        final item = transactionList[index];

        final color =
            item.value.isNegative ? AppColors.outcome : AppColors.income;
        final value = "\$${item.value.toStringAsFixed(2)}";
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          leading: Container(
            decoration: const BoxDecoration(
              color: AppColors.antiFlashWhite,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.monetization_on_outlined,
            ),
          ),
          title: Text(
            item.description,
            style: AppTextStyles.mediumText16w500,
          ),
          subtitle: Text(
            DateTime.fromMillisecondsSinceEpoch(item.date).toString(),
            style: AppTextStyles.smallText13,
          ),
          trailing: Text(
            value,
            style: AppTextStyles.mediumText18.apply(color: color),
          ),
        );
      },
    );
  }
}
