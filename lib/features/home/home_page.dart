import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/extensions/sizes.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../common/widgets/transaction_listview.dart';
import '../../locator.dart';
import 'home_controller.dart';
import 'home_state.dart';
import 'widgets/balance_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = locator.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppHeader(),
          const BalanceCard(
            totalAmount: 1232.23,
            incomeAmount: 1311.12,
            outcomeAmount: -1231231.32,
          ),
          Positioned(
            top: 397.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Transaction History',
                        style: AppTextStyles.mediumText18,
                      ),
                      Text(
                        'See all',
                        style: AppTextStyles.inputLabelText,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      if (controller.state is HomeStateLoading) {
                        return const CustomCircularProgressIndicator(
                          color: AppColors.green,
                        );
                      }
                      if (controller.state is HomeStateError) {
                        return const Center(
                          child: Text('An error has occurred'),
                        );
                      }
                      if (controller.transactions.isEmpty) {
                        return const Center(
                          child: Text('There is no transactions at this time.'),
                        );
                      }
                      return TransactionListView(
                        transactionList: controller.transactions,
                        itemCount: 5,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
