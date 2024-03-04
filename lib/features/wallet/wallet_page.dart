import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    with TickerProviderStateMixin, CustomModalSheetMixin {
  final _balanceController = locator.get<BalanceController>();
  final _walletController = locator.get<WalletController>();
  late final TabController _optionsTabController;
  late final TabController _monthsTabController;

  @override
  void initState() {
    super.initState();
    _optionsTabController = TabController(
      length: 2,
      vsync: this,
    );
    _monthsTabController = TabController(
      length: 1,
      vsync: this,
    );

    _walletController.getTransactionsByDateRange();
    _balanceController.getBalances();

    _walletController.addListener(_handleWalletStateChange);
  }

  @override
  void dispose() {
    _optionsTabController.dispose();
    _monthsTabController.dispose();
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
            NamedRoute.initial,
            (route) => false,
          ),
        );
        break;
    }
  }

  void _goToPreviousMonth() {
    final selectedDate = _walletController.selectedDate;

    _walletController.changeSelectedDate(
        DateTime(selectedDate.year, selectedDate.month - 1));
    _monthsTabController.index = 0;
    _walletController.getTransactionsByDateRange();
  }

  void _goToNextMonth() {
    final selectedDate = _walletController.selectedDate;

    _walletController.changeSelectedDate(
        DateTime(selectedDate.year, selectedDate.month + 1));
    _monthsTabController.index = 0;
    _walletController.getTransactionsByDateRange();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => locator
          .get<HomeController>()
          .pageController
          .navigateTo(BottomAppBarItem.home),
      child: Stack(
        children: [
          AppHeader(
            title: 'Wallet',
            onPressed: () {
              locator
                  .get<HomeController>()
                  .pageController
                  .navigateTo(BottomAppBarItem.home);
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
                        animation: _balanceController,
                        builder: (context, _) {
                          if (_balanceController.state is BalanceStateLoading) {
                            return const CustomCircularProgressIndicator();
                          }

                          return Text(
                            '\$ ${_balanceController.balances.totalBalance.toStringAsFixed(2)}',
                            style: AppTextStyles.mediumText30
                                .apply(color: AppColors.blackGrey),
                          );
                        }),
                    const SizedBox(height: 24.0),
                    //TODO: finish transaction / upcoming bills tabs

                    // StatefulBuilder(
                    //   builder: (context, setState) {
                    //     return TabBar(
                    //       labelPadding: EdgeInsets.zero,
                    //       controller: _optionsTabController,
                    //       onTap: (_) {
                    //         if (_optionsTabController.indexIsChanging) {
                    //           setState(() {});
                    //         }
                    //       },
                    //       tabs: [
                    //         Tab(
                    //           child: Container(
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               color: _optionsTabController.index == 0
                    //                   ? AppColors.iceWhite
                    //                   : AppColors.white,
                    //               borderRadius: const BorderRadius.all(
                    //                 Radius.circular(24.0),
                    //               ),
                    //             ),
                    //             child: Text(
                    //               'Transactions',
                    //               style: AppTextStyles.mediumText16w500
                    //                   .apply(color: AppColors.darkGrey),
                    //             ),
                    //           ),
                    //         ),
                    //         Tab(
                    //           child: Container(
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               color: _optionsTabController.index == 1
                    //                   ? AppColors.iceWhite
                    //                   : AppColors.white,
                    //               borderRadius: const BorderRadius.all(
                    //                 Radius.circular(24.0),
                    //               ),
                    //             ),
                    //             child: Text(
                    //               'Upcoming Bills',
                    //               style: AppTextStyles.mediumText16w500
                    //                   .apply(color: AppColors.darkGrey),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 32.0),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              color: AppColors.green,
                              onPressed: () {
                                setState(_goToPreviousMonth);
                              },
                            ),
                            TabBar(
                              labelColor: AppColors.green,
                              labelStyle: AppTextStyles.mediumText16w600,
                              controller: _monthsTabController,
                              isScrollable: true,
                              tabs: [
                                Tab(
                                  text: DateFormat('MMMM yyyy')
                                      .format(_walletController.selectedDate),
                                ),
                              ],
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.arrow_forward_ios_outlined),
                              color: AppColors.green,
                              onPressed: () => setState(_goToNextMonth),
                            ),
                          ],
                        );
                      },
                    ),
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
                          if (_walletController.state is WalletStateSuccess) {
                            return TransactionListView(
                              transactionList: _walletController.transactions,
                              onChange: () {
                                _walletController.getTransactionsByDateRange();
                                _balanceController.getBalances();
                              },
                              selectedDate: _walletController.selectedDate,
                            );
                          }

                          return const Center(
                            child: Text(
                                'There are no transactions registered here.'),
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
