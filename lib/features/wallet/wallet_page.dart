import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/extensions/sizes.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/base_page.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../common/widgets/transaction_listview.dart';
import '../../locator.dart';
import '../home/home_controller.dart';
import '../home/widgets/balance_card/balance_card_widget_controller.dart';
import '../home/widgets/balance_card/balance_card_widget_state.dart';
import 'wallet_controller.dart';
import 'wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  final walletController = locator.get<WalletController>();
  final ballanceController = locator.get<BalanceCardWidgetController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    walletController.getAllTransactions();
  }

  @override
  void dispose() {
    locator.resetLazySingleton<WalletController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        locator.get<HomeController>().pageController.jumpToPage(0);
        return false;
      },
      child: Stack(
        children: [
          AppHeader(
            title: 'Wallet',
            onPressed: () {
              locator.get<HomeController>().pageController.jumpToPage(0);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 165.h,
            bottom: 0,
            child: BasePage(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 48.0,
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: AppTextStyles.inputLabelText
                          .apply(color: AppColors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    AnimatedBuilder(
                        animation: ballanceController,
                        builder: (context, _) {
                          if (ballanceController.state
                              is BalanceCardWidgetStateLoading) {
                            return const CustomCircularProgressIndicator();
                          }
                          return Text(
                            '\$ ${ballanceController.balances.totalBalance.toStringAsFixed(2)}',
                            style: AppTextStyles.mediumText30
                                .apply(color: AppColors.blackGrey),
                          );
                        }),
                    const SizedBox(height: 24.0),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return TabBar(
                          labelPadding: EdgeInsets.zero,
                          controller: _tabController,
                          onTap: (_) {
                            if (_tabController.indexIsChanging) {
                              setState(() {});
                            }
                          },
                          tabs: [
                            Tab(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _tabController.index == 0
                                      ? AppColors.iceWhite
                                      : AppColors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0),
                                  ),
                                ),
                                child: Text(
                                  'Transactions',
                                  style: AppTextStyles.mediumText16w500
                                      .apply(color: AppColors.darkGrey),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _tabController.index == 1
                                      ? AppColors.iceWhite
                                      : AppColors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0),
                                  ),
                                ),
                                child: Text(
                                  'Upcoming Bills',
                                  style: AppTextStyles.mediumText16w500
                                      .apply(color: AppColors.darkGrey),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32.0),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: walletController,
                        builder: (context, _) {
                          if (walletController.state is WalletStateLoading) {
                            return const CustomCircularProgressIndicator(
                              color: AppColors.green,
                            );
                          }
                          if (walletController.state is WalletStateError) {
                            return const Center(
                              child: Text('An error has occurred'),
                            );
                          }
                          if (walletController.state is WalletStateSuccess &&
                              walletController.transactions.isNotEmpty) {
                            return TransactionListView(
                              transactionList: walletController.transactions,
                              isLoading: walletController.isLoading,
                              onLoading: (value) {
                                if (value) {
                                  walletController.fetchMore;
                                }
                              },
                            );
                          }
                          return const Center(
                            child:
                                Text('There are no transactions at this time.'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
