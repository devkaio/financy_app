import 'package:flutter/material.dart';

import '../../features/home/home_controller.dart';
import '../../features/home/widgets/balance_card/balance_card_widget_controller.dart';
import '../../features/wallet/wallet_controller.dart';
import '../../locator.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../extensions/date_formatter.dart';
import '../models/transaction_model.dart';
import 'custom_circular_progress_indicator.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({
    super.key,
    required this.transactionList,
    this.itemCount,
    this.onLoading,
    this.isLoading = false,
  });

  final List<TransactionModel> transactionList;
  final int? itemCount;
  final ValueChanged<bool>? onLoading;
  final bool isLoading;

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (widget.onLoading != null) {
        widget.onLoading!(_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.itemCount ?? widget.transactionList.length,
            (context, index) {
              final item = widget.transactionList[index];

              final color =
                  item.value.isNegative ? AppColors.outcome : AppColors.income;

              final value = "\$${item.value.toStringAsFixed(2)}";

              return ListTile(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/transaction',
                    arguments: item,
                  );
                  if (result != null) {
                    locator.get<HomeController>().getLatestTransactions();
                    locator.get<BalanceCardWidgetController>().getBalances();
                    locator.get<WalletController>().getAllTransactions();
                  }
                },
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
                  DateTime.fromMillisecondsSinceEpoch(item.date).toText,
                  style: AppTextStyles.smallText13,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.mediumText18.apply(color: color),
                    ),
                    Text(
                      item.status ? 'done' : 'pending',
                      style: AppTextStyles.smallText13
                          .apply(color: AppColors.lightGrey),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.isLoading)
          const SliverToBoxAdapter(
            child: CustomCircularProgressIndicator(),
          ),
      ],
    );
  }
}
