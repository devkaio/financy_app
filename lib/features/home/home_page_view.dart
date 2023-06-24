import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/features/balance/balance.dart';
import '../../common/features/transaction/transaction.dart';
import '../../common/widgets/custom_bottom_app_bar.dart';
import '../../locator.dart';
import '../profile/profile_page.dart';
import '../stats/stats_page.dart';
import '../wallet/wallet_controller.dart';
import '../wallet/wallet_page.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final homeController = locator.get<HomeController>();
  final walletController = locator.get<WalletController>();
  final balanceController = locator.get<BalanceController>();

  @override
  void initState() {
    super.initState();
    homeController.setPageController = PageController();
  }

  @override
  void dispose() {
    locator.resetLazySingleton<HomeController>();
    locator.resetLazySingleton<BalanceController>();
    locator.resetLazySingleton<WalletController>();
    locator.resetLazySingleton<TransactionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: homeController.pageController,
        children: const [
          HomePage(),
          StatsPage(),
          WalletPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/transaction');
          if (result != null) {
            if (homeController.pageController.page == 0) {
              homeController.getLatestTransactions();
            }
            if (homeController.pageController.page == 2) {
              walletController.getAllTransactions();
            }
            balanceController.getBalances();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        controller: homeController.pageController,
        selectedItemColor: AppColors.green,
        children: [
          CustomBottomAppBarItem(
            key: Keys.homePageBottomAppBarItem,
            label: 'home',
            primaryIcon: Icons.home,
            secondaryIcon: Icons.home_outlined,
            onPressed: () => homeController.pageController.jumpToPage(
              0,
            ),
          ),
          CustomBottomAppBarItem(
            key: Keys.statsPageBottomAppBarItem,
            label: 'stats',
            primaryIcon: Icons.analytics,
            secondaryIcon: Icons.analytics_outlined,
            onPressed: () => homeController.pageController.jumpToPage(
              1,
            ),
          ),
          CustomBottomAppBarItem.empty(),
          CustomBottomAppBarItem(
            key: Keys.walletPageBottomAppBarItem,
            label: 'wallet',
            primaryIcon: Icons.account_balance_wallet,
            secondaryIcon: Icons.account_balance_wallet_outlined,
            onPressed: () => homeController.pageController.jumpToPage(
              2,
            ),
          ),
          CustomBottomAppBarItem(
            key: Keys.profilePageBottomAppBarItem,
            label: 'profile',
            primaryIcon: Icons.person,
            secondaryIcon: Icons.person_outline,
            onPressed: () => homeController.pageController.jumpToPage(
              3,
            ),
          ),
        ],
      ),
    );
  }
}
