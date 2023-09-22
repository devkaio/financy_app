import 'package:flutter/material.dart';

import '../../locator.dart';
import '../constants/constants.dart';
import '../extensions/extensions.dart';
import '../features/balance/balance.dart';
import '../features/transaction/transaction_controller.dart';
import '../features/transaction/transaction_state.dart';
import '../models/models.dart';
import 'widgets.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({
    super.key,
    required this.transactionList,
    required this.onChange,
    this.selectedDate,
  });

  final List<TransactionModel> transactionList;
  final DateTime? selectedDate;

  ///Called when transaction is updated or deleted
  final VoidCallback onChange;

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with CustomModalSheetMixin, CustomSnackBar, SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _transactionController = locator.get<TransactionController>();
  final _balanceController = locator.get<BalanceController>();
  bool? confirmDelete = false;

  @override
  void initState() {
    super.initState();
    _transactionController.addListener(_handleTransactionStateChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transactionController.removeListener(_handleTransactionStateChange);
    locator.resetLazySingleton<TransactionController>();
    super.dispose();
  }

  void _handleTransactionStateChange() {
    final state = _transactionController.state;

    switch (state.runtimeType) {
      case TransactionStateError:
        if (!mounted) return;
        setState(() {
          showCustomSnackBar(
            context: context,
            text: (state as TransactionStateError).message,
            type: SnackBarType.error,
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      slivers: [
        if (widget.transactionList.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text('There are no transactions in this period.'),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.transactionList.length,
            (context, index) {
              final item = widget.transactionList[index];

              final color =
                  item.value.isNegative ? AppColors.outcome : AppColors.income;

              final value = "\$${item.value.toStringAsFixed(2)}";

              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                dismissThresholds: const {DismissDirection.endToStart: 0.5},
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  if (confirmDelete!) {
                    await _transactionController.deleteTransaction(item);
                    await _balanceController.updateBalance(
                      oldTransaction: item,
                      newTransaction: item.copyWith(value: 0),
                    );
                    widget.onChange.call();
                  }
                },
                confirmDismiss: (direction) async {
                  confirmDelete = await showCustomModalBottomSheet(
                    context: context,
                    content: 'Confirm delete transaction',
                    actions: [
                      Flexible(
                        child: PrimaryButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Flexible(
                        child: PrimaryButton(
                          text: 'Confirm',
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ),
                    ],
                  );

                  return confirmDelete;
                },
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/transaction',
                      arguments: item,
                    );
                    if (result != null) {
                      widget.onChange.call();
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
