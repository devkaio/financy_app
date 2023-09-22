import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/extensions.dart';
import '../../common/features/balance/balance.dart';
import '../../common/features/transaction/transaction.dart';
import '../../common/models/models.dart';
import '../../common/utils/utils.dart';
import '../../common/widgets/widgets.dart';
import '../../locator.dart';

class TransactionPage extends StatefulWidget {
  final TransactionModel? transaction;
  const TransactionPage({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin, CustomSnackBar {
  final _transactionController = locator.get<TransactionController>();
  final _balanceController = locator.get<BalanceController>();

  final _formKey = GlobalKey<FormState>();

  final _incomes = ['Services', 'Investment', 'Other'];
  final _outcomes = ['House', 'Grocery', 'Other'];

  DateTime? _newDate;
  bool value = false;

  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = MoneyMaskedTextController(prefix: '\$');

  late final TabController _tabController;

  int get _initialIndex {
    if (widget.transaction != null && widget.transaction!.value.isNegative) {
      return 1;
    }

    return 0;
  }

  String get _date {
    if (widget.transaction?.date != null) {
      return DateTime.fromMillisecondsSinceEpoch(widget.transaction!.date)
          .toText;
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _amountController.updateValue(widget.transaction?.value ?? 0);

    value = widget.transaction?.status ?? false;

    _descriptionController.text = widget.transaction?.description ?? '';
    _categoryController.text = widget.transaction?.category ?? '';
    _newDate =
        DateTime.fromMillisecondsSinceEpoch(widget.transaction?.date ?? 0);
    _dateController.text = widget.transaction?.date != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.transaction!.date).toText
        : '';

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialIndex,
    );

    _transactionController.addListener(_handleTransactionStateChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _transactionController.removeListener(_handleTransactionStateChange);
    super.dispose();
  }

  void _handleTransactionStateChange() {
    final state = _transactionController.state;
    switch (state.runtimeType) {
      case TransactionStateLoading:
        if (!mounted) return;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case TransactionStateSuccess:
        if (!mounted) return;
        Navigator.of(context).pop();
        break;
      case TransactionStateError:
        if (!mounted) return;
        showCustomSnackBar(
          context: context,
          text: (state as TransactionStateError).message,
          type: SnackBarType.error,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(
            preffixOption: true,
            title: widget.transaction != null
                ? 'Edit Transaction'
                : 'Add Transaction',
          ),
          Positioned(
            top: 164.h,
            left: 28.w,
            right: 28.w,
            bottom: 16.h,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TabBar(
                            labelPadding: EdgeInsets.zero,
                            controller: _tabController,
                            onTap: (_) {
                              if (_tabController.indexIsChanging) {
                                setState(() {});
                              }
                              if (_tabController.indexIsChanging &&
                                  _categoryController.text.isNotEmpty) {
                                _categoryController.clear();
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
                                    'Income',
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
                                    'Expense',
                                    style: AppTextStyles.mediumText16w500
                                        .apply(color: AppColors.darkGrey),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        labelText: "Amount",
                        hintText: "Type an amount",
                        suffixIcon: StatefulBuilder(
                          builder: (context, setState) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  value = !value;
                                });
                              },
                              icon: AnimatedContainer(
                                transform: value
                                    ? Matrix4.rotationX(math.pi * 2)
                                    : Matrix4.rotationX(math.pi),
                                transformAlignment: Alignment.center,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(Icons.thumb_up_alt_rounded),
                              ),
                            );
                          },
                        ),
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Add a description',
                        validator: (value) {
                          if (_descriptionController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _categoryController,
                        readOnly: true,
                        labelText: "Category",
                        hintText: "Select a category",
                        validator: (value) {
                          if (_categoryController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: (_tabController.index == 0
                                    ? _incomes
                                    : _outcomes)
                                .map(
                                  (e) => TextButton(
                                    onPressed: () {
                                      _categoryController.text = e;
                                      Navigator.pop(context);
                                    },
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _dateController,
                        readOnly: true,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        labelText: "Date",
                        hintText: "Select a date",
                        validator: (value) {
                          if (_dateController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                        onTap: () async {
                          _newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2030),
                          );

                          _newDate = _newDate != null
                              ? DateTime.now().copyWith(
                                  day: _newDate?.day,
                                  month: _newDate?.month,
                                  year: _newDate?.year,
                                )
                              : null;

                          _dateController.text =
                              _newDate != null ? _newDate!.toText : _date;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: PrimaryButton(
                          text: widget.transaction != null ? 'Save' : 'Add',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              final newValue = double.parse(_amountController
                                  .text
                                  .replaceAll('\$', '')
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.'));

                              final now = DateTime.now().millisecondsSinceEpoch;

                              final newTransaction = TransactionModel(
                                category: _categoryController.text,
                                description: _descriptionController.text,
                                value: _tabController.index == 1
                                    ? newValue * -1
                                    : newValue,
                                date: _newDate != null
                                    ? _newDate!.millisecondsSinceEpoch
                                    : now,
                                createdAt: widget.transaction?.createdAt ?? now,
                                status: value,
                                id: widget.transaction?.id,
                              );
                              if (widget.transaction == newTransaction) {
                                Navigator.pop(context);
                                return;
                              }
                              if (widget.transaction != null) {
                                await _transactionController
                                    .updateTransaction(newTransaction);
                                await _balanceController.updateBalance(
                                  oldTransaction: widget.transaction!,
                                  newTransaction: newTransaction,
                                );
                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              } else {
                                await _transactionController
                                    .addTransaction(newTransaction);
                                await _balanceController.updateBalance(
                                  newTransaction: newTransaction,
                                );
                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              }
                            } else {
                              log('invalid');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
