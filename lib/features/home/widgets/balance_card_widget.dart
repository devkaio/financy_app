import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extensions/extensions.dart';
import '../../../common/features/balance/balance.dart';

class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BalanceController controller;

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_handleBalanceStateChange);
  }

  void _handleBalanceStateChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleBalanceStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor =
        MediaQuery.sizeOf(context).width <= 360 ? 0.8 : 1.0;

    return Positioned(
      left: 24.w,
      right: 24.w,
      top: 155.h,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 32.h,
        ),
        decoration: const BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: AppTextStyles.mediumText16w600
                          .apply(color: AppColors.white),
                    ),
                    AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, _) {
                          if (widget.controller.state is BalanceStateLoading) {
                            return Container(
                              color: AppColors.greenTwo,
                              constraints:
                                  BoxConstraints.tightFor(width: 128.0.w),
                              height: 48.0.h,
                            );
                          }
                          return ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 250.0.w),
                            child: Text(
                              '\$${widget.controller.balances.totalBalance.toStringAsFixed(2)}',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: AppTextStyles.mediumText30
                                  .apply(color: AppColors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        })
                  ],
                ),
                // TODO: add card menu options

                // GestureDetector(
                //   onTap: () => log('options'),
                //   child: PopupMenuButton(
                //     padding: EdgeInsets.zero,
                //     child: const Icon(
                //       Icons.more_horiz,
                //       color: AppColors.white,
                //     ),
                //     itemBuilder: (context) => [
                //       const PopupMenuItem(
                //         height: 24.0,
                //         child: Text("Item 1"),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 36.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, _) {
                      return TransactionValueWidget(
                        amount: widget.controller.balances.totalIncome,
                        controller: widget.controller,
                      );
                    },
                  ),
                ),
                Flexible(
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, _) {
                      return TransactionValueWidget(
                        amount: widget.controller.balances.totalOutcome,
                        controller: widget.controller,
                        type: TransactionType.outcome,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum TransactionType { income, outcome }

class TransactionValueWidget extends StatelessWidget {
  const TransactionValueWidget({
    super.key,
    required this.amount,
    required this.controller,
    this.type = TransactionType.income,
  });
  final BalanceController controller;
  final double amount;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    double textScaleFactor =
        MediaQuery.sizeOf(context).width <= 360 ? 0.8 : 1.0;

    double iconSize = MediaQuery.sizeOf(context).width <= 360 ? 16.0 : 24.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.06),
            borderRadius: const BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Icon(
            type == TransactionType.income
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: AppColors.white,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 4.0),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type == TransactionType.income ? 'Income' : 'Expense',
                textScaler: TextScaler.linear(textScaleFactor),
                style: AppTextStyles.mediumText16w500
                    .apply(color: AppColors.white),
              ),
              AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    if (controller.state is BalanceStateLoading) {
                      return Container(
                        color: AppColors.greenTwo,
                        constraints: BoxConstraints.tightFor(width: 80.0.w),
                        height: 36.0.h,
                      );
                    }
                    return Text(
                      '\$${amount.toStringAsFixed(2)}',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: AppTextStyles.mediumText20
                          .apply(color: AppColors.white),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
            ],
          ),
        )
      ],
    );
  }
}
