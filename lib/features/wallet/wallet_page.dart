import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/extensions.dart';
import '../../common/features/balance/balance.dart';
import '../../common/widgets/widgets.dart';
import '../../locator.dart';
import '../home/home_controller.dart';
import 'wallet_controller.dart';
import 'wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin, CustomModalSheetMixin {
  final balanceController = locator.get<BalanceController>();
  final _walletController = locator.get<WalletController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _walletController.getAllTransactions();
    balanceController.getBalances();

    _walletController.addListener(_handleWalletStateChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _walletController.removeListener(_handleWalletStateChange);
    super.dispose();
  }

  void _handleWalletStateChange() {
    final state = _walletController.state;
    switch (state.runtimeType) {
      case WalletStateError:
        if (!mounted) return;

        showCustomModalBottomSheet(
          context: context,
          content: (_walletController.state as WalletStateError).message,
          buttonText: 'Go to login',
          isDismissible: false,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            NamedRoute.signIn,
            ModalRoute.withName(NamedRoute.initial),
          ),
        );
        break;
    }
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
                        animation: balanceController,
                        builder: (context, _) {
                          if (balanceController.state is BalanceStateLoading) {
                            return const CustomCircularProgressIndicator();
                          }

                          return Text(
                            '\$ ${balanceController.balances.totalBalance.toStringAsFixed(2)}',
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
                        animation: _walletController,
                        builder: (context, _) {
                          if (_walletController.state is WalletStateLoading) {
                            return const CustomCircularProgressIndicator(
                              color: AppColors.green,
                            );
                          }
                          if (_walletController.state is WalletStateError) {
                            return const Center(
                              child: Text('An error has occurred'),
                            );
                          }
                          if (_walletController.state is WalletStateSuccess &&
                              _walletController.transactions.isNotEmpty) {
                            return TransactionListView.withCalendar(
                              transactionList: _walletController.transactions,
                              itemCount: _walletController.transactions.length,
                              onChange: () {
                                _walletController.getAllTransactions().then(
                                    (_) => balanceController.getBalances());
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
